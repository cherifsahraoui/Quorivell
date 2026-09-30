import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Quorivell [TextField] that yields leftover vertical overscroll to an
/// ancestor [Scrollable].
///
/// A multiline field keeps its own scroll until the top or bottom edge; further
/// drag then moves the surrounding page instead of getting stuck on the field.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.scrollController,
    this.enabled,
    this.readOnly = false,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.expands = false,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.inputFormatters,
    this.scrollPadding = const EdgeInsets.all(20),
    this.scrollPhysics,
    this.decoration = const InputDecoration(),
    this.autofillHints,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool? enabled;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool expands;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final InputDecoration? decoration;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        if (notification.depth != 0) {
          return false;
        }
        notification.disallowIndicator();
        return true;
      },
      child: NotificationListener<OverscrollNotification>(
        onNotification: (notification) {
          return _handoffVerticalOverscroll(context, notification);
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          scrollController: scrollController,
          enabled: enabled,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          expands: expands,
          style: style,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          onTap: onTap,
          inputFormatters: inputFormatters,
          scrollPadding: scrollPadding,
          // Clamping (not bouncing) so an edge drag becomes parent overscroll
          // instead of rubber-banding inside the field.
          scrollPhysics: scrollPhysics ?? const ClampingScrollPhysics(),
          decoration: decoration,
          autofillHints: autofillHints,
        ),
      ),
    );
  }
}

bool _handoffVerticalOverscroll(
  BuildContext context,
  OverscrollNotification notification,
) {
  if (notification.depth != 0 || notification.overscroll == 0) {
    return false;
  }
  if (notification.metrics.axis != Axis.vertical) {
    return false;
  }

  final parent = Scrollable.maybeOf(context, axis: Axis.vertical);
  if (parent == null) {
    return false;
  }

  final position = parent.position;
  if (!position.hasContentDimensions || !position.hasPixels) {
    return false;
  }

  final next = (position.pixels + notification.overscroll).clamp(
    position.minScrollExtent,
    position.maxScrollExtent,
  );
  if (next == position.pixels) {
    return false;
  }

  position.jumpTo(next);
  return true;
}
