import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_failure.dart';

part 'local_persistence_failure.freezed.dart';

/// Failures raised by on-device (Drift) persistence.
///
/// Drift exceptions are caught in the data layer and mapped to these values so
/// no database detail reaches controllers or UI copy.
@freezed
sealed class LocalPersistenceFailure
    with _$LocalPersistenceFailure
    implements AppFailure {
  const factory LocalPersistenceFailure.notFound() =
      LocalPersistenceNotFoundFailure;
  const factory LocalPersistenceFailure.invalidInput() =
      LocalPersistenceInvalidInputFailure;
  const factory LocalPersistenceFailure.alreadyExists() =
      LocalPersistenceAlreadyExistsFailure;
  const factory LocalPersistenceFailure.readFailed() =
      LocalPersistenceReadFailedFailure;
  const factory LocalPersistenceFailure.writeFailed() =
      LocalPersistenceWriteFailedFailure;
}
