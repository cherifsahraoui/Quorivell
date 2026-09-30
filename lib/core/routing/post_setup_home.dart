/// Shared post-boot / post-onboarding home destinations.
///
/// Prefer Review when the pending queue is non-empty; otherwise Ledger.
abstract final class PostSetupHome {
  static const String ledger = '/ledger';
  static const String review = '/review';
  static const String chat = '/chat';

  /// Review after extract found nothing — opens the conversation-shape sheet.
  static const String reviewEmptyHelp = '/review?teach=1';

  /// Query flag appended by [reviewEmptyHelp].
  static const String teachQuery = 'teach';
  static const String teachValue = '1';

  /// Max numeric badge before showing a capped label (e.g. `9+`).
  static const int badgeMax = 9;

  /// Smart-open path when [pendingCount] is known.
  ///
  /// When [pendingCount] is still loading (`null`), returns [ledger] so
  /// imperative navigations do not flash the wrong tab. The router waits on
  /// `/boot` instead of using this fallback.
  static String locationForPendingCount(int? pendingCount) {
    if (pendingCount != null && pendingCount > 0) {
      return review;
    }
    return ledger;
  }

  /// Visible badge label for a shell destination, or `null` when hidden.
  static String? badgeLabel(int count) {
    if (count <= 0) {
      return null;
    }
    if (count > badgeMax) {
      return '$badgeMax+';
    }
    return '$count';
  }
}
