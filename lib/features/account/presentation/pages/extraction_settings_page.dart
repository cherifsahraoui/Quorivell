import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/extraction_prompt_builder.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/widgets/show_app_snack_bar.dart';
import '../../../../core/widgets/sticky_primary_action_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/debug_ai_settings_providers.dart';
import '../../domain/entities/user_preference.dart';

class ExtractionSettingsPage extends ConsumerStatefulWidget {
  const ExtractionSettingsPage({super.key});

  @override
  ConsumerState<ExtractionSettingsPage> createState() =>
      _ExtractionSettingsPageState();
}

class _ExtractionSettingsPageState
    extends ConsumerState<ExtractionSettingsPage> {
  final _chatController = TextEditingController();
  final _extractionUserController = TextEditingController();
  final _extractionSystemController = TextEditingController();
  var _hydrated = false;

  @override
  void dispose() {
    _chatController.dispose();
    _extractionUserController.dispose();
    _extractionSystemController.dispose();
    super.dispose();
  }

  void _hydrateIfNeeded(AppLocalizations l10n, UserPreference? prefs) {
    if (_hydrated) return;
    _hydrated = true;
    _chatController.text =
        prefs?.chatSystemPromptOverride ?? l10n.chatSystemInstruction;
    _extractionUserController.text =
        prefs?.extractionPromptOverride ??
        ExtractionPromptBuilder.userPrompt(l10n, const [], '{conversation}');
    _extractionSystemController.text =
        prefs?.extractionSystemPromptOverride ??
        ExtractionPromptBuilder.systemInstruction(l10n, const []);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = ref.watch(debugAiSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extractionSettingsTitle),
        leading: BackButton(
          onPressed: () {
            final router = GoRouter.maybeOf(context);
            if (router != null) {
              if (router.canPop()) {
                router.pop();
              } else {
                router.go('/account');
              }
              return;
            }
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: settings.when(
        loading: () => const LoadingState(),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              failureMessage(l10n, error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        data: (prefs) {
          _hydrateIfNeeded(l10n, prefs);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    InfoCard(
                      icon: Icons.tune_outlined,
                      title: l10n.extractionSettingsTitle,
                      subtitle: l10n.extractionSettingsSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.extractionSettingsOverridesNote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.category_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      title: Text(l10n.extractionKindsTitle),
                      subtitle: Text(l10n.extractionKindsSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/review/kinds'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _OverrideField(
                      key: const ValueKey('extraction_settings_chat_prompt'),
                      controller: _chatController,
                      label: l10n.accountDebugChatSystemPromptLabel,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () => _applyExplicitChatTone(l10n),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(l10n.extractionSettingsExplicitChatButton),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.extractionSettingsExplicitChatNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: () => context.push('/account/model'),
                        child: Text(
                          l10n.extractionSettingsExplicitChatOpenModel,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_systemPromptModified(l10n, prefs)) ...[
                      InfoCard(
                        icon: Icons.warning_amber_outlined,
                        title: l10n.extractionSettingsSystemPromptModifiedTitle,
                        subtitle:
                            l10n.extractionSettingsSystemPromptModifiedWarning,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    _OverrideField(
                      key: const ValueKey('extraction_settings_system_prompt'),
                      controller: _extractionSystemController,
                      label: l10n.accountDebugExtractionSystemPromptLabel,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _OverrideField(
                      key: const ValueKey('extraction_settings_user_prompt'),
                      controller: _extractionUserController,
                      label: l10n.accountDebugExtractionUserPromptLabel,
                      hint: l10n.accountDebugExtractionUserPromptHint(
                        '{conversation}',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton(
                      onPressed: () => _reset(l10n),
                      child: Text(l10n.accountDebugPromptResetAll),
                    ),
                  ],
                ),
              ),
              StickyPrimaryActionBar(
                label: l10n.extractionSettingsSave,
                onPressed: () => _save(l10n),
              ),
            ],
          );
        },
      ),
    );
  }

  void _applyExplicitChatTone(AppLocalizations l10n) {
    _chatController.text = l10n.chatSystemInstructionExplicit;
    setState(() {});
    showAppSnackBar(
      context,
      content: Text(l10n.extractionSettingsExplicitChatApplied),
    );
  }

  void _goToAccountTab() {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go('/account');
      return;
    }
    Navigator.of(context).maybePop();
  }

  Future<void> _save(AppLocalizations l10n) async {
    try {
      await ref
          .read(debugAiSettingsControllerProvider.notifier)
          .savePromptOverrides(
            chatSystemPromptOverride: _chatController.text,
            extractionPromptOverride: _extractionUserController.text,
            extractionSystemPromptOverride: _extractionSystemController.text,
          );
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.extractionSettingsSaved));
      _goToAccountTab();
    } catch (error) {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(failureMessage(l10n, error)));
    }
  }

  Future<void> _reset(AppLocalizations l10n) async {
    _chatController.text = l10n.chatSystemInstruction;
    _extractionUserController.text = ExtractionPromptBuilder.userPrompt(
      l10n,
      const [],
      '{conversation}',
    );
    _extractionSystemController.text =
        ExtractionPromptBuilder.systemInstruction(l10n, const []);
    setState(() {});
    try {
      await ref
          .read(debugAiSettingsControllerProvider.notifier)
          .savePromptOverrides(
            chatSystemPromptOverride: null,
            extractionPromptOverride: null,
            extractionSystemPromptOverride: null,
          );
      if (!mounted) return;
      showAppSnackBar(context, content: Text(l10n.accountDebugPromptResetDone));
      _goToAccountTab();
    } catch (error) {
      if (!mounted) return;
      showAppSnackBar(context, content: Text(failureMessage(l10n, error)));
    }
  }

  bool _systemPromptModified(AppLocalizations l10n, UserPreference? prefs) {
    final stored = prefs?.extractionSystemPromptOverride?.trim();
    if (stored != null && stored.isNotEmpty) return true;
    final defaultPrompt = ExtractionPromptBuilder.systemInstruction(
      l10n,
      const [],
    );
    return _extractionSystemController.text.trim() != defaultPrompt.trim();
  }
}

class _OverrideField extends StatelessWidget {
  const _OverrideField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      maxLines: 8,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
