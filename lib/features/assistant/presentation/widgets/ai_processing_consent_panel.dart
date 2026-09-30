import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ai_processing_consent.dart';
import '../controllers/ai_processing_consent_controller.dart';

class AiProcessingConsentPanel extends ConsumerWidget {
  const AiProcessingConsentPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final consent = ref.watch(aiProcessingConsentControllerProvider);
    final actions = ref.read(aiProcessingConsentControllerProvider.notifier);

    return consent.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: LoadingState(),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text(failureMessage(l10n, error)),
      ),
      data: (value) => _ConsentBody(
        consent: value,
        onGrant: actions.grant,
        onDecline: actions.decline,
      ),
    );
  }
}

class _ConsentBody extends StatelessWidget {
  const _ConsentBody({
    required this.consent,
    required this.onGrant,
    required this.onDecline,
  });

  final AiProcessingConsent consent;
  final VoidCallback onGrant;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.assistantConsentHeadline, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Text(_bodyCopy(l10n), style: textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        ..._actions(l10n),
      ],
    );
  }

  String _bodyCopy(AppLocalizations l10n) => switch (consent.status) {
    AiProcessingConsentStatus.unknown => l10n.assistantConsentUnknownBody,
    AiProcessingConsentStatus.granted => l10n.assistantConsentGrantedBody,
    AiProcessingConsentStatus.declined => l10n.assistantConsentDeclinedBody,
  };

  List<Widget> _actions(AppLocalizations l10n) => switch (consent.status) {
    AiProcessingConsentStatus.unknown => [
      FilledButton(
        onPressed: onGrant,
        child: Text(l10n.assistantConsentGrantButton),
      ),
      const SizedBox(height: AppSpacing.sm),
      OutlinedButton(
        onPressed: onDecline,
        child: Text(l10n.assistantConsentDeclineButton),
      ),
    ],
    AiProcessingConsentStatus.granted => [
      OutlinedButton(
        onPressed: onDecline,
        child: Text(l10n.assistantConsentWithdrawButton),
      ),
    ],
    AiProcessingConsentStatus.declined => [
      FilledButton(
        onPressed: onGrant,
        child: Text(l10n.assistantConsentGrantLaterButton),
      ),
    ],
  };
}
