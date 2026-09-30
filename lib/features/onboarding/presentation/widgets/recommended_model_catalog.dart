import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ai/local_model_spec.dart';
import '../../../../core/device/device_capability_providers.dart';
import '../../../../core/device/device_capability_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/local_model_size_label.dart';

class RecommendedModelCatalog extends ConsumerWidget {
  const RecommendedModelCatalog({
    required this.enabled,
    required this.downloadingModelId,
    required this.onDownload,
    required this.onOpenPage,
    this.currentModelId,
    super.key,
  });

  final bool enabled;
  final String? downloadingModelId;

  /// When set (e.g. Account → Change model), marks that catalog entry as
  /// already installed so the user does not re-download the same GGUF.
  final String? currentModelId;
  final ValueChanged<LocalModelSpec> onDownload;
  final ValueChanged<Uri> onOpenPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final deviceCapability = ref.watch(deviceCapabilityProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingModelCatalogTitle,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        deviceCapability.when(
          data: (capability) => Text(
            l10n.modelRecommendationDeviceMemory(
              capability.totalRamGB,
              capability.availableRamGB,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final model in LocalModelSpec.catalog) ...[
          _RecommendedModelTile(
            model: model,
            enabled: enabled,
            downloading: downloadingModelId == model.modelId,
            isCurrent: currentModelId == model.modelId,
            onDownload: () => onDownload(model),
            onOpenPage: () => onOpenPage(model.huggingFacePageUri),
            deviceCapability: deviceCapability.value,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _RecommendedModelTile extends StatelessWidget {
  const _RecommendedModelTile({
    required this.model,
    required this.enabled,
    required this.downloading,
    required this.isCurrent,
    required this.onDownload,
    required this.onOpenPage,
    this.deviceCapability,
  });

  final LocalModelSpec model;
  final bool enabled;
  final bool downloading;
  final bool isCurrent;
  final VoidCallback onDownload;
  final VoidCallback onOpenPage;
  final DeviceCapability? deviceCapability;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = model.approximateBytes;

    final canFit = deviceCapability != null && size != null
        ? deviceCapability!.canFitModel(size)
        : true;

    final showRecommendedBadge = model.recommended && canFit && !isCurrent;
    final showNeedsRamWarning = model.needsMoreRam && !canFit;
    final showUncensoredNote = model.uncensored;
    final needsRamDetail = size != null && showNeedsRamWarning
        ? (
            requiredRam: deviceCapability!.requiredRamGBForModel(size),
            usableRam: deviceCapability!.usableRamGB,
          )
        : null;

    final subtitleParts = <String>[
      localModelLicenseLabel(l10n, model.licenseKind),
      if (size != null) localModelSizeLabel(l10n, size),
    ];

    final showBadges =
        isCurrent ||
        showRecommendedBadge ||
        showNeedsRamWarning ||
        showUncensoredNote;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.modelId,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.modelCatalogOpenPageTooltip,
                  onPressed: enabled ? onOpenPage : null,
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
            if (showBadges) ...[
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  if (isCurrent)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(l10n.modelCatalogCurrentModel),
                      backgroundColor: colorScheme.secondaryContainer,
                    ),
                  if (showRecommendedBadge)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(l10n.modelRecommendationFitsDevice),
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                  if (showUncensoredNote)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(l10n.modelCatalogUncensored),
                      backgroundColor: colorScheme.tertiaryContainer,
                    ),
                  if (showNeedsRamWarning)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(l10n.modelRecommendationNeedsMoreRam),
                      backgroundColor: colorScheme.errorContainer,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              subtitleParts.join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (showUncensoredNote) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.modelCatalogUncensoredNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (needsRamDetail != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.modelRecommendationNeedsRamDetail(
                  needsRamDetail.requiredRam,
                  needsRamDetail.usableRam,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            FilledButton.tonalIcon(
              onPressed: enabled && !isCurrent ? onDownload : null,
              icon: downloading
                  ? SizedBox.square(
                      dimension: AppSpacing.md,
                      child: ExcludeSemantics(
                        child: CircularProgressIndicator(
                          strokeWidth: AppSpacing.xs / 2,
                        ),
                      ),
                    )
                  : Icon(isCurrent ? Icons.check : Icons.download),
              label: Text(
                downloading
                    ? l10n.onboardingModelDownloading
                    : isCurrent
                    ? l10n.modelCatalogAlreadyInstalled
                    : l10n.onboardingModelDownloadButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String localModelLicenseLabel(
  AppLocalizations l10n,
  LocalModelLicenseKind kind,
) {
  return switch (kind) {
    LocalModelLicenseKind.apache20 => l10n.modelLicenseApache20,
    LocalModelLicenseKind.llama3Community => l10n.modelLicenseLlama3,
    LocalModelLicenseKind.llama32Community => l10n.modelLicenseLlama32,
  };
}
