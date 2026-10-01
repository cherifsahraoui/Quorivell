import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/meeting_notes/data/providers/source_conversation_providers.dart';
import 'package:quorivell/features/meeting_notes/domain/entities/source_conversation.dart';
import 'package:quorivell/features/meeting_notes/domain/repositories/source_conversation_repository.dart';
import 'package:quorivell/features/meeting_notes/presentation/pages/conversation_detail_page.dart';
import 'package:quorivell/l10n/app_localizations.dart';

import '../../../helpers/layout_overflow.dart';

class _FakeSourceConversationRepository
    implements SourceConversationRepository {
  _FakeSourceConversationRepository(this.conversation);

  final SourceConversation? conversation;

  @override
  Future<SourceConversation> capture(
    String content, {
    String? sourceUrl,
  }) async => throw UnimplementedError();

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
  }) => Stream.value(const []);

  @override
  Future<SourceConversation?> find(String id) async =>
      conversation?.id == id ? conversation : null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> archive(String id) async {}

  @override
  Future<void> unarchive(String id) async {}
}

void main() {
  final websiteConversation = SourceConversation(
    id: 'source-web',
    userId: 'user-id',
    content: 'Fetched article body about the roadmap.',
    sourceUrl: 'https://example.com/article',
    sourceRevision: 1,
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 1),
    isArchived: true,
  );

  testWidgets('shows website origin for webpage captures', (tester) async {
    await expectNoLayoutOverflow(() async {
      tester.view.physicalSize = const Size(390, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sourceConversationRepositoryProvider.overrideWithValue(
              _FakeSourceConversationRepository(websiteConversation),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ConversationDetailPage(sourceId: 'source-web'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('From website'), findsOneWidget);
      expect(find.text('https://example.com/article'), findsOneWidget);
      expect(find.text('Open page'), findsOneWidget);
      expect(
        find.text('Fetched article body about the roadmap.'),
        findsOneWidget,
      );
    });
  });
}
