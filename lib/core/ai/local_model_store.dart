import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'local_model_spec.dart';

/// How the GGUF currently in the store was installed.
enum LocalModelOrigin {
  /// Official production file streamed by the app.
  download,

  /// User-picked `.gguf` copied into the store.
  import,
}

class PartialDownloadInfo {
  const PartialDownloadInfo({
    required this.bytesReceived,
    this.totalBytes,
    this.modelId,
  });

  final int bytesReceived;
  final int? totalBytes;
  final String? modelId;

  double? get progress {
    final total = totalBytes;
    if (total == null || total <= 0) return null;
    return (bytesReceived / total).clamp(0, 1);
  }

  /// True when the `.part` file already has the full payload.
  bool get isComplete {
    final total = totalBytes;
    return total != null && total > 0 && bytesReceived >= total;
  }
}

class PartialImportInfo {
  const PartialImportInfo({
    required this.bytesReceived,
    this.totalBytes,
    this.sourceUri,
    this.displayName,
  });

  final int bytesReceived;
  final int? totalBytes;
  final String? sourceUri;
  final String? displayName;

  double? get progress {
    final total = totalBytes;
    if (total == null || total <= 0) return null;
    return (bytesReceived / total).clamp(0, 1);
  }
}

/// Display identity of the GGUF currently in the store.
class InstalledLocalModelIdentity {
  const InstalledLocalModelIdentity({
    required this.modelId,
    required this.fileName,
    required this.checksumVerified,
  });

  final String modelId;
  final String fileName;
  final bool checksumVerified;
}

const _sidecarImported = 'imported';
const _sidecarAdvisory = 'advisory';

/// Locates and checksums the downloaded GGUF on this device.
class LocalModelStore {
  LocalModelStore({
    required this.resolveDocumentsDirectory,
    this.spec = LocalModelSpec.production,
  });

  final Future<Directory> Function() resolveDocumentsDirectory;
  final LocalModelSpec spec;

  String? _cachedPath;
  int? _cachedLength;
  bool? _cachedReady;

  Future<File> modelFile() async {
    final root = await resolveDocumentsDirectory();
    final directory = Directory('${root.path}${Platform.pathSeparator}models');
    return File('${directory.path}${Platform.pathSeparator}${spec.fileName}');
  }

  Future<File> partialFile() async {
    final destination = await modelFile();
    return File('${destination.path}.part');
  }

  Future<File> partialMetaFile() async {
    final part = await partialFile();
    return File('${part.path}.meta');
  }

  Future<File> importPartialFile() async {
    final destination = await modelFile();
    return File('${destination.path}.import.part');
  }

  Future<File> importPartialMetaFile() async {
    final part = await importPartialFile();
    return File('${part.path}.meta');
  }

  Future<File> verifiedMetaFile() async {
    final destination = await modelFile();
    return File('${destination.path}.verified');
  }

  Future<File> originFile() async {
    final destination = await modelFile();
    return File('${destination.path}.origin');
  }

  /// Local cancel/status sidecar for exporting the installed GGUF to SAF.
  Future<File> exportStatusFile() async {
    final destination = await modelFile();
    return File('${destination.path}.export');
  }

  Future<File> identityFile() async {
    final destination = await modelFile();
    return File('${destination.path}.identity');
  }

  Future<PartialDownloadInfo?> partialProgress() async {
    final part = await partialFile();
    if (!part.existsSync()) return null;
    final bytes = part.lengthSync();
    if (bytes <= 0) return null;
    final meta = await partialMetaFile();
    int? total;
    String? modelId;
    if (meta.existsSync()) {
      final lines = (await meta.readAsString()).split(RegExp(r'\r?\n'));
      if (lines.isNotEmpty) {
        total = int.tryParse(lines[0].trim());
      }
      if (lines.length >= 2 && lines[1].trim().isNotEmpty) {
        modelId = lines[1].trim();
      }
    }
    return PartialDownloadInfo(
      bytesReceived: bytes,
      totalBytes: total != null && total > 0 ? total : null,
      modelId: modelId,
    );
  }

  Future<void> writePartialMeta({int? totalBytes, String? modelId}) async {
    final meta = await partialMetaFile();
    await meta.parent.create(recursive: true);
    final total = (totalBytes != null && totalBytes > 0) ? totalBytes : 0;
    final id = modelId?.trim() ?? '';
    await meta.writeAsString(id.isEmpty ? '$total' : '$total\n$id\n');
  }

  /// Drops a `.part` that is not tagged as [modelId].
  ///
  /// HTTP Range resume of an anonymous or other-model prefix concatenates two
  /// GGUFs and fails SHA-256 after a retry.
  Future<void> clearPartialUnlessFor(String modelId) async {
    final part = await partialFile();
    final meta = await partialMetaFile();
    final status = File('${part.path}.status');
    final hasPart = part.existsSync() && part.lengthSync() > 0;
    final hasMeta = meta.existsSync();
    final hasStatus = status.existsSync();
    if (!hasPart && !hasMeta && !hasStatus) return;
    String? id;
    if (hasMeta) {
      final lines = (await meta.readAsString()).split(RegExp(r'\r?\n'));
      if (lines.length >= 2 && lines[1].trim().isNotEmpty) {
        id = lines[1].trim();
      }
    }
    if (id == modelId) {
      if (!hasPart) {
        await _deleteIfExists(status);
        await _deleteIfExists(File('${part.path}.cancel'));
      }
      return;
    }
    await clearPartialDownload();
  }

  Future<void> clearPartialDownload() async {
    await _deleteTransferArtifacts(await partialFile());
  }

  Future<void> clearImportPartial() async {
    await _deleteTransferArtifacts(await importPartialFile());
  }

  Future<void> writeImportPartialMeta({
    int? totalBytes,
    String? sourceUri,
    String? displayName,
  }) async {
    final meta = await importPartialMetaFile();
    await meta.parent.create(recursive: true);
    final total = totalBytes ?? 0;
    final uri = sourceUri?.trim() ?? '';
    final name = displayName?.trim() ?? '';
    await meta.writeAsString('$total\n$uri\n$name\n');
  }

  Future<PartialImportInfo?> importPartialProgress() async {
    final part = await importPartialFile();
    if (!part.existsSync()) return null;
    final bytes = part.lengthSync();
    if (bytes <= 0) return null;
    final meta = await importPartialMetaFile();
    int? total;
    String? uri;
    String? name;
    if (meta.existsSync()) {
      final lines = (await meta.readAsString()).split(RegExp(r'\r?\n'));
      if (lines.isNotEmpty) {
        total = int.tryParse(lines[0].trim());
      }
      if (lines.length >= 2 && lines[1].trim().isNotEmpty) {
        uri = lines[1].trim();
      }
      if (lines.length >= 3 && lines[2].trim().isNotEmpty) {
        name = lines[2].trim();
      }
    }
    return PartialImportInfo(
      bytesReceived: bytes,
      totalBytes: total != null && total > 0 ? total : null,
      sourceUri: uri,
      displayName: name,
    );
  }

  /// Removes dead temp files that are safe to delete across restarts.
  ///
  /// Keeps a non-empty download `.part` and import `.import.part` by default
  /// so killed transfers can resume. Drops empty temps. When
  /// [keepResumePart] or [keepImportPart] is false, also drops that paused
  /// file. When a model file is already in the store, drops every temp
  /// without SHA-256 hashing the GGUF.
  Future<int> cleanupStaleTemps({
    bool keepResumePart = true,
    bool keepImportPart = true,
  }) async {
    var reclaimed = 0;
    final present = await hasModelFile();

    if (present || !keepImportPart) {
      reclaimed += await _deleteTransferArtifacts(await importPartialFile());
    } else {
      final importPart = await importPartialFile();
      if (!importPart.existsSync() || importPart.lengthSync() <= 0) {
        reclaimed += await _deleteTransferArtifacts(importPart);
      }
    }

    if (present || !keepResumePart) {
      reclaimed += await _deleteTransferArtifacts(await partialFile());
      return reclaimed;
    }

    final part = await partialFile();
    if (!part.existsSync() || part.lengthSync() <= 0) {
      reclaimed += await _deleteTransferArtifacts(part);
    }
    return reclaimed;
  }

  /// True when a non-empty GGUF is in the store. Does not checksum.
  Future<bool> hasModelFile() async {
    final file = await modelFile();
    return file.existsSync() && file.lengthSync() > 0;
  }

  /// Whether a usable GGUF is in the store.
  ///
  /// Official in-app downloads still match [spec.sha256] when that digest is
  /// known. User-imported files skip that check (the user is responsible for
  /// authenticity). After a successful verify, a sidecar records digest +
  /// byte length so later launches do not re-hash ~1 GB. Pass [hashIfNeeded]
  /// false to only trust that sidecar / in-memory cache (used at startup so
  /// the UI can show a checking state instead of the download gate).
  Future<bool> isReady({bool hashIfNeeded = true}) async {
    final file = await modelFile();
    if (!file.existsSync() || file.lengthSync() <= 0) {
      _clearReadyCache();
      return false;
    }
    final cached = _cachedReadyFor(file);
    if (cached != null) return cached;
    if (await _sidecarMatches(file)) {
      _rememberReady(file, true);
      return true;
    }
    final origin = await readOrigin();
    if (origin == LocalModelOrigin.import) {
      _rememberReady(file, true);
      return true;
    }
    if (!hashIfNeeded) return false;

    final digest = await sha256.bind(file.openRead()).first;
    final expected = spec.sha256;
    final ok = expected == null || digest.toString() == expected;
    if (ok) {
      await _writeVerifiedSidecar(file, digest.toString());
    } else if (origin != LocalModelOrigin.download) {
      await _writeVerifiedSidecar(
        file,
        digest.toString(),
        kind: _sidecarAdvisory,
      );
      _rememberReady(file, true);
      return true;
    } else {
      await _deleteIfExists(await verifiedMetaFile());
      _rememberReady(file, false);
    }
    return ok;
  }

  Future<void> installVerified(
    File tempFile,
    String digest, {
    LocalModelOrigin? origin,
    String? expectedSha256,
    LocalModelSpec? identity,
    bool requireChecksum = true,
  }) async {
    final expected = expectedSha256 ?? spec.sha256;
    if (requireChecksum && expected != null && digest != expected) {
      await _deleteIfExists(tempFile);
      throw const LocalModelChecksumException();
    }
    _clearReadyCache();
    final destination = await modelFile();
    await destination.parent.create(recursive: true);
    await _deleteIfExists(await verifiedMetaFile());
    await _deleteWithRetry(destination);
    try {
      await tempFile.rename(destination.path);
    } on FileSystemException {
      // Prefer another rename attempt after ensuring the target is free; copy
      // only as a last resort because it needs ~2× free space.
      try {
        await _deleteWithRetry(destination);
        await tempFile.rename(destination.path);
      } on FileSystemException {
        try {
          await tempFile.copy(destination.path);
          await tempFile.delete();
        } on Object catch (error) {
          await _deleteIfExists(destination);
          if (isOutOfSpaceError(error)) {
            throw const LocalModelStorageFullException();
          }
          rethrow;
        }
      }
    }
    await _writeVerifiedSidecar(
      destination,
      digest,
      kind: requireChecksum && expected != null
          ? null
          : (origin == LocalModelOrigin.import
                ? _sidecarImported
                : _sidecarAdvisory),
    );
    if (origin != null) {
      await writeOrigin(origin);
    }
    final record = identity ?? spec;
    await writeInstalledIdentity(
      InstalledLocalModelIdentity(
        modelId: record.modelId,
        fileName: record.fileName,
        checksumVerified: requireChecksum && expected != null,
      ),
    );
  }

  /// Copies a local GGUF into the store.
  ///
  /// SHA-256 of the recommended download is not required. The user is
  /// responsible for the authenticity of a file they selected.
  ///
  /// Uses a separate `.import.part` temp file so a resumable download `.part`
  /// is not deleted when the user picks a local file.
  Stream<double> installFromBytes(
    Stream<List<int>> bytes, {
    int? totalBytes,
    String? displayName,
    bool resume = false,
    String? sourceUri,
  }) async* {
    yield 0;
    final tempFile = await importPartialFile();
    await tempFile.parent.create(recursive: true);
    var received = 0;
    if (resume && tempFile.existsSync()) {
      received = tempFile.lengthSync();
    } else {
      await _deleteIfExists(tempFile);
    }
    await writeImportPartialMeta(
      totalBytes: totalBytes,
      sourceUri: sourceUri,
      displayName: displayName,
    );

    final ioSink = tempFile.openWrite(
      mode: received > 0 ? FileMode.append : FileMode.write,
    );
    final digestSink = _DigestSink();
    final hashInput = sha256.startChunkedConversion(digestSink);
    final hashIncrementally = received <= 0;
    try {
      try {
        await for (final chunk in bytes) {
          ioSink.add(chunk);
          if (hashIncrementally) {
            hashInput.add(chunk);
          }
          received += chunk.length;
          if (totalBytes != null && totalBytes > 0) {
            yield (received / totalBytes).clamp(0, 1);
          } else {
            yield 0;
          }
        }
      } finally {
        await ioSink.close();
        hashInput.close();
      }

      if (received == 0) {
        await _deleteIfExists(tempFile);
        throw const LocalModelImportException();
      }
      final digest = hashIncrementally
          ? digestSink.value?.toString()
          : (await sha256.bind(tempFile.openRead()).first).toString();
      if (digest == null || digest.isEmpty) {
        await _deleteIfExists(tempFile);
        throw const LocalModelImportException();
      }
      final name = (displayName == null || displayName.trim().isEmpty)
          ? spec.fileName
          : displayName.trim();
      await installVerified(
        tempFile,
        digest,
        origin: LocalModelOrigin.import,
        requireChecksum: false,
        identity: LocalModelSpec(
          modelId: name,
          fileName: name,
          downloadUri: spec.downloadUri,
        ),
      );
      await _deleteIfExists(await importPartialMetaFile());
      yield 1;
    } on LocalModelChecksumException {
      await _deleteIfExists(tempFile);
      rethrow;
    } on LocalModelImportException {
      await _deleteIfExists(tempFile);
      rethrow;
    } on LocalModelStorageFullException {
      await _deleteIfExists(tempFile);
      rethrow;
    } on Object catch (error) {
      await _deleteIfExists(tempFile);
      if (isOutOfSpaceError(error)) {
        throw const LocalModelStorageFullException();
      }
      throw const LocalModelImportException();
    }
  }

  /// Installs from an on-device file path (host copy / Downloads / etc.).
  Stream<double> installFromFile(File source) async* {
    if (!source.existsSync()) {
      throw const LocalModelImportException();
    }
    yield* installFromBytes(
      source.openRead(),
      totalBytes: source.lengthSync(),
      displayName: source.uri.pathSegments.isEmpty
          ? source.path
          : source.uri.pathSegments.last,
    );
  }

  Future<LocalModelOrigin?> readOrigin() async {
    final file = await originFile();
    if (!file.existsSync()) return null;
    return parseLocalModelOrigin(await file.readAsString());
  }

  Future<void> writeOrigin(LocalModelOrigin origin) async {
    final file = await originFile();
    await file.parent.create(recursive: true);
    await file.writeAsString('${origin.name}\n');
  }

  Future<int?> installedByteLength() async {
    final file = await modelFile();
    if (!file.existsSync()) return null;
    final length = file.lengthSync();
    return length > 0 ? length : null;
  }

  Future<InstalledLocalModelIdentity?> readInstalledIdentity() async {
    final file = await identityFile();
    if (!file.existsSync()) return null;
    final lines = (await file.readAsString()).split(RegExp(r'\r?\n'));
    if (lines.length < 2) return null;
    final modelId = lines[0].trim();
    final fileName = lines[1].trim();
    if (modelId.isEmpty || fileName.isEmpty) return null;
    final verified = lines.length >= 3 && lines[2].trim() == '1';
    return InstalledLocalModelIdentity(
      modelId: modelId,
      fileName: fileName,
      checksumVerified: verified,
    );
  }

  Future<void> writeInstalledIdentity(
    InstalledLocalModelIdentity identity,
  ) async {
    final file = await identityFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(
      '${identity.modelId}\n${identity.fileName}\n'
      '${identity.checksumVerified ? '1' : '0'}\n',
    );
  }

  /// Deletes the installed GGUF, checksum sidecar, origin, and temp files.
  Future<void> deleteInstalled() async {
    await removeInstalledWeights();
    await clearPartialDownload();
    await clearImportPartial();
  }

  /// Uninstalls the current GGUF but keeps a resumable `.part`.
  ///
  /// Used when replacing a loaded model so mmap/RAM/disk from the old file
  /// cannot poison the new download.
  Future<void> removeInstalledWeights() async {
    _clearReadyCache();
    await _deleteWithRetry(await modelFile());
    await _deleteIfExists(await verifiedMetaFile());
    await _deleteIfExists(await originFile());
    await _deleteIfExists(await identityFile());
    await _deleteTransferArtifacts(await exportStatusFile());
  }

  Future<int> _deleteTransferArtifacts(File part) async {
    var reclaimed = 0;
    reclaimed += await _deleteIfExists(part);
    reclaimed += await _deleteIfExists(File('${part.path}.meta'));
    reclaimed += await _deleteIfExists(File('${part.path}.status'));
    reclaimed += await _deleteIfExists(File('${part.path}.cancel'));
    return reclaimed;
  }

  Future<int> _deleteIfExists(File file) async {
    if (!file.existsSync()) return 0;
    final size = file.lengthSync();
    await file.delete();
    return size < 0 ? 0 : size;
  }

  /// Deletes [file] when present, retrying Windows sharing violations after
  /// llama.cpp mmap has been asked to release the GGUF.
  Future<void> _deleteWithRetry(File file) async {
    for (var attempt = 0; attempt < 6; attempt++) {
      if (!file.existsSync()) return;
      try {
        await file.delete();
        return;
      } on FileSystemException {
        if (attempt == 5) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 50 * (attempt + 1)));
      }
    }
  }

  bool? _cachedReadyFor(File file) {
    if (_cachedReady == null || _cachedPath != file.path) return null;
    if (_cachedLength != file.lengthSync()) return null;
    return _cachedReady;
  }

  void _rememberReady(File file, bool ready) {
    _cachedPath = file.path;
    _cachedLength = file.lengthSync();
    _cachedReady = ready;
  }

  void _clearReadyCache() {
    _cachedPath = null;
    _cachedLength = null;
    _cachedReady = null;
  }

  Future<bool> _sidecarMatches(File file) async {
    final sidecar = await verifiedMetaFile();
    if (!sidecar.existsSync()) return false;
    final lines = (await sidecar.readAsString()).split(RegExp(r'\r?\n'));
    if (lines.length < 2) return false;
    final digest = lines[0].trim();
    final length = int.tryParse(lines[1].trim());
    if (length == null || digest.isEmpty) return false;
    if (length != file.lengthSync()) return false;
    if (lines.length >= 3) {
      final kind = lines[2].trim();
      if (kind == _sidecarImported || kind == _sidecarAdvisory) {
        return true;
      }
    }
    final expected = spec.sha256;
    if (expected == null) return true;
    return digest == expected;
  }

  Future<void> _writeVerifiedSidecar(
    File file,
    String digest, {
    String? kind,
  }) async {
    _rememberReady(file, true);
    final sidecar = await verifiedMetaFile();
    await sidecar.parent.create(recursive: true);
    final extra = kind == null || kind.isEmpty ? '' : '$kind\n';
    await sidecar.writeAsString('$digest\n${file.lengthSync()}\n$extra');
  }
}

bool isOutOfSpaceError(Object error) {
  if (error is LocalModelStorageFullException) return true;
  if (error is! FileSystemException) return false;
  final code = error.osError?.errorCode;
  // ENOSPC on Linux/Android; ERROR_DISK_FULL / ERROR_HANDLE_DISK_FULL on Windows.
  if (code == 28 || code == 112 || code == 39) return true;
  final message = '${error.message} ${error.osError}'.toLowerCase();
  return message.contains('no space left') ||
      message.contains('not enough space') ||
      message.contains('disk full');
}

class _DigestSink implements ChunkedConversionSink<Digest> {
  Digest? value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}

LocalModelOrigin? parseLocalModelOrigin(String? raw) {
  return switch (raw?.trim()) {
    'download' => LocalModelOrigin.download,
    'import' => LocalModelOrigin.import,
    _ => null,
  };
}

class LocalModelChecksumException implements Exception {
  const LocalModelChecksumException();
}

class LocalModelDownloadException implements Exception {
  const LocalModelDownloadException();
}

class LocalModelImportException implements Exception {
  const LocalModelImportException();
}

class LocalModelExportException implements Exception {
  const LocalModelExportException();
}

class LocalModelStorageFullException implements Exception {
  const LocalModelStorageFullException();
}
