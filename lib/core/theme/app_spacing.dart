import 'package:flutter/material.dart';

/// Thawani POS Design System — Spacing, Radius, Shadows, Sizing
///
/// Based on a 4px base grid. Derived from stitch HTML prototypes.
class AppSpacing {
  AppSpacing._();

  // ─── Spacing Scale (padding, margin, gap) ────────────────
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // ─── Page Padding ────────────────────────────────────────
  static const double pagePaddingMobile = 16.0; // p-4
  static const double pagePaddingTablet = 24.0; // p-6
  static const double pagePaddingDesktop = 32.0; // p-8

  // ─── Card Internal Padding ───────────────────────────────
  static const double cardPaddingCompact = 12.0; // p-3 (POS product cards)
  static const double cardPadding = 20.0; // p-5
  static const double cardPaddingLarge = 24.0; // p-6
  static const double cardPaddingXL = 32.0; // p-8

  // ─── Section Gaps ────────────────────────────────────────
  static const double sectionGap = 24.0; // gap-6
  static const double sectionGapLarge = 32.0; // gap-8

  // ─── Grid Gap ────────────────────────────────────────────
  static const double gridGap = 16.0; // gap-4
  static const double gridGapLarge = 24.0; // gap-6

  // ─── Form Field Gap ──────────────────────────────────────
  static const double formFieldGap = 16.0; // gap-4
  static const double formFieldGapLarge = 24.0; // gap-6

  // ─── Icon + Text Gap ─────────────────────────────────────
  static const double iconTextGap = 8.0; // gap-2
  static const double iconTextGapSm = 4.0; // gap-1
  static const double iconTextGapLg = 12.0; // gap-3

  // ─── SizedBox Helpers ────────────────────────────────────
  static const SizedBox gapH2 = SizedBox(height: xxs);
  static const SizedBox gapH4 = SizedBox(height: xs);
  static const SizedBox gapH8 = SizedBox(height: sm);
  static const SizedBox gapH12 = SizedBox(height: md);
  static const SizedBox gapH16 = SizedBox(height: base);
  static const SizedBox gapH20 = SizedBox(height: lg);
  static const SizedBox gapH24 = SizedBox(height: xl);
  static const SizedBox gapH32 = SizedBox(height: xxl);
  static const SizedBox gapH40 = SizedBox(height: xxxl);
  static const SizedBox gapH48 = SizedBox(height: huge);

  static const SizedBox gapW2 = SizedBox(width: xxs);
  static const SizedBox gapW4 = SizedBox(width: xs);
  static const SizedBox gapW8 = SizedBox(width: sm);
  static const SizedBox gapW12 = SizedBox(width: md);
  static const SizedBox gapW16 = SizedBox(width: base);
  static const SizedBox gapW20 = SizedBox(width: lg);
  static const SizedBox gapW24 = SizedBox(width: xl);
  static const SizedBox gapW32 = SizedBox(width: xxl);

  // ─── EdgeInsets Presets ──────────────────────────────────
  static const EdgeInsets paddingAll4 = EdgeInsets.all(xs);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(sm);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(md);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(base);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(lg);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(xl);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(xxl);

  static const EdgeInsets paddingH8 = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingH12 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingH16 = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets paddingH24 = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);

  static const EdgeInsets paddingV4 = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingV8 = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingV12 = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingV16 = EdgeInsets.symmetric(vertical: base);

  // ─── Semantic SizedBox Helpers (aliases) ─────────────────
  static const SizedBox verticalXs = SizedBox(height: xs);
  static const SizedBox verticalSm = SizedBox(height: sm);
  static const SizedBox verticalMd = SizedBox(height: md);
  static const SizedBox verticalLg = SizedBox(height: lg);
  static const SizedBox verticalXl = SizedBox(height: xl);

  static const SizedBox horizontalXs = SizedBox(width: xs);
  static const SizedBox horizontalSm = SizedBox(width: sm);
  static const SizedBox horizontalMd = SizedBox(width: md);
  static const SizedBox horizontalLg = SizedBox(width: lg);
  static const SizedBox horizontalXl = SizedBox(width: xl);

  // ─── Semantic EdgeInsets Presets ──────────────────────────
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);
}

/// Border Radius Tokens
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0; // rounded-lg
  static const double lg = 12.0; // rounded-xl — cards, buttons, modals
  static const double xl = 16.0; // rounded-2xl — settings cards, product cards
  static const double xxl = 24.0; // rounded-3xl
  static const double full = 9999.0; // pill / circle

  // ─── Pre-built BorderRadius ──────────────────────────────
  static final BorderRadius borderXs = BorderRadius.circular(xs);
  static final BorderRadius borderSm = BorderRadius.circular(sm);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderLg = BorderRadius.circular(lg);
  static final BorderRadius borderXl = BorderRadius.circular(xl);
  static final BorderRadius borderXxl = BorderRadius.circular(xxl);
  static final BorderRadius borderFull = BorderRadius.circular(full);
}

/// Box Shadow Tokens
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000), // ~5% black
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000), // ~10% black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lg = [BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8))];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x26000000), // ~15% black
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  /// Primary glow — used on CTA buttons
  static List<BoxShadow> primarySm = [
    BoxShadow(color: const Color(0xFFFD8209).withValues(alpha: 0.20), blurRadius: 16, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> primaryLg = [
    BoxShadow(color: const Color(0xFFFD8209).withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8)),
  ];

  /// FAB shadow
  static List<BoxShadow> fab = [
    BoxShadow(color: const Color(0xFFFD8209).withValues(alpha: 0.40), blurRadius: 30, offset: const Offset(0, 8)),
  ];
}

/// Sizing constants
class AppSizes {
  AppSizes._();

  // ─── Icon Sizes ──────────────────────────────────────────
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  // ─── Avatar Sizes ────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;

  // ─── Button Heights ──────────────────────────────────────
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  // ─── App Bar ─────────────────────────────────────────────
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;

  // ─── Sidebar ─────────────────────────────────────────────
  static const double sidebarWidth = 256.0; // w-64
  static const double sidebarCollapsedWidth = 72.0;

  // ─── Notification Badge ──────────────────────────────────
  static const double badgeSize = 16.0;

  // ─── Status Dot ──────────────────────────────────────────
  static const double dotSm = 6.0;
  static const double dotMd = 8.0;
  static const double dotLg = 12.0;

  // ─── Receipt ─────────────────────────────────────────────
  static const double receiptWidth80mm = 302.0; // ~80mm at 96dpi
  static const double receiptWidth58mm = 219.0;

  // ─── Max Widths ──────────────────────────────────────────
  static const double maxWidthLogin = 480.0;
  static const double maxWidthForm = 720.0;
  static const double maxWidthPage = 1280.0; // max-w-7xl
  static const double maxWidthDialog = 540.0;

  // ─── Progress Bar ────────────────────────────────────────
  static const double progressBarHeight = 8.0;
  static const double progressBarHeightSm = 4.0;
  static const double progressBarHeightLg = 16.0;

  // ─── Breakpoints ─────────────────────────────────────────
  static const double breakpointMobile = 640.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointWide = 1280.0;
}
