import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// LOADING INDICATOR
// ─────────────────────────────────────────────────────────────

/// Centered loading spinner with optional message.
class PosLoading extends StatelessWidget {
  const PosLoading({super.key, this.message, this.size = 36});

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
          ),
          if (message != null) ...[
            AppSpacing.gapH12,
            Text(
              message!,
              style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer placeholder for card content (skeleton loader).
class PosShimmer extends StatelessWidget {
  const PosShimmer({super.key, this.width, this.height = 16, this.borderRadius});

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.borderDark : AppColors.borderSubtleLight,
        borderRadius: borderRadius ?? AppRadius.borderSm,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────

/// "No data" placeholder with illustration area, title, and action button.
class PosEmptyState extends StatelessWidget {
  const PosEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconSize = 64,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final double iconSize;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.primary10, shape: BoxShape.circle),
                child: Icon(icon, size: 40, color: AppColors.primary),
              ),
              AppSpacing.gapH24,
            ],
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.gapH8,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapH24,
              FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add), label: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AVATAR
// ─────────────────────────────────────────────────────────────

/// User avatar with optional online status dot and image fallback.
class PosAvatar extends StatelessWidget {
  const PosAvatar({super.key, this.imageUrl, this.name, this.radius = 20, this.showStatus = false, this.isOnline = false});

  final String? imageUrl;
  final String? name;
  final double radius;
  final bool showStatus;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary10,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              (name ?? '?').substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: radius * 0.8, fontWeight: FontWeight.w700, color: AppColors.primary),
            )
          : null,
    );

    if (!showStatus) return avatar;

    return Stack(
      children: [
        avatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: radius * 0.5,
            height: radius * 0.5,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.stockOut,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? AppColors.cardDark : Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DIVIDER
// ─────────────────────────────────────────────────────────────

/// Themed divider with optional label text.
class PosDivider extends StatelessWidget {
  const PosDivider({super.key, this.label, this.thickness = 1, this.indent = 0, this.endIndent = 0, this.height = 24});

  final String? label;
  final double thickness;
  final double indent;
  final double endIndent;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    if (label == null) {
      return Divider(height: height, thickness: thickness, indent: indent, endIndent: endIndent, color: dividerColor);
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: thickness, indent: indent, color: dividerColor),
          ),
          Padding(
            padding: AppSpacing.paddingH12,
            child: Text(
              label!,
              style: AppTypography.overline.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
          Expanded(
            child: Divider(thickness: thickness, endIndent: endIndent, color: dividerColor),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROGRESS BAR
// ─────────────────────────────────────────────────────────────

/// Linear progress bar with optional label and percentage text.
class PosProgressBar extends StatelessWidget {
  const PosProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = true,
    this.height,
    this.color,
    this.trackColor,
  });

  /// 0.0 – 1.0
  final double value;
  final String? label;
  final bool showPercentage;
  final double? height;
  final Color? color;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barHeight = height ?? AppSizes.progressBarHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                if (showPercentage)
                  Text(
                    '${(value * 100).toInt()}%',
                    style: AppTypography.labelSmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: AppRadius.borderFull,
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: barHeight,
            color: color ?? AppColors.primary,
            backgroundColor: trackColor ?? (isDark ? AppColors.borderDark : AppColors.borderSubtleLight),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION CONTAINER
// ─────────────────────────────────────────────────────────────

/// Section wrapper with optional title header and responsive padding.
class PosSection extends StatelessWidget {
  const PosSection({super.key, required this.child, this.title, this.titleAction, this.padding});

  final Widget child;
  final String? title;
  final Widget? titleAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: padding ?? AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: AppTypography.headlineSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                ?titleAction,
              ],
            ),
            AppSpacing.gapH16,
          ],
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PAGE CONTAINER
// ─────────────────────────────────────────────────────────────

/// Full-page wrapper with max width constraint and responsive padding.
class PosPageContainer extends StatelessWidget {
  const PosPageContainer({super.key, required this.child, this.maxWidth, this.padding});

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final pagePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: width < AppSizes.breakpointTablet
              ? AppSpacing.pagePaddingMobile
              : width < AppSizes.breakpointDesktop
              ? AppSpacing.pagePaddingTablet
              : AppSpacing.pagePaddingDesktop,
          vertical: AppSpacing.base,
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? AppSizes.maxWidthPage),
        child: Padding(padding: pagePadding, child: child),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM NAVIGATION BAR (mobile)
// ─────────────────────────────────────────────────────────────

/// Mobile bottom nav with 4-5 destiantion items.
class PosBottomNav extends StatelessWidget {
  const PosBottomNav({super.key, required this.currentIndex, required this.onTap, this.items});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem>? items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navItems =
        items ??
        [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard_rounded), label: l10n.navHome),
          BottomNavigationBarItem(icon: const Icon(Icons.point_of_sale_rounded), label: l10n.navPos),
          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long_rounded), label: l10n.navOrders),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2_rounded), label: l10n.navCatalog),
          BottomNavigationBarItem(icon: const Icon(Icons.more_horiz_rounded), label: l10n.navMore),
        ];

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: AppColors.primary10,
      destinations: navItems
          .map((item) => NavigationDestination(icon: item.icon, selectedIcon: item.activeIcon, label: item.label ?? ''))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIZARD / STEPPER
// ─────────────────────────────────────────────────────────────

/// Horizontal step indicator for onboarding / multi-step flows.
class PosStepIndicator extends StatelessWidget {
  const PosStepIndicator({super.key, required this.totalSteps, required this.currentStep, this.labels});

  final int totalSteps;

  /// 0-indexed current step.
  final int currentStep;
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isCompleted = i < currentStep;
        final isCurrent = i == currentStep;
        final isLast = i == totalSteps - 1;

        return Expanded(
          child: Row(
            children: [
              // Circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary
                      : isCurrent
                      ? AppColors.primary10
                      : AppColors.inputBgLight,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: AppColors.primary, width: 2) : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            color: isCurrent
                                ? AppColors.primary
                                : (Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              // Connector line
              if (!isLast) Expanded(child: Container(height: 2, color: isCompleted ? AppColors.primary : AppColors.borderLight)),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RESPONSIVE SCAFFOLD (sidebar + content)
// ─────────────────────────────────────────────────────────────

/// Adaptive layout: sidebar on desktop, bottom-nav on mobile.
class PosResponsiveScaffold extends StatelessWidget {
  const PosResponsiveScaffold({
    super.key,
    required this.body,
    this.sidebar,
    this.appBar,
    this.bottomNav,
    this.floatingActionButton,
  });

  final Widget body;
  final Widget? sidebar;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNav;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppSizes.breakpointDesktop;

    if (isDesktop && sidebar != null) {
      return Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            sidebar!,
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(appBar: appBar, body: body, bottomNavigationBar: bottomNav, floatingActionButton: floatingActionButton);
  }
}
