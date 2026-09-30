import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/local_model_downloader.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';

void main() {
  late Directory tempDir;
  const payload = [1, 2, 3, 4, 5, 9];

  LocalModelSpec specFor(Uri uri) {
    return LocalModelSpec(
      modelId: 'test-model',
      fileName: 'test.gguf',
      downloadUri: uri.toString(),
      sha256: sha256.convert(payload).toString(),
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('quorivell-model-');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('isReady is false until a matching file is installed', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );

    expect(await store.isReady(), isFalse);

    final temp = File('${tempDir.path}${Platform.pathSeparator}part');
    await temp.writeAsBytes(payload);
    await store.installVerified(temp, sha256.convert(payload).toString());

    expect(await store.isReady(), isTrue);
    expect((await store.modelFile()).existsSync(), isTrue);
  });

  test('isReady trusts a matching sidecar without hashing again', () async {
    final spec = specFor(Uri.parse('http://127.0.0.1/test.gguf'));
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final temp = File('${tempDir.path}${Platform.pathSeparator}part');
    await temp.writeAsBytes(payload);
    await store.installVerified(temp, sha256.convert(payload).toString());
    expect((await store.verifiedMetaFile()).existsSync(), isTrue);

    final restarted = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    expect(await restarted.isReady(hashIfNeeded: false), isTrue);

    await (await restarted.verifiedMetaFile()).delete();
    final withoutSidecar = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    expect(await withoutSidecar.isReady(hashIfNeeded: false), isFalse);
    expect(await withoutSidecar.isReady(), isTrue);

    final afterHash = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    expect(await afterHash.isReady(hashIfNeeded: false), isTrue);
  });

  test(
    'cleanupStaleTemps drops resume part when a model file is present',
    () async {
      final store = LocalModelStore(
        resolveDocumentsDirectory: () async => tempDir,
        spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
      );
      final temp = File('${tempDir.path}${Platform.pathSeparator}part');
      await temp.writeAsBytes(payload);
      await store.installVerified(temp, sha256.convert(payload).toString());
      final part = await store.partialFile();
      await part.writeAsBytes(payload.sublist(0, 3));

      final reclaimed = await store.cleanupStaleTemps();

      expect(reclaimed, greaterThan(0));
      expect(part.existsSync(), isFalse);
      expect(await store.hasModelFile(), isTrue);
    },
  );

  test('rejects a checksum mismatch without installing', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final temp = File('${tempDir.path}${Platform.pathSeparator}part');
    await temp.writeAsBytes(payload);

    await expectLater(
      store.installVerified(temp, 'deadbeef'),
      throwsA(isA<LocalModelChecksumException>()),
    );
    expect(await store.isReady(), isFalse);
  });

  test('downloads from a local HTTP server and verifies the digest', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((request) async {
      request.response
        ..statusCode = 200
        ..contentLength = payload.length
        ..add(payload);
      await request.response.close();
    });

    final spec = specFor(
      Uri.parse('http://127.0.0.1:${server.port}/test.gguf'),
    );
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final downloader = LocalModelDownloader(store: store);

    await downloader.download().drain<void>();

    expect(await store.isReady(), isTrue);
    expect(await store.readOrigin(), LocalModelOrigin.download);
  });

  test('imports a local file after verifying the digest', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final source = File('${tempDir.path}${Platform.pathSeparator}source.gguf');
    await source.writeAsBytes(payload);

    await store.installFromFile(source).drain<void>();

    expect(await store.isReady(), isTrue);
    expect(await store.readOrigin(), LocalModelOrigin.import);
  });

  test('imports a local file even when the digest does not match', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final source = File('${tempDir.path}${Platform.pathSeparator}bad.gguf');
    await source.writeAsBytes(const [9, 9, 9]);

    await store.installFromFile(source).drain<void>();

    expect(await store.isReady(), isTrue);
    expect(await store.readOrigin(), LocalModelOrigin.import);
    expect(await store.hasModelFile(), isTrue);
  });

  test('resumes a partial download with HTTP Range', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((request) async {
      final range = request.headers.value(HttpHeaders.rangeHeader);
      if (range == 'bytes=3-') {
        request.response
          ..statusCode = HttpStatus.partialContent
          ..headers.set(
            HttpHeaders.contentRangeHeader,
            'bytes 3-${payload.length - 1}/${payload.length}',
          )
          ..contentLength = payload.length - 3
          ..add(payload.sublist(3));
      } else {
        request.response
          ..statusCode = 200
          ..contentLength = payload.length
          ..add(payload);
      }
      await request.response.close();
    });

    final spec = specFor(
      Uri.parse('http://127.0.0.1:${server.port}/test.gguf'),
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

    final downloader = LocalModelDownloader(store: store);
    await downloader.download().drain<void>();

    expect(await store.isReady(), isTrue);
    expect(part.existsSync(), isFalse);
  });

  test('does not Range-append a .part tagged for a different model', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((request) async {
      final range = request.headers.value(HttpHeaders.rangeHeader);
      if (range != null) {
        request.response
          ..statusCode = HttpStatus.partialContent
          ..headers.set(
            HttpHeaders.contentRangeHeader,
            'bytes 3-${payload.length - 1}/${payload.length}',
          )
          ..contentLength = payload.length - 3
          ..add(payload.sublist(3));
      } else {
        request.response
          ..statusCode = 200
          ..contentLength = payload.length
          ..add(payload);
      }
      await request.response.close();
    });

    final spec = specFor(
      Uri.parse('http://127.0.0.1:${server.port}/test.gguf'),
    );
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final part = await store.partialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(const [9, 9, 9]);
    await store.writePartialMeta(
      totalBytes: payload.length,
      modelId: 'other-model',
    );

    final downloader = LocalModelDownloader(store: store);
    await downloader.download().drain<void>();

    expect(await store.isReady(), isTrue);
    expect(part.existsSync(), isFalse);
  });

  test('cleanupStaleTemps keeps import leftovers and resume part', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final part = await store.partialFile();
    final importPart = await store.importPartialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 3));
    await importPart.writeAsBytes(payload);

    final reclaimed = await store.cleanupStaleTemps();

    expect(reclaimed, 0);
    expect(importPart.existsSync(), isTrue);
    expect(part.existsSync(), isTrue);
  });

  test('cleanupStaleTemps can drop import leftovers when reclaiming', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final importPart = await store.importPartialFile();
    await importPart.parent.create(recursive: true);
    await importPart.writeAsBytes(payload);

    await store.cleanupStaleTemps(keepImportPart: false);

    expect(importPart.existsSync(), isFalse);
  });

  test('cleanupStaleTemps can drop the resume part when reclaiming', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final part = await store.partialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 3));

    await store.cleanupStaleTemps(keepResumePart: false);

    expect(part.existsSync(), isFalse);
  });

  test('maps out-of-space filesystem errors', () {
    expect(
      isOutOfSpaceError(
        const FileSystemException(
          'write failed',
          '/tmp/x',
          OSError('No space left on device', 28),
        ),
      ),
      isTrue,
    );
    expect(isOutOfSpaceError(const LocalModelImportException()), isFalse);
  });

  test('cancel keeps the partial download for later resume', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    final started = Completer<void>();
    server.listen((request) async {
      request.response
        ..statusCode = 200
        ..contentLength = payload.length;
      request.response.add(payload.sublist(0, 2));
      await request.response.flush();
      started.complete();
      await Future<void>.delayed(const Duration(seconds: 2));
      try {
        request.response.add(payload.sublist(2));
        await request.response.close();
      } on Object {
        // Client may have cancelled.
      }
    });

    final spec = specFor(
      Uri.parse('http://127.0.0.1:${server.port}/test.gguf'),
    );
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: spec,
    );
    final downloader = LocalModelDownloader(store: store);
    final firstProgress = Completer<void>();
    final downloadFuture = downloader.download().listen((tick) {
      if (tick.progress > 0 && !firstProgress.isCompleted) {
        firstProgress.complete();
      }
    }).asFuture<void>();
    await started.future;
    await firstProgress.future.timeout(const Duration(seconds: 5));
    downloader.cancel();
    await expectLater(
      downloadFuture,
      throwsA(isA<LocalModelDownloadCancelledException>()),
    );

    final partial = await store.partialProgress();
    expect(partial, isNotNull);
    expect(partial!.bytesReceived, greaterThan(0));
    expect(await store.isReady(), isFalse);
  });

  test('deleteInstalled removes the GGUF, sidecar, and origin', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final source = File('${tempDir.path}${Platform.pathSeparator}source.gguf');
    await source.writeAsBytes(payload);
    await store.installFromFile(source).drain<void>();

    expect(await store.isReady(), isTrue);
    await store.deleteInstalled();

    expect(await store.isReady(), isFalse);
    expect(await store.hasModelFile(), isFalse);
    expect(await store.readOrigin(), isNull);
    expect((await store.verifiedMetaFile()).existsSync(), isFalse);
  });

  test('removeInstalledWeights keeps a resume .part', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final source = File('${tempDir.path}${Platform.pathSeparator}source.gguf');
    await source.writeAsBytes(payload);
    await store.installFromFile(source).drain<void>();
    final part = await store.partialFile();
    await part.writeAsBytes(payload.sublist(0, 2));
    await store.writePartialMeta(
      totalBytes: payload.length,
      modelId: 'next-model',
    );

    await store.removeInstalledWeights();

    expect(await store.hasModelFile(), isFalse);
    expect(part.existsSync(), isTrue);
    expect((await store.partialProgress())?.modelId, 'next-model');
  });

  test('clearPartialUnlessFor drops anonymous and other-model parts', () async {
    final store = LocalModelStore(
      resolveDocumentsDirectory: () async => tempDir,
      spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
    );
    final part = await store.partialFile();
    await part.parent.create(recursive: true);
    await part.writeAsBytes(payload.sublist(0, 2));

    await store.clearPartialUnlessFor('wanted-model');
    expect(part.existsSync(), isFalse);

    await part.writeAsBytes(payload.sublist(0, 2));
    await store.writePartialMeta(totalBytes: payload.length, modelId: 'other');
    await store.clearPartialUnlessFor('wanted-model');
    expect(part.existsSync(), isFalse);

    await part.writeAsBytes(payload.sublist(0, 2));
    await store.writePartialMeta(
      totalBytes: payload.length,
      modelId: 'wanted-model',
    );
    await store.clearPartialUnlessFor('wanted-model');
    expect(part.existsSync(), isTrue);
  });

  test(
    'cleanupStaleTemps drops leftover native status when a model is present',
    () async {
      final store = LocalModelStore(
        resolveDocumentsDirectory: () async => tempDir,
        spec: specFor(Uri.parse('http://127.0.0.1/test.gguf')),
      );
      final temp = File('${tempDir.path}${Platform.pathSeparator}part');
      await temp.writeAsBytes(payload);
      await store.installVerified(temp, sha256.convert(payload).toString());
      final part = await store.partialFile();
      final status = File('${part.path}.status');
      await status.writeAsString('{"state":"complete","received":6}');

      await store.cleanupStaleTemps();

      expect(status.existsSync(), isFalse);
      expect(await store.hasModelFile(), isTrue);
    },
  );
}
