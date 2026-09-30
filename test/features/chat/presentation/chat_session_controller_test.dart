import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/ai/local_ai_service.dart';
import 'package:quorivell/core/ai/local_model_providers.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/ai/local_model_store.dart';
import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/extraction_platform_service.dart';
import 'package:quorivell/features/account/data/providers/debug_ai_settings_providers.dart';
import 'package:quorivell/features/account/data/providers/locale_preference_providers.dart';
import 'package:quorivell/features/account/domain/entities/user_preference.dart';
import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/chat/data/providers/chat_providers.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_message.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_thread.dart';
import 'package:quorivell/features/chat/domain/repositories/chat_repository.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_conversation_visible_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_session_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/unread_chat_count_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

AiChatThread _thread(String id) => AiChatThread(
  id: id,
  userId: 'user-1',
  title: 'synthetic fixture chat',
  modelId: 'test-model',
  createdAt: DateTime.utc(2026, 9, 11),
  updatedAt: DateTime.utc(2026, 9, 11),
);

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository();

  final threads = <AiChatThread>[];
  final messages = <String, List<AiChatMessage>>{};
  var threadSeq = 0;
  var messageSeq = 0;

  @override
  Stream<List<AiChatThread>> watchThreads({int limit = 100, int offset = 0}) =>
      Stream.value(List.of(threads));

  @override
  Stream<AiChatThread?> watchThread(String id) =>
      Stream.value(threads.where((thread) => thread.id == id).firstOrNull);

  @override
  Stream<List<AiChatMessage>> watchMessages(
    String threadId, {
    int limit = 200,
    int offset = 0,
  }) => Stream.value(List.of(messages[threadId] ?? const []));

  @override
  Future<List<AiChatMessage>> listMessages(String threadId) async =>
      List.of(messages[threadId] ?? const []);

  @override
  Future<AiChatThread> createThread({
    required String title,
    String? modelId,
  }) async {
    threadSeq++;
    final thread = _thread(
      'thread-$threadSeq',
    ).copyWith(title: title, modelId: modelId);
    threads.insert(0, thread);
    messages[thread.id] = [];
    return thread;
  }

  @override
  Future<AiChatMessage> appendMessage({
    required String threadId,
    required AiChatRole role,
    required String content,
    AiChatMessageStatus status = AiChatMessageStatus.complete,
    String? modelId,
  }) async {
    messageSeq++;
    final message = AiChatMessage(
      id: 'message-$messageSeq',
      userId: 'user-1',
      threadId: threadId,
      role: role,
      content: content,
      status: status,
      createdAt: DateTime.utc(2026, 9, 11),
      updatedAt: DateTime.utc(2026, 9, 11),
    );
    messages.putIfAbsent(threadId, () => []).add(message);
    if (modelId != null) {
      final index = threads.indexWhere((thread) => thread.id == threadId);
      if (index >= 0) {
        threads[index] = threads[index].copyWith(modelId: modelId);
      }
    }
    return message;
  }

  @override
  Future<void> updateThreadModelId({
    required String threadId,
    required String? modelId,
  }) async {
    final index = threads.indexWhere((thread) => thread.id == threadId);
    if (index >= 0) {
      threads[index] = threads[index].copyWith(modelId: modelId);
    }
  }

  @override
  Future<void> deleteThread(String id) async {
    threads.removeWhere((thread) => thread.id == id);
    messages.remove(id);
  }
}

class _FakeLocalAIService implements LocalAIService {
  _FakeLocalAIService({this.exception, this.hold, this.modelId = 'test-model'});

  final String reply = 'Hello from the model.';
  LocalAIException? exception;
  final Completer<void>? hold;
  LocalChatRequest? lastRequest;
  var stopChatCalls = 0;

  @override
  String modelId;

  @override
  int get maxInputCharacters => LocalAIRequest.maxInputCharacters;

  @override
  Future<bool> isAvailable() async => exception?.code != 'unavailable';

  @override
  Future<LocalAIResponse> extract(LocalAIRequest request) async =>
      const LocalAIResponse(modelId: 'test-model', candidates: []);

  @override
  Future<LocalAIResponse> extractChunked(
    LocalAIRequest request, {
    void Function(ExtractionChunkResult chunk)? onChunk,
    int skipChunks = 0,
  }) async => const LocalAIResponse(modelId: 'test-model', candidates: []);

  @override
  Future<String> chat(
    LocalChatRequest request, {
    void Function(String token)? onToken,
  }) async {
    lastRequest = request;
    if (exception != null) throw exception!;
    onToken?.call('Partial.');
    if (hold != null) {
      await hold!.future;
      return 'Partial.';
    }
    onToken?.call(reply);
    return reply;
  }

  @override
  Future<void> stopChat() async {
    stopChatCalls++;
    if (hold != null && !hold!.isCompleted) {
      hold!.complete();
    }
  }

  @override
  void prepareExtraction() {}

  @override
  Future<void> cancelExtraction() async {}

  @override
  Future<void> dispose() async {}
}

class _DisabledDebugAiSettings extends DebugAiSettingsController {
  @override
  Future<UserPreference?> build() async => null;
}

class _SystemLocalePreference extends LocalePreferenceController {
  @override
  Future<AppLocalePreference> build() async => AppLocalePreference.en;
}

class _GermanLocalePreference extends LocalePreferenceController {
  @override
  Future<AppLocalePreference> build() async => AppLocalePreference.de;
}

class _HiddenChatConversation extends ChatConversationVisibleController {
  @override
  bool build() => false;
}

class _RecordingExtractionPlatformService implements ExtractionPlatformService {
  final starts = <(String title, String body, String destination)>[];
  final completions = <(String title, String body, String destination)>[];
  var stopCount = 0;

  @override
  Future<void> startForegroundService(
    String title,
    String body, {
    String destination = '',
  }) async {
    starts.add((title, body, destination));
  }

  @override
  Future<void> updateForegroundServiceProgress({
    required int current,
    required int total,
    String? title,
    String? body,
  }) async {}

  @override
  Future<void> stopForegroundService() async {
    stopCount++;
  }

  @override
  Future<void> showCompletionNotification(
    String title,
    String body, {
    String destination = '',
  }) async {
    completions.add((title, body, destination));
  }

  @override
  Future<String?> consumeLaunchDestination() async => null;

  @override
  Stream<String> get launchDestinations => const Stream.empty();

  @override
  Future<bool> isForegroundServiceRunning() async => starts.length > stopCount;
}

class _IdentityStore extends LocalModelStore {
  _IdentityStore(this.identity)
    : super(resolveDocumentsDirectory: () async => Directory.systemTemp);

  final InstalledLocalModelIdentity? identity;

  @override
  Future<InstalledLocalModelIdentity?> readInstalledIdentity() async =>
      identity;
}

ProviderContainer _container({
  required ChatRepository repository,
  required LocalAIService ai,
  ExtractionPlatformService? platform,
  LocalModelStore? modelStore,
  bool chatVisible = true,
  LocalePreferenceController Function()? localePreference,
}) {
  return ProviderContainer(
    overrides: [
      chatRepositoryProvider.overrideWithValue(repository),
      localAIServiceProvider.overrideWithValue(ai),
      localModelStoreProvider.overrideWithValue(
        modelStore ?? _IdentityStore(null),
      ),
      debugAiSettingsControllerProvider.overrideWith(
        _DisabledDebugAiSettings.new,
      ),
      localePreferenceControllerProvider.overrideWith(
        localePreference ?? _SystemLocalePreference.new,
      ),
      if (platform != null)
        extractionPlatformServiceProvider.overrideWithValue(platform),
      if (!chatVisible)
        chatConversationVisibleControllerProvider.overrideWith(
          _HiddenChatConversation.new,
        ),
    ],
  );
}

Future<void> _waitUntil(bool Function() condition, {int maxTurns = 40}) async {
  for (var i = 0; i < maxTurns; i++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  expect(condition(), isTrue);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'send creates a thread, stores both turns, and clears generating',
    () async {
      final repository = _FakeChatRepository();
      final ai = _FakeLocalAIService();
      final container = _container(repository: repository, ai: ai);
      addTearDown(container.dispose);

      await container
          .read(chatSessionControllerProvider.notifier)
          .send('Say hello.');

      final state = container.read(chatSessionControllerProvider);
      expect(state.isGenerating, isFalse);
      expect(state.sendFailure, isNull);
      expect(state.threadId, 'thread-1');
      expect(repository.messages['thread-1'], hasLength(2));
      expect(repository.messages['thread-1']!.first.role, AiChatRole.user);
      expect(repository.messages['thread-1']!.last.role, AiChatRole.assistant);
      expect(ai.lastRequest, isNotNull);
    },
  );

  test('send on an existing thread updates the recorded model', () async {
    final repository = _FakeChatRepository();
    final thread = await repository.createThread(
      title: 'synthetic fixture chat',
      modelId: 'old-model',
    );
    final ai = _FakeLocalAIService(modelId: 'new-model');
    final container = _container(repository: repository, ai: ai);
    addTearDown(container.dispose);

    container
        .read(chatSessionControllerProvider.notifier)
        .openThread(thread.id);
    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Follow-up with the new model.');

    expect(repository.threads.single.modelId, 'new-model');
  });

  test(
    'send records installed identity, not the production runtime modelId',
    () async {
      final repository = _FakeChatRepository();
      final ai = _FakeLocalAIService(
        modelId: LocalModelSpec.production.modelId,
      );
      final container = _container(
        repository: repository,
        ai: ai,
        modelStore: _IdentityStore(
          const InstalledLocalModelIdentity(
            modelId: 'Dolphin3.0-Qwen2.5-1.5B-Q4_K_M',
            fileName: 'Dolphin3.0-Qwen2.5-1.5B.Q4_K_M.gguf',
            checksumVerified: false,
          ),
        ),
      );
      addTearDown(container.dispose);

      await container
          .read(chatSessionControllerProvider.notifier)
          .send('Say hello.');

      expect(
        repository.threads.single.modelId,
        'Dolphin3.0-Qwen2.5-1.5B-Q4_K_M',
      );
    },
  );

  test(
    'sendSummarizeSelection opens a new thread with the proofread prompt',
    () async {
      final repository = _FakeChatRepository();
      final ai = _FakeLocalAIService();
      final container = _container(repository: repository, ai: ai);
      addTearDown(container.dispose);

      const selected = 'Alex will send the checklist.';
      await container
          .read(chatSessionControllerProvider.notifier)
          .sendSummarizeSelection(selected);

      expect(repository.threads, hasLength(1));
      expect(repository.threads.single.title, selected);
      final userTurn = repository.messages[repository.threads.single.id]!.first;
      expect(userTurn.role, AiChatRole.user);
      expect(userTurn.content, contains('do not summarize it again'));
      expect(userTurn.content, contains('already a short summary'));
      expect(userTurn.content, contains(selected));
      expect(
        ai.lastRequest!.turns.last.content,
        contains('Only correct spelling, grammar'),
      );
    },
  );

  test('unavailable model becomes a typed chat failure', () async {
    final repository = _FakeChatRepository();
    final ai = _FakeLocalAIService(
      exception: const LocalAIException('unavailable', 'missing'),
    );
    final container = _container(repository: repository, ai: ai);
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');

    final state = container.read(chatSessionControllerProvider);
    expect(state.sendFailure, isA<ChatModelUnavailableFailure>());
    expect(state.isGenerating, isFalse);
  });

  test('stop keeps the partial assistant reply', () async {
    final repository = _FakeChatRepository();
    final hold = Completer<void>();
    final ai = _FakeLocalAIService(hold: hold);
    final container = _container(repository: repository, ai: ai);
    addTearDown(container.dispose);

    final sendFuture = container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');
    await _waitUntil(
      () =>
          container.read(chatSessionControllerProvider).streamingText ==
          'Partial.',
    );
    expect(container.read(chatSessionControllerProvider).isGenerating, isTrue);

    await container.read(chatSessionControllerProvider.notifier).stop();
    await sendFuture;

    final state = container.read(chatSessionControllerProvider);
    expect(state.isGenerating, isFalse);
    expect(ai.stopChatCalls, 1);
    final stored = repository.messages['thread-1']!;
    expect(stored, hasLength(2));
    expect(stored.last.role, AiChatRole.assistant);
    expect(stored.last.content, 'Partial.');
  });

  test('startNewChat during generation keeps the partial reply', () async {
    final repository = _FakeChatRepository();
    final hold = Completer<void>();
    final ai = _FakeLocalAIService(hold: hold);
    final container = _container(repository: repository, ai: ai);
    addTearDown(container.dispose);

    final sendFuture = container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');
    await _waitUntil(
      () =>
          container.read(chatSessionControllerProvider).streamingText ==
          'Partial.',
    );
    await container.read(chatSessionControllerProvider.notifier).startNewChat();
    await sendFuture;

    final state = container.read(chatSessionControllerProvider);
    expect(state.draftNew, isTrue);
    expect(state.threadId, isNull);
    expect(ai.stopChatCalls, 1);
    final stored = repository.messages['thread-1']!;
    expect(stored.last.role, AiChatRole.assistant);
    expect(stored.last.content, 'Partial.');
  });

  test('startNewChat does not restore a previous thread', () async {
    final repository = _FakeChatRepository();
    await repository.createThread(title: 'synthetic fixture chat');
    final container = _container(
      repository: repository,
      ai: _FakeLocalAIService(),
    );
    addTearDown(container.dispose);

    final notifier = container.read(chatSessionControllerProvider.notifier);
    notifier.openThread('thread-1');
    expect(container.read(chatSessionControllerProvider).threadId, 'thread-1');
    notifier.startNewChat();
    final state = container.read(chatSessionControllerProvider);
    expect(state.draftNew, isTrue);
    expect(state.threadId, isNull);
  });

  test('auto-scroll preference survives starting a new chat', () async {
    final container = _container(
      repository: _FakeChatRepository(),
      ai: _FakeLocalAIService(),
    );
    addTearDown(container.dispose);

    final notifier = container.read(chatSessionControllerProvider.notifier);
    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isTrue,
    );
    notifier.toggleAutoScroll();
    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isFalse,
    );
    notifier.startNewChat();
    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isFalse,
    );
  });

  test('retry after a completed reply does not generate again', () async {
    final repository = _FakeChatRepository();
    final ai = _FakeLocalAIService();
    final container = _container(repository: repository, ai: ai);
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');
    await container.read(chatSessionControllerProvider.notifier).retry();

    expect(repository.messages['thread-1'], hasLength(2));
    expect(ai.lastRequest, isNotNull);
  });

  test(
    'retry after a model failure generates a single assistant reply',
    () async {
      final repository = _FakeChatRepository();
      final failing = _FakeLocalAIService(
        exception: const LocalAIException('unavailable', 'missing'),
      );
      final container = _container(repository: repository, ai: failing);
      addTearDown(container.dispose);

      await container
          .read(chatSessionControllerProvider.notifier)
          .send('Say hello.');
      expect(
        container.read(chatSessionControllerProvider).sendFailure,
        isA<ChatModelUnavailableFailure>(),
      );
      expect(repository.messages['thread-1'], hasLength(1));

      failing.exception = null;
      await container.read(chatSessionControllerProvider.notifier).retry();

      expect(container.read(chatSessionControllerProvider).sendFailure, isNull);
      expect(repository.messages['thread-1'], hasLength(2));
      expect(repository.messages['thread-1']!.last.role, AiChatRole.assistant);
    },
  );

  test('does not notify when chat is visible', () async {
    final platform = _RecordingExtractionPlatformService();
    final container = _container(
      repository: _FakeChatRepository(),
      ai: _FakeLocalAIService(),
      platform: platform,
    );
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');

    expect(platform.starts, isNotEmpty);
    expect(platform.starts.single.$3, '/chat');
    expect(platform.completions, isEmpty);
    expect(platform.stopCount, 1);
    expect(container.read(unreadChatCountControllerProvider), 0);
  });

  test('does not notify when chat is visible while inactive', () async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    addTearDown(
      () => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed),
    );

    final platform = _RecordingExtractionPlatformService();
    final container = _container(
      repository: _FakeChatRepository(),
      ai: _FakeLocalAIService(),
      platform: platform,
    );
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');

    expect(platform.completions, isEmpty);
    expect(container.read(unreadChatCountControllerProvider), 0);
  });

  test('notifies when a reply finishes after the app is paused', () async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    addTearDown(
      () => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed),
    );

    final platform = _RecordingExtractionPlatformService();
    final container = _container(
      repository: _FakeChatRepository(),
      ai: _FakeLocalAIService(),
      platform: platform,
    );
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');

    expect(platform.completions, hasLength(1));
    expect(container.read(unreadChatCountControllerProvider), 1);
  });

  test(
    'notifies with generic copy when a reply finishes while chat is hidden',
    () async {
      final platform = _RecordingExtractionPlatformService();
      final l10n = lookupAppLocalizations(const Locale('en'));
      final container = _container(
        repository: _FakeChatRepository(),
        ai: _FakeLocalAIService(),
        platform: platform,
        chatVisible: false,
      );
      addTearDown(container.dispose);

      await container
          .read(chatSessionControllerProvider.notifier)
          .send('Say hello.');

      expect(platform.completions, hasLength(1));
      expect(
        platform.completions.single.$1,
        l10n.chatCompleteNotificationTitle,
      );
      expect(platform.completions.single.$2, l10n.chatCompleteNotificationBody);
      expect(platform.completions.single.$3, '/chat');
      expect(
        platform.completions.single.$2,
        isNot(contains('Hello from the model.')),
      );
      expect(container.read(unreadChatCountControllerProvider), 1);
    },
  );

  test('stop does not send a completion notification', () async {
    final platform = _RecordingExtractionPlatformService();
    final hold = Completer<void>();
    final container = _container(
      repository: _FakeChatRepository(),
      ai: _FakeLocalAIService(hold: hold),
      platform: platform,
      chatVisible: false,
    );
    addTearDown(container.dispose);

    final sendFuture = container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');
    await _waitUntil(
      () =>
          container.read(chatSessionControllerProvider).streamingText ==
          'Partial.',
    );
    await container.read(chatSessionControllerProvider.notifier).stop();
    await sendFuture;

    expect(platform.completions, isEmpty);
    expect(platform.stopCount, 1);
    expect(container.read(unreadChatCountControllerProvider), 0);
  });

  test('chat prompts follow the account locale preference', () async {
    final ai = _FakeLocalAIService();
    final container = _container(
      repository: _FakeChatRepository(),
      ai: ai,
      localePreference: _GermanLocalePreference.new,
    );
    addTearDown(container.dispose);

    await container
        .read(chatSessionControllerProvider.notifier)
        .send('Say hello.');

    expect(ai.lastRequest, isNotNull);
    expect(ai.lastRequest!.copy.languageCode, 'de');
    expect(
      ai.lastRequest!.copy.chatSystemInstruction,
      contains('Assistent auf dem Gerät'),
    );
  });

  test(
    'completion notification copy follows the account locale preference',
    () async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      addTearDown(
        () => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed),
      );

      final platform = _RecordingExtractionPlatformService();
      final l10n = lookupAppLocalizations(const Locale('de'));
      final container = _container(
        repository: _FakeChatRepository(),
        ai: _FakeLocalAIService(),
        platform: platform,
        localePreference: _GermanLocalePreference.new,
      );
      addTearDown(container.dispose);

      await container
          .read(chatSessionControllerProvider.notifier)
          .send('Say hello.');

      expect(platform.completions, hasLength(1));
      expect(
        platform.completions.single.$1,
        l10n.chatCompleteNotificationTitle,
      );
      expect(platform.completions.single.$2, l10n.chatCompleteNotificationBody);
      expect(container.read(unreadChatCountControllerProvider), 1);
    },
  );
}
