import 'package:flutter/material.dart';

/// Semantic status colors for review and ledger chrome.
///
/// Read via `Theme.of(context).extension<AppStatusColors>()`.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.pending,
    required this.onPending,
    required this.extracted,
    required this.onExtracted,
  });

  final Color pending;
  final Color onPending;
  final Color extracted;
  final Color onExtracted;

  static const AppStatusColors light = AppStatusColors(
    pending: Color(0xFFD68910),
    onPending: Color(0xFF3D2402),
    extracted: Color(0xFF1976D2),
    onExtracted: Color(0xFFFFFFFF),
  );

  static const AppStatusColors dark = AppStatusColors(
    pending: Color(0xFFFFB74D),
    onPending: Color(0xFF2E1B00),
    extracted: Color(0xFF64B5F6),
    onExtracted: Color(0xFF002538),
  );

  @override
  AppStatusColors copyWith({
    Color? pending,
    Color? onPending,
    Color? extracted,
    Color? onExtracted,
  }) {
    return AppStatusColors(
      pending: pending ?? this.pending,
      onPending: onPending ?? this.onPending,
      extracted: extracted ?? this.extracted,
      onExtracted: onExtracted ?? this.onExtracted,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      pending: Color.lerp(pending, other.pending, t)!,
      onPending: Color.lerp(onPending, other.onPending, t)!,
      extracted: Color.lerp(extracted, other.extracted, t)!,
      onExtracted: Color.lerp(onExtracted, other.onExtracted, t)!,
    );
  }
}
