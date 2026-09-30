import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/shell_bottom_inset.dart';
import 'app_spacing.dart';
import 'app_status_colors.dart';

/// Single source of truth for Quorivell's Material 3 theme.
///
/// Screens must read colors and typography from `Theme.of(context)`
/// (`colorScheme` / `textTheme`) rather than hardcoding hex values or
/// custom static color classes.
abstract final class AppTheme {
  /// Professional teal and mint from the brand icon.
  static const Color _seedColor = Color(0xFF1D757F);
  static const Color _primary = Color(0xFF1D757F);
  static final Color _primaryDark = Color.lerp(_primary, Colors.white, 0.35)!;

  /// Darker primary for selected radios / list tiles in light mode.
  static final Color _primarySelectedLight = Color.lerp(
    _primary,
    Colors.black,
    0.28,
  )!;
  static const Color _secondary = Color(0xFF88C79C);
  static final Color _secondaryDark = Color.lerp(
    _secondary,
    Colors.white,
    0.15,
  )!;
  static const Color _surfaceLight = Color(0xFFF8F9F9);
  static const Color _cardLight = Color(0xFFFFFFFF);

  static ThemeData light() => _themed(brightness: Brightness.light);

  static ThemeData dark() => _themed(brightness: Brightness.dark);

  static ThemeData _themed({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: brightness,
        ).copyWith(
          primary: isLight ? _primary : _primaryDark,
          onPrimary: Colors.white,
          secondary: isLight ? _secondary : _secondaryDark,
          tertiary: const Color(0xFFE8A04A),
          surface: isLight ? _surfaceLight : null,
          surfaceContainerLowest: isLight ? _cardLight : null,
          surfaceContainerLow: isLight ? const Color(0xFFF1F3F3) : null,
          surfaceContainer: isLight ? const Color(0xFFE8EBEB) : null,
          surfaceContainerHigh: isLight ? _cardLight : null,
          surfaceContainerHighest: isLight ? const Color(0xFFE3E7E7) : null,
        );

    final baseTextTheme = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    final textTheme = GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: <ThemeExtension<dynamic>>[
        isLight ? AppStatusColors.light : AppStatusColors.dark,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0.5,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.06),
        color: colorScheme.surfaceContainerHigh,
        surfaceTintColor: colorScheme.surfaceTint,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: textTheme.labelLarge,
          disabledBackgroundColor: colorScheme.onSurface.withValues(
            alpha: 0.12,
          ),
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: textTheme.labelLarge,
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: textTheme.labelLarge,
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        // Must set an explicit ColorScheme color. A null-color labelStyle
        // overrides FilterChip M3 defaults and leaves labels unreadable.
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        surfaceTintColor: colorScheme.surfaceTint,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      dialogTheme: DialogThemeData(
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        // Clear the shell's raised Ledger control (Stack sibling above Scaffold).
        insetPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          ShellBottomInset.fabOuterRadius + AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        elevation: 3,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        minLeadingWidth: AppSpacing.xl,
        selectedColor: isLight ? _primarySelectedLight : colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isLight ? _primarySelectedLight : colorScheme.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}
