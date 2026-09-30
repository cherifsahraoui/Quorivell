import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/layout/app_breakpoints.dart';
import 'package:quorivell/core/routing/app_shell.dart';
import 'package:quorivell/features/assistant/presentation/controllers/review_controller.dart';
import 'package:quorivell/features/chat/presentation/controllers/unread_chat_count_controller.dart';
import 'package:quorivell/l10n/app_localizations.dart';

void main() {
  Future<GoRouter> pumpShell(
    WidgetTester tester, {
    required Size size,
    int pendingReviewCount = 0,
    int unreadChatCount = 0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/capture',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            for (final path in [
              '/capture',
              '/review',
              '/ledger',
              '/chat',
              '/account',
            ])
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: path,
                    builder: (context, state) => Scaffold(
                      body: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('body-$path'),
                      ),
                    ),
                    routes: [
                      if (path == '/account')
                        GoRoute(
                          path: 'preferences',
                          builder: (context, state) => const Scaffold(
                            body: Text('body-/account/preferences'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pendingReviewCountProvider.overrideWithValue(pendingReviewCount),
          unreadChatCountControllerProvider.overrideWithValue(unreadChatCount),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('window size classes map phone / 7in / 10in widths', () {
    expect(appWindowSizeForWidth(390), AppWindowSize.compact);
    expect(appWindowSizeForWidth(600), AppWindowSize.medium);
    expect(appWindowSizeForWidth(720), AppWindowSize.medium);
    expect(appWindowSizeForWidth(840), AppWindowSize.expanded);
    expect(appWindowSizeForWidth(1280), AppWindowSize.expanded);
  });

  testWidgets('phone bottom nav order is Capture Review Ledger Chat Account', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('body-/capture'), findsOneWidget);

    // Side destinations show labels; center Ledger is icon-only (semantics).
    expect(find.text('Capture'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Ledger'), findsNothing);
    expect(find.bySemanticsLabel('Ledger'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    expect(AppShell.ledgerBranchIndex, 2);
    expect(AppShell.reviewBranchIndex, 1);
  });

  testWidgets('phone center control is Ledger and opens the ledger branch', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    expect(find.text('body-/capture'), findsOneWidget);
    expect(find.bySemanticsLabel('Ledger'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Ledger'));
    await tester.pumpAndSettle();
    expect(find.text('body-/ledger'), findsOneWidget);
  });

  testWidgets('from Review, raised Ledger FAB top remains tappable over body', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('body-/review'), findsOneWidget);

    final ledgerRect = tester.getRect(find.bySemanticsLabel('Ledger'));
    // Upper half paints over the Review body; it must still receive the tap.
    await tester.tapAt(Offset(ledgerRect.center.dx, ledgerRect.top + 8));
    await tester.pumpAndSettle();
    expect(find.text('body-/ledger'), findsOneWidget);
  });

  testWidgets('phone Capture lays body clear of the raised Ledger control', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    final bodyRect = tester.getRect(find.text('body-/capture'));
    final ledgerRect = tester.getRect(find.bySemanticsLabel('Ledger'));
    expect(bodyRect.bottom, lessThanOrEqualTo(ledgerRect.top));
  });

  testWidgets('phone Review lets body extend under the raised Ledger FAB', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    final captureBottom = tester.getRect(find.text('body-/capture')).bottom;

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    final reviewBottom = tester.getRect(find.text('body-/review')).bottom;
    final ledgerTop = tester.getRect(find.bySemanticsLabel('Ledger')).top;

    expect(reviewBottom, greaterThan(captureBottom));
    expect(reviewBottom, greaterThan(ledgerTop));
  });

  testWidgets('phone Account lets body extend under the raised Ledger FAB', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    final captureBottom = tester.getRect(find.text('body-/capture')).bottom;

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    final accountBottom = tester.getRect(find.text('body-/account')).bottom;
    final ledgerTop = tester.getRect(find.bySemanticsLabel('Ledger')).top;

    expect(accountBottom, greaterThan(captureBottom));
    expect(accountBottom, greaterThan(ledgerTop));
  });

  testWidgets('phone Ledger lets body extend under the raised Ledger FAB', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    final captureBottom = tester.getRect(find.text('body-/capture')).bottom;

    await tester.tap(find.bySemanticsLabel('Ledger'));
    await tester.pumpAndSettle();

    final ledgerBodyBottom = tester.getRect(find.text('body-/ledger')).bottom;
    final ledgerTop = tester.getRect(find.bySemanticsLabel('Ledger')).top;

    expect(ledgerBodyBottom, greaterThan(captureBottom));
    expect(ledgerBodyBottom, greaterThan(ledgerTop));
  });

  testWidgets('phone Chat lays body clear of the raised Ledger control', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    final bodyRect = tester.getRect(find.text('body-/chat'));
    final ledgerRect = tester.getRect(find.bySemanticsLabel('Ledger'));
    expect(bodyRect.bottom, lessThanOrEqualTo(ledgerRect.top));
  });

  testWidgets('phone Chat is a side destination', (tester) async {
    await pumpShell(tester, size: const Size(390, 844));

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('body-/chat'), findsOneWidget);
  });

  testWidgets('re-entering a tab resets nested routes to the branch root', (
    tester,
  ) async {
    final router = await pumpShell(tester, size: const Size(390, 844));

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('body-/account'), findsOneWidget);

    router.go('/account/preferences');
    await tester.pumpAndSettle();
    expect(find.text('body-/account/preferences'), findsOneWidget);

    await tester.tap(find.text('Capture'));
    await tester.pumpAndSettle();
    expect(find.text('body-/capture'), findsOneWidget);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('body-/account'), findsOneWidget);
    expect(find.text('body-/account/preferences'), findsNothing);
  });

  testWidgets('Review tab shows a badge when pending count is greater than 0', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844), pendingReviewCount: 3);

    expect(find.byType(Badge), findsWidgets);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Review tab hides the badge when pending count is 0', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844), pendingReviewCount: 0);

    expect(find.text('3'), findsNothing);
    expect(find.text('9+'), findsNothing);
    final badges = tester.widgetList<Badge>(find.byType(Badge));
    expect(badges.every((badge) => !badge.isLabelVisible), isTrue);
  });

  testWidgets('Review tab badge caps at 9+', (tester) async {
    await pumpShell(tester, size: const Size(390, 844), pendingReviewCount: 12);

    expect(find.text('9+'), findsOneWidget);
  });

  testWidgets('Chat tab shows a badge when unread count is greater than 0', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844), unreadChatCount: 1);

    expect(find.byType(Badge), findsWidgets);
    expect(find.text('1'), findsOneWidget);
    expect(find.bySemanticsLabel('Chat, 1 unread'), findsOneWidget);
  });

  testWidgets('Chat tab hides the badge when unread count is 0', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(390, 844));

    expect(find.text('1'), findsNothing);
    expect(find.bySemanticsLabel('Chat'), findsOneWidget);
  });

  testWidgets('7-inch tablet uses NavigationRail', (tester) async {
    // ~7" portrait logical size
    await pumpShell(tester, size: const Size(600, 960));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('10-inch tablet Review rail shows pending badge', (tester) async {
    // ~10" portrait logical size
    await pumpShell(tester, size: const Size(900, 1280), pendingReviewCount: 2);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('body-/review'), findsOneWidget);
  });
}
