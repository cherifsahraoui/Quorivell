import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_preference.dart';
import 'user_preference_providers.dart';

part 'debug_ai_settings_providers.g.dart';

/// Persisted debug-mode flag and on-device prompt overrides.
@Riverpod(keepAlive: true)
class DebugAiSettingsController extends _$DebugAiSettingsController {
  @override
  Future<UserPreference?> build() async {
    return ref.watch(userPreferenceRepositoryProvider).load();
  }

  Future<void> setEnabled(bool enabled) async {
    final saved = await ref
        .read(userPreferenceRepositoryProvider)
        .saveDebugModeEnabled(enabled);
    if (!ref.mounted) return;
    state = AsyncValue.data(saved);
  }

  Future<void> savePromptOverrides({
    required String? chatSystemPromptOverride,
    required String? extractionPromptOverride,
    required String? extractionSystemPromptOverride,
  }) async {
    final saved = await ref
        .read(userPreferenceRepositoryProvider)
        .savePromptOverrides(
          chatSystemPromptOverride: chatSystemPromptOverride,
          extractionPromptOverride: extractionPromptOverride,
          extractionSystemPromptOverride: extractionSystemPromptOverride,
        );
    if (!ref.mounted) return;
    state = AsyncValue.data(saved);
  }

  Future<void> dismissExtractionKindsIntro() async {
    final saved = await ref
        .read(userPreferenceRepositoryProvider)
        .saveExtractionKindsIntroDismissed(true);
    if (!ref.mounted) return;
    state = AsyncValue.data(saved);
  }
}
