import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/ai/chatml_sanitizer.dart';
import '../../../../core/ai/local_ai_service.dart';
import '../../../../core/ai/local_model_providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/local_ai_copy.dart';
import '../../../../core/platform/extraction_platform_service.dart';
import '../../../../core/platform/model_transfer_platform_service.dart';
import '../../../../core/platform/share_intent.dart';
import '../../../../core/routing/post_setup_home.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/providers/debug_ai_settings_providers.dart';
import '../../../account/data/providers/locale_preference_providers.dart';
import '../../../account/domain/entities/user_preference.dart';
import '../../../assistant/data/providers/extraction_providers.dart';
import '../../../assistant/presentation/controllers/review_controller.dart';
import '../../data/providers/chat_providers.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/chat_summarize_selection.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_conversation_visible_controller.dart';
import 'chat_generation_hold_controller.dart';
import 'chat_session_state.dart';
import 'unread_chat_count_controller.dart';

part 'chat_session_controller.g.dart';

@Riverpod(keepAlive: true)
class ChatSessionController extends _$ChatSessionController {
  var _generation = 0;

  @override
  ChatSessionState build() {
    // Extraction and chat share the on-device model; stop chat when extraction
    // starts so the device is not overloaded.
    ref.listen(extractionRunningControllerProvider, (previous, next) {
      if (next && state.isGenerating) {
        unawaited(stop());
      }
    });
    return const ChatSessionState();
  }

  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  LocalAIService get _ai => ref.read(localAIServiceProvider);

  void openThread(String id) {
    state = state.copyWith(
      threadId: id,
      draftNew: false,
      streamingText: '',
      sendFailure: null,
    );
  }

  Future<void> startNewChat() async {
    final shouldStop = state.isGenerating;
    final threadId = state.threadId;
    final partial = state.streamingText.trim();
    final autoScrollEnabled = state.autoScrollEnabled;
    _generation++;
    state = ChatSessionState(
      draftNew: true,
      autoScrollEnabled: autoScrollEnabled,
    );
    if (shouldStop) {
      await _haltGeneration(threadId: threadId, partial: partial);
    }
  }

  void toggleAutoScroll() {
    state = state.copyWith(autoScrollEnabled: !state.autoScrollEnabled);
  }

  void setAutoScrollEnabled(bool enabled) {
    if (state.autoScrollEnabled == enabled) return;
    state = state.copyWith(autoScrollEnabled: enabled);
  }

  Future<LocalAICopy> _effectiveCopy() async {
    final prefs = ref.read(debugAiSettingsControllerProvider).asData?.value;
    final localePreference = await _resolvedLocalePreference();
    return applyAiPromptOverrides(
      localAICopyForLocale(
        LocalePreferenceController.effectiveLocale(localePreference),
      ),
      debugModeEnabled: prefs?.debugModeEnabled ?? false,
      chatSystemPromptOverride: prefs?.chatSystemPromptOverride,
      extractionPromptOverride: prefs?.extractionPromptOverride,
      extractionSystemPromptOverride: prefs?.extractionSystemPromptOverride,
    );
  }

  Future<AppLocalePreference> _resolvedLocalePreference() async {
    final current = ref.read(localePreferenceControllerProvider);
    final loaded = current.asData?.value;
    if (loaded != null) return loaded;
    try {
      return await ref.read(localePreferenceControllerProvider.future);
    } on Object {
      return AppLocalePreference.system;
    }
  }

  Future<void> deleteThread(String id) async {
    await _repository.deleteThread(id);
    if (!ref.mounted) return;
    if (state.threadId == id) {
      _generation++;
      state = ChatSessionState(
        draftNew: true,
        autoScrollEnabled: state.autoScrollEnabled,
      );
    }
  }

  Future<void> send(String raw, {String? threadTitle}) async {
    final text = raw.trim();
    if (text.isEmpty ||
        state.isGenerating ||
        ref.read(extractionRunningControllerProvider)) {
      return;
    }

    final generation = ++_generation;
    state = state.copyWith(
      isGenerating: true,
      streamingText: '',
      sendFailure: null,
    );
    await _startChatKeepAlive();

    try {
      final copy = await _effectiveCopy();
      if (!ref.mounted || generation != _generation) return;
      final modelId = await _resolvedModelId();
      if (!ref.mounted || generation != _generation) return;
      var threadId = state.threadId;
      if (threadId == null || state.draftNew) {
        final thread = await _repository.createThread(
          title: chatThreadTitleFrom(threadTitle ?? text),
          modelId: modelId,
        );
        if (!ref.mounted || generation != _generation) return;
        threadId = thread.id;
        state = state.copyWith(threadId: threadId, draftNew: false);
      }

      await _repository.appendMessage(
        threadId: threadId,
        role: AiChatRole.user,
        content: text,
        status: AiChatMessageStatus.complete,
        modelId: modelId,
      );
      if (!ref.mounted || generation != _generation) return;

      await _generateAssistantReply(
        threadId: threadId,
        copy: copy,
        generation: generation,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: failure,
      );
    } on LocalAIException catch (error) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: _mapLocalAIException(error),
      );
    } on Object {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: const ChatFailure.unknown(),
      );
    } finally {
      await _stopChatKeepAlive();
    }
  }

  /// Opens a new thread and sends the localized PROCESS_TEXT summarize prompt.
  Future<void> sendSummarizeSelection(String selectedText) async {
    final text = sanitizeSharedPlainText(selectedText);
    if (text == null) return;
    final l10n = await _appL10n();
    if (!ref.mounted) return;
    final prompt = buildChatSummarizeSelectionPrompt(
      interpolate: l10n.chatSummarizeSelectionPrompt,
      selectedText: text,
    );
    if (prompt.trim().isEmpty) return;
    await startNewChat();
    if (!ref.mounted) return;
    await send(prompt, threadTitle: chatThreadTitleFrom(text));
  }

  Future<void> retry() async {
    final threadId = state.threadId;
    if (threadId == null ||
        state.isGenerating ||
        state.sendFailure == null ||
        ref.read(extractionRunningControllerProvider)) {
      return;
    }

    final generation = ++_generation;
    state = state.copyWith(
      isGenerating: true,
      streamingText: '',
      sendFailure: null,
    );
    await _startChatKeepAlive();

    try {
      final copy = await _effectiveCopy();
      if (!ref.mounted || generation != _generation) return;
      final modelId = await _resolvedModelId();
      if (!ref.mounted || generation != _generation) return;
      await _repository.updateThreadModelId(
        threadId: threadId,
        modelId: modelId,
      );
      if (!ref.mounted || generation != _generation) return;
      await _generateAssistantReply(
        threadId: threadId,
        copy: copy,
        generation: generation,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: failure,
      );
    } on LocalAIException catch (error) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: _mapLocalAIException(error),
      );
    } on Object {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isGenerating: false,
        streamingText: '',
        sendFailure: const ChatFailure.unknown(),
      );
    } finally {
      await _stopChatKeepAlive();
    }
  }

  Future<void> stop() async {
    if (!state.isGenerating) return;
    _generation++;
    final partial = state.streamingText.trim();
    final threadId = state.threadId;
    state = state.copyWith(isGenerating: false);
    await _haltGeneration(threadId: threadId, partial: partial);
    if (!ref.mounted) return;
    state = state.copyWith(streamingText: '');
  }

  Future<void> _haltGeneration({
    required String? threadId,
    required String partial,
  }) async {
    try {
      await _ai.stopChat();
    } on Object {
      // Generation may already have finished.
    }
    if (!ref.mounted || threadId == null || partial.isEmpty) return;
    try {
      final sanitizedPartial = stripChatMLTokens(partial);
      if (sanitizedPartial.isEmpty) return;
      await _appendAssistantIfNew(
        threadId: threadId,
        content: sanitizedPartial,
      );
    } on Object {
      // The user already stopped; keep the on-screen halt even if persist fails.
    }
  }

  Future<void> _generateAssistantReply({
    required String threadId,
    required LocalAICopy copy,
    required int generation,
  }) async {
    final history = await _repository.listMessages(threadId);
    if (!ref.mounted || generation != _generation) return;

    final turns = [
      for (final message in history)
        if (message.status == AiChatMessageStatus.complete)
          LocalChatTurn(
            role: message.role == AiChatRole.user
                ? LocalChatRole.user
                : LocalChatRole.assistant,
            content: message.content,
          ),
    ];

    final buffer = StringBuffer();
    final output = await _ai.chat(
      LocalChatRequest(turns: turns, copy: copy),
      onToken: (token) {
        if (!ref.mounted || generation != _generation) return;
        buffer.write(token);
        // Strip ChatML tokens from streaming display
        state = state.copyWith(
          streamingText: stripChatMLTokens(buffer.toString()),
        );
      },
    );

    if (!ref.mounted || generation != _generation) {
      return;
    }

    final sanitizedOutput = stripChatMLTokens(output);
    if (sanitizedOutput.isNotEmpty) {
      await _appendAssistantIfNew(threadId: threadId, content: sanitizedOutput);
      if (!ref.mounted || generation != _generation) return;
      await _notifyReplyReadyIfHidden();
    }
    if (!ref.mounted || generation != _generation) return;
    state = state.copyWith(isGenerating: false, streamingText: '');
  }

  Future<void> _startChatKeepAlive() async {
    ref.read(chatGenerationHoldControllerProvider.notifier).setActive(true);
    if (!ref.mounted) return;
    final l10n = await _appL10n();
    try {
      await ref
          .read(extractionPlatformServiceProvider)
          .startForegroundService(
            l10n.chatProgressNotificationTitle,
            l10n.chatProgressNotificationBody,
            destination: PostSetupHome.chat,
          );
    } on Object {
      // Keep generating even if the keep-alive shade cannot start.
    }
  }

  Future<void> _stopChatKeepAlive() async {
    if (ref.mounted) {
      ref.read(chatGenerationHoldControllerProvider.notifier).setActive(false);
    }
    if (ref.mounted && ref.read(extractionRunningControllerProvider)) {
      return;
    }
    try {
      final transferring = await ref
          .read(modelTransferPlatformServiceProvider)
          .isTransferRunning();
      if (transferring) return;
    } on Object {
      // Fall through and try to dismiss a chat-owned shade.
    }
    if (ref.mounted && ref.read(extractionRunningControllerProvider)) {
      return;
    }
    try {
      await ref.read(extractionPlatformServiceProvider).stopForegroundService();
    } on Object {
      // Shade dismiss is best-effort.
    }
  }

  Future<void> _notifyReplyReadyIfHidden() async {
    if (!ref.mounted) return;
    if (_isChatConversationVisible()) return;
    ref.read(unreadChatCountControllerProvider.notifier).markUnread();
    final l10n = await _appL10n();
    try {
      await ref
          .read(extractionPlatformServiceProvider)
          .showCompletionNotification(
            l10n.chatCompleteNotificationTitle,
            l10n.chatCompleteNotificationBody,
            destination: PostSetupHome.chat,
          );
    } on Object {
      // Completion alert is best-effort.
    }
  }

  bool _isChatConversationVisible() {
    if (!chatLifecycleIsForeground(WidgetsBinding.instance.lifecycleState)) {
      return false;
    }
    return ref.read(chatConversationVisibleControllerProvider);
  }

  Future<AppLocalizations> _appL10n() async {
    final localePreference = await _resolvedLocalePreference();
    return lookupAppLocalizations(
      LocalePreferenceController.effectiveLocale(localePreference),
    );
  }

  /// Prefer the installed GGUF identity over the runtime catalog default.
  ///
  /// [localModelSpecProvider] stays on [LocalModelSpec.production] for on-disk
  /// paths, so [_ai.modelId] is often Qwen even when Dolphin/Llama is loaded.
  Future<String> _resolvedModelId() async {
    try {
      final identity = await ref
          .read(localModelStoreProvider)
          .readInstalledIdentity();
      final id = identity?.modelId.trim();
      if (id != null && id.isNotEmpty) return id;
    } on Object {
      // Identity fetch is best-effort; fall back to the runtime id.
    }
    return _ai.modelId;
  }

  Future<void> _appendAssistantIfNew({
    required String threadId,
    required String content,
  }) async {
    final messages = await _repository.listMessages(threadId);
    if (!ref.mounted) return;
    final last = messages.isEmpty ? null : messages.last;
    if (last != null && last.role == AiChatRole.assistant) {
      return;
    }
    await _repository.appendMessage(
      threadId: threadId,
      role: AiChatRole.assistant,
      content: content,
      status: AiChatMessageStatus.complete,
    );
  }

  ChatFailure _mapLocalAIException(LocalAIException error) =>
      switch (error.code) {
        'invalid-input' => const ChatFailure.invalidInput(),
        'unavailable' => const ChatFailure.modelUnavailable(),
        _ => const ChatFailure.unknown(),
      };
}
