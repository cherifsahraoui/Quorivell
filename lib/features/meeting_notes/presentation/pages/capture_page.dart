import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/network/webpage_text_fetcher.dart';
import '../../../../core/platform/share_intent.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/sticky_primary_action_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/capture_controller.dart';
import '../controllers/incoming_share_controller.dart';
import '../widgets/capture_incoming_share_banner.dart';
import '../widgets/capture_privacy_dialog.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key});

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> {
  final _conversationController = TextEditingController();
  final _urlController = TextEditingController();
  var _fetchingPage = false;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    _conversationController.addListener(_onTextChanged);
    final pending = ref.read(incomingShareControllerProvider);
    if (pending != null && pending.isShare) {
      _applySharedText(pending.text);
    }
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _conversationController.removeListener(_onTextChanged);
    _conversationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _applySharedText(String text) {
    if (looksLikeHttpUrl(text)) {
      _urlController.text = text.trim();
      _conversationController.clear();
      return;
    }
    _conversationController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _applyIncomingShare(IncomingSharePayload? next) {
    if (next == null || !next.isShare) return;
    _applySharedText(next.text);
  }

  void _discardShare() {
    ref.read(incomingShareControllerProvider.notifier).discard();
    _conversationController.clear();
    _urlController.clear();
    setState(() => _fetchError = null);
  }

  Future<void> _fetchWebpage() async {
    final l10n = AppLocalizations.of(context);
    final raw = _urlController.text.trim().isNotEmpty
        ? _urlController.text
        : _conversationController.text;
    final uri = parseHttpUrl(raw);
    if (uri == null) {
      setState(() => _fetchError = l10n.captureUrlInvalid);
      return;
    }

    setState(() {
      _fetchingPage = true;
      _fetchError = null;
    });

    final fetcher = HttpWebpageTextFetcher();
    try {
      final result = await fetcher.fetchMainText(uri);
      if (!mounted) return;
      final buffer = StringBuffer();
      if (result.title != null && result.title!.isNotEmpty) {
        buffer.writeln(result.title);
        buffer.writeln();
      }
      buffer.write(result.text);
      final composed = buffer.toString().trim();
      _conversationController.value = TextEditingValue(
        text: composed,
        selection: TextSelection.collapsed(offset: composed.length),
      );
      _urlController.text = uri.toString();
    } on WebpageFetchException {
      if (!mounted) return;
      setState(() => _fetchError = l10n.captureUrlFetchFailed);
    } on Object {
      if (!mounted) return;
      setState(() => _fetchError = l10n.captureUrlFetchFailed);
    } finally {
      fetcher.close();
      if (mounted) {
        setState(() => _fetchingPage = false);
      }
    }
  }

  Future<void> _capture() async {
    await ref
        .read(captureControllerProvider.notifier)
        .capture(_conversationController.text);
    if (!mounted) return;

    final result = ref.read(captureControllerProvider);
    if (result.hasError) return;
    ref.read(incomingShareControllerProvider.notifier).discard();
    _conversationController.clear();
    _urlController.clear();
    context.go('/review');
  }

  bool get _canSave =>
      !_fetchingPage && _conversationController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(captureControllerProvider);
    final incomingShare = ref.watch(incomingShareControllerProvider);
    final pendingShare = incomingShare?.isShare == true ? incomingShare : null;
    ref.listen(incomingShareControllerProvider, (previous, next) {
      if (next != null && next.isShare && next.id != previous?.id) {
        _applyIncomingShare(next);
      }
    });
    final isSaving = state.isLoading;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showUrlFetch =
        looksLikeHttpUrl(_urlController.text) ||
        looksLikeHttpUrl(_conversationController.text) ||
        _urlController.text.trim().isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: l10n.captureHeadline,
                  subtitle: l10n.captureSubtitle,
                  action: IconButton(
                    icon: const Icon(Icons.history),
                    tooltip: l10n.captureHistoryTooltip,
                    onPressed: () => context.push('/capture/sources'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: InfoCard(
                    icon: Icons.lock_outline,
                    title: l10n.welcomeFeature1Title,
                    subtitle: l10n.capturePrivacySubtitle,
                    color: colorScheme.tertiary,
                    onTap: () => showCapturePrivacyDialog(context),
                  ),
                ),
              ),
              if (pendingShare != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      0,
                    ),
                    child: CaptureIncomingShareBanner(
                      title: l10n.captureShareBannerTitle,
                      body: l10n.captureShareBannerBody,
                      discardLabel: l10n.captureShareDiscardButton,
                      onDiscard: isSaving || _fetchingPage
                          ? null
                          : _discardShare,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _urlController,
                        enabled: !isSaving && !_fetchingPage,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (_) => _fetchWebpage(),
                        decoration: InputDecoration(
                          labelText: l10n.captureUrlFieldLabel,
                          hintText: l10n.captureUrlFieldHint,
                          prefixIcon: const Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: OutlinedButton.icon(
                          onPressed: isSaving || _fetchingPage
                              ? null
                              : _fetchWebpage,
                          icon: _fetchingPage
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: ExcludeSemantics(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.download_outlined),
                          label: Text(
                            _fetchingPage
                                ? l10n.captureUrlFetching
                                : l10n.captureUrlFetchButton,
                          ),
                        ),
                      ),
                      if (showUrlFetch) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.captureUrlHelp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (_fetchError != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _fetchError!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _conversationController,
                        enabled: !isSaving && !_fetchingPage,
                        minLines: 8,
                        maxLines: 16,
                        textCapitalization: TextCapitalization.sentences,
                        scrollPadding: const EdgeInsets.only(
                          top: AppSpacing.xxl,
                          bottom: AppSpacing.xxl * 2,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.captureFieldLabel,
                          hintText: l10n.captureFieldHint,
                          alignLabelWithHint: true,
                        ),
                      ),
                      if (state.hasError) ...[
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                failureMessage(l10n, state.error),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        StickyPrimaryActionBar(
          label: isSaving ? l10n.captureSavingButton : l10n.captureSaveButton,
          icon: Icons.save_outlined,
          onPressed: isSaving || !_canSave ? null : _capture,
          isLoading: isSaving,
          clearRaisedFab: false,
        ),
      ],
    );
  }
}
