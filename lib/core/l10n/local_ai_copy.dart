import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../ai/extraction_kind_prompt_spec.dart';
import '../ai/extraction_prompt_builder.dart';
import '../ai/local_ai_service.dart';

Locale supportedAppLocale(Locale requested) {
  for (final supported in AppLocalizations.supportedLocales) {
    if (supported.languageCode == requested.languageCode) {
      return Locale(supported.languageCode);
    }
  }
  return const Locale('en');
}

LocalAICopy localAICopyFromL10n(
  AppLocalizations l10n, {
  List<ExtractionKindPromptSpec>? enabledKinds,
}) {
  final kinds = enabledKinds ?? defaultBuiltInKindSpecs();
  return LocalAICopy(
    emptySummary: l10n.extractionEmptySummary,
    candidateCommitments: l10n.extractionCandidateCommitments,
    reviewEachItem: l10n.extractionReviewEachItem,
    buildPrompt: (conversation) =>
        ExtractionPromptBuilder.userPrompt(l10n, kinds, conversation),
    remoteSystemInstruction: ExtractionPromptBuilder.systemInstruction(
      l10n,
      kinds,
    ),
    chatSystemInstruction: l10n.chatSystemInstruction,
    languageCode: Locale(l10n.localeName).languageCode,
    enabledKindSlugs: {for (final kind in kinds) kind.slug},
    slugsAllowingDates: {
      for (final kind in kinds)
        if (kind.allowsDueDate) kind.slug,
    },
  );
}

LocalAICopy localAICopyForLocale(
  Locale locale, {
  List<ExtractionKindPromptSpec>? enabledKinds,
}) {
  return localAICopyFromL10n(
    lookupAppLocalizations(supportedAppLocale(locale)),
    enabledKinds: enabledKinds,
  );
}

/// Defaults to the device locale. Prefer [localAICopyForLocale] with
/// [LocalePreferenceController.effectiveLocale] so app language changes apply.
LocalAICopy localAICopyForPlatform() {
  return localAICopyForLocale(
    WidgetsBinding.instance.platformDispatcher.locale,
  );
}

String? _nonEmptyOverride(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

/// Applies stored prompt overrides whenever they are non-empty.
///
/// Empty / null fields keep [base]. Debug mode is not required; it only
/// controls JSON peek panels in the UI.
LocalAICopy applyAiPromptOverrides(
  LocalAICopy base, {
  bool debugModeEnabled = false,
  String? chatSystemPromptOverride,
  String? extractionPromptOverride,
  String? extractionSystemPromptOverride,
}) {
  // Debug mode no longer gates overrides; keep the flag for call-site compat.
  assert(() {
    debugModeEnabled;
    return true;
  }());
  final chat = _nonEmptyOverride(chatSystemPromptOverride);
  final extractionSystem = _nonEmptyOverride(extractionSystemPromptOverride);
  final extractionUser = _nonEmptyOverride(extractionPromptOverride);
  if (chat == null && extractionSystem == null && extractionUser == null) {
    return base;
  }

  return LocalAICopy(
    emptySummary: base.emptySummary,
    candidateCommitments: base.candidateCommitments,
    reviewEachItem: base.reviewEachItem,
    buildPrompt: extractionUser == null
        ? base.buildPrompt
        : (conversation) {
            if (extractionUser.contains('{conversation}')) {
              return extractionUser.replaceAll('{conversation}', conversation);
            }
            return '$extractionUser\n\n$conversation';
          },
    remoteSystemInstruction: extractionSystem ?? base.remoteSystemInstruction,
    chatSystemInstruction: chat ?? base.chatSystemInstruction,
    languageCode: base.languageCode,
    enabledKindSlugs: base.enabledKindSlugs,
    slugsAllowingDates: base.slugsAllowingDates,
  );
}
