import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
  ];

  /// The public application name.
  ///
  /// In en, this message translates to:
  /// **'Quorivell'**
  String get appTitle;

  /// Accessible label for the startup loading screen with the rotating app icon.
  ///
  /// In en, this message translates to:
  /// **'Loading Quorivell'**
  String get appBootLoadingSemantics;

  /// Accessible label for an in-progress list or page loading indicator.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingSemantics;

  /// Bottom navigation label for the capture tab.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get navCapture;

  /// Bottom navigation label for the review tab.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// Accessible label for the Review tab when pending candidates exist.
  ///
  /// In en, this message translates to:
  /// **'Review, {count} pending'**
  String navReviewPendingSemantics(int count);

  /// Bottom navigation label for the ledger tab.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get navLedger;

  /// Bottom navigation label for the account tab.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// Bottom navigation label for the on-device AI chat tab.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// Accessible label for the Chat tab when unread replies exist.
  ///
  /// In en, this message translates to:
  /// **'Chat, {count} unread'**
  String navChatUnreadSemantics(int count);

  /// Headline on the capture page.
  ///
  /// In en, this message translates to:
  /// **'Capture a source conversation'**
  String get captureHeadline;

  /// Explanatory copy on the capture page.
  ///
  /// In en, this message translates to:
  /// **'Keep the original wording local. You can review evidence before anything becomes a ledger item.'**
  String get captureSubtitle;

  /// Label for the conversation text field.
  ///
  /// In en, this message translates to:
  /// **'Conversation text'**
  String get captureFieldLabel;

  /// Hint text for the conversation text field.
  ///
  /// In en, this message translates to:
  /// **'Paste or type the rough conversation here'**
  String get captureFieldHint;

  /// Button label to save a captured conversation.
  ///
  /// In en, this message translates to:
  /// **'Save locally'**
  String get captureSaveButton;

  /// Button label shown while a capture is saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get captureSavingButton;

  /// Validation error when the capture field is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter some conversation text before saving.'**
  String get captureValidationError;

  /// Tooltip for the button that opens the conversation history list.
  ///
  /// In en, this message translates to:
  /// **'View past conversations'**
  String get captureHistoryTooltip;

  /// Title when Capture was opened from an Android share.
  ///
  /// In en, this message translates to:
  /// **'Shared text ready to save'**
  String get captureShareBannerTitle;

  /// Explains that a shared text is pending save and will not extract or sync.
  ///
  /// In en, this message translates to:
  /// **'Save it as a local source conversation, or discard it. Sharing does not extract or sync.'**
  String get captureShareBannerBody;

  /// Cancels a pending Android share without saving a source conversation.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get captureShareDiscardButton;

  /// Title of the conversation history list page.
  ///
  /// In en, this message translates to:
  /// **'Past conversations'**
  String get conversationHistoryTitle;

  /// Empty state shown when no conversations have been captured.
  ///
  /// In en, this message translates to:
  /// **'No conversations captured yet.'**
  String get conversationHistoryEmpty;

  /// Filter chip for conversations not yet used for extraction.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get conversationHistoryFilterActive;

  /// Filter chip for conversations already used for extraction.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get conversationHistoryFilterArchived;

  /// Empty state when the archived conversations filter has no rows.
  ///
  /// In en, this message translates to:
  /// **'No archived conversations.'**
  String get conversationHistoryEmptyArchived;

  /// Subtitle for the empty archived conversations state.
  ///
  /// In en, this message translates to:
  /// **'Conversations move here after you extract the kinds you enabled from them.'**
  String get conversationHistoryEmptyArchivedSubtitle;

  /// Badge label on an archived conversation in the history list.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get conversationHistoryArchivedBadge;

  /// Error state when the conversation history fails to load.
  ///
  /// In en, this message translates to:
  /// **'Conversation history unavailable.'**
  String get conversationHistoryUnavailable;

  /// Title of the conversation detail page.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversationDetailTitle;

  /// Shown when a conversation detail cannot be found.
  ///
  /// In en, this message translates to:
  /// **'This conversation is no longer available.'**
  String get conversationDetailNotFound;

  /// Error state when the conversation detail fails to load.
  ///
  /// In en, this message translates to:
  /// **'Conversation unavailable.'**
  String get conversationDetailUnavailable;

  /// Title of the delete-conversation confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete this conversation?'**
  String get conversationDeleteTitle;

  /// Body of the delete-conversation confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the conversation from your history on this device. It cannot be undone.'**
  String get conversationDeleteBody;

  /// Delete-conversation body when the archived source is linked from ledger evidence.
  ///
  /// In en, this message translates to:
  /// **'This removes the conversation from your history on this device. Decisions and commitments that link here will no longer be able to open the original evidence. It cannot be undone.'**
  String get conversationDeleteBodyWithLedgerLinks;

  /// Confirms deleting a captured conversation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get conversationDeleteConfirm;

  /// Dismisses the delete-conversation confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get conversationDeleteCancel;

  /// Tooltip for the delete action on the conversation detail page.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get conversationDeleteTooltip;

  /// SnackBar shown when soft-deleting a conversation fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the conversation. Try again.'**
  String get conversationDeleteFailed;

  /// Title for the bulk conversation delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this conversation?} other{Delete {count} conversations?}}'**
  String conversationBulkDeleteTitle(int count);

  /// Body for the bulk conversation delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected conversations from your history on this device. It cannot be undone.'**
  String get conversationBulkDeleteBody;

  /// Body for bulk delete when any selected conversation is archived and may be linked from the ledger.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected conversations from your history on this device. Decisions and commitments that link here will no longer be able to open the original evidence. It cannot be undone.'**
  String get conversationBulkDeleteBodyWithLedgerLinks;

  /// SnackBar when bulk conversation delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected conversations. Try again.'**
  String get conversationBulkDeleteFailed;

  /// Error state when the review queue fails to load.
  ///
  /// In en, this message translates to:
  /// **'Review queue unavailable.'**
  String get reviewUnavailable;

  /// Error shown when extraction is attempted without a capture.
  ///
  /// In en, this message translates to:
  /// **'Capture a source conversation first.'**
  String get reviewCaptureFirstError;

  /// Title shown when there are no review candidates.
  ///
  /// In en, this message translates to:
  /// **'No candidates waiting for review.'**
  String get reviewEmptyTitle;

  /// Subtitle shown when there are no review candidates but an active capture exists.
  ///
  /// In en, this message translates to:
  /// **'Extract explicit items for the kinds you enabled from your latest local capture.'**
  String get reviewEmptySubtitle;

  /// Title when Review is empty and there is no active (non-archived) capture to extract from.
  ///
  /// In en, this message translates to:
  /// **'Capture a conversation first.'**
  String get reviewEmptyNoCaptureTitle;

  /// Subtitle when Review needs a new active capture before extract can run.
  ///
  /// In en, this message translates to:
  /// **'Extraction only uses active captures. Add a new conversation, then return here to extract.'**
  String get reviewEmptyNoCaptureSubtitle;

  /// Button label to start extraction from active captures.
  ///
  /// In en, this message translates to:
  /// **'Extract'**
  String get reviewExtractButton;

  /// Button that opens Capture when no active conversation is available to extract.
  ///
  /// In en, this message translates to:
  /// **'Go to Capture'**
  String get reviewGoToCaptureButton;

  /// Title shown briefly after the last review candidate is accepted or rejected.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get reviewCompleteTitle;

  /// Subtitle during the short handoff from an empty review queue to the ledger.
  ///
  /// In en, this message translates to:
  /// **'Opening your ledger…'**
  String get reviewCompleteSubtitle;

  /// Button to skip the handoff delay and open the ledger immediately.
  ///
  /// In en, this message translates to:
  /// **'View ledger'**
  String get reviewCompleteGoToLedger;

  /// Message shown when extraction yields no review candidates.
  ///
  /// In en, this message translates to:
  /// **'No explicit decisions or commitments were found in the selected capture(s).'**
  String get reviewNoCandidatesFound;

  /// Title of the extract target chooser sheet on Review.
  ///
  /// In en, this message translates to:
  /// **'What should we extract?'**
  String get extractChooserTitle;

  /// Supporting copy under the extract chooser title.
  ///
  /// In en, this message translates to:
  /// **'Each active capture is extracted separately. Archived captures are skipped.'**
  String get extractChooserSubtitle;

  /// Option to extract every active capture in sequence.
  ///
  /// In en, this message translates to:
  /// **'All active conversations'**
  String get extractChooserAllTitle;

  /// Subtitle for the extract-all option.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Extract 1 capture, oldest to newest} other{Extract {count} captures, oldest to newest}}'**
  String extractChooserAllSubtitle(int count);

  /// Option to pick a single active capture for extraction.
  ///
  /// In en, this message translates to:
  /// **'Choose a conversation'**
  String get extractChooserPickTitle;

  /// Subtitle for the pick-one extract option.
  ///
  /// In en, this message translates to:
  /// **'Extract only one active capture'**
  String get extractChooserPickSubtitle;

  /// Title when listing active captures to extract.
  ///
  /// In en, this message translates to:
  /// **'Choose a capture'**
  String get extractChooserPickListTitle;

  /// Back control from the pick-one list to the extract mode chooser.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get extractChooserBack;

  /// Dismisses the extract target chooser.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get extractChooserCancel;

  /// Accessibility label for a capture row in the extract chooser.
  ///
  /// In en, this message translates to:
  /// **'Capture: {preview}. Updated {date}.'**
  String extractChooserConversationSemantics(String preview, String date);

  /// Shows which conversation is being extracted in a multi-capture run.
  ///
  /// In en, this message translates to:
  /// **'Conversation {current} of {total}'**
  String extractionProgressConversation(int current, int total);

  /// Title of the teaching sheet when extract finds no candidates.
  ///
  /// In en, this message translates to:
  /// **'Nothing explicit to extract'**
  String get reviewEmptyExtractExampleTitle;

  /// Body copy for the empty-extract teaching sheet.
  ///
  /// In en, this message translates to:
  /// **'Quorivell only keeps items that match the kinds you enabled. Capture wording like this, and the highlighted phrases become review candidates.'**
  String get reviewEmptyExtractExampleBody;

  /// Caption above the annotated example conversation.
  ///
  /// In en, this message translates to:
  /// **'Example capture'**
  String get reviewEmptyExtractExampleCaption;

  /// Example sentence that contains an explicit commitment. Must include reviewEmptyExtractExampleCommitmentSpan as an exact substring.
  ///
  /// In en, this message translates to:
  /// **'During today\'s sync, Alex explicitly committed to delivering the API documentation by October 15th.'**
  String get reviewEmptyExtractExampleCommitmentSentence;

  /// Highlighted commitment span; must appear verbatim inside reviewEmptyExtractExampleCommitmentSentence.
  ///
  /// In en, this message translates to:
  /// **'Alex explicitly committed to delivering the API documentation by October 15th'**
  String get reviewEmptyExtractExampleCommitmentSpan;

  /// Example sentence that contains an explicit decision. Must include reviewEmptyExtractExampleDecisionSpan as an exact substring.
  ///
  /// In en, this message translates to:
  /// **'We evaluated two designs for the homepage, and the team officially decided to proceed with Option A.'**
  String get reviewEmptyExtractExampleDecisionSentence;

  /// Highlighted decision span; must appear verbatim inside reviewEmptyExtractExampleDecisionSentence.
  ///
  /// In en, this message translates to:
  /// **'the team officially decided to proceed with Option A'**
  String get reviewEmptyExtractExampleDecisionSpan;

  /// Example sentence that should not produce a candidate. Must include reviewEmptyExtractExampleSkippedSpan as an exact substring.
  ///
  /// In en, this message translates to:
  /// **'Mark mentioned he might look into the database performance issues, but no formal commitment was made.'**
  String get reviewEmptyExtractExampleSkippedSentence;

  /// Highlighted non-candidate span; must appear verbatim inside reviewEmptyExtractExampleSkippedSentence.
  ///
  /// In en, this message translates to:
  /// **'Mark mentioned he might look into the database performance issues'**
  String get reviewEmptyExtractExampleSkippedSpan;

  /// Chip label for vague wording that is intentionally not extracted.
  ///
  /// In en, this message translates to:
  /// **'Not extracted'**
  String get reviewEmptyExtractExampleSkippedLabel;

  /// Example sentence for a custom enabled extraction kind. Must include reviewEmptyExtractExampleCustomSpan as an exact substring.
  ///
  /// In en, this message translates to:
  /// **'In the notes they clearly listed items for {kindName}: milk, eggs, and bread.'**
  String reviewEmptyExtractExampleCustomSentence(String kindName);

  /// Highlighted custom-kind span; must appear verbatim inside reviewEmptyExtractExampleCustomSentence.
  ///
  /// In en, this message translates to:
  /// **'milk, eggs, and bread'**
  String get reviewEmptyExtractExampleCustomSpan;

  /// Label for the editable candidate statement field.
  ///
  /// In en, this message translates to:
  /// **'Candidate statement'**
  String get reviewCandidateStatementLabel;

  /// Evidence quote shown on a review candidate card.
  ///
  /// In en, this message translates to:
  /// **'Evidence: “{quote}”'**
  String reviewEvidenceLabel(String quote);

  /// Debug-only expansion label for the extraction JSON that produced a review candidate.
  ///
  /// In en, this message translates to:
  /// **'Source JSON'**
  String get reviewDebugSourceJson;

  /// Debug-only button to copy a review candidate's source JSON.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON'**
  String get reviewDebugCopySourceJson;

  /// Debug-only snackbar after copying a review candidate's source JSON.
  ///
  /// In en, this message translates to:
  /// **'Source JSON copied'**
  String get reviewDebugSourceJsonCopied;

  /// Owner label shown on a candidate or ledger item.
  ///
  /// In en, this message translates to:
  /// **'Owner: {owner}'**
  String ownerLabel(String owner);

  /// Button label to accept a review candidate.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get reviewAcceptButton;

  /// Button to optionally set a due date for a commitment.
  ///
  /// In en, this message translates to:
  /// **'Set due date (optional)'**
  String get reviewSetDueDateOptional;

  /// Title for the due date picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Set due date'**
  String get reviewDueDateDialogTitle;

  /// Label for the date field in due date picker.
  ///
  /// In en, this message translates to:
  /// **'Date (optional)'**
  String get reviewDueDateDialogDateLabel;

  /// Label for the time field in due date picker.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get reviewDueDateDialogTimeLabel;

  /// Save button in due date picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get reviewDueDateDialogSave;

  /// Cancel button in due date picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reviewDueDateDialogCancel;

  /// Button to clear/remove the due date.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get reviewDueDateDialogClear;

  /// Button label to reject a review candidate.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reviewRejectButton;

  /// Tooltip for the history button that opens rejected suggestions and extraction runs.
  ///
  /// In en, this message translates to:
  /// **'View rejected suggestions and extraction history'**
  String get reviewRejectedHistoryTooltip;

  /// App bar title for rejected suggestions and extraction run history.
  ///
  /// In en, this message translates to:
  /// **'Review history'**
  String get reviewRejectedHistoryTitle;

  /// Empty state title when there are no rejected review candidates.
  ///
  /// In en, this message translates to:
  /// **'No rejected suggestions.'**
  String get reviewRejectedHistoryEmpty;

  /// Empty state subtitle for the rejected review suggestions list.
  ///
  /// In en, this message translates to:
  /// **'Suggestions you reject appear here so you can review or delete them later.'**
  String get reviewRejectedHistoryEmptySubtitle;

  /// Error state when the rejected review list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Rejected suggestions unavailable.'**
  String get reviewRejectedHistoryUnavailable;

  /// Status badge on a rejected review suggestion tile.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get reviewRejectedBadge;

  /// Title of the confirm-delete dialog for a rejected review suggestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this suggestion?'**
  String get reviewRejectedDeleteTitle;

  /// Body of the confirm-delete dialog for a rejected review suggestion.
  ///
  /// In en, this message translates to:
  /// **'This removes the suggestion from your history on this device. It cannot be undone.'**
  String get reviewRejectedDeleteBody;

  /// Confirms deleting a rejected review suggestion.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get reviewRejectedDeleteConfirm;

  /// Dismisses the delete-rejected-suggestion confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reviewRejectedDeleteCancel;

  /// SnackBar shown when soft-deleting a rejected suggestion fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the suggestion. Try again.'**
  String get reviewRejectedDeleteFailed;

  /// Title for the bulk rejected-suggestion delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this suggestion?} other{Delete {count} suggestions?}}'**
  String reviewRejectedBulkDeleteTitle(int count);

  /// Body for the bulk rejected-suggestion delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected suggestions from your history on this device. It cannot be undone.'**
  String get reviewRejectedBulkDeleteBody;

  /// SnackBar when bulk rejected-suggestion delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected suggestions. Try again.'**
  String get reviewRejectedBulkDeleteFailed;

  /// Title for the bulk extraction-run delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this extraction run?} other{Delete {count} extraction runs?}}'**
  String extractionHistoryBulkDeleteTitle(int count);

  /// Body for the bulk extraction-run delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected extraction runs from your history on this device. It cannot be undone.'**
  String get extractionHistoryBulkDeleteBody;

  /// SnackBar when bulk extraction-run delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected extraction runs. Try again.'**
  String get extractionHistoryBulkDeleteFailed;

  /// Title for deleting a single extraction run.
  ///
  /// In en, this message translates to:
  /// **'Delete this extraction run?'**
  String get extractionHistoryDeleteTitle;

  /// Body for deleting a single extraction run.
  ///
  /// In en, this message translates to:
  /// **'This removes the extraction run from your history on this device. It cannot be undone.'**
  String get extractionHistoryDeleteBody;

  /// Confirm button for deleting an extraction run.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get extractionHistoryDeleteConfirm;

  /// Cancel button for deleting an extraction run.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get extractionHistoryDeleteCancel;

  /// SnackBar when deleting an extraction run fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the extraction run. Try again.'**
  String get extractionHistoryDeleteFailed;

  /// Title of the dialog to accept a rejected review suggestion into the ledger.
  ///
  /// In en, this message translates to:
  /// **'Accept suggestion'**
  String get reviewRejectedAcceptTitle;

  /// SnackBar shown after accepting a rejected suggestion into the ledger.
  ///
  /// In en, this message translates to:
  /// **'Suggestion added to your ledger.'**
  String get reviewRejectedAcceptSuccess;

  /// SnackBar shown when accepting a rejected suggestion fails.
  ///
  /// In en, this message translates to:
  /// **'Could not accept the suggestion. Try again.'**
  String get reviewRejectedAcceptFailed;

  /// Tab label for rejected suggestions in the history page.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get reviewRejectedTabTitle;

  /// Tab label for extraction history in the history page.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get extractionHistoryTabTitle;

  /// Empty state title when there are no extraction runs.
  ///
  /// In en, this message translates to:
  /// **'No extraction runs yet.'**
  String get extractionHistoryEmpty;

  /// Empty state subtitle for the extraction history list.
  ///
  /// In en, this message translates to:
  /// **'Extraction history shows how long each run took, which model was used, and how many findings were extracted.'**
  String get extractionHistoryEmptySubtitle;

  /// Error state when the extraction history list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Extraction history unavailable.'**
  String get extractionHistoryUnavailable;

  /// Shows when the extraction run completed.
  ///
  /// In en, this message translates to:
  /// **'Completed {timestamp}'**
  String extractionHistoryCompletedAt(String timestamp);

  /// Shows how long the extraction run took.
  ///
  /// In en, this message translates to:
  /// **'Took {seconds}s'**
  String extractionHistoryDuration(String seconds);

  /// Count of decision findings in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'{count} decisions'**
  String extractionHistoryDecisionCount(int count);

  /// Count of commitment findings in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'{count} commitments'**
  String extractionHistoryCommitmentCount(int count);

  /// Count of accepted findings in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'{count} accepted'**
  String extractionHistoryAcceptedCount(int count);

  /// Count of rejected findings in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'{count} rejected'**
  String extractionHistoryRejectedCount(int count);

  /// Count of pending findings in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String extractionHistoryPendingCount(int count);

  /// Accessible status label for a successful extraction run.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get extractionHistoryStatusSuccess;

  /// Status label for a failed extraction run.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get extractionHistoryStatusFailure;

  /// Label for a review candidate of kind decision.
  ///
  /// In en, this message translates to:
  /// **'Decision'**
  String get reviewKindDecision;

  /// Label for a review candidate of kind commitment.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get reviewKindCommitment;

  /// Semantics label for the Decision / Commitment toggle on review.
  ///
  /// In en, this message translates to:
  /// **'Change candidate type'**
  String get reviewKindToggleSemantics;

  /// Error state when the ledger fails to load.
  ///
  /// In en, this message translates to:
  /// **'Ledger unavailable.'**
  String get ledgerUnavailable;

  /// Empty state when there are no open commitments.
  ///
  /// In en, this message translates to:
  /// **'No open commitments.'**
  String get ledgerEmpty;

  /// Title for the first-time empty ledger home state.
  ///
  /// In en, this message translates to:
  /// **'Your ledger is ready.'**
  String get ledgerEmptyStartTitle;

  /// Subtitle guiding users from an empty ledger into Capture.
  ///
  /// In en, this message translates to:
  /// **'Capture a conversation to extract the kinds you enabled, or add an item yourself.'**
  String get ledgerEmptyStartSubtitle;

  /// Button that navigates from an empty ledger to Capture.
  ///
  /// In en, this message translates to:
  /// **'Capture a conversation'**
  String get ledgerEmptyGoToCapture;

  /// Empty state when the full ledger has no items.
  ///
  /// In en, this message translates to:
  /// **'Nothing in the ledger yet.'**
  String get ledgerEmptyAll;

  /// Subtitle for the empty all-items ledger state.
  ///
  /// In en, this message translates to:
  /// **'Accepted or added decisions and commitments appear here.'**
  String get ledgerEmptyAllSubtitle;

  /// Empty state when there are no accepted decisions.
  ///
  /// In en, this message translates to:
  /// **'No decisions yet.'**
  String get ledgerEmptyDecisions;

  /// Subtitle for the empty decisions ledger state.
  ///
  /// In en, this message translates to:
  /// **'Accepted or added decisions appear here.'**
  String get ledgerEmptyDecisionsSubtitle;

  /// Empty state when there are no completed commitments.
  ///
  /// In en, this message translates to:
  /// **'No completed commitments.'**
  String get ledgerEmptyCompleted;

  /// Subtitle for the empty completed-commitments state.
  ///
  /// In en, this message translates to:
  /// **'Check off open commitments to move them here.'**
  String get ledgerEmptyCompletedSubtitle;

  /// Empty state when a ledger search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No matching ledger items.'**
  String get ledgerNoMatches;

  /// Label for the ledger search field.
  ///
  /// In en, this message translates to:
  /// **'Search the ledger'**
  String get ledgerSearchLabel;

  /// Tooltip and accessible name for clearing the ledger search field.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get ledgerSearchClearTooltip;

  /// Subtitle when a ledger search has no matches.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get ledgerSearchNoMatchesSubtitle;

  /// Subtitle showing how many open commitments are visible.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 open commitment} other{{count} open commitments}}'**
  String ledgerOpenCount(int count);

  /// Subtitle showing how many completed commitments are visible.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 completed commitment} other{{count} completed commitments}}'**
  String ledgerCompletedCount(int count);

  /// Subtitle showing how many decisions are visible.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 decision} other{{count} decisions}}'**
  String ledgerDecisionCount(int count);

  /// Subtitle showing how many mixed ledger items are visible.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ledger item} other{{count} ledger items}}'**
  String ledgerItemCount(int count);

  /// Ledger kind filter for all items.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ledgerFilterAll;

  /// Ledger kind filter for decisions only.
  ///
  /// In en, this message translates to:
  /// **'Decisions'**
  String get ledgerFilterDecisions;

  /// Ledger kind filter for commitments only.
  ///
  /// In en, this message translates to:
  /// **'Commitments'**
  String get ledgerFilterCommitments;

  /// Ledger status filter for open commitments.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ledgerFilterOpen;

  /// Ledger status filter for completed commitments.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ledgerFilterCompleted;

  /// Status chip label for an open commitment.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ledgerStatusOpen;

  /// Status chip label for a completed commitment.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ledgerStatusCompleted;

  /// Due date label on a ledger item.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String ledgerDueDateLabel(String date);

  /// Title for the ledger delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Remove this ledger item?'**
  String get ledgerDeleteTitle;

  /// Body for the ledger delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the item and its evidence from this device. It cannot be undone.'**
  String get ledgerDeleteBody;

  /// Confirm button for ledger delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get ledgerDeleteConfirm;

  /// Cancel button for ledger delete.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get ledgerDeleteCancel;

  /// Tooltip for deleting a ledger item.
  ///
  /// In en, this message translates to:
  /// **'Delete ledger item'**
  String get ledgerDeleteTooltip;

  /// SnackBar when ledger delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the ledger item. Try again.'**
  String get ledgerDeleteFailed;

  /// Tooltip for entering ledger multi-select mode.
  ///
  /// In en, this message translates to:
  /// **'Select items'**
  String get ledgerSelectTooltip;

  /// Button that exits ledger multi-select mode.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ledgerSelectionDone;

  /// Subtitle showing how many ledger items are selected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Select items} =1{1 selected} other{{count} selected}}'**
  String ledgerSelectedCount(int count);

  /// Title for the bulk ledger delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Remove this ledger item?} other{Remove {count} ledger items?}}'**
  String ledgerBulkDeleteTitle(int count);

  /// Body for the bulk ledger delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected items and their evidence from this device. It cannot be undone.'**
  String get ledgerBulkDeleteBody;

  /// Tooltip for deleting selected ledger items.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get ledgerBulkDeleteTooltip;

  /// SnackBar when bulk ledger delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected ledger items. Try again.'**
  String get ledgerBulkDeleteFailed;

  /// Tooltip for selecting every visible ledger item.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get ledgerSelectAllTooltip;

  /// Tooltip for clearing the ledger multi-select selection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get ledgerClearSelectionTooltip;

  /// Tooltip for entering multi-select mode on a history or catalog list.
  ///
  /// In en, this message translates to:
  /// **'Select items'**
  String get listSelectTooltip;

  /// Button that exits multi-select mode on a history or catalog list.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get listSelectionDone;

  /// Subtitle or app-bar status showing how many list items are selected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Select items} =1{1 selected} other{{count} selected}}'**
  String listSelectedCount(int count);

  /// Tooltip for deleting selected list items.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get listBulkDeleteTooltip;

  /// Tooltip for selecting every selectable item in a list.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get listSelectAllTooltip;

  /// Tooltip for clearing the multi-select selection on a list.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get listClearSelectionTooltip;

  /// SnackBar when ledger status update fails.
  ///
  /// In en, this message translates to:
  /// **'Could not update the ledger item. Try again.'**
  String get ledgerUpdateFailed;

  /// Fallback app bar title for ledger detail.
  ///
  /// In en, this message translates to:
  /// **'Ledger item'**
  String get ledgerDetailTitle;

  /// Empty state when a ledger item id is missing.
  ///
  /// In en, this message translates to:
  /// **'This ledger item is no longer available.'**
  String get ledgerDetailNotFound;

  /// Error state when ledger detail fails to load.
  ///
  /// In en, this message translates to:
  /// **'Ledger item unavailable.'**
  String get ledgerDetailUnavailable;

  /// Section title for evidence on ledger detail.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get ledgerEvidenceSectionTitle;

  /// Empty evidence section on ledger detail.
  ///
  /// In en, this message translates to:
  /// **'No evidence is attached to this item.'**
  String get ledgerEvidenceEmpty;

  /// Error state when evidence fails to load.
  ///
  /// In en, this message translates to:
  /// **'Evidence unavailable.'**
  String get ledgerEvidenceUnavailable;

  /// Semantics and affordance for opening the archived source from ledger evidence.
  ///
  /// In en, this message translates to:
  /// **'View in conversation'**
  String get ledgerEvidenceOpenSource;

  /// Title when ledger evidence points at a deleted archived conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation unavailable'**
  String get ledgerEvidenceSourceDeletedTitle;

  /// Body when ledger evidence cannot open a deleted source conversation.
  ///
  /// In en, this message translates to:
  /// **'The archived conversation linked to this evidence was deleted, so the original text can no longer be opened.'**
  String get ledgerEvidenceSourceDeletedBody;

  /// Dismisses the deleted-source evidence dialog.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ledgerEvidenceSourceDeletedDismiss;

  /// Tooltip for creating a user-authored ledger item.
  ///
  /// In en, this message translates to:
  /// **'Add a ledger item'**
  String get ledgerAddTooltip;

  /// Empty-state action that opens the manual ledger create form.
  ///
  /// In en, this message translates to:
  /// **'Add a ledger item'**
  String get ledgerEmptyAddItem;

  /// App bar title for the manual ledger create form.
  ///
  /// In en, this message translates to:
  /// **'Add to ledger'**
  String get ledgerCreateTitle;

  /// Primary button that saves a user-authored ledger item.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get ledgerCreateSave;

  /// SnackBar when manual ledger create fails.
  ///
  /// In en, this message translates to:
  /// **'Could not add the ledger item. Try again.'**
  String get ledgerCreateFailed;

  /// Title for the leave-confirmation dialog when a form has unsaved edits.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChangesTitle;

  /// Body for the leave-confirmation dialog when a form has unsaved edits.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving? Your edits will be lost.'**
  String get unsavedChangesBody;

  /// Dismisses the unsaved-changes dialog and stays on the form.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get unsavedChangesKeepEditing;

  /// Leaves the form without saving edits.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get unsavedChangesDiscard;

  /// Saves the form then leaves, from the unsaved-changes dialog.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get unsavedChangesSave;

  /// Label for the statement field on the manual ledger create form.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get ledgerCreateStatementLabel;

  /// Label for the optional owner field on the manual ledger create form.
  ///
  /// In en, this message translates to:
  /// **'Owner (optional)'**
  String get ledgerCreateOwnerLabel;

  /// Semantics label for Decision / Commitment on the create form.
  ///
  /// In en, this message translates to:
  /// **'Item type'**
  String get ledgerCreateKindSemantics;

  /// Detail copy when a ledger item has no evidence because it was added by the user.
  ///
  /// In en, this message translates to:
  /// **'You added this item. No conversation evidence is attached.'**
  String get ledgerManualOriginNote;

  /// Title on the welcome/onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Quorivell.'**
  String get welcomeTitle;

  /// Body copy on the welcome onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'The private, local-first platform to capture meeting conversations, extract the kinds you enable (Decision and Commitment are the built-in example), and build a secure, evidence-backed ledger. Your data stays on your device.'**
  String get welcomeBody;

  /// Brand tagline on the welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Decisions, with evidence.'**
  String get welcomeSubtitle;

  /// First feature title on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Private by default'**
  String get welcomeFeature1Title;

  /// First feature subtitle on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Your conversations stay local. Review evidence before committing anything.'**
  String get welcomeFeature1Subtitle;

  /// Second feature title on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Turn conversations into ledger items'**
  String get welcomeFeature2Title;

  /// Second feature subtitle on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Extract the kinds you enable — Decision and Commitment are the built-in example — with evidence from rough notes.'**
  String get welcomeFeature2Subtitle;

  /// Third feature title on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Track what matters'**
  String get welcomeFeature3Title;

  /// Third feature subtitle on welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Keep commitments visible with owners and due dates.'**
  String get welcomeFeature3Subtitle;

  /// Button label to leave the welcome page and start the onboarding tour.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStartedButton;

  /// Prefix for the skip-onboarding action on the welcome screen.
  ///
  /// In en, this message translates to:
  /// **'You know the app already?'**
  String get welcomeAlreadyUser;

  /// Action that skips the onboarding tour and opens the local app.
  ///
  /// In en, this message translates to:
  /// **'Skip onboarding'**
  String get welcomeSignInLocally;

  /// Skip the remaining onboarding pages.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Advance to the next onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Return to the previous onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Accessible label for a reserved onboarding illustration.
  ///
  /// In en, this message translates to:
  /// **'Illustration placeholder'**
  String get onboardingIllustrationPlaceholder;

  /// Title of the capture onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Capture Effortlessly.'**
  String get onboardingCaptureTitle;

  /// Body copy of the capture onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Seamlessly capture conversation text. Quorivell can process audio or imported notes from your meetings, keeping raw content secure.'**
  String get onboardingCaptureBody;

  /// Title of the extract onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Choose what to extract.'**
  String get onboardingExtractTitle;

  /// Body copy of the extract onboarding page.
  ///
  /// In en, this message translates to:
  /// **'You choose what to look for. Decision and Commitment are the built-in example. Every item still needs an exact quote and your review before it reaches the ledger.'**
  String get onboardingExtractBody;

  /// Title of the local AI chat onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Chat with Local AI.'**
  String get onboardingChatTitle;

  /// Body copy of the local AI chat onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Talk directly with the on-device AI anytime. Chats stay private on this device — nothing is sent to the cloud.'**
  String get onboardingChatBody;

  /// Tip copy on the local AI chat onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Tip, open Chat to ask the local AI without sharing your conversation off this device.'**
  String get onboardingChatTip;

  /// Title of the privacy onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Privacy First. Locally.'**
  String get onboardingPrivacyTitle;

  /// Body copy of the privacy onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Your conversations, evidence, and ledger are your own. No raw data ever leaves without your explicit consent. Your digital integrity is our priority.'**
  String get onboardingPrivacyBody;

  /// Badge on the capture onboarding preview card.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get onboardingLocalOnly;

  /// Heading inside the privacy onboarding tip card.
  ///
  /// In en, this message translates to:
  /// **'Ready to start?'**
  String get onboardingReadyToStart;

  /// Tip copy on the privacy onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Tip, your conversations, raw data live on a single device.'**
  String get onboardingPrivacyTip;

  /// Primary action on the last onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Begin My First Capture'**
  String get onboardingBeginCapture;

  /// Primary action on the model reinstall gate after the welcome tour was already completed.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinueToApp;

  /// Visible step counter for the onboarding tour pages.
  ///
  /// In en, this message translates to:
  /// **'{page} of {total}'**
  String onboardingStepCounter(int page, int total);

  /// Accessible label for the welcome screen logo image.
  ///
  /// In en, this message translates to:
  /// **'Quorivell logo'**
  String get onboardingLogoSemantics;

  /// Accessible label for the welcome screen wordmark image.
  ///
  /// In en, this message translates to:
  /// **'Quorivell'**
  String get onboardingWordmarkSemantics;

  /// Accessible label for the capture onboarding illustration.
  ///
  /// In en, this message translates to:
  /// **'People capturing a meeting conversation'**
  String get onboardingCaptureIllustrationSemantics;

  /// Accessible label for the extract onboarding illustration.
  ///
  /// In en, this message translates to:
  /// **'Conversation text extracted into commitments and decisions'**
  String get onboardingExtractIllustrationSemantics;

  /// Accessible label for the local AI chat onboarding illustration.
  ///
  /// In en, this message translates to:
  /// **'On-device AI chat assistant on a phone'**
  String get onboardingChatIllustrationSemantics;

  /// Accessible label for the privacy onboarding illustration.
  ///
  /// In en, this message translates to:
  /// **'Local-only privacy: no cloud, data stays on this device'**
  String get onboardingPrivacyIllustrationSemantics;

  /// Title of the review onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Review before anything is saved'**
  String get onboardingReviewTitle;

  /// Body copy of the review onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Candidates stay pending until you accept them with supporting evidence.'**
  String get onboardingReviewBody;

  /// Title of the ledger onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Keep a decision ledger'**
  String get onboardingLedgerTitle;

  /// Body copy of the ledger onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Accepted decisions and commitments stay visible with a path back to the conversation.'**
  String get onboardingLedgerBody;

  /// Title of the commit onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Commit only what you trust'**
  String get onboardingCommitTitle;

  /// Body copy of the commit onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Confirm owner, due date, and evidence before an item enters your ledger.'**
  String get onboardingCommitBody;

  /// Privacy badge shown in onboarding previews.
  ///
  /// In en, this message translates to:
  /// **'Local-First'**
  String get onboardingLocalFirstBadge;

  /// Primary capture action shown in the home preview.
  ///
  /// In en, this message translates to:
  /// **'New Capture'**
  String get onboardingNewCapture;

  /// Section title in the home onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Recent Conversations'**
  String get onboardingRecentConversations;

  /// Footer status in the home onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Ready for review'**
  String get onboardingReadyForReview;

  /// Section title in the review onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Reviewable candidates'**
  String get onboardingReviewableCandidates;

  /// Status chip for a candidate awaiting review.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get onboardingPendingReview;

  /// Status chip for an extracted candidate.
  ///
  /// In en, this message translates to:
  /// **'Extracted'**
  String get onboardingExtracted;

  /// Secondary action to discard a candidate in onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get onboardingDiscard;

  /// Primary action on the commit onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Commit to Ledger'**
  String get onboardingCommitToLedger;

  /// Active filter chip on the ledger onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get onboardingLedgerActive;

  /// Resolved filter chip on the ledger onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get onboardingLedgerResolved;

  /// Archived filter chip on the ledger onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get onboardingLedgerArchived;

  /// Evidence link label in onboarding previews.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get onboardingEvidence;

  /// Conversation link label in onboarding previews.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get onboardingConversation;

  /// Owner field label in the commit onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get onboardingOwner;

  /// Due date field label in the commit onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get onboardingDueDate;

  /// Summary field label in the commit onboarding preview.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get onboardingSummary;

  /// Accessibility label for the current onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Onboarding, page {page} of {total}'**
  String onboardingPageSemantics(int page, int total);

  /// Title of the account page.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// Subtitle of the account page.
  ///
  /// In en, this message translates to:
  /// **'Your local preferences, privacy, and app information.'**
  String get accountSubtitle;

  /// Section header for preferences on account page.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get accountSectionPreferences;

  /// Section header for privacy, local processing, and sync status on the account page.
  ///
  /// In en, this message translates to:
  /// **'Privacy and processing'**
  String get accountSectionPrivacy;

  /// Label for on-device processing status on the account page.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get accountProcessingStatusLabel;

  /// Value showing that extraction and processing stay on-device.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get accountProcessingStatusValue;

  /// Explains that local processing does not send source text off-device.
  ///
  /// In en, this message translates to:
  /// **'Extraction runs locally. Source conversations do not leave this device.'**
  String get accountProcessingStatusBody;

  /// Label for account sync status on the account page.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get accountSyncStatusLabel;

  /// Value showing that account sync is not enabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get accountSyncStatusValue;

  /// Explains that there is no cloud sync writer yet.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on this device. Account sync is not available yet.'**
  String get accountSyncStatusBody;

  /// Section header for about section on account page.
  ///
  /// In en, this message translates to:
  /// **'About Quorivell'**
  String get accountSectionAbout;

  /// Title for notification permission card.
  ///
  /// In en, this message translates to:
  /// **'Completion notifications'**
  String get accountNotificationPermissionTitle;

  /// Body explaining why notification permission is needed.
  ///
  /// In en, this message translates to:
  /// **'Quorivell can notify you when extraction, a chat reply, or model install finishes in the background.'**
  String get accountNotificationPermissionBody;

  /// Additional context explaining notification purpose.
  ///
  /// In en, this message translates to:
  /// **'Extraction, chat, and on-device model install run locally. Notifications let you know when they finish, even if the app is backgrounded.'**
  String get accountNotificationPermissionReason;

  /// Button to request notification permission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get accountNotificationPermissionAllow;

  /// Button to decline notification permission for now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get accountNotificationPermissionNotNow;

  /// Title when notification permission is granted.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get accountNotificationPermissionGrantedTitle;

  /// Body text when notification permission is granted.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified when extractions, chat replies, or model installs complete.'**
  String get accountNotificationPermissionGrantedBody;

  /// Title when notification permission is permanently denied.
  ///
  /// In en, this message translates to:
  /// **'Notifications blocked'**
  String get accountNotificationPermissionDeniedTitle;

  /// Body text when notification permission is permanently denied.
  ///
  /// In en, this message translates to:
  /// **'To receive completion notifications for extraction, chat, and model install, enable them in system settings.'**
  String get accountNotificationPermissionDeniedBody;

  /// Button to open system settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get accountNotificationPermissionOpenSettings;

  /// Title for soft prompt shown when starting extraction without notification permission.
  ///
  /// In en, this message translates to:
  /// **'Enable extraction notifications?'**
  String get notificationPermissionExtractionReminderTitle;

  /// Body for soft prompt before extraction when notifications are not granted.
  ///
  /// In en, this message translates to:
  /// **'Quorivell can notify you when this extraction finishes in the background. Extraction will continue either way.'**
  String get notificationPermissionExtractionReminderBody;

  /// Dismiss action that continues extraction without enabling notifications.
  ///
  /// In en, this message translates to:
  /// **'Continue without notifications'**
  String get notificationPermissionExtractionReminderContinue;

  /// Title for soft prompt before model download or copy without notification permission.
  ///
  /// In en, this message translates to:
  /// **'Enable model install notifications?'**
  String get notificationPermissionModelInstallReminderTitle;

  /// Body for soft prompt before model install when notifications are not granted.
  ///
  /// In en, this message translates to:
  /// **'Quorivell can notify you when this model download or copy finishes in the background. The transfer will continue either way.'**
  String get notificationPermissionModelInstallReminderBody;

  /// Title when Android per-app Restricted battery setting can stop background work.
  ///
  /// In en, this message translates to:
  /// **'Background restriction is on'**
  String get backgroundRestrictionReminderTitle;

  /// Body before extraction when the app is Restricted. Names Xiaomi and stock Android allowlist labels.
  ///
  /// In en, this message translates to:
  /// **'This app is restricted in the background. Choose No restrictions or Unrestricted so extraction can continue if you leave the app.'**
  String get backgroundRestrictionReminderExtractionBody;

  /// Body before model download or copy when the app is Restricted. Names Xiaomi and stock Android allowlist labels.
  ///
  /// In en, this message translates to:
  /// **'This app is restricted in the background. Choose No restrictions or Unrestricted so model install can continue if you leave the app.'**
  String get backgroundRestrictionReminderModelInstallBody;

  /// Title when system Battery Saver may slow on-device work.
  ///
  /// In en, this message translates to:
  /// **'Battery Saver is on'**
  String get backgroundBatterySaverReminderTitle;

  /// Body before extraction when Battery Saver is on.
  ///
  /// In en, this message translates to:
  /// **'Battery Saver may slow on-device extraction.'**
  String get backgroundBatterySaverReminderExtractionBody;

  /// Body before model download or copy when Battery Saver is on.
  ///
  /// In en, this message translates to:
  /// **'Battery Saver may slow on-device model install.'**
  String get backgroundBatterySaverReminderModelInstallBody;

  /// Title when Xiaomi/HyperOS recommended Battery saver can stop background work.
  ///
  /// In en, this message translates to:
  /// **'Background work may pause'**
  String get backgroundOemBatteryReminderTitle;

  /// Body before extraction when OEM recommended Battery saver is on. Names Xiaomi and stock allowlist labels.
  ///
  /// In en, this message translates to:
  /// **'The recommended battery setting on this phone can pause extraction if you leave the app. Choose No restrictions or Unrestricted so extraction can continue.'**
  String get backgroundOemBatteryReminderExtractionBody;

  /// Body before model download or copy when OEM recommended Battery saver is on.
  ///
  /// In en, this message translates to:
  /// **'The recommended battery setting on this phone can pause model install if you leave the app. Choose No restrictions or Unrestricted so the transfer can continue.'**
  String get backgroundOemBatteryReminderModelInstallBody;

  /// Dismisses the Restricted, OEM, or Battery Saver reminder and continues the work.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get backgroundWorkReminderContinue;

  /// Calm Account card title for Android battery / background work guidance.
  ///
  /// In en, this message translates to:
  /// **'Background battery settings'**
  String get accountBatteryGuidanceTitle;

  /// Calm Account card body explaining Restricted / Battery Saver impact without nagging.
  ///
  /// In en, this message translates to:
  /// **'If this app is Restricted or Battery Saver is on, extraction and model downloads can pause when you leave the app. You can review battery settings anytime.'**
  String get accountBatteryGuidanceBody;

  /// Account card title when Android per-app Restricted is enabled.
  ///
  /// In en, this message translates to:
  /// **'Background is Restricted'**
  String get accountBatteryGuidanceRestrictedTitle;

  /// Account card body when Restricted. Names Xiaomi No restrictions and stock Unrestricted.
  ///
  /// In en, this message translates to:
  /// **'This app is restricted in the background. Open battery settings and choose No restrictions or Unrestricted so extraction and model downloads can continue if you leave the app.'**
  String get accountBatteryGuidanceRestrictedBody;

  /// Account card title when system Battery Saver is on.
  ///
  /// In en, this message translates to:
  /// **'Battery Saver is on'**
  String get accountBatteryGuidanceBatterySaverTitle;

  /// Account card body when Battery Saver is on.
  ///
  /// In en, this message translates to:
  /// **'Battery Saver may slow or interrupt on-device extraction and model downloads.'**
  String get accountBatteryGuidanceBatterySaverBody;

  /// Account card title when Xiaomi/HyperOS recommended Battery saver can interrupt work.
  ///
  /// In en, this message translates to:
  /// **'Background work may pause'**
  String get accountBatteryGuidanceOemTitle;

  /// Account card body for OEM recommended Battery saver. Names Xiaomi No restrictions and stock Unrestricted.
  ///
  /// In en, this message translates to:
  /// **'The recommended battery setting on this phone can pause extraction and model downloads when you leave the app. Open battery settings and choose No restrictions or Unrestricted so that work can continue.'**
  String get accountBatteryGuidanceOemBody;

  /// Button that opens Android app battery / background work settings.
  ///
  /// In en, this message translates to:
  /// **'Open battery settings'**
  String get accountBatteryGuidanceOpenSettings;

  /// Label for theme preference.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get accountThemeLabel;

  /// System theme option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get accountThemeSystem;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get accountThemeLight;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get accountThemeDark;

  /// Supporting copy on the theme details page.
  ///
  /// In en, this message translates to:
  /// **'Choose light, dark, or follow the system setting. System is the default.'**
  String get accountThemeDetailsSubtitle;

  /// Subtitle for the system theme option.
  ///
  /// In en, this message translates to:
  /// **'Match the device light or dark mode.'**
  String get accountThemeSystemDescription;

  /// Account row and preferences page title for theme and language settings.
  ///
  /// In en, this message translates to:
  /// **'User preferences'**
  String get accountUserPreferencesLabel;

  /// Account row subtitle summarizing current theme and language choices.
  ///
  /// In en, this message translates to:
  /// **'{theme} · {language}'**
  String accountUserPreferencesSubtitle(String theme, String language);

  /// Section header for language preference.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguageLabel;

  /// Supporting copy for the language preference section.
  ///
  /// In en, this message translates to:
  /// **'Choose English, German, Arabic, or follow the system language. System is the default.'**
  String get accountLanguageDetailsSubtitle;

  /// System language option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get accountLanguageSystem;

  /// Subtitle for the system language option.
  ///
  /// In en, this message translates to:
  /// **'Match the device language when Quorivell supports it.'**
  String get accountLanguageSystemDescription;

  /// English language option.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get accountLanguageEnglish;

  /// German language option.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get accountLanguageGerman;

  /// Arabic language option.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get accountLanguageArabic;

  /// Label for app version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get accountVersionLabel;

  /// Label for privacy policy link.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get accountPrivacyLabel;

  /// Empty state title when no text is entered.
  ///
  /// In en, this message translates to:
  /// **'Ready to capture'**
  String get captureEmptyTitle;

  /// Empty state subtitle on capture page.
  ///
  /// In en, this message translates to:
  /// **'Paste or type any rough conversation. It stays private until you review and accept candidates.'**
  String get captureEmptySubtitle;

  /// Privacy callout on the capture page.
  ///
  /// In en, this message translates to:
  /// **'Your conversation stays on this device'**
  String get capturePrivacySubtitle;

  /// Body of the capture privacy explainer dialog.
  ///
  /// In en, this message translates to:
  /// **'Quorivell uses on-device AI by default. Extraction runs locally on this device. Data is sent to the cloud only if you explicitly allow cloud access — that option is not available yet.'**
  String get capturePrivacyDialogBody;

  /// Dismiss button for the capture privacy explainer dialog.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get capturePrivacyDialogDismiss;

  /// Privacy summary on the account page.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device'**
  String get accountPrivacyBody;

  /// Account card title listing Android share and text-selection entry points.
  ///
  /// In en, this message translates to:
  /// **'Android actions from other apps'**
  String get androidIncomingActionsTitle;

  /// Explains the two shipped Android incoming actions: share-to-capture and PROCESS_TEXT summarize.
  ///
  /// In en, this message translates to:
  /// **'Share text with “Capture in Quorivell” to save it in Capture. Select text in another app and choose “Summarize with Quorivell” from the overflow menu to summarize in Chat — if it is already a summary, Chat only corrects spelling, grammar, and light wording.'**
  String get androidIncomingActionsBody;

  /// Installed application version name and build number from this binary.
  ///
  /// In en, this message translates to:
  /// **'{version}'**
  String accountVersionValue(String version);

  /// Shown when the installed application version cannot be read.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get accountVersionUnavailable;

  /// Section header for debug-only tools on the account page.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get accountSectionDebug;

  /// Debug-only button that permanently deletes local ledger, conversation, review, and chat data.
  ///
  /// In en, this message translates to:
  /// **'Clear app data'**
  String get accountDebugClearAppData;

  /// Explains what the debug clear-app-data action deletes.
  ///
  /// In en, this message translates to:
  /// **'Deletes ledger items, conversations, review candidates, and chat threads on this device.'**
  String get accountDebugClearAppDataSubtitle;

  /// Title of the clear-app-data confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Clear app data?'**
  String get accountDebugClearAppDataTitle;

  /// Body of the clear-app-data confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes ledger items, source conversations, review candidates, and chat threads on this device. Preferences and the on-device model stay.'**
  String get accountDebugClearAppDataBody;

  /// Confirms clearing local app content.
  ///
  /// In en, this message translates to:
  /// **'Clear data'**
  String get accountDebugClearAppDataConfirm;

  /// Dismisses the clear-app-data confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get accountDebugClearAppDataCancel;

  /// SnackBar after local app content was cleared.
  ///
  /// In en, this message translates to:
  /// **'App data cleared.'**
  String get accountDebugClearAppDataDone;

  /// Debug-only button that clears SharedPreferences, including the welcome flag.
  ///
  /// In en, this message translates to:
  /// **'Clear shared preferences'**
  String get accountDebugClearPreferences;

  /// Explains what the debug clear-preferences action does.
  ///
  /// In en, this message translates to:
  /// **'Resets onboarding and other local flags on this device.'**
  String get accountDebugClearPreferencesSubtitle;

  /// Account row title for the user-facing debug tools screen.
  ///
  /// In en, this message translates to:
  /// **'Debug mode'**
  String get accountDebugModeLabel;

  /// Account row subtitle for debug mode.
  ///
  /// In en, this message translates to:
  /// **'Inspect findings as JSON and edit on-device AI prompts.'**
  String get accountDebugModeSubtitle;

  /// App bar title for the debug mode screen.
  ///
  /// In en, this message translates to:
  /// **'Debug mode'**
  String get accountDebugModePageTitle;

  /// Switch label that turns debug mode on or off.
  ///
  /// In en, this message translates to:
  /// **'Enable debug mode'**
  String get accountDebugModeToggleTitle;

  /// Explains what enabling debug mode does.
  ///
  /// In en, this message translates to:
  /// **'Shows JSON on Review and Ledger, and uses your prompt overrides for on-device AI.'**
  String get accountDebugModeToggleSubtitle;

  /// Heading for the debug-mode privacy note.
  ///
  /// In en, this message translates to:
  /// **'Stays on this device'**
  String get accountDebugModePrivacyTitle;

  /// Privacy reminder on the debug mode screen.
  ///
  /// In en, this message translates to:
  /// **'Debug tools stay on this device. They do not send conversations to the cloud or write to the ledger automatically.'**
  String get accountDebugModePrivacyNote;

  /// Section header for editable AI prompts.
  ///
  /// In en, this message translates to:
  /// **'On-device prompts'**
  String get accountDebugPromptsSection;

  /// Explains prompt overrides on the debug screen.
  ///
  /// In en, this message translates to:
  /// **'These replace the built-in on-device prompts while debug mode is on. Reset restores the app defaults.'**
  String get accountDebugPromptsSubtitle;

  /// Label for the on-device chat system prompt editor.
  ///
  /// In en, this message translates to:
  /// **'Chat system prompt'**
  String get accountDebugChatSystemPromptLabel;

  /// Label for the extraction system prompt editor.
  ///
  /// In en, this message translates to:
  /// **'Extraction system prompt'**
  String get accountDebugExtractionSystemPromptLabel;

  /// Label for the extraction user-turn prompt editor.
  ///
  /// In en, this message translates to:
  /// **'Extraction user prompt'**
  String get accountDebugExtractionUserPromptLabel;

  /// Hint for the extraction user prompt placeholder.
  ///
  /// In en, this message translates to:
  /// **'Use {conversation} where the source text should be inserted.'**
  String accountDebugExtractionUserPromptHint(String conversation);

  /// Saves debug prompt overrides.
  ///
  /// In en, this message translates to:
  /// **'Save prompts'**
  String get accountDebugPromptSave;

  /// SnackBar after debug prompts are stored.
  ///
  /// In en, this message translates to:
  /// **'Prompts saved.'**
  String get accountDebugPromptSaved;

  /// Clears debug prompt overrides.
  ///
  /// In en, this message translates to:
  /// **'Reset all to defaults'**
  String get accountDebugPromptResetAll;

  /// SnackBar after debug prompts are reset.
  ///
  /// In en, this message translates to:
  /// **'Prompts restored to defaults.'**
  String get accountDebugPromptResetDone;

  /// Expansion title for a ledger item JSON dump in debug mode.
  ///
  /// In en, this message translates to:
  /// **'Ledger item JSON'**
  String get ledgerDebugItemJson;

  /// Expansion title for evidence JSON in debug mode.
  ///
  /// In en, this message translates to:
  /// **'Evidence JSON'**
  String get ledgerDebugEvidenceJson;

  /// Subtitle showing how many review candidates are waiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Review 1 candidate} other{Review {count} candidates}}'**
  String reviewPendingCount(int count);

  /// Subtitle for the empty open-commitments state.
  ///
  /// In en, this message translates to:
  /// **'Accepted or added commitments appear here.'**
  String get ledgerEmptySubtitle;

  /// Subtitle when conversation history is empty.
  ///
  /// In en, this message translates to:
  /// **'Captured conversations will appear here'**
  String get conversationHistoryEmptySubtitle;

  /// Fallback message for an unclassified failure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Message for a local persistence read or write failure.
  ///
  /// In en, this message translates to:
  /// **'This device could not save or read your local records.'**
  String get errorLocalStorage;

  /// Message shown when a local record cannot be found.
  ///
  /// In en, this message translates to:
  /// **'That local record is no longer available.'**
  String get errorLocalRecordMissing;

  /// Message for a network failure.
  ///
  /// In en, this message translates to:
  /// **'No network connection is available.'**
  String get errorNetworkUnavailable;

  /// Message for a disabled, unconfigured, or blocked remote capability.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available yet.'**
  String get errorRemoteUnavailable;

  /// Message for an invalid sign-in attempt.
  ///
  /// In en, this message translates to:
  /// **'That email address and password do not match.'**
  String get errorSignInInvalidCredentials;

  /// Message shown when an account is disabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get errorSignInUserDisabled;

  /// Message shown after too many sign-in attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get errorSignInTooManyRequests;

  /// Message shown when extraction input is invalid.
  ///
  /// In en, this message translates to:
  /// **'The conversation text is empty or longer than 20,000 characters. Shorten it and try again.'**
  String get errorExtractionInvalidInput;

  /// Message shown when the local model cannot run.
  ///
  /// In en, this message translates to:
  /// **'The on-device model could not be loaded. Free some memory and try again, or reinstall the model from Account.'**
  String get errorExtractionModelUnavailable;

  /// Message shown when the local model lacks an extraction codec.
  ///
  /// In en, this message translates to:
  /// **'The configured on-device model cannot extract candidates yet.'**
  String get errorExtractionModelUnsupported;

  /// Message shown when local model text could not be parsed as extraction JSON.
  ///
  /// In en, this message translates to:
  /// **'The on-device model returned an unreadable result. Try a shorter capture, or extract again.'**
  String get errorExtractionInvalidOutput;

  /// Message shown when a resumable extraction job points at an archived source conversation.
  ///
  /// In en, this message translates to:
  /// **'This conversation was already extracted.'**
  String get errorExtractionSourceArchived;

  /// Headline on the assistant consent settings page.
  ///
  /// In en, this message translates to:
  /// **'How Quorivell processes your notes'**
  String get assistantConsentHeadline;

  /// Consent copy shown before the user has granted or declined cloud processing.
  ///
  /// In en, this message translates to:
  /// **'On-device extraction stays on this device and does not need cloud permission. Cloud processing is off until you explicitly allow it. Your choice is saved on this device.'**
  String get assistantConsentUnknownBody;

  /// Consent copy shown after the user has granted cloud processing.
  ///
  /// In en, this message translates to:
  /// **'You allowed cloud processing. Extraction still runs on this device. Cloud AI is not connected yet, and nothing leaves the device until that feature ships with the same saved consent.'**
  String get assistantConsentGrantedBody;

  /// Consent copy shown after the user has declined cloud processing.
  ///
  /// In en, this message translates to:
  /// **'You kept processing on this device. Cloud AI stays off. On-device extraction continues to run locally.'**
  String get assistantConsentDeclinedBody;

  /// Button that records affirmative consent for future cloud processing.
  ///
  /// In en, this message translates to:
  /// **'Allow cloud processing'**
  String get assistantConsentGrantButton;

  /// Button that records a decline of cloud processing.
  ///
  /// In en, this message translates to:
  /// **'Keep processing on this device'**
  String get assistantConsentDeclineButton;

  /// Button that withdraws previously granted cloud-processing consent.
  ///
  /// In en, this message translates to:
  /// **'Withdraw cloud permission'**
  String get assistantConsentWithdrawButton;

  /// Button that grants cloud processing after a previous decline.
  ///
  /// In en, this message translates to:
  /// **'Allow cloud processing'**
  String get assistantConsentGrantLaterButton;

  /// Fallback extraction summary when the source text has no sentences.
  ///
  /// In en, this message translates to:
  /// **'Paste a conversation to extract the kinds you enabled.'**
  String get extractionEmptySummary;

  /// Heading used in the legacy local extraction summary.
  ///
  /// In en, this message translates to:
  /// **'Candidate commitments:'**
  String get extractionCandidateCommitments;

  /// Reminder in the legacy local extraction summary to review candidates.
  ///
  /// In en, this message translates to:
  /// **'Review each item before saving it to your ledger.'**
  String get extractionReviewEachItem;

  /// On-device model prompt for extracting review candidates from a conversation.
  ///
  /// In en, this message translates to:
  /// **'Extract every matching candidate for each enabled kind ({legalKinds}) from the Conversation only (do not copy the system examples). Include informal mentions when a kind hint matches. Follow the system rules. Return raw JSON only — no markdown. Emit only kinds from this list: {legalKinds}.{dueDateClause} quoteSnippet must come from the supporting sentence. statement must be a short ledger label (Milk, Sugar) and must NOT equal quoteSnippet. For list-like kinds, one candidate per short item name.\n\nConversation:\n{conversation}'**
  String extractionPrompt(
    String legalKinds,
    String dueDateClause,
    String conversation,
  );

  /// System instruction for the on-device extraction model and any gated remote assistant. openBrace and closeBrace are literal curly braces so JSON examples stay valid ICU.
  ///
  /// In en, this message translates to:
  /// **'You are a JSON extractor for a personal evidence ledger. Output ONLY valid JSON with no markdown fences. Shape: {openBrace}\"candidates\":[...]{closeBrace}\n\nEach candidate: kind, statement, owner, dueDate, quoteSnippet.\n- statement: short ledger label — prefer a single noun or few words (Milk, Sugar, Emila). MUST differ from quoteSnippet (never paste the quote as the statement)\n- owner: person name or null (only when the kind ownerPolicy allows it; otherwise null)\n- dueDate: ISO when the kind datePolicy allows dates AND a calendar day is stated (October 15th, November the 7th at 5 PM, Oct 15, 15 October, 20.05.2026, 2026-10-15). Dot-numeric dates are day.month.year (German/EU). Use YYYY-MM-DD for date-only, or YYYY-MM-DDTHH:MM:00 when a clock time is stated (5 PM → 17:00). Prefer a year written in the conversation; if missing, use the conversation year if present, otherwise the current calendar year. Weekday-only words like Friday stay null. Relative deadlines (next week, EOD, end of day) stay null. If the kind datePolicy is none, dueDate is always null.\n- quoteSnippet: exact contiguous substring from the Conversation text below (never from the examples). Must not be identical to statement.\n\nSKIP: soft hedges (might/maybe/probably/thinking out loud) unless a kind hint explicitly wants them; hard stops; pure status with no match. If nothing qualifies, return {openBrace}\"candidates\":[]{closeBrace}. Never invent a kind other than the enabled kinds: {legalKinds}. Emit candidates only for those enabled kinds. {kindCatalog}\n\nWorks for narrative prose and Name: dialogue. Resolve I/I\'ll under Name: to that speaker.\n\nIMPORTANT: Extract only from the user\'s Conversation. Do not copy example answers.'**
  String assistantRemoteSystemInstruction(
    String openBrace,
    String closeBrace,
    String legalKinds,
    String kindCatalog,
  );

  /// Title of the onboarding page that downloads the local GGUF model.
  ///
  /// In en, this message translates to:
  /// **'Install the on-device model.'**
  String get onboardingModelTitle;

  /// Title shown while verifying an already stored GGUF at startup.
  ///
  /// In en, this message translates to:
  /// **'Checking the on-device model.'**
  String get onboardingModelCheckingTitle;

  /// Supporting copy shown while SHA-256 verifying a stored GGUF.
  ///
  /// In en, this message translates to:
  /// **'Confirming the model file already on this device. This can take a moment for a large file.'**
  String get onboardingModelCheckingBody;

  /// Title shown after the user picks a local GGUF, before copy and verify progress.
  ///
  /// In en, this message translates to:
  /// **'Preparing the selected model.'**
  String get onboardingModelPickingTitle;

  /// Supporting copy shown while the file picker hands back a selected GGUF.
  ///
  /// In en, this message translates to:
  /// **'Getting the file ready. Copying will start next.'**
  String get onboardingModelPickingBody;

  /// Supporting copy on the onboarding model install page.
  ///
  /// In en, this message translates to:
  /// **'Qwen 1.5B is recommended. If this device has enough memory, you can download another GGUF such as Llama 3, or select a file you already copied here.'**
  String get onboardingModelBody;

  /// Button that starts the local GGUF download.
  ///
  /// In en, this message translates to:
  /// **'Download on-device model'**
  String get onboardingModelDownloadButton;

  /// Button that resumes a paused or interrupted GGUF download.
  ///
  /// In en, this message translates to:
  /// **'Resume download'**
  String get onboardingModelResumeDownload;

  /// Button that cancels an in-progress GGUF download while keeping the partial file.
  ///
  /// In en, this message translates to:
  /// **'Stop download'**
  String get onboardingModelCancelDownload;

  /// Button that deletes a paused GGUF partial download.
  ///
  /// In en, this message translates to:
  /// **'Discard partial download'**
  String get onboardingModelDiscardPartial;

  /// Button that opens a file picker for a local GGUF.
  ///
  /// In en, this message translates to:
  /// **'Select model file'**
  String get onboardingModelSelectFileButton;

  /// Button label shown while the local model is downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading model…'**
  String get onboardingModelDownloading;

  /// Button label shown while a local GGUF is being imported.
  ///
  /// In en, this message translates to:
  /// **'Importing model…'**
  String get onboardingModelImporting;

  /// Hint shown under the download progress indicator. Home/app switch is OK; swipe-away still kills Dart-only copy.
  ///
  /// In en, this message translates to:
  /// **'You can switch apps or go Home. Swiping Quorivell away from Recents stops in-app copy, but a download continues and can auto-resume. About 1.1 GB; the file stays on this device.'**
  String get onboardingModelDownloadHint;

  /// Ongoing dataSync FGS notification title during GGUF download.
  ///
  /// In en, this message translates to:
  /// **'Downloading model'**
  String get modelInstallDownloadNotificationTitle;

  /// Ongoing dataSync FGS notification body during GGUF download.
  ///
  /// In en, this message translates to:
  /// **'Downloading the on-device model. You can switch apps.'**
  String get modelInstallDownloadNotificationBody;

  /// Ongoing dataSync FGS notification title during local GGUF copy.
  ///
  /// In en, this message translates to:
  /// **'Copying model'**
  String get modelInstallCopyNotificationTitle;

  /// Ongoing dataSync FGS notification body during local GGUF copy.
  ///
  /// In en, this message translates to:
  /// **'Copying the selected GGUF onto this device.'**
  String get modelInstallCopyNotificationBody;

  /// Completion notification title after model download or copy finishes.
  ///
  /// In en, this message translates to:
  /// **'On-device model ready'**
  String get modelInstallCompleteNotificationTitle;

  /// Completion notification body after a GGUF download.
  ///
  /// In en, this message translates to:
  /// **'The on-device model finished downloading.'**
  String get modelInstallDownloadCompleteNotificationBody;

  /// Completion notification body after a local GGUF copy.
  ///
  /// In en, this message translates to:
  /// **'The selected GGUF was copied onto this device.'**
  String get modelInstallCopyCompleteNotificationBody;

  /// Foreground notification title while exporting the installed GGUF.
  ///
  /// In en, this message translates to:
  /// **'Saving model'**
  String get modelInstallExportNotificationTitle;

  /// Foreground notification body while exporting the installed GGUF.
  ///
  /// In en, this message translates to:
  /// **'Saving a copy of the on-device model.'**
  String get modelInstallExportNotificationBody;

  /// Completion notification after the installed GGUF was exported.
  ///
  /// In en, this message translates to:
  /// **'A copy of the on-device model was saved.'**
  String get modelInstallExportCompleteNotificationBody;

  /// Download percent shown before speed/ETA are known.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String onboardingModelDownloadPercent(int percent);

  /// Live download stats: percent, throughput, and ETA.
  ///
  /// In en, this message translates to:
  /// **'{percent}% · {speed} · {timeLeft}'**
  String onboardingModelDownloadStats(
    int percent,
    String speed,
    String timeLeft,
  );

  /// Download throughput in megabytes per second.
  ///
  /// In en, this message translates to:
  /// **'{value} MB/s'**
  String onboardingModelDownloadSpeedMBps(String value);

  /// Download throughput in kilobytes per second.
  ///
  /// In en, this message translates to:
  /// **'{value} KB/s'**
  String onboardingModelDownloadSpeedKBps(String value);

  /// Download throughput in bytes per second.
  ///
  /// In en, this message translates to:
  /// **'{value} B/s'**
  String onboardingModelDownloadSpeedBps(int value);

  /// Estimated hours remaining for the model download.
  ///
  /// In en, this message translates to:
  /// **'~{count} h left'**
  String onboardingModelDownloadTimeLeftHours(int count);

  /// Estimated minutes remaining for the model download.
  ///
  /// In en, this message translates to:
  /// **'~{count} min left'**
  String onboardingModelDownloadTimeLeftMinutes(int count);

  /// Estimated seconds remaining for the model download.
  ///
  /// In en, this message translates to:
  /// **'~{count} s left'**
  String onboardingModelDownloadTimeLeftSeconds(int count);

  /// Hint shown when a partial GGUF download can be resumed.
  ///
  /// In en, this message translates to:
  /// **'Download paused. Resume to continue, or discard the partial file.'**
  String get onboardingModelDownloadPausedHint;

  /// Hint shown under the import progress indicator.
  ///
  /// In en, this message translates to:
  /// **'You can switch apps or go Home while the GGUF copies. Swiping Quorivell away from Recents may pause the copy; reopen to continue. The file stays on this device. You are responsible for it.'**
  String get onboardingModelImportHint;

  /// Message shown when download reached 100% and checksum/install is still running.
  ///
  /// In en, this message translates to:
  /// **'Finalizing the model…'**
  String get onboardingModelFinalizingHint;

  /// Error shown when the GGUF download fails.
  ///
  /// In en, this message translates to:
  /// **'The model could not be downloaded. Check your connection and try again.'**
  String get onboardingModelDownloadError;

  /// Error shown when a local GGUF import fails.
  ///
  /// In en, this message translates to:
  /// **'The selected file could not be imported. Choose a GGUF file and try again.'**
  String get onboardingModelImportError;

  /// Error shown when the GGUF SHA-256 does not match.
  ///
  /// In en, this message translates to:
  /// **'The downloaded model file did not match the expected checksum. Try the download again, or select a local GGUF file.'**
  String get onboardingModelChecksumError;

  /// Error shown when download or import fails because the device has no free space.
  ///
  /// In en, this message translates to:
  /// **'This device is out of storage. Free space, then discard temporary model files below and try again. The model needs about 1.1 GB free.'**
  String get onboardingModelStorageFullError;

  /// Button that deletes import leftovers and discarded partial download files after a storage-full error.
  ///
  /// In en, this message translates to:
  /// **'Free temporary model files'**
  String get onboardingModelFreeTempSpace;

  /// Title shown after the local model is verified.
  ///
  /// In en, this message translates to:
  /// **'On-device model ready'**
  String get onboardingModelReadyTitle;

  /// Subtitle shown after the local model is verified.
  ///
  /// In en, this message translates to:
  /// **'Extraction will run on this device. You can continue into the app.'**
  String get onboardingModelReadySubtitle;

  /// Skips model install during onboarding. Local AI stays off until a model is configured in Account.
  ///
  /// In en, this message translates to:
  /// **'Configure later'**
  String get onboardingModelConfigureLater;

  /// Account row that opens the installed local model details.
  ///
  /// In en, this message translates to:
  /// **'On-device model'**
  String get accountModelDetailsLabel;

  /// Subtitle for the account row that opens model details.
  ///
  /// In en, this message translates to:
  /// **'See which model is installed and change it.'**
  String get accountModelDetailsRowSubtitle;

  /// Status when no on-device GGUF is installed.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get accountModelNotConfigured;

  /// App bar title for the local model details screen.
  ///
  /// In en, this message translates to:
  /// **'On-device model'**
  String get accountModelDetailsTitle;

  /// Subtitle on the local model details screen.
  ///
  /// In en, this message translates to:
  /// **'Local extraction uses this GGUF on this device.'**
  String get accountModelDetailsSubtitle;

  /// Label for the installed model identifier.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get accountModelNameLabel;

  /// Label for the installed GGUF file name.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get accountModelFileLabel;

  /// Label for how the current model was installed.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get accountModelOriginLabel;

  /// Shown when the current GGUF was downloaded by Quorivell.
  ///
  /// In en, this message translates to:
  /// **'Downloaded by the app'**
  String get accountModelOriginDownload;

  /// Shown when the current GGUF was imported from a user-picked file.
  ///
  /// In en, this message translates to:
  /// **'Selected from a file'**
  String get accountModelOriginImport;

  /// Shown when a GGUF is present but its install source is unknown.
  ///
  /// In en, this message translates to:
  /// **'Installed on this device'**
  String get accountModelOriginUnknown;

  /// Label for the installed GGUF file size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get accountModelSizeLabel;

  /// Installed model size in megabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String accountModelSizeMegabytes(String size);

  /// Installed model size in gigabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} GB'**
  String accountModelSizeGigabytes(String size);

  /// Status line when a verified on-device model is installed.
  ///
  /// In en, this message translates to:
  /// **'Ready for local AI'**
  String get accountModelStatusReady;

  /// Shows download and file-picker actions to replace the installed GGUF.
  ///
  /// In en, this message translates to:
  /// **'Change model'**
  String get accountModelChangeButton;

  /// Exports the installed GGUF to a user-chosen folder for reuse.
  ///
  /// In en, this message translates to:
  /// **'Save model file'**
  String get accountModelSaveLocallyButton;

  /// Progress label while copying the installed GGUF to storage.
  ///
  /// In en, this message translates to:
  /// **'Saving model file…'**
  String get accountModelSavingLocally;

  /// SnackBar after the installed GGUF was exported successfully.
  ///
  /// In en, this message translates to:
  /// **'Model file saved. You can select it later with Select model file.'**
  String get accountModelSaveLocallySuccess;

  /// SnackBar when exporting the installed GGUF fails.
  ///
  /// In en, this message translates to:
  /// **'The model file could not be saved. Try again.'**
  String get accountModelSaveLocallyError;

  /// Cancels an in-progress export of the installed GGUF.
  ///
  /// In en, this message translates to:
  /// **'Stop saving'**
  String get accountModelSaveLocallyCancel;

  /// Hides replace actions and returns to the current model details.
  ///
  /// In en, this message translates to:
  /// **'Keep current model'**
  String get accountModelCancelChange;

  /// Deletes the installed on-device GGUF.
  ///
  /// In en, this message translates to:
  /// **'Delete model'**
  String get accountModelDeleteButton;

  /// Title of the delete-model confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete the on-device model?'**
  String get accountModelDeleteTitle;

  /// Body of the delete-model confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the model file from this device. Local AI stays off until you download or select a model again.'**
  String get accountModelDeleteBody;

  /// Confirms deleting the on-device GGUF.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get accountModelDeleteConfirm;

  /// Dismisses the delete-model confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get accountModelDeleteCancel;

  /// Title of the replace-model confirmation before a catalog download.
  ///
  /// In en, this message translates to:
  /// **'Replace the on-device model?'**
  String get accountModelReplaceTitle;

  /// Warns that starting a different catalog download deletes the installed GGUF at once.
  ///
  /// In en, this message translates to:
  /// **'Downloading another model removes the current one from this device immediately. Local AI stays off until the new download finishes.'**
  String get accountModelReplaceBody;

  /// Confirms replacing the installed GGUF with a new catalog download.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get accountModelReplaceConfirm;

  /// Dismisses the replace-model confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get accountModelReplaceCancel;

  /// Empty-state title when no GGUF is installed.
  ///
  /// In en, this message translates to:
  /// **'Configure the on-device model'**
  String get accountModelEmptyTitle;

  /// Empty-state subtitle when no GGUF is installed.
  ///
  /// In en, this message translates to:
  /// **'Download a recommended GGUF or select a model file to enable local extraction.'**
  String get accountModelEmptySubtitle;

  /// Title of the dialog shown when a feature needs a local model that is not installed.
  ///
  /// In en, this message translates to:
  /// **'Configure the on-device model'**
  String get localModelRequiredTitle;

  /// Body of the dialog shown when a feature needs a local model that is not installed.
  ///
  /// In en, this message translates to:
  /// **'Local AI needs a model on this device before it can extract the kinds you enabled.'**
  String get localModelRequiredBody;

  /// Dialog action that opens the on-device model details screen.
  ///
  /// In en, this message translates to:
  /// **'Configure model'**
  String get localModelRequiredConfigure;

  /// Dismisses the local-model-required dialog without configuring a model.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get localModelRequiredDismiss;

  /// Title of the Qwen model license notice.
  ///
  /// In en, this message translates to:
  /// **'Qwen License Notice'**
  String get qwenLicenseNoticeTitle;

  /// Short Qwen license type used when that model is installed.
  ///
  /// In en, this message translates to:
  /// **'Recommended Qwen 1.5B Instruct weights are licensed under Apache License 2.0. Quorivell does not grant extra rights to any model.'**
  String get qwenLicenseNoticeBody;

  /// Heading above the Hugging Face GGUF download menu.
  ///
  /// In en, this message translates to:
  /// **'Recommended models'**
  String get onboardingModelCatalogTitle;

  /// Disclaimer under the manual GGUF file picker.
  ///
  /// In en, this message translates to:
  /// **'Selecting a local GGUF skips the official checksum. You are responsible for that file\'s authenticity and license.'**
  String get onboardingModelManualResponsibility;

  /// Short license type for Apache 2.0 GGUF weights.
  ///
  /// In en, this message translates to:
  /// **'Apache-2.0'**
  String get modelLicenseApache20;

  /// Short license type for Llama 3 GGUF weights.
  ///
  /// In en, this message translates to:
  /// **'Llama 3 Community'**
  String get modelLicenseLlama3;

  /// Short license type for Llama 3.2 GGUF weights.
  ///
  /// In en, this message translates to:
  /// **'Llama 3.2 Community'**
  String get modelLicenseLlama32;

  /// Chip on the recommended on-device GGUF in the catalog.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get modelCatalogRecommended;

  /// Tooltip for the info icon that opens the Hugging Face model page.
  ///
  /// In en, this message translates to:
  /// **'Open model page'**
  String get modelCatalogOpenPageTooltip;

  /// Hint that a catalog GGUF needs more device memory than Qwen 1.5B.
  ///
  /// In en, this message translates to:
  /// **'Needs more RAM'**
  String get modelCatalogNeedsMoreRam;

  /// Chip on community uncensored GGUF catalog entries.
  ///
  /// In en, this message translates to:
  /// **'Uncensored'**
  String get modelCatalogUncensored;

  /// Short disclaimer under an uncensored catalog GGUF tile.
  ///
  /// In en, this message translates to:
  /// **'Fewer built-in refusal filters than the recommended model. Still runs only on this device—use responsibly.'**
  String get modelCatalogUncensoredNote;

  /// Account row title for on-device model license summary.
  ///
  /// In en, this message translates to:
  /// **'Model licenses'**
  String get accountModelLicensesTitle;

  /// Account summary of on-device model license responsibility.
  ///
  /// In en, this message translates to:
  /// **'Qwen is recommended (Apache-2.0). Uncensored catalog options refuse less often and stay on-device. Other GGUF files use their upstream licenses. You are responsible for files you select.'**
  String get accountModelLicensesBody;

  /// Tooltip for the chat follow-latest FAB when pinned to new tokens.
  ///
  /// In en, this message translates to:
  /// **'Following latest replies'**
  String get chatAutoScrollOnTooltip;

  /// Tooltip for the chat FAB when the user has scrolled up.
  ///
  /// In en, this message translates to:
  /// **'Jump to latest replies'**
  String get chatAutoScrollOffTooltip;

  /// Default app bar title for the on-device AI chat screen.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// Tooltip for starting a new on-device chat thread.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNewTooltip;

  /// Tooltip for opening the list of saved chat threads.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistoryTooltip;

  /// Empty-state headline when a chat thread has no messages yet.
  ///
  /// In en, this message translates to:
  /// **'Ask the on-device model'**
  String get chatEmptyTitle;

  /// Empty-state subtitle explaining local chat privacy, system-prompt influence, and purpose.
  ///
  /// In en, this message translates to:
  /// **'Messages stay on this device. Answers follow the chat system prompt — change it in Extraction settings. The model can help with decisions and commitments; chat is not a second ledger.'**
  String get chatEmptySubtitle;

  /// Link from the empty chat state to Account → Extraction settings to edit the chat system prompt.
  ///
  /// In en, this message translates to:
  /// **'Open Extraction settings'**
  String get chatEmptyExtractionSettingsLink;

  /// Accessible label for the chat text field.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get chatComposerLabel;

  /// Hint text inside the chat composer.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get chatComposerHint;

  /// Character counter shown near the chat composer limit.
  ///
  /// In en, this message translates to:
  /// **'{used} of {max} characters'**
  String chatComposerCount(int used, int max);

  /// Tooltip for the send message button.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSendTooltip;

  /// Tooltip for stopping an in-progress model reply.
  ///
  /// In en, this message translates to:
  /// **'Stop generating'**
  String get chatStopTooltip;

  /// Confirmation shown after copying a chat message.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get chatCopiedSnackbar;

  /// Button that retries a failed chat generation.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatRetryLabel;

  /// Label shown in the streaming bubble before tokens arrive.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get chatGeneratingLabel;

  /// Accessible live-region label while the model is generating.
  ///
  /// In en, this message translates to:
  /// **'The on-device model is writing a reply'**
  String get chatGeneratingSemantics;

  /// Error state when chat messages cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Chat is unavailable right now.'**
  String get chatUnavailable;

  /// Title of the saved chat threads list.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistoryTitle;

  /// Empty state when no chat threads have been saved.
  ///
  /// In en, this message translates to:
  /// **'No chats yet.'**
  String get chatHistoryEmpty;

  /// Empty-state subtitle for the chat history list.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation from the Chat tab. Threads are stored only on this device.'**
  String get chatHistoryEmptySubtitle;

  /// Error state when chat threads cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Chat history is unavailable.'**
  String get chatHistoryUnavailable;

  /// Title of the delete-chat confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete this chat?'**
  String get chatDeleteTitle;

  /// Body of the delete-chat confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the thread and its messages from this device. That cannot be undone.'**
  String get chatDeleteBody;

  /// Confirms deleting a chat thread.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDeleteConfirm;

  /// Dismisses the delete-chat dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatDeleteCancel;

  /// SnackBar shown when deleting a chat thread fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this chat.'**
  String get chatDeleteFailed;

  /// Title for the bulk chat-thread delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this chat?} other{Delete {count} chats?}}'**
  String chatBulkDeleteTitle(int count);

  /// Body for the bulk chat-thread delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected threads and their messages from this device. That cannot be undone.'**
  String get chatBulkDeleteBody;

  /// SnackBar when bulk chat-thread delete fails.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected chats. Try again.'**
  String get chatBulkDeleteFailed;

  /// Semantics label prefix for a user chat bubble.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get chatMessageUserSemantics;

  /// Semantics label prefix for an assistant chat bubble.
  ///
  /// In en, this message translates to:
  /// **'Model reply'**
  String get chatMessageAssistantSemantics;

  /// First empty-state suggestion chip for on-device chat.
  ///
  /// In en, this message translates to:
  /// **'Help me phrase a decision from a meeting.'**
  String get chatSuggestion1;

  /// Second empty-state suggestion chip for on-device chat.
  ///
  /// In en, this message translates to:
  /// **'What makes a commitment reviewable?'**
  String get chatSuggestion2;

  /// Third empty-state suggestion chip for on-device chat.
  ///
  /// In en, this message translates to:
  /// **'How should I capture evidence quotes?'**
  String get chatSuggestion3;

  /// Shown when a chat message is empty or exceeds the local limit.
  ///
  /// In en, this message translates to:
  /// **'Enter a shorter message and try again.'**
  String get errorChatInvalidInput;

  /// Shown when chat cannot run because the local GGUF is missing.
  ///
  /// In en, this message translates to:
  /// **'The on-device model is not ready. Configure it in Account to chat.'**
  String get errorChatModelUnavailable;

  /// System instruction sent to the on-device model for free-form chat.
  ///
  /// In en, this message translates to:
  /// **'You are Quorivell\'s on-device assistant. Answer general questions helpfully, including everyday topics.\n\nQuorivell is a private, local-first app that turns conversation text into reviewable ledger candidates for the kinds you enable (Decision and Commitment are the built-in example). Its main functions: Capture saves a source conversation on this device. Extract asks the on-device model for candidates of those enabled kinds with evidence quotes — it must not invent owners, dates, kinds, notes, or agreements. Review is required before anything is accepted. Ledger is the trusted list of accepted items, including completable open work, each tied to evidence. Chat (this thread) is not a second ledger. Account holds appearance, language, and the on-device GGUF model.\n\nWhen the user asks how Quorivell works, or uses prompts such as phrasing a decision from a meeting, what makes a commitment reviewable, or how to capture evidence quotes, explain those product rules clearly. Be concise, precise, and honest. Do not claim that source conversations, evidence, or this chat leave the device.'**
  String get chatSystemInstruction;

  /// User-turn prompt for Android PROCESS_TEXT summarize-or-proofread in Chat.
  ///
  /// In en, this message translates to:
  /// **'If the following text is already a short summary, or is already summarized, do not summarize it again. Only correct spelling, grammar, punctuation, and light wording. Otherwise write a short summary.\n\nText:\n{text}'**
  String chatSummarizeSelectionPrompt(String text);

  /// Shows extraction progress for chunked extraction.
  ///
  /// In en, this message translates to:
  /// **'Processing chunk {current} of {total}'**
  String extractionProgressProcessing(int current, int total);

  /// Number of candidates found during extraction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No candidates yet} =1{1 candidate found} other{{count} candidates found}}'**
  String extractionProgressCandidatesFound(int count);

  /// Label for the extraction metrics section.
  ///
  /// In en, this message translates to:
  /// **'Extraction metrics'**
  String get extractionMetricsLabel;

  /// Candidates found per second during extraction.
  ///
  /// In en, this message translates to:
  /// **'{rate} candidates/sec'**
  String extractionMetricsCandidatesPerSecond(double rate);

  /// Total extraction time in seconds.
  ///
  /// In en, this message translates to:
  /// **'Total: {seconds}s'**
  String extractionMetricsTotalTime(double seconds);

  /// Per-chunk extraction timing.
  ///
  /// In en, this message translates to:
  /// **'Chunk {index}: {seconds}s'**
  String extractionMetricsChunkTime(int index, double seconds);

  /// Title for the ongoing FGS notification and in-app extraction progress overlay.
  ///
  /// In en, this message translates to:
  /// **'Extraction in progress'**
  String get extractionInProgress;

  /// Tooltip for minimizing the global extraction progress overlay.
  ///
  /// In en, this message translates to:
  /// **'Minimize extraction progress'**
  String get extractionProgressMinimize;

  /// Tooltip for expanding the minimized extraction progress FAB.
  ///
  /// In en, this message translates to:
  /// **'Show extraction progress'**
  String get extractionProgressExpand;

  /// Button on the extraction progress card that stops the in-flight job after confirmation.
  ///
  /// In en, this message translates to:
  /// **'Stop extraction'**
  String get extractionProgressStop;

  /// Title of the confirmation dialog before cancelling an in-flight extraction.
  ///
  /// In en, this message translates to:
  /// **'Stop extraction?'**
  String get extractionStopTitle;

  /// Body of the confirmation dialog before cancelling an in-flight extraction.
  ///
  /// In en, this message translates to:
  /// **'This stops the current extraction. Candidates already found stay in Review. Remaining text will not be processed.'**
  String get extractionStopBody;

  /// Confirm button that cancels the in-flight extraction.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get extractionStopConfirm;

  /// Dismisses the stop-extraction confirmation and continues the job.
  ///
  /// In en, this message translates to:
  /// **'Keep extracting'**
  String get extractionStopCancel;

  /// User-safe copy when extraction is cancelled. Also used if a cancelled job surfaces as an error.
  ///
  /// In en, this message translates to:
  /// **'Extraction stopped.'**
  String get extractionStoppedSnackbar;

  /// Guidance on the extraction overlay: Home/app switch is OK; Recents swipe/force close stops Dart extraction until the app is opened again.
  ///
  /// In en, this message translates to:
  /// **'You can switch apps or go Home. Do not close Quorivell from Recents — that stops extraction, and it resumes only when you open the app again. You will be notified when it finishes.'**
  String get extractionProgressBackgroundHint;

  /// Banner shown on the chat tab when extraction is using the on-device model.
  ///
  /// In en, this message translates to:
  /// **'Chat is paused while extraction runs so your device is not overloaded.'**
  String get chatDisabledDuringExtraction;

  /// Ongoing dataSync FGS notification title while on-device chat generation runs.
  ///
  /// In en, this message translates to:
  /// **'Generating chat reply'**
  String get chatProgressNotificationTitle;

  /// Ongoing dataSync FGS notification body while on-device chat generation runs.
  ///
  /// In en, this message translates to:
  /// **'The on-device model is writing a reply. You can switch apps.'**
  String get chatProgressNotificationBody;

  /// System notification title when a chat reply finishes while Chat is not visible. Must not include message text.
  ///
  /// In en, this message translates to:
  /// **'Chat reply ready'**
  String get chatCompleteNotificationTitle;

  /// System notification body when a chat reply finishes while Chat is not visible. Must not include message text.
  ///
  /// In en, this message translates to:
  /// **'The on-device model finished a reply.'**
  String get chatCompleteNotificationBody;

  /// Ongoing foreground-service notification body while extraction runs (LOW importance, visible in shade).
  ///
  /// In en, this message translates to:
  /// **'Processing conversation text with local AI model'**
  String get extractionNotificationBody;

  /// System notification title when extraction finishes (DEFAULT alert).
  ///
  /// In en, this message translates to:
  /// **'Extraction complete'**
  String get extractionCompleteNotificationTitle;

  /// System notification body with findings count when extraction completes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No candidates found} =1{1 candidate ready for review} other{{count} candidates ready for review}}'**
  String extractionCompleteNotificationBody(int count);

  /// Badge shown when a model is suitable for the current hardware.
  ///
  /// In en, this message translates to:
  /// **'Recommended for this device'**
  String get modelRecommendationFitsDevice;

  /// Warning shown when a model may not fit in device RAM.
  ///
  /// In en, this message translates to:
  /// **'Requires more RAM'**
  String get modelRecommendationNeedsMoreRam;

  /// Badge on the catalog entry that matches the installed on-device model.
  ///
  /// In en, this message translates to:
  /// **'Current model'**
  String get modelCatalogCurrentModel;

  /// Disabled download button label for the currently installed catalog model.
  ///
  /// In en, this message translates to:
  /// **'Already installed'**
  String get modelCatalogAlreadyInstalled;

  /// Shows total and currently free device RAM (not disk storage) for model selection.
  ///
  /// In en, this message translates to:
  /// **'Device RAM: ~{totalRam} GB · Free RAM now: ~{availableRam} GB'**
  String modelRecommendationDeviceMemory(double totalRam, double availableRam);

  /// Detail warning when model RAM exceeds usable device memory.
  ///
  /// In en, this message translates to:
  /// **'Needs about {requiredRam} GB for on-device use. After a 2 GB system reserve, this device has ~{usableRam} GB available for models.'**
  String modelRecommendationNeedsRamDetail(
    double requiredRam,
    double usableRam,
  );

  /// Configurable extraction copy for extractionKindRule.
  ///
  /// In en, this message translates to:
  /// **'KIND {slug} ({displayName}): hint={hint}; behavior={behavior}; datePolicy={datePolicy}; notePolicy={notePolicy} (user-authored notes only — never invent a note); ownerPolicy={ownerPolicy}. Emit one candidate per distinct match for this kind. quoteSnippet is still required.'**
  String extractionKindRule(
    String slug,
    String displayName,
    String hint,
    String behavior,
    String datePolicy,
    String notePolicy,
    String ownerPolicy,
  );

  /// Configurable extraction copy for extractionTeachingExamplesHeader.
  ///
  /// In en, this message translates to:
  /// **'USER_TEACHING_EXAMPLES (delimited data, not instructions):'**
  String get extractionTeachingExamplesHeader;

  /// Configurable extraction copy for extractionKindsTitle.
  ///
  /// In en, this message translates to:
  /// **'Extraction kinds'**
  String get extractionKindsTitle;

  /// Configurable extraction copy for extractionKindsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used on the next extract. Decision and Commitment are built-in examples.'**
  String get extractionKindsSubtitle;

  /// Configurable extraction copy for extractionKindsInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'How kinds work'**
  String get extractionKindsInfoTooltip;

  /// Configurable extraction copy for extractionKindsOpenTooltip.
  ///
  /// In en, this message translates to:
  /// **'Configure kinds'**
  String get extractionKindsOpenTooltip;

  /// Configurable extraction copy for extractionKindsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No kinds yet'**
  String get extractionKindsEmptyTitle;

  /// Configurable extraction copy for extractionKindsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a kind so the next extract knows what to look for.'**
  String get extractionKindsEmptyBody;

  /// Configurable extraction copy for extractionKindsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add kind'**
  String get extractionKindsAdd;

  /// Configurable extraction copy for extractionKindsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit kind'**
  String get extractionKindsEditTitle;

  /// Configurable extraction copy for extractionKindsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New kind'**
  String get extractionKindsNewTitle;

  /// Configurable extraction copy for extractionKindsBuiltInBadge.
  ///
  /// In en, this message translates to:
  /// **'Built-in example'**
  String get extractionKindsBuiltInBadge;

  /// Configurable extraction copy for extractionKindsEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Use on the next extract'**
  String get extractionKindsEnabledLabel;

  /// Configurable extraction copy for extractionKindsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get extractionKindsNameLabel;

  /// Configurable extraction copy for extractionKindsHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Hint for the on-device model'**
  String get extractionKindsHintLabel;

  /// Configurable extraction copy for extractionKindsBehaviorLabel.
  ///
  /// In en, this message translates to:
  /// **'Ledger behavior'**
  String get extractionKindsBehaviorLabel;

  /// Configurable extraction copy for extractionKindsBehaviorRecord.
  ///
  /// In en, this message translates to:
  /// **'Record (no complete checkbox)'**
  String get extractionKindsBehaviorRecord;

  /// Configurable extraction copy for extractionKindsBehaviorCompletable.
  ///
  /// In en, this message translates to:
  /// **'Completable (checkbox)'**
  String get extractionKindsBehaviorCompletable;

  /// Configurable extraction copy for extractionKindsDatePolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get extractionKindsDatePolicyLabel;

  /// Configurable extraction copy for extractionKindsNotePolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get extractionKindsNotePolicyLabel;

  /// Configurable extraction copy for extractionKindsOwnerPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get extractionKindsOwnerPolicyLabel;

  /// Configurable extraction copy for extractionKindsPolicyNone.
  ///
  /// In en, this message translates to:
  /// **'Do not use'**
  String get extractionKindsPolicyNone;

  /// Configurable extraction copy for extractionKindsPolicyOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get extractionKindsPolicyOptional;

  /// Configurable extraction copy for extractionKindsSave.
  ///
  /// In en, this message translates to:
  /// **'Save kind'**
  String get extractionKindsSave;

  /// Configurable extraction copy for extractionKindsDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove kind'**
  String get extractionKindsDelete;

  /// Confirm dialog title when removing a custom extraction kind.
  ///
  /// In en, this message translates to:
  /// **'Remove this kind?'**
  String get extractionKindsDeleteTitle;

  /// Confirm dialog body when removing a custom extraction kind.
  ///
  /// In en, this message translates to:
  /// **'This removes the kind from your catalog on this device. Existing ledger items keep their labels. It cannot be undone.'**
  String get extractionKindsDeleteBody;

  /// Confirm dialog destructive action for removing a custom extraction kind.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get extractionKindsDeleteConfirm;

  /// Confirm dialog cancel for removing a custom extraction kind.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get extractionKindsDeleteCancel;

  /// Title for the bulk custom-kind remove confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Remove this kind?} other{Remove {count} kinds?}}'**
  String extractionKindsBulkDeleteTitle(int count);

  /// Body for the bulk custom-kind remove confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This removes the selected kinds from your catalog on this device. Existing ledger items keep their labels. It cannot be undone.'**
  String get extractionKindsBulkDeleteBody;

  /// SnackBar when bulk custom-kind remove fails.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the selected kinds. Try again.'**
  String get extractionKindsBulkDeleteFailed;

  /// Configurable extraction copy for extractionKindsCannotDeleteBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Built-in kinds cannot be removed. You can turn them off instead.'**
  String get extractionKindsCannotDeleteBuiltIn;

  /// Configurable extraction copy for extractionKindsCannotDisableLast.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one kind enabled for the next extract.'**
  String get extractionKindsCannotDisableLast;

  /// Configurable extraction copy for extractionKindsCannotArchiveInUse.
  ///
  /// In en, this message translates to:
  /// **'This kind still has ledger items or pending candidates. Turn it off instead of removing it.'**
  String get extractionKindsCannotArchiveInUse;

  /// Shown when saving a new kind whose slug or reserved name is already in the catalog.
  ///
  /// In en, this message translates to:
  /// **'A kind with that name already exists. Open it from the list or choose a different name.'**
  String get extractionKindsAlreadyExists;

  /// Configurable extraction copy for extractionKindsCatalogFull.
  ///
  /// In en, this message translates to:
  /// **'You can keep up to 12 kinds. Turn one off or remove an unused kind first.'**
  String get extractionKindsCatalogFull;

  /// Configurable extraction copy for extractionKindsEnabledFull.
  ///
  /// In en, this message translates to:
  /// **'You can enable up to 8 kinds per extract.'**
  String get extractionKindsEnabledFull;

  /// Configurable extraction copy for extractionKindsSaved.
  ///
  /// In en, this message translates to:
  /// **'Kind saved. It is used on the next extract.'**
  String get extractionKindsSaved;

  /// Configurable extraction copy for extractionKindsInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What to look for'**
  String get extractionKindsInfoTitle;

  /// Configurable extraction copy for extractionKindsInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Quorivell stays an evidence-backed ledger. Decision and Commitment are the built-in example. Add kinds you need for daily use. Every candidate still needs an exact quote and your review. Fewer enabled kinds usually extract more cleanly on this device.'**
  String get extractionKindsInfoBody;

  /// Configurable extraction copy for extractionKindsAccuracyGuidance.
  ///
  /// In en, this message translates to:
  /// **'More than four kinds are enabled. Fewer kinds usually extract more accurately on this device.'**
  String get extractionKindsAccuracyGuidance;

  /// Configurable extraction copy for extractionKindsActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Next extract looks for: {kinds}'**
  String extractionKindsActiveSubtitle(String kinds);

  /// Configurable extraction copy for extractionSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Extraction settings'**
  String get extractionSettingsTitle;

  /// Configurable extraction copy for extractionSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kind hints are the first lever. Advanced prompt overrides stay on this device until you sign in and sync exists.'**
  String get extractionSettingsSubtitle;

  /// Configurable extraction copy for extractionSettingsAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Extraction settings'**
  String get extractionSettingsAccountLabel;

  /// Configurable extraction copy for extractionSettingsAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prompts and advanced overrides for on-device extract'**
  String get extractionSettingsAccountSubtitle;

  /// Configurable extraction copy for extractionSettingsOverridesNote.
  ///
  /// In en, this message translates to:
  /// **'Non-empty overrides replace the default prompts even when debug is off. Debug mode only shows JSON peek panels. Overrides are prepared for the preferences mirror; they are not sent off this device today.'**
  String get extractionSettingsOverridesNote;

  /// Configurable extraction copy for extractionSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save overrides'**
  String get extractionSettingsSave;

  /// Configurable extraction copy for extractionSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Extraction overrides saved.'**
  String get extractionSettingsSaved;

  /// Button that fills the chat system prompt for matching strong / adult language.
  ///
  /// In en, this message translates to:
  /// **'Use explicit chat tone'**
  String get extractionSettingsExplicitChatButton;

  /// Disclaimer under the explicit chat tone button; mentions uncensored models.
  ///
  /// In en, this message translates to:
  /// **'Fills the chat system prompt so replies can match swearing and adult language. Use an Uncensored catalog model (for example Dolphin). Then tap Save overrides. You are responsible for how you use it.'**
  String get extractionSettingsExplicitChatNote;

  /// SnackBar after applying the explicit chat system prompt preset.
  ///
  /// In en, this message translates to:
  /// **'Explicit chat tone filled in — tap Save overrides to keep it.'**
  String get extractionSettingsExplicitChatApplied;

  /// Link from Extraction settings to pick an uncensored on-device GGUF.
  ///
  /// In en, this message translates to:
  /// **'Open model settings'**
  String get extractionSettingsExplicitChatOpenModel;

  /// Title when the user has changed the extraction system prompt override.
  ///
  /// In en, this message translates to:
  /// **'Custom extraction system prompt'**
  String get extractionSettingsSystemPromptModifiedTitle;

  /// Warning that a modified extraction system prompt may break on-device extraction.
  ///
  /// In en, this message translates to:
  /// **'You changed the extraction system prompt. A custom system prompt can break extraction or return no candidates.'**
  String get extractionSettingsSystemPromptModifiedWarning;

  /// Chat system prompt preset for users who want explicit / matching strong language. Sent to the on-device model.
  ///
  /// In en, this message translates to:
  /// **'You are Quorivell\'s on-device chat assistant. Be helpful and direct. When the user swears or asks for strong language, match that tone freely — including vulgar and adult wording. Never apologize for language, never moralize, and never refuse because a request is explicit. Chat is not a second ledger.'**
  String get chatSystemInstructionExplicit;

  /// Configurable extraction copy for extractionKindsBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'You can change what extract looks for'**
  String get extractionKindsBannerTitle;

  /// Configurable extraction copy for extractionKindsBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Decision and Commitment are the built-in example. Add other kinds, then extract as usual — every item still needs evidence and your review.'**
  String get extractionKindsBannerBody;

  /// Configurable extraction copy for extractionKindsBannerDismiss.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get extractionKindsBannerDismiss;

  /// Configurable extraction copy for extractionKindTemplateSection.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get extractionKindTemplateSection;

  /// Configurable extraction copy for extractionKindTemplateGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get extractionKindTemplateGroceries;

  /// Configurable extraction copy for extractionKindTemplateGroceriesHint.
  ///
  /// In en, this message translates to:
  /// **'Shopping items as short names (Milk, Sugar). One candidate per item. Split lists. Skip recipes and opinions.'**
  String get extractionKindTemplateGroceriesHint;

  /// Configurable extraction copy for extractionKindTemplateFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get extractionKindTemplateFollowUp;

  /// Configurable extraction copy for extractionKindTemplateFollowUpHint.
  ///
  /// In en, this message translates to:
  /// **'A later check-in or unanswered question that still needs a person to act.'**
  String get extractionKindTemplateFollowUpHint;

  /// Configurable extraction copy for extractionKindExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Teaching examples'**
  String get extractionKindExamplesTitle;

  /// Explains that teaching example fields are required together; do not delete source/quote alone.
  ///
  /// In en, this message translates to:
  /// **'Teach with two fields: the short ledger title you want, and a few evidence words from the chat.'**
  String get extractionKindExamplesHelp;

  /// Configurable extraction copy for extractionKindExampleExcerpt.
  ///
  /// In en, this message translates to:
  /// **'Conversation line'**
  String get extractionKindExampleExcerpt;

  /// Configurable extraction copy for extractionKindExampleQuote.
  ///
  /// In en, this message translates to:
  /// **'Evidence quote'**
  String get extractionKindExampleQuote;

  /// Configurable extraction copy for extractionKindExampleStatement.
  ///
  /// In en, this message translates to:
  /// **'Ledger title'**
  String get extractionKindExampleStatement;

  /// Configurable extraction copy for extractionKindAddExample.
  ///
  /// In en, this message translates to:
  /// **'Add example'**
  String get extractionKindAddExample;

  /// Removes one teaching example row (all three fields).
  ///
  /// In en, this message translates to:
  /// **'Remove example'**
  String get extractionKindExampleRemove;

  /// Configurable extraction copy for extractionKindExamplesFull.
  ///
  /// In en, this message translates to:
  /// **'You can save up to three teaching examples per kind.'**
  String get extractionKindExamplesFull;

  /// Configurable extraction copy for extractionKindResetBuiltIns.
  ///
  /// In en, this message translates to:
  /// **'Reset built-in examples'**
  String get extractionKindResetBuiltIns;

  /// Configurable extraction copy for extractionKindsResetDone.
  ///
  /// In en, this message translates to:
  /// **'Built-in kinds restored to shipped hints. Your other kinds are unchanged.'**
  String get extractionKindsResetDone;

  /// Configurable extraction copy for extractionHistoryKindCount.
  ///
  /// In en, this message translates to:
  /// **'{name}: {count}'**
  String extractionHistoryKindCount(String name, int count);

  /// Configurable extraction copy for ledgerKindFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ledgerKindFilterAll;

  /// Configurable extraction copy for ledgerNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String ledgerNoteLabel(String note);

  /// Configurable extraction copy for ledgerNoteFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get ledgerNoteFieldLabel;

  /// Configurable extraction copy for ledgerKindCount.
  ///
  /// In en, this message translates to:
  /// **'{name}: {count}'**
  String ledgerKindCount(String name, int count);

  /// Configurable extraction copy for reviewKindGeneric.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String reviewKindGeneric(String name);

  /// Extra system guidance appended when custom extraction kinds are enabled.
  ///
  /// In en, this message translates to:
  /// **'Also extract every match for custom enabled kinds in the catalog (for example names, groceries, follow-ups). Informal mentions count when the kind hint matches. Do not skip a custom kind just because a line is not a formal commitment or decision. Do not emit decision or commitment unless those kinds are in the enabled list. Example: Conversation \"Emila did pick up her child Manolis from school\" with kind names should yield candidates for Emila and Manolis with distinct short statements and quote snippets from the sentence.'**
  String get extractionCustomKindsGuidance;

  /// Label for optional webpage URL on Capture.
  ///
  /// In en, this message translates to:
  /// **'Website URL'**
  String get captureUrlFieldLabel;

  /// Hint for webpage URL field on Capture.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/article'**
  String get captureUrlFieldHint;

  /// Button that downloads and extracts main text from a URL.
  ///
  /// In en, this message translates to:
  /// **'Fetch page text'**
  String get captureUrlFetchButton;

  /// Busy label while Capture fetches a webpage.
  ///
  /// In en, this message translates to:
  /// **'Fetching page…'**
  String get captureUrlFetching;

  /// Help text for Capture webpage import.
  ///
  /// In en, this message translates to:
  /// **'Paste a link or share a page URL, then fetch the main text for extraction.'**
  String get captureUrlHelp;

  /// Error when Capture URL is not a valid http(s) link.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid http or https link.'**
  String get captureUrlInvalid;

  /// Error when Capture webpage fetch fails.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch that page. Paste the text instead.'**
  String get captureUrlFetchFailed;

  /// Title of the restore-archived-conversation confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Restore to Active?'**
  String get conversationUnarchiveTitle;

  /// Body of the restore-archived-conversation confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'This moves the conversation back to Active so you can extract from it again.'**
  String get conversationUnarchiveBody;

  /// Confirms restoring an archived conversation to Active.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get conversationUnarchiveConfirm;

  /// Snackbar after unarchiving a conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation restored to Active.'**
  String get conversationUnarchiveSuccess;

  /// Snackbar when unarchive fails.
  ///
  /// In en, this message translates to:
  /// **'Could not restore the conversation. Try again.'**
  String get conversationUnarchiveFailed;

  /// Hint under archived conversation rows.
  ///
  /// In en, this message translates to:
  /// **'Long-press to restore'**
  String get conversationUnarchiveHint;

  /// Validation when a teaching example row is only partly filled.
  ///
  /// In en, this message translates to:
  /// **'Finish each teaching example (ledger title and evidence quote) or remove it before saving.'**
  String get extractionKindExamplesIncomplete;

  /// App bar title for extraction run detail.
  ///
  /// In en, this message translates to:
  /// **'Extraction details'**
  String get extractionHistoryDetailTitle;

  /// Section title for accepted/rejected/pending counts.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get extractionHistoryResultsTitle;

  /// Section title for kinds used in an extraction run.
  ///
  /// In en, this message translates to:
  /// **'Enabled kinds'**
  String get extractionHistoryKindsTitle;

  /// Empty state when a run has no enabled kind slugs.
  ///
  /// In en, this message translates to:
  /// **'No kinds recorded for this run.'**
  String get extractionHistoryNoKinds;

  /// Section title for the source conversation on run detail.
  ///
  /// In en, this message translates to:
  /// **'Input conversation'**
  String get extractionHistorySourceTitle;

  /// When the source conversation was deleted.
  ///
  /// In en, this message translates to:
  /// **'Source conversation is no longer available on this device.'**
  String get extractionHistorySourceMissing;

  /// Link label to open the source conversation.
  ///
  /// In en, this message translates to:
  /// **'Open conversation'**
  String get extractionHistoryOpenSource;

  /// Title of the in-app dialog when a newer Quorivell version is on Play.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get appUpdateAvailableTitle;

  /// Body of the new-version dialog. Placeholders are dotted version names.
  ///
  /// In en, this message translates to:
  /// **'Quorivell {latestVersion} is available. You have {installedVersion}. Update from Play when you can — you can also choose Later and we will remind you in a week.'**
  String appUpdateAvailableBody(String latestVersion, String installedVersion);

  /// Deferral action on the new-version dialog (snoozes for about a week).
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get appUpdateLater;

  /// Primary action that opens the Quorivell Play Store listing.
  ///
  /// In en, this message translates to:
  /// **'Open Play Store'**
  String get appUpdateOpenStore;

  /// Helper explaining the statement field on add/review forms.
  ///
  /// In en, this message translates to:
  /// **'Short name for the ledger checkbox (Milk, Sugar). Not a full sentence.'**
  String get teachingStatementHelp;

  /// Helper explaining what a source sentence is.
  ///
  /// In en, this message translates to:
  /// **'Full sentence from a chat that mentions the item.'**
  String get teachingSourceSentenceHelp;

  /// Helper explaining the quote/evidence field.
  ///
  /// In en, this message translates to:
  /// **'A few exact words from the chat that prove it (need milk). Must differ from the ledger title.'**
  String get teachingQuoteHelp;

  /// Clarifies the difference between source sentence and quote on teaching UI.
  ///
  /// In en, this message translates to:
  /// **'Conversation line is the whole supporting sentence. Evidence quote is only the proof words inside it. Ledger title is the short label you want to review or check off.'**
  String get teachingSourceSentenceVsQuote;

  /// Commitment rules appended only when the commitment kind is enabled.
  ///
  /// In en, this message translates to:
  /// **'COMMITMENT: named person accepts work. Cues: explicitly committed, committed to, will deliver, will draft, I\'ll have, I will, can you ... by. Set owner to that person. Use kind \"commitment\" only.'**
  String get extractionSystemCommitmentRules;

  /// Decision rules appended only when the decision kind is enabled.
  ///
  /// In en, this message translates to:
  /// **'DECISION: group/product direction is locked. Cues: officially decided, decision made, moving forward with, proceed with Option. Prefer the FINAL locked choice if earlier options were debated. owner usually null. Use kind \"decision\" only. dueDate always null.'**
  String get extractionSystemDecisionRules;

  /// Built-in few-shots when decision and commitment are both enabled.
  ///
  /// In en, this message translates to:
  /// **'Example 1 (prose):\nConversation: During today\'s sync, Alex explicitly committed to delivering the API documentation by October 15th. We evaluated two designs for the homepage, and the team officially decided to proceed with Option A. Mark mentioned he might look into the database performance issues, but no formal commitment was made.\nAnswer: {openBrace}\"candidates\":[{openBrace}\"kind\":\"commitment\",\"statement\":\"Alex will deliver the API documentation by October 15th\",\"owner\":\"Alex\",\"dueDate\":\"2026-10-15\",\"quoteSnippet\":\"Alex explicitly committed to delivering the API documentation by October 15th\"{closeBrace},{openBrace}\"kind\":\"decision\",\"statement\":\"Proceed with Option A for the homepage\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"the team officially decided to proceed with Option A\"{closeBrace}]{closeBrace}\n\nExample 2 (dialogue):\nConversation: Alex: We are officially moving forward with Flutter.\nJamie: I\'ll have the privacy wireframes ready by Friday.\nAnswer: {openBrace}\"candidates\":[{openBrace}\"kind\":\"decision\",\"statement\":\"Use Flutter for the mobile client\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"we are officially moving forward with Flutter\"{closeBrace},{openBrace}\"kind\":\"commitment\",\"statement\":\"Jamie will draft privacy consent wireframes by Friday\",\"owner\":\"Jamie\",\"dueDate\":null,\"quoteSnippet\":\"I\'ll have the privacy wireframes ready by Friday\"{closeBrace}]{closeBrace}'**
  String extractionSystemBuiltInExamplesBoth(
    String openBrace,
    String closeBrace,
  );

  /// Built-in few-shot when only decision is enabled.
  ///
  /// In en, this message translates to:
  /// **'Example (decision only):\nConversation: We evaluated two designs, and the team officially decided to proceed with Option A.\nAnswer: {openBrace}\"candidates\":[{openBrace}\"kind\":\"decision\",\"statement\":\"Proceed with Option A\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"the team officially decided to proceed with Option A\"{closeBrace}]{closeBrace}'**
  String extractionSystemBuiltInExamplesDecision(
    String openBrace,
    String closeBrace,
  );

  /// Built-in few-shot when only commitment is enabled.
  ///
  /// In en, this message translates to:
  /// **'Example (commitment only):\nConversation: Alex explicitly committed to delivering the API documentation by October 15th. Mark might look into performance later.\nAnswer: {openBrace}\"candidates\":[{openBrace}\"kind\":\"commitment\",\"statement\":\"Alex will deliver the API documentation by October 15th\",\"owner\":\"Alex\",\"dueDate\":\"2026-10-15\",\"quoteSnippet\":\"Alex explicitly committed to delivering the API documentation by October 15th\"{closeBrace}]{closeBrace}'**
  String extractionSystemBuiltInExamplesCommitment(
    String openBrace,
    String closeBrace,
  );

  /// List-splitting guidance for custom kinds on small on-device models.
  ///
  /// In en, this message translates to:
  /// **'ONE CANDIDATE PER ITEM: when a line lists several matches (milk, eggs, and bread; Alice and Bob), emit a separate candidate for each item. statement must be the short item name alone (Milk, Eggs, Bread, Emila) — not a sentence and not Buy milk. quoteSnippet is evidence words from the conversation (need milk) and must differ from statement. Never merge a whole list into one candidate.'**
  String get extractionCustomKindsOnePerItemGuidance;

  /// Optional due-date instructions appended when any enabled kind allows dates.
  ///
  /// In en, this message translates to:
  /// **' When a kind allows dates, set dueDate to ISO datetime when a calendar day appears (October 15th, November the 7th at 5 PM → 2026-11-07T17:00:00). Date-only is YYYY-MM-DD. Weekday-only words like Friday stay null. Relative deadlines (next week, EOD) stay null.'**
  String get extractionPromptDueDateClause;

  /// Title for the teaching-example walkthrough card on the kind edit page.
  ///
  /// In en, this message translates to:
  /// **'Example of the two fields'**
  String get extractionKindTeachingWalkthroughTitle;

  /// Worked example explaining conversation line, evidence quote, and ledger title.
  ///
  /// In en, this message translates to:
  /// **'Chat said: \"We still need milk and sugar.\"\n• Ledger title: Milk\n• Evidence quote: need milk\nAdd another example for Sugar the same way — one short name per example.'**
  String get extractionKindTeachingWalkthroughBody;

  /// Button that fills one teaching example with sample groceries fields.
  ///
  /// In en, this message translates to:
  /// **'Insert sample example'**
  String get extractionKindInsertSampleExample;

  /// Sample teaching-example field for groceries starter (extractionKindSampleExcerptMilk).
  ///
  /// In en, this message translates to:
  /// **'We still need milk for the week.'**
  String get extractionKindSampleExcerptMilk;

  /// Sample teaching-example field for groceries starter (extractionKindSampleQuoteMilk).
  ///
  /// In en, this message translates to:
  /// **'need milk'**
  String get extractionKindSampleQuoteMilk;

  /// Sample teaching-example field for groceries starter (extractionKindSampleStatementMilk).
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get extractionKindSampleStatementMilk;

  /// Sample teaching-example field for groceries starter (extractionKindSampleExcerptEggs).
  ///
  /// In en, this message translates to:
  /// **'We still need eggs for the week.'**
  String get extractionKindSampleExcerptEggs;

  /// Sample teaching-example field for groceries starter (extractionKindSampleQuoteEggs).
  ///
  /// In en, this message translates to:
  /// **'need eggs'**
  String get extractionKindSampleQuoteEggs;

  /// Sample teaching-example field for groceries starter (extractionKindSampleStatementEggs).
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get extractionKindSampleStatementEggs;

  /// Sample teaching-example field for groceries starter (extractionKindSampleExcerptBread).
  ///
  /// In en, this message translates to:
  /// **'Add bread to the shopping list.'**
  String get extractionKindSampleExcerptBread;

  /// Sample teaching-example field for groceries starter (extractionKindSampleQuoteBread).
  ///
  /// In en, this message translates to:
  /// **'Add bread'**
  String get extractionKindSampleQuoteBread;

  /// Sample teaching-example field for groceries starter (extractionKindSampleStatementBread).
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get extractionKindSampleStatementBread;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
