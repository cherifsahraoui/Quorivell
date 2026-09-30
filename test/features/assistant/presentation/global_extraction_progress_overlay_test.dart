import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/features/assistant/data/providers/extraction_providers.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_job.dart';
import 'package:quorivell/features/assistant/domain/entities/extraction_progress.dart';
import 'package:quorivell/features/assistant/domain/entities/review_candidate.dart';
import 'package:quorivell/features/assistant/domain/repositories/extraction_repository.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/assistant/presentation/widgets/global_extraction_progress_overlay.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _FakeExtractionRepository implements ExtractionRepository {
  var cancelCount = 0;

  @override
  Stream<List<ReviewCandidate>> watchPending({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Stream<List<ReviewCandidate>> watchRejected({
    int limit = 100,
    int offset = 0,
  }) => const Stream.empty();

  @override
  Future<List<ReviewCandidate>> extract(String sourceConversationId) async =>
      const [];

  @override
  Stream<ExtractionProgressUpdate> extractChunked(
    String sourceConversationId,
  ) async* {}

  @override
  Future<ExtractionJob?> loadActiveJob() async => null;

  @override
  Future<void> upsertJob(ExtractionJob job) async {}

  @override
  Future<void> clearJob() async {}

  @override
  Future<void> prepareRun() async {}

  @override
  Future<void> cancelActive() async {
    cancelCount += 1;
  }

  @override
  Future<void> updateReview(ReviewCandidate candidate) async {}

  @override
  Future<void> deletePending(String candidateId) async {}
}

Future<void> _pumpOverlay(
  WidgetTester tester, {
  required ProviderContainer container,
}) {
  return tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Stack(children: [GlobalExtractionProgressOverlay()]),
        ),
      ),
    ),
  );
}

void main() {
  const stackHeight = 800.0;
  const minTop = 50.0;
  const spacing = 8.0;
  const fabHeight = 40.0;
  const cardHeight = 200.0;
  const fabBaseTop = 680.0;

  test('expanded card can be dragged until its top sits on minTop', () {
    const cardBaseTop = fabBaseTop + fabHeight - cardHeight;
    final dy = clampExtractionOverlayDragDy(
      next: -1000,
      currentTop: cardBaseTop,
      dragDy: 0,
      childHeight: cardHeight,
      stackHeight: stackHeight,
      minTop: minTop,
      spacing: spacing,
    );

    expect(cardBaseTop + dy, minTop);
  });

  test(
    'minimized FAB cannot be dragged higher than the expanded card fits',
    () {
      final dy = clampExtractionOverlayDragDy(
        next: -1000,
        currentTop: fabBaseTop,
        dragDy: 0,
        childHeight: fabHeight,
        stackHeight: stackHeight,
        minTop: minTop,
        spacing: spacing,
        expandedHeight: cardHeight,
      );

      final fabTop = fabBaseTop + dy;
      final cardTopIfExpanded = fabTop + fabHeight - cardHeight;
      expect(cardTopIfExpanded, minTop);
      expect(dy, greaterThan(minTop - fabBaseTop));
    },
  );

  test('does not drag the overlay down from its resting seat', () {
    final dy = clampExtractionOverlayDragDy(
      next: 80,
      currentTop: fabBaseTop,
      dragDy: 0,
      childHeight: fabHeight,
      stackHeight: stackHeight,
      minTop: minTop,
      spacing: spacing,
      expandedHeight: cardHeight,
    );

    expect(dy, 0);
  });

  testWidgets('stop on the extraction card warns before cancelling', (
    tester,
  ) async {
    final extraction = _FakeExtractionRepository();
    final container = ProviderContainer.test(
      overrides: [extractionRepositoryProvider.overrideWithValue(extraction)],
    );
    addTearDown(container.dispose);
    container.read(extractionRunningControllerProvider.notifier).start();
    container
        .read(extractionProgressControllerProvider.notifier)
        .updateProgress(
          ExtractionProgress(
            currentChunk: 1,
            totalChunks: 3,
            candidatesFound: 1,
            chunkTimings: const [0.2],
            startTime: DateTime.utc(2026, 9, 21),
          ),
        );

    await _pumpOverlay(tester, container: container);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Stop extraction'), findsOneWidget);
    await tester.tap(find.text('Stop extraction'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Stop extraction?'), findsOneWidget);
    await tester.tap(find.text('Keep extracting'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(extraction.cancelCount, 0);

    await tester.tap(find.text('Stop extraction'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Stop').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(extraction.cancelCount, 1);
  });
}
