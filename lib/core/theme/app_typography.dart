import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Wameed POS Design System — Typography
///
/// Font: Cairo (Arabic-first, supports Latin)
/// Weight scale: ExtraLight(200), Light(300), Regular(400),
///               SemiBold(600), Bold(700), Black(900)
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Cairo';

  // ─── Display (Hero text, main headings) ──────────────────
  /// 48px Black — "Wameed POS" hero text
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.1,
  );

  /// 36px ExtraBold — subscription pricing, grand totals
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.25,
    height: 1.2,
  );

  /// 30px Bold — main page title, cart total
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
  );

  // ─── Headings ────────────────────────────────────────────
  /// 24px Bold — KPI values, page section titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
  );

  /// 20px Bold — page sub-headers, app bar title
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.15,
    height: 1.3,
  );

  /// 18px Bold — section headers, card titles
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // ─── Title (Card headings, nav items) ────────────────────
  /// 16px SemiBold — card sub-headings
  static const TextStyle titleLarge = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  /// 14px SemiBold — form labels, sidebar active
  static const TextStyle titleMedium = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);

  /// 12px SemiBold — small section titles
  static const TextStyle titleSmall = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4);

  // ─── Body ────────────────────────────────────────────────
  /// 16px Regular — default body text
  static const TextStyle bodyLarge = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  /// 14px Regular — body text, form inputs, sidebar links, table cells
  static const TextStyle bodyMedium = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);

  /// 12px Regular — descriptions, labels
  static const TextStyle bodySmall = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // ─── Label ───────────────────────────────────────────────
  /// 14px Bold — button text, nav items
  static const TextStyle labelLarge = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w700, height: 1.4);

  /// 12px Bold — badge text, tag text
  static const TextStyle labelMedium = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w700, height: 1.4);

  /// 10px Bold — micro labels, uppercase tracking
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.4,
  );

  // ─── Caption ─────────────────────────────────────────────
  /// 11px Regular — receipt text, info notes
  static const TextStyle caption = TextStyle(fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w400, height: 1.4);

  /// 10px Regular — timestamps, micro descriptions
  static const TextStyle micro = TextStyle(fontFamily: fontFamily, fontSize: 10, fontWeight: FontWeight.w400, height: 1.4);

  // ─── Uppercase Label ─────────────────────────────────────
  /// 10px Bold Uppercase — category labels, table headers
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.4,
  );

  // ─── Price ───────────────────────────────────────────────
  /// 16px Bold — product card price
  static const TextStyle priceSmall = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w700, height: 1.2);

  /// 24px Bold — cart total, KPI value
  static const TextStyle priceMedium = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2);

  /// 30px Black — grand total
  static const TextStyle priceLarge = TextStyle(fontFamily: fontFamily, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1);

  // ─── Helper: build TextTheme for MaterialApp ─────────────
  static TextTheme textTheme({bool isDark = false}) {
    final color = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: color),
      displayMedium: displayMedium.copyWith(color: color),
      displaySmall: displaySmall.copyWith(color: color),
      headlineLarge: headlineLarge.copyWith(color: color),
      headlineMedium: headlineMedium.copyWith(color: color),
      headlineSmall: headlineSmall.copyWith(color: color),
      titleLarge: titleLarge.copyWith(color: color),
      titleMedium: titleMedium.copyWith(color: color),
      titleSmall: titleSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: color),
      labelLarge: labelLarge.copyWith(color: color),
      labelMedium: labelMedium.copyWith(color: color),
      labelSmall: labelSmall.copyWith(color: color),
    );
  }
}
