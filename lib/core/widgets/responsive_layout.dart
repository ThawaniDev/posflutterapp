import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

// ═══════════════════════════════════════════════════════════════
// Responsive Layout Utilities
// ═══════════════════════════════════════════════════════════════

/// Device type based on screen width.
enum DeviceType { mobile, tablet, desktop, wide }

/// Extension on BuildContext for responsive helpers.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppSizes.breakpointTablet;
  bool get isTablet => screenWidth >= AppSizes.breakpointTablet && screenWidth < AppSizes.breakpointDesktop;
  bool get isDesktop => screenWidth >= AppSizes.breakpointDesktop;
  bool get isWide => screenWidth >= AppSizes.breakpointWide;

  /// True for phone-sized screens (< 768).
  bool get isPhone => screenWidth < AppSizes.breakpointTablet;

  /// True for tablet and above (≥ 768).
  bool get isTabletOrAbove => screenWidth >= AppSizes.breakpointTablet;

  DeviceType get deviceType {
    if (screenWidth >= AppSizes.breakpointWide) return DeviceType.wide;
    if (screenWidth >= AppSizes.breakpointDesktop) return DeviceType.desktop;
    if (screenWidth >= AppSizes.breakpointTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Returns the appropriate page padding for the current screen size.
  EdgeInsets get responsivePagePadding => EdgeInsets.all(
    isMobile
        ? AppSpacing.pagePaddingMobile
        : isTablet
        ? AppSpacing.pagePaddingTablet
        : AppSpacing.pagePaddingDesktop,
  );

  /// Returns a horizontal-only page padding.
  EdgeInsets get responsiveHorizontalPadding => EdgeInsets.symmetric(
    horizontal: isMobile
        ? AppSpacing.pagePaddingMobile
        : isTablet
        ? AppSpacing.pagePaddingTablet
        : AppSpacing.pagePaddingDesktop,
  );

  /// Responsive card internal padding (12px mobile, 16px desktop).
  EdgeInsets get responsiveCardPadding =>
      isMobile ? AppSpacing.paddingAll12 : AppSpacing.paddingAll16;

  /// Responsive card internal padding as double (12 mobile, 16 desktop).
  double get responsiveCardPaddingValue =>
      isMobile ? AppSpacing.cardPaddingCompact : AppSpacing.base;

  /// Responsive icon size (20px mobile, 24px desktop).
  double get responsiveIconSize => isMobile ? AppSizes.iconMd : AppSizes.iconLg;

  /// Responsive icon size small (16px mobile, 20px desktop).
  double get responsiveIconSizeSm => isMobile ? AppSizes.iconSm : AppSizes.iconMd;

  /// Responsive avatar size (40px mobile, 48px desktop).
  double get responsiveAvatarSize => isMobile ? AppSizes.avatarMd : AppSizes.avatarLg;

  /// Responsive grid cross-axis count.
  int get responsiveGridCount {
    if (isWide) return 4;
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  /// Number of columns for KPI/stat cards.
  int get responsiveKpiCount {
    if (isWide) return 4;
    if (isDesktop) return 4;
    if (isTablet) return 2;
    return 2;
  }
}

// ═══════════════════════════════════════════════════════════════
// ResponsiveBuilder — switches between mobile/desktop builders
// ═══════════════════════════════════════════════════════════════

/// A widget that builds different UIs for mobile vs desktop.
/// The [mobile] builder is used when width < 768 (phone).
/// The [desktop] builder is used otherwise.
/// Optionally provide [tablet] for 768–1024 range.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.mobile, this.tablet, required this.desktop});

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 0 ? constraints.maxWidth : MediaQuery.sizeOf(context).width;

        if (width < AppSizes.breakpointTablet) {
          return mobile(context);
        }
        if (width < AppSizes.breakpointDesktop && tablet != null) {
          return tablet!(context);
        }
        return desktop(context);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ResponsiveValue — pick a value based on screen size
// ═══════════════════════════════════════════════════════════════

/// Returns different values per breakpoint.
T responsiveValue<T>(BuildContext context, {required T mobile, T? tablet, required T desktop}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < AppSizes.breakpointTablet) return mobile;
  if (width < AppSizes.breakpointDesktop) return tablet ?? desktop;
  return desktop;
}

// ═══════════════════════════════════════════════════════════════
// ResponsiveGrid — adaptive grid layout
// ═══════════════════════════════════════════════════════════════

/// A grid that adapts its cross-axis count to the screen width.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.wideColumns = 4,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = false,
    this.padding,
    this.physics,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int wideColumns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final columns = responsiveValue(context, mobile: mobileColumns, tablet: tabletColumns, desktop: desktopColumns);

    return GridView.count(
      crossAxisCount: context.isWide ? wideColumns : columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: shrinkWrap,
      padding: padding,
      physics: physics ?? (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      children: children,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ResponsiveWrap — Wrap on mobile, Row on desktop
// ═══════════════════════════════════════════════════════════════

/// On phones, wraps children using [Wrap]. On desktop, uses [Row].
class ResponsiveRowWrap extends StatelessWidget {
  const ResponsiveRowWrap({
    super.key,
    required this.children,
    this.spacing = AppSpacing.sm,
    this.runSpacing = AppSpacing.sm,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    if (context.isPhone) {
      return Wrap(spacing: spacing, runSpacing: runSpacing, alignment: alignment, children: children);
    }
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(width: spacing), children[i]],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Responsive two-column → stacked on mobile
// ═══════════════════════════════════════════════════════════════

/// Two-column layout on desktop, stacked on mobile.
class ResponsiveTwoColumn extends StatelessWidget {
  const ResponsiveTwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 3,
    this.rightFlex = 2,
    this.spacing = AppSpacing.base,
  });

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (context.isPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left,
          SizedBox(height: spacing),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftFlex, child: left),
        SizedBox(width: spacing),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ResponsiveSearchFilterBar — search + filters, responsive
// ═══════════════════════════════════════════════════════════════

/// A responsive toolbar with a search field and filter widgets.
///
/// On **mobile**: search on top, filters in an even row below.
/// On **desktop**: all in one row with search expanded.
class ResponsiveSearchFilterBar extends StatelessWidget {
  const ResponsiveSearchFilterBar({
    super.key,
    required this.searchField,
    required this.filters,
    this.spacing = AppSpacing.sm,
  });

  final Widget searchField;
  final List<Widget> filters;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (context.isPhone) {
      return Column(
        children: [
          searchField,
          SizedBox(height: spacing),
          Row(
            children: [
              for (int i = 0; i < filters.length; i++) ...[
                if (i > 0) SizedBox(width: spacing),
                Expanded(child: filters[i]),
              ],
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: searchField),
        SizedBox(width: spacing * 1.5),
        for (int i = 0; i < filters.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          filters[i],
        ],
      ],
    );
  }
}
