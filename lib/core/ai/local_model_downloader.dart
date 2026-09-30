import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'local_model_spec.dart';
import 'local_model_store.dart';
import '../platform/model_transfer_platform_service.dart';

/// One progress sample from an in-flight GGUF download.
class LocalModelDownloadTick {
  const LocalModelDownloadTick({
    required this.progress,
    required this.receivedBytes,
    this.totalBytes,
    this.isFinalizing = false,
  });

  /// Fraction complete in `0…1`. When [totalBytes] is unknown, may be `0`.
  final double progress;
  final int receivedBytes;
  final int? totalBytes;

  /// Bytes are on disk; checksum / install is still running.
  final bool isFinalizing;

  /// True when the payload is fully received (or [isFinalizing]).
  bool get isComplete {
    if (isFinalizing) return true;
    final total = totalBytes;
    return total != null && total > 0 && receivedBytes >= total;
  }
}

/// Downloads the production GGUF into the local model store.
///
/// Supports cancel (keeps the `.part` file) and resume via HTTP Range after
/// app restart when the server accepts partial content.
class LocalModelDownloader {
  LocalModelDownloader({
    required LocalModelStore store,
    HttpClient Function()? clientFactory,
    ModelTransferPlatformService? transfer,
  }) : _store = store,
       _clientFactory = clientFactory ?? HttpClient.new,
       _transfer = transfer;

  final LocalModelStore _store;
  final HttpClient Function() _clientFactory;
  final ModelTransferPlatformService? _transfer;

  HttpClient? _activeClient;
  File? _activePartFile;
  bool _cancelRequested = false;

  void cancel() {
    _cancelRequested = true;
    _activeClient?.close(force: true);
    final part = _activePartFile;
    if (part != null) {
      _transfer?.cancelDownload(part);
    }
  }

  /// Yields progress ticks. Completes after checksum verification when
  /// [spec] (or the store spec) has a SHA-256. Catalog entries without a
  /// digest skip that check.
  ///
  /// When a `.part` file already exists, sends `Range` and appends when the
  /// server responds with 206. Hugging Face supports this for GGUF blobs.
  Stream<LocalModelDownloadTick> download({LocalModelSpec? spec}) async* {
    cancel();
    _cancelRequested = false;
    final model = spec ?? _store.spec;
    await _store.clearPartialUnlessFor(model.modelId);
    final tempFile = await _store.partialFile();
    final metaFile = await _store.partialMetaFile();
    await tempFile.parent.create(recursive: true);

    var existingBytes = tempFile.existsSync() ? tempFile.lengthSync() : 0;
    if (existingBytes < 0) existingBytes = 0;
    _activePartFile = tempFile;

    int? totalBytes;
    if (metaFile.existsSync()) {
      totalBytes = int.tryParse(
        (await metaFile.readAsString()).split(RegExp(r'\r?\n')).first.trim(),
      );
      if (totalBytes != null && totalBytes <= 0) totalBytes = null;
    }
    await _store.writePartialMeta(
      totalBytes: totalBytes,
      modelId: model.modelId,
    );

    if (_isAlreadyComplete(tempFile, existingBytes, totalBytes)) {
      try {
        yield* _finalizePartial(
          tempFile,
          metaFile,
          existingBytes,
          totalBytes,
          model,
        );
      } finally {
        _activePartFile = null;
      }
      return;
    }

    final transfer = _transfer;
    if (transfer != null && transfer.canRunNativeTransfers) {
      yield* _downloadViaPlatform(
        model: model,
        tempFile: tempFile,
        metaFile: metaFile,
        existingBytes: existingBytes,
        totalBytes: totalBytes,
      );
      return;
    }

    final client = _clientFactory()..userAgent = 'Quorivell/0.1';
    _activeClient = client;
    try {
      final request = await client.getUrl(model.uri);
      request.followRedirects = true;
      if (existingBytes > 0) {
        request.headers.set(HttpHeaders.rangeHeader, 'bytes=$existingBytes-');
      }

      final response = await request.close();
      _throwIfCancelled();

      var append = false;
      if (response.statusCode == HttpStatus.partialContent) {
        append = existingBytes > 0;
        totalBytes =
            _totalFromContentRange(
              response.headers.value(HttpHeaders.contentRangeHeader),
            ) ??
            totalBytes;
        if (totalBytes == null &&
            response.contentLength > 0 &&
            existingBytes > 0) {
          totalBytes = existingBytes + response.contentLength;
        }
      } else if (response.statusCode >= 200 && response.statusCode < 300) {
        // Full body — drop any partial so we do not keep two large copies.
        if (existingBytes > 0) {
          await tempFile.delete();
          existingBytes = 0;
        }
        if (response.contentLength > 0) {
          totalBytes = response.contentLength;
        }
      } else if (response.statusCode ==
              HttpStatus.requestedRangeNotSatisfiable &&
          existingBytes > 0) {
        await response.drain<void>();
        yield* _finalizePartial(
          tempFile,
          metaFile,
          existingBytes,
          totalBytes,
          model,
        );
        return;
      } else {
        throw const LocalModelDownloadException();
      }

      // Imports leave non-resumable temps; free them before growing `.part`.
      await _store.clearImportPartial();

      await _store.writePartialMeta(
        totalBytes: totalBytes,
        modelId: model.modelId,
      );

      if (existingBytes > 0) {
        yield _tick(existingBytes, totalBytes);
      }

      final ioSink = tempFile.openWrite(
        mode: append ? FileMode.append : FileMode.write,
      );
      var received = existingBytes;
      try {
        await for (final chunk in response) {
          _throwIfCancelled();
          ioSink.add(chunk);
          received += chunk.length;
          await ioSink.flush();
          yield _tick(received, totalBytes);
        }
      } finally {
        await ioSink.close();
      }

      _throwIfCancelled();
      yield* _finalizePartial(tempFile, metaFile, received, totalBytes, model);
    } on LocalModelDownloadCancelledException {
      rethrow;
    } on LocalModelChecksumException {
      await _store.clearPartialDownload();
      rethrow;
    } on LocalModelStorageFullException {
      await _store.clearImportPartial();
      rethrow;
    } on LocalModelDownloadException {
      rethrow;
    } on Object catch (error) {
      if (_cancelRequested) {
        throw const LocalModelDownloadCancelledException();
      }
      if (isOutOfSpaceError(error)) {
        await _store.clearImportPartial();
        throw const LocalModelStorageFullException();
      }
      throw const LocalModelDownloadException();
    } finally {
      _activeClient = null;
      _activePartFile = null;
      client.close(force: true);
    }
  }

  Stream<LocalModelDownloadTick> _downloadViaPlatform({
    required LocalModelSpec model,
    required File tempFile,
    required File metaFile,
    required int existingBytes,
    required int? totalBytes,
  }) async* {
    var knownTotal = totalBytes;
    try {
      await _store.clearImportPartial();
      await _store.writePartialMeta(
        totalBytes: knownTotal,
        modelId: model.modelId,
      );
      if (existingBytes > 0) {
        yield _tick(existingBytes, knownTotal);
      }
      await for (final tick in _transfer!.downloadToPart(
        url: model.uri,
        partFile: tempFile,
        existingBytes: existingBytes,
        totalBytes: knownTotal,
      )) {
        _throwIfCancelled();
        knownTotal = tick.totalBytes ?? knownTotal;
        await _store.writePartialMeta(
          totalBytes: knownTotal,
          modelId: model.modelId,
        );
        yield tick;
      }
      _throwIfCancelled();
      final received = tempFile.existsSync() ? tempFile.lengthSync() : 0;
      yield* _finalizePartial(tempFile, metaFile, received, knownTotal, model);
    } on LocalModelDownloadCancelledException {
      rethrow;
    } on LocalModelChecksumException {
      await _store.clearPartialDownload();
      rethrow;
    } on LocalModelStorageFullException {
      await _store.clearImportPartial();
      rethrow;
    } on LocalModelDownloadException {
      rethrow;
    } on Object catch (error) {
      if (_cancelRequested) {
        throw const LocalModelDownloadCancelledException();
      }
      if (isOutOfSpaceError(error)) {
        await _store.clearImportPartial();
        throw const LocalModelStorageFullException();
      }
      throw const LocalModelDownloadException();
    } finally {
      _activePartFile = null;
    }
  }

  Stream<LocalModelDownloadTick> _finalizePartial(
    File tempFile,
    File metaFile,
    int received,
    int? totalBytes,
    LocalModelSpec model,
  ) async* {
    if (received <= 0) {
      await _store.clearPartialDownload();
      throw const LocalModelDownloadException();
    }
    if (totalBytes != null && totalBytes > 0 && received < totalBytes) {
      throw const LocalModelDownloadException();
    }

    yield _tick(
      received,
      totalBytes ?? received,
      forceComplete: true,
      isFinalizing: true,
    );
    final digest = await sha256.bind(tempFile.openRead()).first;
    await _store.installVerified(
      tempFile,
      digest.toString(),
      origin: LocalModelOrigin.download,
      expectedSha256: model.sha256,
      identity: model,
      requireChecksum: model.sha256 != null,
    );
    if (metaFile.existsSync()) {
      await metaFile.delete();
    }
    yield _tick(
      received,
      totalBytes ?? received,
      forceComplete: true,
      isFinalizing: true,
    );
  }

  LocalModelDownloadTick _tick(
    int receivedBytes,
    int? totalBytes, {
    bool forceComplete = false,
    bool isFinalizing = false,
  }) {
    final progress = forceComplete || isFinalizing
        ? 1.0
        : (totalBytes != null && totalBytes > 0)
        ? (receivedBytes / totalBytes).clamp(0.0, 1.0)
        : 0.0;
    return LocalModelDownloadTick(
      progress: progress,
      receivedBytes: receivedBytes,
      totalBytes: totalBytes,
      isFinalizing: isFinalizing,
    );
  }

  bool _isAlreadyComplete(File partFile, int received, int? total) {
    if (received <= 0) return false;
    if (total != null && total > 0 && received >= total) return true;
    final statusFile = File('${partFile.path}.status');
    if (!statusFile.existsSync()) return false;
    try {
      final decoded = jsonDecode(statusFile.readAsStringSync());
      if (decoded is! Map) return false;
      if (decoded['state'] != 'complete') return false;
      return total == null || total <= 0 || received >= total;
    } on Object {
      return false;
    }
  }

  void _throwIfCancelled() {
    if (_cancelRequested) {
      throw const LocalModelDownloadCancelledException();
    }
  }

  int? _totalFromContentRange(String? header) {
    if (header == null) return null;
    // bytes start-end/total  OR  bytes */total
    final slash = header.lastIndexOf('/');
    if (slash < 0 || slash == header.length - 1) return null;
    return int.tryParse(header.substring(slash + 1));
  }
}

class LocalModelDownloadCancelledException implements Exception {
  const LocalModelDownloadCancelledException();
}
