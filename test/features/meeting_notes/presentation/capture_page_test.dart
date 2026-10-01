import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/core/platform/share_intent.dart';
import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/features/meeting_notes/presentation/controllers/incoming_share_controller.dart';
import 'package:quorivell/features/meeting_notes/presentation/pages/capture_page.dart';
import 'package:quorivell/features/onboarding/presentation/controllers/local_model_install_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => const Scaffold(body: Text('review')),
      ),
      GoRoute(
        path: '/account/model',
        builder: (context, state) =>
            const Scaffold(body: Text('model-details')),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository({this.pending});

  final Completer<SourceConversation>? pending;
  String? capturedContent;

  String? capturedSourceUrl;

  @override
  Future<SourceConversation> capture(
    String content, {
    String? sourceUrl,
  }) async {
    if (pending != null) return pending!.future;
    if (content.trim().isEmpty) {
      throw const LocalPersistenceFailure.invalidInput();
    }
    capturedContent = content;
    capturedSourceUrl = sourceUrl;
    return SourceConversation(
      id: 'source-id',
      userId: 'user-id',
      content: content.trim(),
      sourceUrl: sourceUrl,
      sourceRevision: 1,
      createdAt: DateTime.utc(2026, 9, 7),
      updatedAt: DateTime.utc(2026, 9, 7),
    );
  }

  @override
  Future<SourceConversation?> latest() async => null;

  @override
  Future<List<SourceConversation>> listActive({
    int? limit,
    bool newestFirst = true,
  }) async => const [];

  @override
  Stream<List<SourceConversation>> watchAll({
    int limit = 50,
    int offset = 0,
    bool archivedOnly = false,
  }) => const Stream.empty();

  @override
  Future<SourceConversation?> find(String id) async => null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> archive(String id) async {}

  @override
  Future<void> unarchive(String id) async {}
}

class _MissingInstallController extends LocalModelInstallController {
  @override
  Future<LocalModelInstallSnapshot> build() async {
    return const LocalModelInstallSnapshot(isReady: false);
  }
}

Future<void> _pumpCapturePage(
  WidgetTester tester, {
  required SourceConversationRepository conversations,
  LocalModelInstallController? install,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(conversations),
        if (install != null)
          localModelInstallControllerProvider.overrideWith(() => install),
      ],
      child: _wrap(const CapturePage()),
    ),
  );
}

Finder _conversationField() => find.byType(TextField).at(1);

void main() {
  testWidgets('saves the conversation and opens review without extracting', (
    tester,
  ) async {
    final conversations = _FakeSourceConversationRepository();
    await _pumpCapturePage(tester, conversations: conversations);

    await tester.enterText(_conversationField(), 'Synthetic conversation.');
    await tester.pump();
    await tester.tap(find.text('Save locally'));
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, 'Synthetic conversation.');
    expect(find.text('review'), findsOneWidget);
  });

  testWidgets('shows a saving state while the capture is in flight', (
    tester,
  ) async {
    final pending = Completer<SourceConversation>();
    await _pumpCapturePage(
      tester,
      conversations: _FakeSourceConversationRepository(pending: pending),
    );

    await tester.enterText(_conversationField(), 'Synthetic conversation.');
    await tester.pump();
    await tester.tap(find.text('Save locally'));
    await tester.pump();

    expect(find.text('Saving...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.completeError(const LocalPersistenceFailure.writeFailed());
    await tester.pumpAndSettle();
  });

  testWidgets('disables save when conversation text is empty', (tester) async {
    final conversations = _FakeSourceConversationRepository();
    await _pumpCapturePage(tester, conversations: conversations);

    final save = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save locally'),
    );
    expect(save.onPressed, isNull);

    await tester.tap(find.text('Save locally'));
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, isNull);
    expect(find.text('review'), findsNothing);
  });

  testWidgets('shows a localized message when local storage fails', (
    tester,
  ) async {
    final pending = Completer<SourceConversation>();
    await _pumpCapturePage(
      tester,
      conversations: _FakeSourceConversationRepository(pending: pending),
    );

    await tester.enterText(_conversationField(), 'Synthetic conversation.');
    await tester.pump();
    await tester.tap(find.text('Save locally'));
    await tester.pump();
    pending.completeError(const LocalPersistenceFailure.writeFailed());
    await tester.pumpAndSettle();

    expect(
      find.text('This device could not save or read your local records.'),
      findsOneWidget,
    );
    expect(find.text('review'), findsNothing);
  });

  testWidgets('opens a privacy dialog from the private-by-default callout', (
    tester,
  ) async {
    final conversations = _FakeSourceConversationRepository();
    await _pumpCapturePage(tester, conversations: conversations);

    await tester.tap(find.text('Private by default'));
    await tester.pumpAndSettle();

    expect(find.textContaining('uses on-device AI by default'), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(find.text('Got it'), findsNothing);
  });

  testWidgets('saves even when no on-device model is configured', (
    tester,
  ) async {
    final conversations = _FakeSourceConversationRepository();
    await _pumpCapturePage(
      tester,
      conversations: conversations,
      install: _MissingInstallController(),
    );

    await tester.enterText(_conversationField(), 'Synthetic conversation.');
    await tester.pump();
    await tester.tap(find.text('Save locally'));
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, 'Synthetic conversation.');
    expect(find.text('review'), findsOneWidget);
    expect(find.text('Configure the on-device model'), findsNothing);
  });

  testWidgets('prefills shared text and discards without saving', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;

    final conversations = _FakeSourceConversationRepository();
    final container = ProviderContainer(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(conversations),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(
          const IncomingSharePayload(
            id: 11,
            text: 'Shared synthetic conversation.',
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _wrap(const CapturePage()),
      ),
    );
    await tester.pump();

    expect(find.text('Shared text ready to save'), findsOneWidget);
    expect(
      tester.widget<TextField>(_conversationField()).controller?.text,
      'Shared synthetic conversation.',
    );
    expect(
      tester.getSize(find.widgetWithText(OutlinedButton, 'Discard')).height,
      greaterThanOrEqualTo(48),
    );

    await tester.tap(find.text('Discard'));
    await tester.pump();

    expect(conversations.capturedContent, isNull);
    expect(find.text('Shared text ready to save'), findsNothing);
    expect(find.text('review'), findsNothing);
    expect(
      tester.widget<TextField>(_conversationField()).controller?.text,
      isEmpty,
    );
  });

  testWidgets('does not treat PROCESS_TEXT as a capture share', (tester) async {
    final conversations = _FakeSourceConversationRepository();
    final container = ProviderContainer(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(conversations),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(
          const IncomingSharePayload(
            id: 21,
            text: 'Selected synthetic conversation.',
            kind: IncomingTextKind.processText,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _wrap(const CapturePage()),
      ),
    );
    await tester.pump();

    expect(find.text('Shared text ready to save'), findsNothing);
    expect(
      tester.widget<TextField>(_conversationField()).controller?.text,
      isEmpty,
    );
  });

  testWidgets('saves shared text locally without extracting', (tester) async {
    final conversations = _FakeSourceConversationRepository();
    final container = ProviderContainer(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(conversations),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(
          const IncomingSharePayload(
            id: 12,
            text: 'Shared synthetic conversation.',
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _wrap(const CapturePage()),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Save locally'));
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, 'Shared synthetic conversation.');
    expect(find.text('review'), findsOneWidget);
    expect(find.text('Shared text ready to save'), findsNothing);
  });

  testWidgets('saves a long shared conversation locally', (tester) async {
    final conversations = _FakeSourceConversationRepository();
    final longText = 'x' * 20000;
    final container = ProviderContainer(
      overrides: [
        sourceConversationRepositoryProvider.overrideWithValue(conversations),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(IncomingSharePayload(id: 13, text: longText));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _wrap(const CapturePage()),
      ),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Save locally'));
    await tester.tap(find.text('Save locally'));
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, longText);
    expect(conversations.capturedContent?.length, 20000);
    expect(find.text('review'), findsOneWidget);
  });

  testWidgets('keeps the save button tappable when the keyboard is open', (
    tester,
  ) async {
    final conversations = _FakeSourceConversationRepository();
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    await _pumpCapturePage(tester, conversations: conversations);
    await tester.enterText(_conversationField(), 'Synthetic conversation.');
    await tester.pump();

    // Soft keyboard shrinks the body; sticky footer must keep Save above it.
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pump();

    final saveButton = find.text('Save locally');
    expect(saveButton, findsOneWidget);
    expect(tester.getRect(saveButton).bottom, lessThanOrEqualTo(844 - 320));

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(conversations.capturedContent, 'Synthetic conversation.');
    expect(find.text('review'), findsOneWidget);
  });
}
