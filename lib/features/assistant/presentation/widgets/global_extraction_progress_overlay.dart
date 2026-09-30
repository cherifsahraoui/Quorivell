import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/extraction_progress.dart';
import '../controllers/review_controller.dart';
import 'confirm_stop_extraction_dialog.dart';

/// Global extraction progress overlay that persists across navigation.
///
/// Shows a card at the bottom of the screen (above nav/FAB) during extraction.
/// Can be minimized to a floating button but never fully dismissed while
/// extraction is running.
///
/// Vertical drag uses [Listener] (does not steal button taps) + fixed
/// [Positioned] + [Transform.translate]. Bounds are clamped to the ancestor
/// body [RenderStack] so the card cannot slide under the nav or off-screen.
/// The minimized FAB also reserves the expanded card height, so expanding
/// after a drag cannot place the card above the screen.
class GlobalExtractionProgressOverlay extends ConsumerStatefulWidget {
  const GlobalExtractionProgressOverlay({super.key});

  static const Duration _transitionDuration = Duration(milliseconds: 220);

  /// Clearance above the bottom nav / shell FAB.
  static const double _bottomNavClearance = 80;

  @override
  ConsumerState<GlobalExtractionProgressOverlay> createState() =>
      _GlobalExtractionProgressOverlayState();
}

class _GlobalExtractionProgressOverlayState
    extends ConsumerState<GlobalExtractionProgressOverlay> {
  final GlobalKey _contentKey = GlobalKey();

  /// Vertical translation from the default bottom placement.
  /// Positive moves down; negative moves up (matches pointer [delta.dy]).
  double _dragDy = 0;

  /// Last laid-out height of the expanded card. Used so the minimized FAB
  /// cannot be dragged higher than the card would fit when expanded.
  double? _expandedHeight;

  bool _dragging = false;

  int? _activePointer;
  Offset _pointerDownPos = Offset.zero;
  bool _passedSlop = false;

  void _resetOffset() {
    if (_dragDy != 0 || _dragging || _expandedHeight != null) {
      _dragDy = 0;
      _dragging = false;
      _expandedHeight = null;
    }
    _activePointer = null;
    _passedSlop = false;
  }

  /// Body [Stack] that hosts this overlay — never the overlay's own box.
  RenderStack? _hostStack() {
    return context.findAncestorRenderObjectOfType<RenderStack>();
  }

  double _clampedDy(double next, {required bool isMinimized}) {
    final contentBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    final stackBox = _hostStack();
    if (contentBox == null ||
        stackBox == null ||
        !contentBox.hasSize ||
        !stackBox.hasSize) {
      // Without a host, only allow moving up from the default seat.
      return next.clamp(double.negativeInfinity, 0);
    }

    final padding = MediaQuery.paddingOf(context);
    final currentTop = stackBox
        .globalToLocal(contentBox.localToGlobal(Offset.zero))
        .dy;
    return clampExtractionOverlayDragDy(
      next: next,
      currentTop: currentTop,
      dragDy: _dragDy,
      childHeight: contentBox.size.height,
      stackHeight: stackBox.size.height,
      minTop: padding.top + AppSpacing.sm,
      spacing: AppSpacing.sm,
      expandedHeight: isMinimized ? _expandedHeight : null,
    );
  }

  void _captureExpandedHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final height = box.size.height;
      if (height <= 0 || height == _expandedHeight) return;
      setState(() {
        _expandedHeight = height;
        _dragDy = _clampedDy(_dragDy, isMinimized: false);
      });
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    _activePointer = event.pointer;
    _pointerDownPos = event.position;
    _passedSlop = false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;

    if (!_passedSlop) {
      if ((event.position - _pointerDownPos).distance < kTouchSlop) {
        return;
      }
      _passedSlop = true;
      setState(() => _dragging = true);
    }

    setState(() {
      _dragDy = _clampedDy(
        _dragDy + event.delta.dy,
        isMinimized: ref.read(
          extractionProgressOverlayMinimizedControllerProvider,
        ),
      );
    });
  }

  void _handlePointerEnd(PointerEvent event) {
    if (event.pointer != _activePointer) return;
    _activePointer = null;
    _passedSlop = false;
    if (_dragging) {
      setState(() => _dragging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(extractionProgressControllerProvider);
    final isExtracting = ref.watch(extractionRunningControllerProvider);
    final isMinimized = ref.watch(
      extractionProgressOverlayMinimizedControllerProvider,
    );

    if (progress == null || !isExtracting) {
      _resetOffset();
      return const SizedBox.shrink();
    }
    if (!isMinimized) {
      _captureExpandedHeight();
    }
    final l10n = AppLocalizations.of(context);
    final bottomOffset =
        MediaQuery.paddingOf(context).bottom +
        GlobalExtractionProgressOverlay._bottomNavClearance;

    // Disable actions while dragging so a drag release cannot click.
    final VoidCallback? onExpand = _dragging
        ? null
        : () {
            ref
                .read(
                  extractionProgressOverlayMinimizedControllerProvider.notifier,
                )
                .expand();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _dragDy = _clampedDy(_dragDy, isMinimized: false);
              });
            });
          };
    final VoidCallback? onMinimize = _dragging
        ? null
        : () => ref
              .read(
                extractionProgressOverlayMinimizedControllerProvider.notifier,
              )
              .minimize();
    final VoidCallback? onStop = _dragging
        ? null
        : () async {
            final confirmed = await confirmStopExtraction(context);
            if (!confirmed || !mounted) return;
            unawaited(
              ref
                  .read(reviewActionsControllerProvider.notifier)
                  .cancelExtraction(),
            );
          };

    final switched = AnimatedSwitcher(
      duration: GlobalExtractionProgressOverlay._transitionDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          clipBehavior: Clip.none,
          children: <Widget>[...previousChildren, ?currentChild],
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
            alignment: Alignment.bottomRight,
            child: child,
          ),
        );
      },
      child: isMinimized
          ? _MinimizedExtractionFab(
              key: const ValueKey('minimized'),
              progress: progress,
              expandLabel: l10n.extractionProgressExpand,
              onExpand: onExpand,
            )
          : _ExpandedExtractionCard(
              key: const ValueKey('expanded'),
              progress: progress,
              minimizeTooltip: l10n.extractionProgressMinimize,
              onMinimize: onMinimize,
              stopLabel: l10n.extractionProgressStop,
              onStop: onStop,
            ),
    );

    // Key the visual content (not the full-width Align) so clamping uses the
    // FAB/card size rather than the bottom band width.
    final measured = KeyedSubtree(key: _contentKey, child: switched);

    return Positioned(
      bottom: bottomOffset,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: Transform.translate(
        offset: Offset(0, _dragDy),
        child: Listener(
          behavior: HitTestBehavior.deferToChild,
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerEnd,
          onPointerCancel: _handlePointerEnd,
          child: AnimatedScale(
            scale: _dragging ? 1.03 : 1,
            duration: const Duration(milliseconds: 120),
            child: isMinimized
                ? Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    heightFactor: 1,
                    child: measured,
                  )
                : measured,
          ),
        ),
      ),
    );
  }
}

class _MinimizedExtractionFab extends StatelessWidget {
  const _MinimizedExtractionFab({
    required this.progress,
    required this.expandLabel,
    required this.onExpand,
    super.key,
  });

  final ExtractionProgress progress;
  final String expandLabel;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progressValue = progress.totalChunks <= 0
        ? null
        : progress.currentChunk / progress.totalChunks;

    return Semantics(
      button: true,
      label: expandLabel,
      child: FloatingActionButton.small(
        heroTag: 'extractionProgressOverlay',
        onPressed: onExpand,
        child: SizedBox(
          width: AppSpacing.lg,
          height: AppSpacing.lg,
          child: ExcludeSemantics(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              value: progressValue,
              // FAB fill is primaryContainer — use on-container tones so the
              // arc and track stay visible against it.
              color: colorScheme.onPrimaryContainer,
              backgroundColor: colorScheme.onPrimaryContainer.withValues(
                alpha: 0.28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedExtractionCard extends StatelessWidget {
  const _ExpandedExtractionCard({
    required this.progress,
    required this.minimizeTooltip,
    required this.onMinimize,
    required this.stopLabel,
    required this.onStop,
    super.key,
  });

  final ExtractionProgress progress;
  final String minimizeTooltip;
  final VoidCallback? onMinimize;
  final String stopLabel;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: ExcludeSemantics(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.totalChunks <= 0
                          ? null
                          : progress.currentChunk / progress.totalChunks,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.currentChunk <= 0
                            ? l10n.extractionInProgress
                            : l10n.extractionProgressProcessing(
                                progress.currentChunk,
                                progress.totalChunks,
                              ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      if (progress.batchTotal > 1) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.extractionProgressConversation(
                            progress.batchIndex + 1,
                            progress.batchTotal,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.extractionProgressCandidatesFound(
                          progress.candidatesFound,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.unfold_less,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: minimizeTooltip,
                  onPressed: onMinimize,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: progress.totalChunks <= 0
                  ? 0
                  : progress.currentChunk / progress.totalChunks,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: onStop,
                icon: const Icon(Icons.stop),
                label: Text(stopLabel),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.extractionProgressBackgroundHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (progress.candidatesPerSecond != null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.extractionMetricsLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  Text(
                    l10n.extractionMetricsCandidatesPerSecond(
                      progress.candidatesPerSecond!,
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (progress.totalSeconds != null)
                    Text(
                      l10n.extractionMetricsTotalTime(progress.totalSeconds!),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Vertical drag delta so the overlay stays on-screen.
///
/// Both modes share a bottom anchor. When the FAB is showing, pass the
/// expanded card height as [expandedHeight] so a later expand cannot place
/// the card above [minTop].
double clampExtractionOverlayDragDy({
  required double next,
  required double currentTop,
  required double dragDy,
  required double childHeight,
  required double stackHeight,
  required double minTop,
  required double spacing,
  double? expandedHeight,
}) {
  if (stackHeight <= 0 || childHeight <= 0) {
    return next.clamp(double.negativeInfinity, 0);
  }

  final baseTop = currentTop - dragDy;
  final reservedHeight = math.max(childHeight, expandedHeight ?? 0);
  final extraUp = math.max(0.0, reservedHeight - childHeight);

  final maxTop = stackHeight - childHeight - spacing;
  final upperTop = maxTop < baseTop ? maxTop : baseTop;
  if (upperTop < minTop) {
    return minTop - baseTop;
  }

  final minDy = minTop - baseTop + extraUp;
  final maxDy = upperTop - baseTop;
  if (minDy > maxDy) {
    return maxDy;
  }
  return next.clamp(minDy, maxDy);
}
