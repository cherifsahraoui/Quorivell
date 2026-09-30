import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quorivell/core/platform/share_intent.dart';
import 'package:quorivell/core/platform/share_intent_service.dart';
import 'package:quorivell/features/meeting_notes/presentation/controllers/incoming_share_controller.dart';
import 'package:quorivell/features/meeting_notes/presentation/widgets/share_intent_host.dart';
import 'package:quorivell/l10n/app_localizations.dart';

class _FakeShareIntentService implements ShareIntentService {
  _FakeShareIntentService({
    this.initial,
    Stream<IncomingSharePayload>? incoming,
  }) : incomingShares = incoming ?? const Stream.empty();

  final IncomingSharePayload? initial;

  @override
  final Stream<IncomingSharePayload> incomingShares;

  @override
  Future<IncomingSharePayload?> consumeInitialShare() async => initial;
}

GoRouter _router() {
  return GoRouter(
    initialLocation: '/ledger',
    routes: [
      GoRoute(
        path: '/ledger',
        builder: (context, state) => const Scaffold(
          body: Stack(children: [Text('ledger'), ShareIntentHost()]),
        ),
      ),
      GoRoute(
        path: '/capture',
        builder: (context, state) => const Scaffold(body: Text('capture')),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const Scaffold(body: Text('chat')),
      ),
    ],
  );
}

Widget _app(GoRouter router) {
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

Future<void> _pumpHost(
  WidgetTester tester, {
  required ShareIntentService service,
  ProviderContainer? container,
}) async {
  final router = _router();
  addTearDown(router.dispose);
  final child = _app(router);
  await tester.pumpWidget(
    container == null
        ? ProviderScope(
            overrides: [shareIntentServiceProvider.overrideWithValue(service)],
            child: child,
          )
        : UncontrolledProviderScope(container: container, child: child),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('opens capture from a cold-start share without saving', (
    tester,
  ) async {
    await _pumpHost(
      tester,
      service: _FakeShareIntentService(
        initial: const IncomingSharePayload(
          id: 1,
          text: 'Shared synthetic conversation.',
        ),
      ),
    );

    expect(find.text('capture'), findsOneWidget);
    expect(find.text('ledger'), findsNothing);
  });

  testWidgets('stays put when the cold-start share is empty', (tester) async {
    await _pumpHost(tester, service: _FakeShareIntentService());

    expect(find.text('ledger'), findsOneWidget);
    expect(find.text('capture'), findsNothing);
  });

  testWidgets('opens capture from a warm-start share', (tester) async {
    final incoming = StreamController<IncomingSharePayload>.broadcast();
    addTearDown(incoming.close);

    await _pumpHost(
      tester,
      service: _FakeShareIntentService(incoming: incoming.stream),
    );
    expect(find.text('ledger'), findsOneWidget);

    incoming.add(
      const IncomingSharePayload(id: 4, text: 'Warm synthetic share.'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('capture'), findsOneWidget);
  });

  testWidgets('opens chat from a PROCESS_TEXT summarize payload', (
    tester,
  ) async {
    await _pumpHost(
      tester,
      service: _FakeShareIntentService(
        initial: const IncomingSharePayload(
          id: 8,
          text: 'Selected synthetic paragraph.',
          kind: IncomingTextKind.processText,
        ),
      ),
    );

    expect(find.text('chat'), findsOneWidget);
    expect(find.text('capture'), findsNothing);
  });

  testWidgets('opens chat from a warm-start PROCESS_TEXT payload', (
    tester,
  ) async {
    final incoming = StreamController<IncomingSharePayload>.broadcast();
    addTearDown(incoming.close);

    await _pumpHost(
      tester,
      service: _FakeShareIntentService(incoming: incoming.stream),
    );
    expect(find.text('ledger'), findsOneWidget);

    incoming.add(
      const IncomingSharePayload(
        id: 5,
        text: 'Warm synthetic selection.',
        kind: IncomingTextKind.processText,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('chat'), findsOneWidget);
    expect(find.text('capture'), findsNothing);
  });

  testWidgets('reopens capture when a pending share already exists', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        shareIntentServiceProvider.overrideWithValue(_FakeShareIntentService()),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(const IncomingSharePayload(id: 9, text: 'Already pending.'));

    await _pumpHost(
      tester,
      service: _FakeShareIntentService(),
      container: container,
    );

    expect(find.text('capture'), findsOneWidget);
  });

  testWidgets('reopens chat when pending PROCESS_TEXT already exists', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        shareIntentServiceProvider.overrideWithValue(_FakeShareIntentService()),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(incomingShareControllerProvider.notifier)
        .offer(
          const IncomingSharePayload(
            id: 10,
            text: 'Already pending selection.',
            kind: IncomingTextKind.processText,
          ),
        );

    await _pumpHost(
      tester,
      service: _FakeShareIntentService(),
      container: container,
    );

    expect(find.text('chat'), findsOneWidget);
    expect(find.text('capture'), findsNothing);
  });
}
