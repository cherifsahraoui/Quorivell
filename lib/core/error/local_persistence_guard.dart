import 'app_failure.dart';
import 'local_persistence_failure.dart';

/// Runs a local read and converts any Drift or SQLite exception into a typed
/// [LocalPersistenceFailure].
Future<T> guardLocalRead<T>(Future<T> Function() read) async {
  try {
    return await read();
  } on AppFailure {
    rethrow;
  } on Object {
    throw const LocalPersistenceFailure.readFailed();
  }
}

/// Runs a local write and converts any Drift or SQLite exception into a typed
/// [LocalPersistenceFailure].
Future<T> guardLocalWrite<T>(Future<T> Function() write) async {
  try {
    return await write();
  } on AppFailure {
    rethrow;
  } on Object {
    throw const LocalPersistenceFailure.writeFailed();
  }
}

/// Wraps a local stream so database errors surface as typed failures instead of
/// raw Drift exceptions.
Stream<T> guardLocalStream<T>(Stream<T> Function() source) async* {
  try {
    yield* source();
  } on AppFailure {
    rethrow;
  } on Object {
    throw const LocalPersistenceFailure.readFailed();
  }
}
