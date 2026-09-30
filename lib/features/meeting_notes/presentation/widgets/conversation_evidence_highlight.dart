import 'package:flutter/material.dart';

import '../../../../core/ai/evidence_quote_range.dart';

export '../../../../core/ai/evidence_quote_range.dart';

/// Renders conversation [content], optionally highlighting an evidence span.
///
/// When a valid quote range is provided and this widget sits in a [Scrollable],
/// it scrolls once so the highlighted span sits near the top of the viewport.
class ConversationEvidenceHighlight extends StatefulWidget {
  const ConversationEvidenceHighlight({
    required this.content,
    this.quoteStart,
    this.quoteEnd,
    this.quoteSnippet,
    super.key,
  });

  final String content;
  final int? quoteStart;
  final int? quoteEnd;
  final String? quoteSnippet;

  @override
  State<ConversationEvidenceHighlight> createState() =>
      _ConversationEvidenceHighlightState();
}

class _ConversationEvidenceHighlightState
    extends State<ConversationEvidenceHighlight> {
  var _didAutoScroll = false;

  @override
  void didUpdateWidget(covariant ConversationEvidenceHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content ||
        oldWidget.quoteStart != widget.quoteStart ||
        oldWidget.quoteEnd != widget.quoteEnd ||
        oldWidget.quoteSnippet != widget.quoteSnippet) {
      _didAutoScroll = false;
    }
  }

  void _scheduleAutoScroll({
    required EvidenceQuoteRange range,
    required TextStyle style,
    required double maxWidth,
  }) {
    if (_didAutoScroll) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didAutoScroll) return;
      _scrollToHighlight(range: range, style: style, maxWidth: maxWidth);
    });
  }

  void _scrollToHighlight({
    required EvidenceQuoteRange range,
    required TextStyle style,
    required double maxWidth,
  }) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final scrollBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollBox == null || !scrollBox.hasSize) return;

    final prefixPainter = TextPainter(
      text: TextSpan(
        text: widget.content.substring(0, range.start),
        style: style,
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    final widgetTopInViewport = box
        .localToGlobal(Offset.zero, ancestor: scrollBox)
        .dy;
    final quoteTopInViewport = widgetTopInViewport + prefixPainter.height;
    final preferredViewportY = scrollable.position.viewportDimension * 0.2;
    final target =
        (scrollable.position.pixels + quoteTopInViewport - preferredViewportY)
            .clamp(0.0, scrollable.position.maxScrollExtent);

    _didAutoScroll = true;
    if ((target - scrollable.position.pixels).abs() < 1) return;

    scrollable.position.animateTo(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseStyle = theme.textTheme.bodyLarge?.copyWith(height: 1.6);
    final range = resolveEvidenceQuoteRange(
      content: widget.content,
      quoteStart: widget.quoteStart,
      quoteEnd: widget.quoteEnd,
      quoteSnippet: widget.quoteSnippet,
    );

    if (range == null) {
      return SelectableText(widget.content, style: baseStyle);
    }

    final style = baseStyle ?? DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        _scheduleAutoScroll(range: range, style: style, maxWidth: maxWidth);

        return SelectableText.rich(
          TextSpan(
            style: style,
            children: [
              TextSpan(text: widget.content.substring(0, range.start)),
              TextSpan(
                text: widget.content.substring(range.start, range.end),
                style: TextStyle(
                  backgroundColor: colorScheme.tertiaryContainer,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              TextSpan(text: widget.content.substring(range.end)),
            ],
          ),
        );
      },
    );
  }
}
