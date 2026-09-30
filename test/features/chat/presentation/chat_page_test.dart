import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/share_intent.dart';
import 'package:quorivell/features/chat/data/providers/chat_providers.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_message.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_thread.dart';
import 'package:quorivell/features/chat/domain/repositories/chat_repository.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_session_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/chat_session_state.dart';
import 'package:quorivell/features/chat/presentation/pages/chat_page.dart';
import 'package:quorivell/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:quorivell/features/meeting_notes/presentation/controllers/incoming_share_controller.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

AiChatThread _thread() => AiChatThread(
  id: 'thread-1',
  userId: 'user-1',
  title: 'synthetic fixture chat',
  modelId: 'test-model',
  createdAt: DateTime.utc(2026, 9, 11),
  updatedAt: DateTime.utc(2026, 9, 11),
);

AiChatMessage _message(String id, AiChatRole role, String content) =>
    AiChatMessage(
      id: id,
      userId: 'user-1',
      threadId: 'thread-1',
      role: role,
      content: content,
      status: AiChatMessageStatus.complete,
      createdAt: DateTime.utc(2026, 9, 11, 8),
      updatedAt: DateTime.utc(2026, 9, 11, 8),
    );

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository({
    Stream<List<AiChatThread>>? threads,
    Stream<List<AiChatMessage>>? messages,
  }) : _threads = threads ?? Stream.value(const []),
       _messages = messages ?? Stream.value(const []);

  final Stream<List<AiChatThread>> _threads;
  final Stream<List<AiChatMessage>> _messages;

  @override
  Stream<List<AiChatThread>> watchThreads({int limit = 100, int offset = 0}) =>
      _threads;

  @override
  Stream<AiChatThread?> watchThread(String id) =>
      Stream.value(id == 'thread-1' ? _thread() : null);

  @override
  Stream<List<AiChatMessage>> watchMessages(
    String threadId, {
    int limit = 200,
    int offset = 0,
  }) => _messages;

  @override
  Future<List<AiChatMessage>> listMessages(String threadId) async => const [];

  @override
  Future<AiChatThread> createThread({
    required String title,
    String? modelId,
  }) async => _thread();

  @override
  Future<AiChatMessage> appendMessage({
    required String threadId,
    required AiChatRole role,
    required String content,
    AiChatMessageStatus status = AiChatMessageStatus.complete,
    String? modelId,
  }) async => _message('new', role, content);

  @override
  Future<void> updateThreadModelId({
    required String threadId,
    required String? modelId,
  }) async {}

  @override
  Future<void> deleteThread(String id) async {}
}

class _HarnessChatSession extends ChatSessionController {
  @override
  ChatSessionState build() {
    return const ChatSessionState(threadId: 'thread-1', draftNew: false);
  }

  void emitStreaming(String text) {
    state = state.copyWith(isGenerating: true, streamingText: text);
  }
}

class _ReadyInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: true);
  }
}

class _RecordingSummarizeSession extends ChatSessionController {
  String? lastSummarize;

  @override
  ChatSessionState build() => const ChatSessionState();

  @override
  Future<void> sendSummarizeSelection(String selectedText) async {
    lastSummarize = selectedText;
  }
}

List<AiChatMessage> _tallTranscript() {
  return [
    for (var i = 0; i < 16; i++)
      _message(
        'm$i',
        i.isEven ? AiChatRole.user : AiChatRole.assistant,
        i == 0
            ? 'oldest-fixture-turn'
            : 'synthetic fixture paragraph $i\nline two\nline three',
      ),
  ];
}

const _shortStream = 'Hi';
const _tallStream =
    'synthetic fixture reply that wraps across many lines while the '
    'assistant bubble grows so scroll physics can be asserted. '
    'Keep adding words until the height is clearly larger than a single '
    'line of body text on a narrow test viewport. Repeat the padding '
    'words for wrap wrap wrap wrap wrap wrap wrap wrap wrap wrap.';

Future<ProviderContainer> _pumpChatPage(
  WidgetTester tester, {
  required ChatRepository repository,
  String? openThreadId,
  Size viewSize = const Size(400, 1200),
  ChatSessionController? session,
}) async {
  tester.view.physicalSize = viewSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final container = ProviderContainer(
    overrides: [
      chatRepositoryProvider.overrideWithValue(repository),
      if (session != null)
        chatSessionControllerProvider.overrideWith(() => session),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatPage(),
      ),
    ),
  );
  if (openThreadId != null) {
    container
        .read(chatSessionControllerProvider.notifier)
        .openThread(openThreadId);
    await tester.pump();
  }
  return container;
}

void main() {
  testWidgets('shows the empty chat state', (tester) async {
    await _pumpChatPage(tester, repository: _FakeChatRepository());
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
    expect(
      find.textContaining('Answers follow the chat system prompt'),
      findsOneWidget,
    );
    expect(find.text('Open Extraction settings'), findsOneWidget);
    expect(find.text('Write a message'), findsOneWidget);
    expect(
      find.text('Help me phrase a decision from a meeting.'),
      findsOneWidget,
    );
  });

  testWidgets('shows the empty chat state while threads are loading', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      repository: _FakeChatRepository(threads: const Stream.empty()),
    );
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('new chat stays available if the thread list fails', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      repository: _FakeChatRepository(
        threads: Stream<List<AiChatThread>>.error(
          const LocalPersistenceFailure.readFailed(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
  });

  testWidgets('renders persisted chat messages after opening a thread', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value([
          _message('m1', AiChatRole.user, 'Say hello.'),
          _message('m2', AiChatRole.assistant, 'Hello from the model.'),
        ]),
      ),
      openThreadId: 'thread-1',
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Say hello.'), findsOneWidget);
    expect(find.text('Hello from the model.'), findsOneWidget);
    expect(find.text('synthetic fixture chat'), findsOneWidget);
    // Short transcript fits the viewport — auto-scroll toggle stays hidden.
    expect(find.byTooltip('Following latest replies'), findsNothing);
    expect(find.byTooltip('Jump to latest replies'), findsNothing);
  });

  test('pin-to-bottom correction sticks when auto-scroll is on', () {
    expect(
      chatPinToBottomCorrection(
        autoScrollEnabled: true,
        nextMaxScrollExtent: 480,
      ),
      480,
    );
  });

  test('pin-to-bottom correction is a no-op when auto-scroll is off', () {
    expect(
      chatPinToBottomCorrection(
        autoScrollEnabled: false,
        nextMaxScrollExtent: 480,
      ),
      isNull,
    );
  });

  test('pin-to-bottom correction is a no-op while scrolling', () {
    expect(
      chatPinToBottomCorrection(
        autoScrollEnabled: true,
        nextMaxScrollExtent: 480,
        isScrolling: true,
      ),
      isNull,
    );
  });

  test('chat list is near bottom near max scroll extent', () {
    expect(chatListIsNearBottom(pixels: 400, maxScrollExtent: 400), isTrue);
    expect(chatListIsNearBottom(pixels: 0, maxScrollExtent: 400), isFalse);
    expect(chatListIsNearBottom(pixels: 350, maxScrollExtent: 400), isTrue);
    expect(chatListIsNearBottom(pixels: 300, maxScrollExtent: 400), isFalse);
  });

  test('streaming bubble stays up until persisted assistant text matches', () {
    expect(
      chatShouldShowStreamingBubble(
        streamingText: 'Hello from the model.',
        messages: [_message('m1', AiChatRole.user, 'Say hello.')],
      ),
      isTrue,
    );
    expect(
      chatShouldShowStreamingBubble(
        streamingText: 'Hello from the model.',
        messages: [
          _message('m1', AiChatRole.user, 'Say hello.'),
          _message('m2', AiChatRole.assistant, 'Hello from the model.'),
        ],
      ),
      isFalse,
    );
  });

  test('pin-to-bottom physics keeps the newest edge when pinned', () {
    final physics = ChatPinToBottomScrollPhysics(autoScrollEnabled: () => true);
    expect(
      physics.adjustPositionForNewDimensions(
        oldPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 400,
          pixels: 400,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        newPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 480,
          pixels: 400,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        isScrolling: false,
        velocity: 0,
      ),
      480,
    );
  });

  test('pin-to-bottom physics leaves pixels alone when unpinned', () {
    final physics = ChatPinToBottomScrollPhysics(
      autoScrollEnabled: () => false,
    );
    expect(
      physics.adjustPositionForNewDimensions(
        oldPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 400,
          pixels: 120,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        newPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 480,
          pixels: 120,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        isScrolling: false,
        velocity: 0,
      ),
      120,
    );
  });

  test('pin-to-bottom physics leaves pixels alone while scrolling', () {
    final physics = ChatPinToBottomScrollPhysics(autoScrollEnabled: () => true);
    expect(
      physics.adjustPositionForNewDimensions(
        oldPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 400,
          pixels: 200,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        newPosition: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 480,
          pixels: 200,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        isScrolling: true,
        velocity: -200,
      ),
      200,
    );
  });

  testWidgets('system back on a new chat keeps the empty chat screen', (
    tester,
  ) async {
    await _pumpChatPage(tester, repository: _FakeChatRepository());
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
    expect(find.text('Write a message'), findsOneWidget);
  });

  testWidgets('system back from an opened thread starts a new chat', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value([
          _message('m1', AiChatRole.user, 'Say hello.'),
          _message('m2', AiChatRole.assistant, 'Hello from the model.'),
        ]),
      ),
      openThreadId: 'thread-1',
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('synthetic fixture chat'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pump();

    expect(find.text('Ask the on-device model'), findsOneWidget);
    expect(find.text('synthetic fixture chat'), findsNothing);
  });

  testWidgets('streaming bubble keeps a stable width as text grows', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Widget bubble(String text) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ChatStreamingBubble(text: text)),
      );
    }

    await tester.pumpWidget(bubble(_shortStream));
    final shortBox = tester.getSize(
      find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox &&
            widget.constraints.hasTightWidth &&
            widget.constraints.maxWidth == 400 * chatBubbleMaxWidthFactor,
      ),
    );
    expect(shortBox.width, 400 * chatBubbleMaxWidthFactor);

    await tester.pumpWidget(bubble(_tallStream));
    final tallBox = tester.getSize(
      find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox &&
            widget.constraints.hasTightWidth &&
            widget.constraints.maxWidth == 400 * chatBubbleMaxWidthFactor,
      ),
    );
    expect(tallBox.width, shortBox.width);
    expect(tallBox.height, greaterThan(shortBox.height));
  });

  testWidgets('pinned streaming growth stays at the newest edge', (
    tester,
  ) async {
    final harness = _HarnessChatSession();
    await _pumpChatPage(
      tester,
      viewSize: const Size(400, 560),
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value(_tallTranscript()),
      ),
      session: harness,
    );
    await tester.pump();
    await tester.pump();

    final controller = tester
        .widget<ListView>(find.byType(ListView))
        .controller!;
    expect(controller.offset, closeTo(controller.position.maxScrollExtent, 1));

    harness.emitStreaming(_shortStream);
    await tester.pump();
    await tester.pump();
    harness.emitStreaming(_tallStream);
    await tester.pump();
    await tester.pump();

    expect(controller.offset, closeTo(controller.position.maxScrollExtent, 1));
    expect(find.text(_tallStream), findsOneWidget);
    expect(find.text('oldest-fixture-turn'), findsNothing);
    expect(find.byTooltip('Following latest replies'), findsOneWidget);
  });

  testWidgets('streaming growth does not pull a scrolled-up list down', (
    tester,
  ) async {
    final harness = _HarnessChatSession();
    final container = await _pumpChatPage(
      tester,
      viewSize: const Size(400, 560),
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value(_tallTranscript()),
      ),
      session: harness,
    );
    await tester.pump();
    await tester.pump();

    final controller = tester
        .widget<ListView>(find.byType(ListView))
        .controller!;
    expect(controller.position.maxScrollExtent, greaterThan(180));

    // Start streaming while pinned so the bubble exists, then scroll up
    // without pre-disabling auto-scroll — the drag itself must unpin.
    harness.emitStreaming(_shortStream);
    await tester.pump();
    await tester.pump();
    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isTrue,
    );

    // Drag down to reveal older messages (toward offset 0).
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    final offsetAfterScroll = controller.offset;
    expect(
      offsetAfterScroll,
      lessThan(controller.position.maxScrollExtent - chatNearBottomThreshold),
      reason:
          'expected a chronological list drag to leave offset '
          '$offsetAfterScroll below the newest edge',
    );
    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isFalse,
      reason: 'scrolling toward older turns must unpin auto-scroll',
    );

    String? trackedId;
    double? yBefore;
    for (var i = 0; i < 16; i++) {
      final found = find.byKey(ValueKey('m$i'));
      if (found.evaluate().isEmpty) continue;
      final y = tester.getTopLeft(found).dy;
      if (y >= 40 && y <= 420) {
        trackedId = 'm$i';
        yBefore = y;
        break;
      }
    }
    expect(trackedId, isNotNull);

    harness.emitStreaming(_tallStream);
    await tester.pump();
    await tester.pump();

    expect(
      container.read(chatSessionControllerProvider).autoScrollEnabled,
      isFalse,
    );
    expect(controller.offset, closeTo(offsetAfterScroll, 1));
    expect(
      tester.getTopLeft(find.byKey(ValueKey(trackedId!))).dy,
      closeTo(yBefore!, 2),
    );
    expect(find.byTooltip('Jump to latest replies'), findsOneWidget);
  });

  test('chatListIsScrollable is true only when content overflows', () {
    expect(chatListIsScrollable(0), isFalse);
    expect(chatListIsScrollable(-1), isFalse);
    expect(chatListIsScrollable(0.5), isTrue);
  });

  testWidgets('auto-scroll toggle stays hidden when transcript fits', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      viewSize: const Size(400, 800),
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value([
          _message('m1', AiChatRole.user, 'short'),
          _message('m2', AiChatRole.assistant, 'reply'),
        ]),
      ),
      session: _HarnessChatSession(),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('short'), findsOneWidget);
    expect(find.byTooltip('Following latest replies'), findsNothing);
    expect(find.byTooltip('Jump to latest replies'), findsNothing);
  });

  testWidgets('auto-scroll toggle appears when transcript overflows', (
    tester,
  ) async {
    await _pumpChatPage(
      tester,
      viewSize: const Size(400, 560),
      repository: _FakeChatRepository(
        threads: Stream.value([_thread()]),
        messages: Stream.value(_tallTranscript()),
      ),
      session: _HarnessChatSession(),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byTooltip('Following latest replies'), findsOneWidget);
  });

  testWidgets('sends PROCESS_TEXT into chat summarize', (tester) async {
    final session = _RecordingSummarizeSession();
    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(_FakeChatRepository()),
        chatSessionControllerProvider.overrideWith(() => session),
        localModelInstallControllerProvider.overrideWith(
          _ReadyInstallController.new,
        ),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(
          const IncomingSharePayload(
            id: 15,
            text: 'Selected synthetic paragraph.',
            kind: IncomingTextKind.processText,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(session.lastSummarize, 'Selected synthetic paragraph.');
  });
}
