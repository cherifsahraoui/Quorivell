import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/local_model_downloader.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/platform/model_transfer_platform_service.dart';

class _ScriptedTransfer extends StubModelTransferPlatformService {
  _ScriptedTransfer(this.remaining);

  final List<int> remaining;

  @override
  bool get canRunNativeTransfers => true;

  @override
  Stream<LocalModelDownloadTick> downloadToPart({
    required Uri url,
    required File partFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) async* {
    await partFile.parent.create(recursive: true);
    final sink = partFile.openWrite(
      mode: existingBytes > 0 ? FileMode.append : FileMode.write,
    );
    var received = existingBytes;
    final total = (totalBytes ?? existingBytes + remaining.length);
    try {
      for (final byte in remaining) {
        sink.add([byte]);
        received += 1;
        yield LocalModelDownloadTick(
          progress: received / total,
          receivedBytes: received,
          totalBytes: total,
        );
      }
    } finally {
      await sink.close();
    }
  }
}

class _MustNotStartTransfer extends StubModelTransferPlatformService {
  var starts = 0;

  @override
  bool get canRunNativeTransfers => true;

  @override
  Stream<LocalModelDownloadTick> downloadToPart({
    required Uri url,
    required File partFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) async* {
    starts += 1;
    throw StateError('native transfer should be skipped');
  }
}

void main() {
  late Directory tempDir;
  const payload = [1, 2, 3, 4, 5, 9];

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('quorivell-transfer-');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('platform download writes .part then verifies via the store', () async {
    final spec = LocalModelSpec(
      modelId: 'test-model',
      fileName: 'test.gguf',
      downloadUri: 'http://127.0.0.1/test.gguf',
      sha256: sha256.convert(payload).toString(),
    );
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final part = await store.partialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 3));
    await store.writePartialMeta(
      totalBytes: payload.length,
      modelId: spec.modelId,
    );

    final downloader = LocalModelDownloader(
      store: store,
      transfer: _ScriptedTransfer(payload.sublist(3)),
    );
    await downloader.download().drain<void>();

    expect(await store.isReady(), isTrue);
    expect(await store.readOrigin(), LocalModelOrigin.download);
    expect(part.existsSync(), isFalse);
  });

  test(
    'skips native transfer when the .part file is already complete',
    () async {
      final spec = LocalModelSpec(
        modelId: 'test-model',
        fileName: 'test.gguf',
        downloadUri: 'http://127.0.0.1/test.gguf',
        sha256: sha256.convert(payload).toString(),
      );
      final store = LocalModelStore(
        resolveDocumentsDirectory: () async => tempDir,
        spec: spec,
      );
      final part = await store.partialFile();
      await part.parent.create(recursive: true);
      await part.writeAsBytes(payload);
      await store.writePartialMeta(
        totalBytes: payload.length,
        modelId: spec.modelId,
      );

      final transfer = _MustNotStartTransfer();
      final downloader = LocalModelDownloader(store: store, transfer: transfer);
      await downloader.download().drain<void>();

      expect(transfer.starts, 0);
      expect(await store.isReady(), isTrue);
      expect(part.existsSync(), isFalse);
    },
  );
}
