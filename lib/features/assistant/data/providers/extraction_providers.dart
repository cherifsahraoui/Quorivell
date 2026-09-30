import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/ai/llama_cpp_local_text_model_runtime.dart';
import '../../../../core/ai/extraction_kind_prompt_spec.dart';
import '../../../../core/ai/local_ai_service.dart';
import '../../../../core/ai/local_model_providers.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/l10n/local_ai_copy.dart';
import '../../../account/data/providers/debug_ai_settings_providers.dart';
import '../../../account/data/providers/locale_preference_providers.dart';
import '../../../account/domain/entities/user_preference.dart';
import '../../../auth/data/providers/local_user_scope_providers.dart';
import '../../../extraction_kinds/data/providers/extraction_item_kind_providers.dart';

import '../../domain/repositories/extraction_repository.dart';
import '../../domain/repositories/extraction_run_repository.dart';
import '../datasources/extraction_local_data_source.dart';
import '../repositories/extraction_repository_impl.dart';
import '../repositories/extraction_run_repository_impl.dart';

part 'extraction_providers.g.dart';

@Riverpod(keepAlive: true)
LocalAIService localAIService(Ref ref) {
  final service = OnDeviceLocalAIService(
    LlamaCppLocalTextModelRuntime(
      store: ref.watch(localModelStoreProvider),
      spec: ref.watch(localModelSpecProvider),
    ),
  );
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
ExtractionLocalDataSource extractionLocalDataSource(Ref ref) {
  return DriftExtractionLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
ExtractionRepository extractionRepository(Ref ref) {
  final prefs = ref.watch(debugAiSettingsControllerProvider).asData?.value;
  final localePreference =
      ref.watch(localePreferenceControllerProvider).asData?.value ??
      AppLocalePreference.system;
  LocalAICopy copyForKinds(kinds) {
    return applyAiPromptOverrides(
      localAICopyForLocale(
        LocalePreferenceController.effectiveLocale(localePreference),
        enabledKinds: kinds,
      ),
      debugModeEnabled: prefs?.debugModeEnabled ?? false,
      chatSystemPromptOverride: prefs?.chatSystemPromptOverride,
      extractionPromptOverride: prefs?.extractionPromptOverride,
      extractionSystemPromptOverride: prefs?.extractionSystemPromptOverride,
    );
  }

  return ExtractionRepositoryImpl(
    localDataSource: ref.watch(extractionLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
    aiService: ref.watch(localAIServiceProvider),
    copy: copyForKinds(defaultBuiltInKindSpecs()),
    kindRepository: ref.watch(extractionItemKindRepositoryProvider),
    copyForKinds: copyForKinds,
    runRepository: ref.watch(extractionRunRepositoryProvider),
    modelStore: ref.watch(localModelStoreProvider),
  );
}

@riverpod
ExtractionRunRepository extractionRunRepository(Ref ref) {
  return ExtractionRunRepositoryImpl(
    localDataSource: ref.watch(extractionLocalDataSourceProvider),
    userScopeRepository: ref.watch(localUserScopeRepositoryProvider),
  );
}
