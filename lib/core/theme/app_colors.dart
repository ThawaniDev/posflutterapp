import 'package:flutter/material.dart';

/// Thawani POS Design System — Color Tokens
///
/// Brand: Primary Orange (#FD8209), Secondary Yellow (#FFBF0D)
/// Derived from stitch HTML prototypes. Uses warm neutrals.
class AppColors {
  AppColors._();

  // ─── Brand ───────────────────────────────────────────────
  static const Color primary = Color(0xFFFD8209);
  static const Color primaryLight = Color(0xFFFFBF0D);
  static const Color secondary = Color(0xFFFFBF0D);

  /// Opacity helpers for primary
  static Color primary5 = primary.withValues(alpha: 0.05);
  static Color primary10 = primary.withValues(alpha: 0.10);
  static Color primary20 = primary.withValues(alpha: 0.20);
  static Color primary30 = primary.withValues(alpha: 0.30);
  static Color primary50 = primary.withValues(alpha: 0.50);

  // ─── Semantic / Status ───────────────────────────────────
  static const Color success = Color(0xFF10B981); // emerald-500
  static const Color successDark = Color(0xFF059669); // emerald-600
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color warningDark = Color(0xFFB45309); // amber-700
  static const Color error = Color(0xFFEF4444); // red-500
  static const Color errorDark = Color(0xFFDC2626); // red-600
  static const Color info = Color(0xFF3B82F6); // blue-500
  static const Color infoDark = Color(0xFF2563EB); // blue-600
  static const Color purple = Color(0xFFA855F7); // purple-500
  static const Color rose = Color(0xFFF43F5E); // rose-500

  // ─── Background ──────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F7F5); // warm off-white
  static const Color backgroundDark = Color(0xFF23190F); // deep warm brown

  // ─── Surface ─────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B); // slate-800

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF0F172A); // slate-900

  // ─── Text ────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F172A); // slate-900
  static const Color textPrimaryDark = Color(0xFFF1F5F9); // slate-100

  static const Color textSecondaryLight = Color(0xFF475569); // slate-600
  static const Color textSecondaryDark = Color(0xFF94A3B8); // slate-400

  static const Color textMutedLight = Color(0xFF64748B); // slate-500
  static const Color textMutedDark = Color(0xFF94A3B8); // slate-400

  static const Color textDisabledLight = Color(0xFF94A3B8); // slate-400
  static const Color textDisabledDark = Color(0xFF64748B); // slate-500

  // ─── Border ──────────────────────────────────────────────
  static const Color borderLight = Color(0xFFE2E8F0); // slate-200
  static const Color borderDark = Color(0xFF334155); // slate-700

  static const Color borderSubtleLight = Color(0xFFF1F5F9); // slate-100
  static const Color borderSubtleDark = Color(0xFF1E293B); // slate-800

  // ─── Input ───────────────────────────────────────────────
  static const Color inputBgLight = Color(0xFFF8FAFC); // slate-50
  static const Color inputBgDark = Color(0xFF1E293B); // slate-800

  // ─── Hover / Active ──────────────────────────────────────
  static const Color hoverLight = Color(0xFFF8FAFC); // slate-50
  static const Color hoverDark = Color(0xFF1E293B); // slate-800

  // ─── Stock Dots ──────────────────────────────────────────
  static const Color stockInStock = Color(0xFF22C55E); // green-500
  static const Color stockMedium = Color(0xFFF97316); // orange-500
  static const Color stockLow = Color(0xFFEF4444); // red-500
  static const Color stockOut = Color(0xFF94A3B8); // slate-400

  // ─── Notification Badge ──────────────────────────────────
  static const Color badge = Color(0xFFEF4444); // red-500

  // ─── Divider ─────────────────────────────────────────────
  static const Color dividerLight = Color(0xFFF1F5F9); // slate-100
  static const Color dividerDark = Color(0xFF1E293B); // slate-800

  // ─── Gradient ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  /// Light mode MaterialColor swatch
  static const MaterialColor primarySwatch = MaterialColor(0xFFFD8209, {
    50: Color(0xFFFFF7ED),
    100: Color(0xFFFFEDD5),
    200: Color(0xFFFED7AA),
    300: Color(0xFFFDBA74),
    400: Color(0xFFFB923C),
    500: Color(0xFFFD8209),
    600: Color(0xFFEA6C08),
    700: Color(0xFFC2530A),
    800: Color(0xFF9A3F10),
    900: Color(0xFF7C3010),
  });
}
