import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Thawani POS Design System — ThemeData Builder
///
/// Provides a fully configured light & dark theme using Cairo font,
/// Thawani brand colors, and all component theme overrides that match
/// the stitch HTML prototypes.
class AppTheme {
  AppTheme._();

  // ─── Light Theme ─────────────────────────────────────────
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme(isDark: false),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ─ App Bar ─
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryLight),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shape: Border(bottom: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5))),
      ),

      // ─ Card ─
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: const BorderSide(color: AppColors.borderSubtleLight),
        ),
        margin: EdgeInsets.zero,
      ),

      // ─ Elevated Button (Primary CTA) ─
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Outlined Button ─
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          side: const BorderSide(color: AppColors.borderLight),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Text Button ─
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Filled Button (Tonal) ─
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary10,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Icon Button ─
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondaryLight,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
        ),
      ),

      // ─ FAB ─
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),

      // ─ Input Decoration ─
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBgLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: AppRadius.borderMd, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.primary10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTypography.titleMedium.copyWith(color: AppColors.textSecondaryLight),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textDisabledLight),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textMutedLight,
        suffixIconColor: AppColors.textMutedLight,
      ),

      // ─ Chip ─
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inputBgLight,
        selectedColor: AppColors.primary10,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderFull),
        side: BorderSide(color: AppColors.borderLight),
      ),

      // ─ Dialog ─
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
        titleTextStyle: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryLight),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
      ),

      // ─ Bottom Sheet ─
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
        showDragHandle: true,
        dragHandleColor: AppColors.borderLight,
      ),

      // ─ Snackbar ─
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        behavior: SnackBarBehavior.floating,
      ),

      // ─ Tab Bar ─
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMutedLight,
        labelStyle: AppTypography.titleMedium,
        unselectedLabelStyle: AppTypography.bodyMedium,
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: AppColors.primary, width: 2)),
      ),

      // ─ Navigation Rail (sidebar on narrow screens) ─
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.textMutedLight),
        selectedLabelTextStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(color: AppColors.textMutedLight),
      ),

      // ─ Divider ─
      dividerTheme: const DividerThemeData(color: AppColors.dividerLight, space: 1, thickness: 1),

      // ─ Tooltip ─
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: AppColors.textPrimaryLight, borderRadius: AppRadius.borderSm),
        textStyle: AppTypography.bodySmall.copyWith(color: Colors.white),
      ),

      // ─ Progress Indicator ─
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.borderSubtleLight,
      ),

      // ─ Switch ─
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textDisabledLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.borderLight;
        }),
      ),

      // ─ Checkbox ─
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: AppColors.primary20),
      ),

      // ─ Radio ─
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textMutedLight;
        }),
      ),

      // ─ Data Table ─
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTypography.overline.copyWith(color: AppColors.textMutedLight),
        dataTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        headingRowColor: WidgetStateProperty.all(AppColors.inputBgLight),
        dividerThickness: 1,
      ),

      // ─ Badge ─
      badgeTheme: const BadgeThemeData(backgroundColor: AppColors.badge, textColor: Colors.white, smallSize: 8, largeSize: 16),
    );
  }

  // ─── Dark Theme ──────────────────────────────────────────
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme(isDark: true),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // ─ App Bar ─
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.cardDark,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: Border(bottom: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.5))),
      ),

      // ─ Card ─
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: const BorderSide(color: AppColors.borderSubtleDark),
        ),
        margin: EdgeInsets.zero,
      ),

      // ─ Elevated Button (Primary CTA) ─
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Outlined Button ─
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          side: const BorderSide(color: AppColors.borderDark),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Text Button ─
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Filled Button (Tonal) ─
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary10,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ─ Input Decoration ─
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBgDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: AppRadius.borderMd, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.primary10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.titleMedium.copyWith(color: AppColors.textSecondaryDark),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textDisabledDark),
        prefixIconColor: AppColors.textMutedDark,
        suffixIconColor: AppColors.textMutedDark,
      ),

      // ─ Dialog ─
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
      ),

      // ─ Bottom Sheet ─
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
        showDragHandle: true,
        dragHandleColor: AppColors.borderDark,
      ),

      // ─ Snackbar ─
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        behavior: SnackBarBehavior.floating,
      ),

      // ─ Divider ─
      dividerTheme: const DividerThemeData(color: AppColors.dividerDark, space: 1, thickness: 1),

      // ─ Switch ─
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textDisabledDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.borderDark;
        }),
      ),

      // ─ Checkbox ─
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: AppColors.primary20),
      ),

      // ─ Data Table ─
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTypography.overline.copyWith(color: AppColors.textMutedDark),
        dataTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        headingRowColor: WidgetStateProperty.all(AppColors.inputBgDark),
        dividerThickness: 1,
      ),

      // ─ Badge ─
      badgeTheme: const BadgeThemeData(backgroundColor: AppColors.badge, textColor: Colors.white, smallSize: 8, largeSize: 16),
    );
  }
}
