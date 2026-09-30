import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/account/presentation/pages/account_page.dart';
import '../../features/account/presentation/pages/debug_mode_page.dart';
import '../../features/account/presentation/pages/extraction_settings_page.dart';
import '../../features/extraction_kinds/presentation/pages/extraction_kind_edit_page.dart';
import '../../features/extraction_kinds/presentation/pages/extraction_kinds_page.dart';
import '../../features/account/presentation/pages/model_details_page.dart';
import '../../features/account/presentation/pages/user_preferences_page.dart';
import '../../features/meeting_notes/presentation/pages/capture_page.dart';
import '../../features/meeting_notes/presentation/pages/conversation_detail_page.dart';
import '../../features/meeting_notes/presentation/pages/conversation_history_page.dart';
import '../../features/assistant/presentation/controllers/review_controller.dart';
import '../../features/assistant/presentation/pages/extraction_run_detail_page.dart';
import '../../features/assistant/presentation/pages/rejected_reviews_page.dart';
import '../../features/assistant/presentation/pages/review_page.dart';
import '../../features/chat/presentation/pages/chat_history_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/ledger/domain/entities/ledger_item.dart';
import '../../features/ledger/presentation/pages/ledger_create_page.dart';
import '../../features/ledger/presentation/pages/ledger_item_detail_page.dart';
import '../../features/ledger/presentation/pages/ledger_page.dart';
import '../../features/onboarding/data/providers/onboarding_providers.dart';
import '../../features/onboarding/presentation/controllers/local_model_install_controller.dart';
import '../../features/onboarding/presentation/pages/boot_page.dart';
import '../../features/onboarding/presentation/pages/model_download_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import 'app_shell.dart';
import 'post_setup_home.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(onboardingStateProvider, (_, _) {
    refresh.value++;
  });
  ref.listen(modelSetupStateProvider, (_, _) {
    refresh.value++;
  });
  ref.listen(localModelInstallControllerProvider, (_, _) {
    refresh.value++;
  });
  ref.listen(extractionResumeControllerProvider, (_, _) {});
  ref.listen(pendingReviewCountProvider, (_, _) {
    refresh.value++;
  });

  final router = GoRouter(
    initialLocation: '/boot',
    refreshListenable: refresh,
    redirect: (context, state) {
      final hasSeenWelcome = ref.read(onboardingStateProvider);
      final modelSetup = ref.read(modelSetupStateProvider);
      final modelInstall = ref.read(localModelInstallControllerProvider);
      final location = state.matchedLocation;
      final isBootPage = location == '/boot';
      final isWelcomePage = location == '/welcome';
      final isModelSetupPage = location == '/model-setup';

      // Stay on the logo boot screen until prefs and model readiness are known.
      // Waiting through [isVerifying] avoids flashing model-setup while a
      // configured GGUF finishes its startup hash check.
      // Reloads (`isLoading` with prior data) must not bounce model-setup to
      // /boot — that trapped users on the model gate.
      final bootstrapping =
          hasSeenWelcome.isLoading ||
          modelSetup.isLoading ||
          (modelInstall.isLoading && !modelInstall.hasValue) ||
          (modelInstall.asData?.value.isVerifying ?? false);
      if (bootstrapping) {
        return isBootPage ? null : '/boot';
      }

      final seen = hasSeenWelcome.value ?? false;
      final modelReady = modelInstall.asData?.value.isReady ?? false;
      final setupCompleted = modelSetup.value ?? false;
      final mayEnterApp = modelReady || setupCompleted;
      if (!seen) {
        return isWelcomePage ? null : '/welcome';
      }
      if (!mayEnterApp) {
        return isModelSetupPage ? null : '/model-setup';
      }
      // First enter from boot / welcome / model-setup: Review if pending, else Ledger.
      if (isWelcomePage || isModelSetupPage || isBootPage) {
        final pendingCount = ref.read(pendingReviewCountProvider);
        // Wait on boot until the pending queue emits. Leaving model-setup
        // (Configure later / model ready) must not return to /boot.
        if (pendingCount == null && isBootPage) {
          return null;
        }
        return PostSetupHome.locationForPendingCount(pendingCount ?? 0);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/boot',
        name: 'boot',
        builder: (context, state) => const BootPage(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) {
          return WelcomePage(
            onTourSeen: () {
              ref.read(onboardingStateProvider.notifier).markWelcomeSeen();
            },
            onComplete: () {
              ref.read(onboardingStateProvider.notifier).markWelcomeSeen();
            },
          );
        },
      ),
      GoRoute(
        path: '/model-setup',
        name: 'modelSetup',
        builder: (context, state) => const ModelDownloadPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/capture',
                name: 'capture',
                builder: (context, state) => const CapturePage(),
                routes: [
                  GoRoute(
                    path: 'sources',
                    name: 'sourceHistory',
                    builder: (context, state) =>
                        const ConversationHistoryPage(),
                    routes: [
                      GoRoute(
                        path: ':sourceId',
                        name: 'sourceDetail',
                        builder: (context, state) {
                          final quoteStart = int.tryParse(
                            state.uri.queryParameters['quoteStart'] ?? '',
                          );
                          final quoteEnd = int.tryParse(
                            state.uri.queryParameters['quoteEnd'] ?? '',
                          );
                          return ConversationDetailPage(
                            sourceId: state.pathParameters['sourceId']!,
                            highlightQuoteStart: quoteStart,
                            highlightQuoteEnd: quoteEnd,
                            highlightQuoteSnippet:
                                state.uri.queryParameters['quoteSnippet'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/review',
                name: 'review',
                builder: (context, state) => const ReviewPage(),
                routes: [
                  GoRoute(
                    path: 'rejected',
                    name: 'rejectedReviews',
                    builder: (context, state) => const RejectedReviewsPage(),
                    routes: [
                      GoRoute(
                        path: 'runs/:runId',
                        name: 'extractionRunDetail',
                        builder: (context, state) => ExtractionRunDetailPage(
                          runId: state.pathParameters['runId']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'kinds',
                    name: 'extractionKinds',
                    builder: (context, state) => const ExtractionKindsPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'extractionKindCreate',
                        builder: (context, state) =>
                            const ExtractionKindEditPage(),
                      ),
                      GoRoute(
                        path: ':kindId',
                        name: 'extractionKindEdit',
                        builder: (context, state) => ExtractionKindEditPage(
                          kindId: state.pathParameters['kindId'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ledger',
                name: 'ledger',
                builder: (context, state) => const LedgerPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: 'ledgerItemCreate',
                    builder: (context, state) {
                      final kindName = state.uri.queryParameters['kind'];
                      return LedgerCreatePage(
                        initialKind: kindName ?? LedgerItemKind.commitment,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'items/:itemId',
                    name: 'ledgerItemDetail',
                    builder: (context, state) => LedgerItemDetailPage(
                      itemId: state.pathParameters['itemId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                name: 'chat',
                builder: (context, state) => const ChatPage(),
                routes: [
                  GoRoute(
                    path: 'threads',
                    name: 'chatHistory',
                    builder: (context, state) => const ChatHistoryPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                name: 'account',
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: 'preferences',
                    name: 'accountPreferences',
                    builder: (context, state) => const UserPreferencesPage(),
                  ),
                  GoRoute(
                    path: 'theme',
                    redirect: (context, state) => '/account/preferences',
                  ),
                  GoRoute(
                    path: 'model',
                    name: 'accountModel',
                    builder: (context, state) => const ModelDetailsPage(),
                  ),
                  GoRoute(
                    path: 'extraction',
                    name: 'accountExtraction',
                    builder: (context, state) => const ExtractionSettingsPage(),
                  ),
                  GoRoute(
                    path: 'debug',
                    name: 'accountDebug',
                    builder: (context, state) => const DebugModePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    refresh.dispose();
    router.dispose();
  });
  return router;
}
