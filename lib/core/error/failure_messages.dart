import '../../l10n/app_localizations.dart';
import 'failures.dart';

/// Maps a typed failure to user-safe localized copy.
///
/// Pages render the result of this function instead of exception text, so no
/// Firebase code, Drift message, or stack detail can leak into the UI.
String failureMessage(
  AppLocalizations l10n,
  Object? failure,
) => switch (failure) {
  AuthInvalidCredentialsFailure() => l10n.errorSignInInvalidCredentials,
  AuthUserDisabledFailure() => l10n.errorSignInUserDisabled,
  AuthTooManyRequestsFailure() => l10n.errorSignInTooManyRequests,
  AuthNetworkFailure() => l10n.errorNetworkUnavailable,
  AuthMissingUserFailure() => l10n.errorSignInInvalidCredentials,
  AuthUnknownFailure() => l10n.errorGeneric,
  ExtractionNoSourceConversationFailure() => l10n.reviewCaptureFirstError,
  ExtractionSourceArchivedFailure() => l10n.errorExtractionSourceArchived,
  ExtractionInvalidInputFailure() => l10n.errorExtractionInvalidInput,
  ExtractionModelUnavailableFailure() => l10n.errorExtractionModelUnavailable,
  ExtractionModelUnsupportedFailure() => l10n.errorExtractionModelUnsupported,
  ExtractionInvalidOutputFailure() => l10n.errorExtractionInvalidOutput,
  ExtractionUnknownFailure() => l10n.errorGeneric,
  ExtractionCancelledFailure() => l10n.extractionStoppedSnackbar,
  ChatInvalidInputFailure() => l10n.errorChatInvalidInput,
  ChatModelUnavailableFailure() => l10n.errorChatModelUnavailable,
  ChatUnknownFailure() => l10n.errorGeneric,
  LocalPersistenceNotFoundFailure() => l10n.errorLocalRecordMissing,
  LocalPersistenceInvalidInputFailure() => l10n.captureValidationError,
  LocalPersistenceAlreadyExistsFailure() => l10n.extractionKindsAlreadyExists,
  LocalPersistenceReadFailedFailure() => l10n.errorLocalStorage,
  LocalPersistenceWriteFailedFailure() => l10n.errorLocalStorage,
  RemoteNetworkFailure() => l10n.errorNetworkUnavailable,
  RemoteFailure() => l10n.errorRemoteUnavailable,
  _ => l10n.errorGeneric,
};
