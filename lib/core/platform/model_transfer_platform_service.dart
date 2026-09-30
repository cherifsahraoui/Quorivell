import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ai/local_model_downloader.dart';
import '../ai/local_model_store.dart';

part 'model_transfer_platform_service.g.dart';

class PickedGguf {
  const PickedGguf({required this.uri, required this.displayName, this.size});

  final String uri;
  final String displayName;
  final int? size;

  bool get isGguf {
    final name = displayName.toLowerCase();
    return name.endsWith('.gguf');
  }
}

/// Native Android download/copy/export runner. Other platforms keep Dart I/O.
abstract interface class ModelTransferPlatformService {
  bool get canRunNativeTransfers;

  Future<PickedGguf?> pickGguf();

  /// Opens a save location for the installed GGUF (SAF create on Android).
  ///
  /// Returns a content URI string, or null if cancelled.
  Future<String?> createGgufDocument({required String suggestedName});

  Stream<LocalModelDownloadTick> downloadToPart({
    required Uri url,
    required File partFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  });

  Stream<LocalModelDownloadTick> copyFromUri({
    required String uri,
    required File destFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  });

  /// Streams [sourceFile] to a previously created document [uri].
  Stream<LocalModelDownloadTick> copyToUri({
    required File sourceFile,
    required String uri,
    required File statusFile,
    String? title,
    String? body,
  });

  void cancelDownload(File partFile);

  void cancelCopy(File destFile);

  void cancelExport(File statusFile);

  /// Whether WorkManager still has an in-flight GGUF download, copy, or export.
  Future<bool> isTransferRunning();
}

class StubModelTransferPlatformService implements ModelTransferPlatformService {
  @override
  bool get canRunNativeTransfers => false;

  @override
  Future<PickedGguf?> pickGguf() async => null;

  @override
  Future<String?> createGgufDocument({required String suggestedName}) async =>
      null;

  @override
  Stream<LocalModelDownloadTick> downloadToPart({
    required Uri url,
    required File partFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) async* {
    throw UnsupportedError('Native model download is Android-only');
  }

  @override
  Stream<LocalModelDownloadTick> copyFromUri({
    required String uri,
    required File destFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) async* {
    throw UnsupportedError('Native model copy is Android-only');
  }

  @override
  Stream<LocalModelDownloadTick> copyToUri({
    required File sourceFile,
    required String uri,
    required File statusFile,
    String? title,
    String? body,
  }) async* {
    throw UnsupportedError('Native model export is Android-only');
  }

  @override
  void cancelDownload(File partFile) {}

  @override
  void cancelCopy(File destFile) {}

  @override
  void cancelExport(File statusFile) {}

  @override
  Future<bool> isTransferRunning() async => false;
}

class AndroidModelTransferPlatformService
    implements ModelTransferPlatformService {
  AndroidModelTransferPlatformService({
    MethodChannel? channel,
    EventChannel? events,
  }) : _channel =
           channel ?? const MethodChannel('com.quorivell.app/model_transfer'),
       _events =
           events ??
           const EventChannel('com.quorivell.app/model_transfer_events');

  final MethodChannel _channel;
  final EventChannel _events;

  @override
  bool get canRunNativeTransfers => true;

  @override
  Future<PickedGguf?> pickGguf() async {
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>('pickGguf');
      if (raw == null) return null;
      final uri = raw['uri'] as String?;
      if (uri == null || uri.isEmpty) return null;
      final name = (raw['displayName'] as String?) ?? 'model.gguf';
      final sizeRaw = raw['size'];
      final size = sizeRaw is num ? sizeRaw.toInt() : null;
      return PickedGguf(
        uri: uri,
        displayName: name,
        size: size != null && size > 0 ? size : null,
      );
    } on PlatformException catch (_) {
      return null;
    }
  }

  @override
  Future<String?> createGgufDocument({required String suggestedName}) async {
    try {
      final uri = await _channel.invokeMethod<String>('createGgufDocument', {
        'suggestedName': suggestedName,
      });
      if (uri == null || uri.isEmpty) return null;
      return uri;
    } on PlatformException catch (_) {
      return null;
    }
  }

  @override
  Stream<LocalModelDownloadTick> downloadToPart({
    required Uri url,
    required File partFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) {
    return _watchTransfer(
      partFile: partFile,
      requireLocalDest: true,
      start: () => _channel.invokeMethod<void>('startDownload', {
        'url': url.toString(),
        'destPath': partFile.path,
        'existingBytes': existingBytes,
        'totalBytes': totalBytes,
        'title': title,
        'body': body,
      }),
    );
  }

  @override
  Stream<LocalModelDownloadTick> copyFromUri({
    required String uri,
    required File destFile,
    required int existingBytes,
    int? totalBytes,
    String? title,
    String? body,
  }) {
    return _watchTransfer(
      partFile: destFile,
      requireLocalDest: true,
      start: () => _channel.invokeMethod<void>('startCopy', {
        'uri': uri,
        'destPath': destFile.path,
        'existingBytes': existingBytes,
        'totalBytes': totalBytes,
        'title': title,
        'body': body,
      }),
    );
  }

  @override
  Stream<LocalModelDownloadTick> copyToUri({
    required File sourceFile,
    required String uri,
    required File statusFile,
    String? title,
    String? body,
  }) {
    return _watchTransfer(
      partFile: statusFile,
      requireLocalDest: false,
      start: () => _channel.invokeMethod<void>('startExport', {
        'sourcePath': sourceFile.path,
        'uri': uri,
        'statusPath': statusFile.path,
        'title': title,
        'body': body,
      }),
    );
  }

  @override
  void cancelDownload(File partFile) {
    unawaited(
      _channel.invokeMethod<void>('cancelDownload', {
        'destPath': partFile.path,
      }),
    );
  }

  @override
  void cancelCopy(File destFile) {
    unawaited(
      _channel.invokeMethod<void>('cancelCopy', {'destPath': destFile.path}),
    );
  }

  @override
  void cancelExport(File statusFile) {
    unawaited(
      _channel.invokeMethod<void>('cancelExport', {
        'statusPath': statusFile.path,
      }),
    );
  }

  @override
  Future<bool> isTransferRunning() async {
    try {
      final running = await _channel.invokeMethod<bool>('isTransferRunning');
      return running ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Stream<LocalModelDownloadTick> _watchTransfer({
    required File partFile,
    required Future<void> Function() start,
    bool requireLocalDest = true,
  }) async* {
    final statusFile = File('${partFile.path}.status');
    final events = _events.receiveBroadcastStream();
    final pending = <LocalModelDownloadTick>[];
    var lastYielded = -1;
    var completed = false;
    Object? failure;
    var cancelled = false;

    void handlePayload(Map<Object?, Object?> payload) {
      final path = payload['path'] as String?;
      if (path != null && path.isNotEmpty && path != partFile.path) {
        return;
      }
      final state = payload['state'] as String? ?? '';
      final received = _asInt(payload['received']) ?? 0;
      final totalRaw = _asInt(payload['total']);
      final total = totalRaw != null && totalRaw > 0 ? totalRaw : null;
      switch (state) {
        case 'complete':
          if (requireLocalDest) {
            final length = partFile.existsSync() ? partFile.lengthSync() : 0;
            if (length <= 0) {
              // Leftover `.part.status` after a previous install is not a
              // finished transfer of this empty/missing `.part`.
              return;
            }
          }
          completed = true;
          pending.add(
            LocalModelDownloadTick(
              progress: 1,
              receivedBytes: received,
              totalBytes: total ?? received,
              isFinalizing: true,
            ),
          );
        case 'cancelled':
          cancelled = true;
        case 'failed':
          failure = payload['error'] ?? 'failed';
        default:
          pending.add(
            LocalModelDownloadTick(
              progress: (total != null && total > 0)
                  ? (received / total).clamp(0.0, 1.0)
                  : 0,
              receivedBytes: received,
              totalBytes: total,
            ),
          );
      }
    }

    StreamSubscription<dynamic>? sub;
    sub = events.listen((event) {
      if (event is Map) {
        handlePayload(event);
      }
    });

    try {
      await start();
      while (!completed && failure == null && !cancelled) {
        final status = _readStatusFile(statusFile);
        if (status != null) {
          handlePayload(status);
        }
        while (pending.isNotEmpty) {
          final tick = pending.removeAt(0);
          if (tick.receivedBytes != lastYielded) {
            lastYielded = tick.receivedBytes;
            yield tick;
          }
        }
        if (completed || failure != null || cancelled) break;
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      while (pending.isNotEmpty) {
        final tick = pending.removeAt(0);
        if (tick.receivedBytes != lastYielded) {
          lastYielded = tick.receivedBytes;
          yield tick;
        }
      }
      if (cancelled) {
        throw const LocalModelDownloadCancelledException();
      }
      if (failure != null) {
        throw const LocalModelDownloadException();
      }
    } on LocalModelDownloadCancelledException {
      rethrow;
    } on LocalModelDownloadException {
      rethrow;
    } on PlatformException catch (_) {
      throw const LocalModelDownloadException();
    } finally {
      await sub.cancel();
    }
  }

  Map<Object?, Object?>? _readStatusFile(File file) {
    if (!file.existsSync()) return null;
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is Map) {
        return decoded;
      }
    } on Object {
      return null;
    }
    return null;
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

ModelTransferPlatformService createModelTransferPlatformService() {
  if (Platform.isAndroid) {
    return AndroidModelTransferPlatformService();
  }
  return StubModelTransferPlatformService();
}

@Riverpod(keepAlive: true)
ModelTransferPlatformService modelTransferPlatformService(Ref ref) {
  return createModelTransferPlatformService();
}
