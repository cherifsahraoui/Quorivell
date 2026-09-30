import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/error/failures.dart';
import 'package:quorivell/features/chat/data/providers/chat_providers.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_message.dart';
import 'package:quorivell/features/chat/domain/entities/ai_chat_thread.dart';
import 'package:quorivell/features/chat/domain/repositories/chat_repository.dart';
import 'package:quorivell/features/chat/presentation/pages/chat_history_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

AiChatThread _thread() => AiChatThread(
  id: 'thread-1',
  userId: 'user-1',
  title: 'synthetic fixture chat',
  modelId: 'test-model',
  createdAt: DateTime.utc(2026, 9, 11),
  updatedAt: DateTime.utc(2026, 9, 11, 9),
);

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository({Stream<List<AiChatThread>>? threads})
    : _threads = threads ?? Stream.value(const []);

  final Stream<List<AiChatThread>> _threads;
  final deletedIds = <String>[];

  @override
  Stream<List<AiChatThread>> watchThreads({int limit = 100, int offset = 0}) =>
      _threads;

  @override
  Stream<AiChatThread?> watchThread(String id) => Stream.value(null);

  @override
  Stream<List<AiChatMessage>> watchMessages(
    String threadId, {
    int limit = 200,
    int offset = 0,
  }) => Stream.value(const []);

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
  }) async => throw UnimplementedError();

  @override
  Future<void> updateThreadModelId({
    required String threadId,
    required String? modelId,
  }) async {}

  @override
  Future<void> deleteThread(String id) async {
    deletedIds.add(id);
  }
}

Future<void> _pumpHistory(
  WidgetTester tester, {
  required ChatRepository repository,
}) {
  tester.view.physicalSize = const Size(400, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    ProviderScope(
      overrides: [chatRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatHistoryPage(),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the empty history state', (tester) async {
    await _pumpHistory(tester, repository: _FakeChatRepository());
    await tester.pump();

    expect(find.text('No chats yet.'), findsOneWidget);
  });

  testWidgets('shows a loading indicator', (tester) async {
    final controller = StreamController<List<AiChatThread>>();
    addTearDown(controller.close);

    await _pumpHistory(
      tester,
      repository: _FakeChatRepository(threads: controller.stream),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('shows an error when history cannot load', (tester) async {
    await _pumpHistory(
      tester,
      repository: _FakeChatRepository(
        threads: Stream<List<AiChatThread>>.error(
          const LocalPersistenceFailure.readFailed(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chat history is unavailable.'), findsOneWidget);
  });

  testWidgets('renders saved chat threads', (tester) async {
    await _pumpHistory(
      tester,
      repository: _FakeChatRepository(threads: Stream.value([_thread()])),
    );
    await tester.pump();

    expect(find.text('synthetic fixture chat'), findsOneWidget);
    expect(find.text('test-model'), findsOneWidget);
  });

  testWidgets('enters selection mode and bulk-deletes after confirm', (
    tester,
  ) async {
    final repo = _FakeChatRepository(
      threads: Stream.value([
        _thread(),
        AiChatThread(
          id: 'thread-2',
          userId: 'user-1',
          title: 'second fixture chat',
          modelId: 'test-model',
          createdAt: DateTime.utc(2026, 9, 12),
          updatedAt: DateTime.utc(2026, 9, 12, 9),
        ),
      ]),
    );
    await _pumpHistory(tester, repository: repo);
    await tester.pump();

    await tester.tap(find.byTooltip('Select items'));
    await tester.pump();

    expect(find.text('Select items'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.byTooltip('Delete selected'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(2));
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byTooltip('Select all'));
    await tester.pump();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pump();
    expect(find.text('Delete 2 chats?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(repo.deletedIds, ['thread-1', 'thread-2']);
    expect(find.byTooltip('Select items'), findsNothing);
  });
}
