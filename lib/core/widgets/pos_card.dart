import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS CARD — unified card wrapper
// ─────────────────────────────────────────────────────────────

/// Base themeable card.
class PosCard extends StatelessWidget {
  const PosCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.elevation,
    this.onTap,
    this.shadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double? elevation;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = color ?? (isDark ? AppColors.cardDark : AppColors.cardLight);
    final br = borderRadius ?? AppRadius.borderLg;
    final borderSide = border ?? Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(color: bg, borderRadius: br, border: borderSide, boxShadow: shadow),
      padding: padding ?? AppSpacing.paddingAll16,
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, borderRadius: br, child: card),
      );
    }

    return card;
  }
}

// ─────────────────────────────────────────────────────────────
// KPI / STAT CARD — responsive (compact squares on mobile)
// ─────────────────────────────────────────────────────────────

/// KPI metric card: icon, label, value, trend.
///
/// On mobile (compact mode), renders as a square tile with centred layout,
/// smaller icon & text. On desktop, uses the wider horizontal layout.
class PosKpiCard extends StatelessWidget {
  const PosKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    this.trend,
    this.trendLabel,
    this.subtitle,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;

  /// Positive = up (green), negative = down (red), null = neutral.
  final double? trend;
  final String? trendLabel;
  final String? subtitle;
  final VoidCallback? onTap;

  /// When true, uses a smaller square-friendly layout (auto-set by [PosKpiGrid]).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    if (compact) return _buildCompact(context, isDark, mutedColor, secondaryColor);
    return _buildExpanded(context, isDark, mutedColor, secondaryColor);
  }

  /// Mobile square tile — centred, smaller type.
  Widget _buildCompact(BuildContext context, bool isDark, Color mutedColor, Color secondaryColor) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBg = iconBgColor ?? effectiveIconColor.withValues(alpha: 0.1);
    final isPositive = (trend ?? 0) >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;

    return PosCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon + trend pill row
          if (icon != null || trend != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: effectiveIconBg, borderRadius: AppRadius.borderMd),
                    child: Center(child: Icon(icon, size: 16, color: effectiveIconColor)),
                  ),
                if (icon != null && trend != null) const SizedBox(width: 6),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(color: trendColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 10, color: trendColor),
                        AppSpacing.gapW2,
                        Text(
                          '${isPositive ? '+' : ''}${trend!.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          AppSpacing.gapH8,
          // Value
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH2,
          // Label
          Text(
            label,
            style: AppTypography.micro.copyWith(color: secondaryColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            AppSpacing.gapH2,
            Text(
              subtitle!,
              style: AppTypography.micro.copyWith(color: mutedColor, fontSize: 9),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Desktop / wide layout — left-aligned, bigger type.
  Widget _buildExpanded(BuildContext context, bool isDark, Color mutedColor, Color secondaryColor) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBg = iconBgColor ?? effectiveIconColor.withValues(alpha: 0.1);
    final isPositive = (trend ?? 0) >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;

    return PosCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: icon + trend pill
          Row(
            children: [
              if (icon != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: effectiveIconBg, borderRadius: AppRadius.borderMd),
                  child: Center(child: Icon(icon, size: 20, color: effectiveIconColor)),
                ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: trendColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 12, color: trendColor),
                      AppSpacing.gapW2,
                      Text(
                        '${isPositive ? '+' : ''}${trend!.toStringAsFixed(1)}%',
                        style: AppTypography.micro.copyWith(color: trendColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          AppSpacing.gapH8,
          // Value
          Text(value, style: AppTypography.headlineMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          AppSpacing.gapH2,
          // Label
          Text(
            label,
            style: AppTypography.micro.copyWith(color: secondaryColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (trendLabel != null) ...[
            AppSpacing.gapH2,
            Text(trendLabel!, style: AppTypography.micro.copyWith(color: mutedColor), maxLines: 1),
          ],
          if (subtitle != null) ...[
            AppSpacing.gapH2,
            Text(
              subtitle!,
              style: AppTypography.micro.copyWith(color: mutedColor, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// KPI GRID — responsive wrapper (2-col squares on phone)
// ─────────────────────────────────────────────────────────────

/// Lays out [PosKpiCard]s in a responsive grid.
///
/// Phone: 2 columns, square aspect ratio, compact cards.
/// Tablet: [tabletCols] columns (default 3).
/// Desktop: [desktopCols] columns (default 4).
class PosKpiGrid extends StatelessWidget {
  const PosKpiGrid({
    super.key,
    required this.cards,
    this.desktopCols = 4,
    this.tabletCols = 3,
    this.mobileCols = 2,
    this.mobileAspectRatio = 1.0,
    this.tabletAspectRatio = 1.4,
    this.desktopAspectRatio = 1.7,
    this.spacing = 10,
  });

  final List<PosKpiCard> cards;
  final int desktopCols;
  final int tabletCols;
  final int mobileCols;
  final double mobileAspectRatio;
  final double tabletAspectRatio;
  final double desktopAspectRatio;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final bool isMobile = w < 600;
        final bool isTablet = w >= 600 && w < 1000;

        final crossAxisCount = isMobile
            ? mobileCols
            : isTablet
            ? tabletCols
            : desktopCols;

        final aspectRatio = isMobile
            ? mobileAspectRatio
            : isTablet
            ? tabletAspectRatio
            : desktopAspectRatio;

        // On mobile, force compact mode on cards
        final effectiveCards = isMobile
            ? cards
                  .map(
                    (c) => PosKpiCard(
                      key: c.key,
                      label: c.label,
                      value: c.value,
                      icon: c.icon,
                      iconColor: c.iconColor,
                      iconBgColor: c.iconBgColor,
                      trend: c.trend,
                      trendLabel: c.trendLabel,
                      subtitle: c.subtitle,
                      onTap: c.onTap,
                      compact: true,
                    ),
                  )
                  .toList()
            : cards;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
          children: effectiveCards,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PRODUCT CARD (POS grid)
// ─────────────────────────────────────────────────────────────

/// Product tile for the POS terminal grid view.
class PosProductCard extends StatelessWidget {
  const PosProductCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.category,
    this.stockStatus,
    this.onTap,
    this.isCompact = false,
  });

  final String name;
  final String price;
  final String? imageUrl;
  final String? category;

  /// 'in_stock' | 'low' | 'out'
  final String? stockStatus;
  final VoidCallback? onTap;
  final bool isCompact;

  Color get _stockDotColor {
    switch (stockStatus) {
      case 'low':
        return AppColors.stockMedium;
      case 'out':
        return AppColors.stockOut;
      default:
        return AppColors.stockInStock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      padding: EdgeInsets.all(isCompact ? 8 : 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.inputBgLight,
                borderRadius: AppRadius.borderMd,
                image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
              ),
              child: imageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 32,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: isCompact ? 6 : 8),
          // Category
          if (category != null && !isCompact)
            Text(
              category!,
              style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          // Name
          Text(
            name,
            style: (isCompact ? AppTypography.labelSmall : AppTypography.titleSmall).copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: isCompact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isCompact ? 2 : 4),
          // Price + stock dot
          Row(
            children: [
              Expanded(
                child: Text(
                  price,
                  style: (isCompact ? AppTypography.priceSmall : AppTypography.priceMedium).copyWith(color: AppColors.primary),
                ),
              ),
              if (stockStatus != null)
                Container(
                  width: AppSizes.dotSm,
                  height: AppSizes.dotSm,
                  decoration: BoxDecoration(color: _stockDotColor, shape: BoxShape.circle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PRODUCT LIST CARD
// ─────────────────────────────────────────────────────────────

/// Horizontal product card for list/management views.
class PosProductListCard extends StatelessWidget {
  const PosProductListCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String name;
  final String price;
  final String? imageUrl;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      padding: AppSpacing.paddingAll12,
      onTap: onTap,
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.inputBgLight,
              borderRadius: AppRadius.borderMd,
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.image_rounded, size: 24, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                : null,
          ),
          AppSpacing.gapW12,
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                AppSpacing.gapH4,
                Text(price, style: AppTypography.priceSmall.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SETTINGS CARD
// ─────────────────────────────────────────────────────────────

/// Settings section card with icon, title, subtitle, and optional control.
class PosSettingsCard extends StatelessWidget {
  const PosSettingsCard({super.key, required this.title, this.subtitle, this.icon, this.iconColor, this.trailing, this.onTap});

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.10),
                borderRadius: AppRadius.borderMd,
              ),
              child: Center(child: Icon(icon, size: 20, color: iconColor ?? AppColors.primary)),
            ),
            AppSpacing.gapW12,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STAFF CARD
// ─────────────────────────────────────────────────────────────

/// Staff/employee card with avatar, name, role, status.
class PosStaffCard extends StatelessWidget {
  const PosStaffCard({super.key, required this.name, required this.role, this.avatarUrl, this.isActive = true, this.onTap});

  final String name;
  final String role;
  final String? avatarUrl;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary10,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? Text(
                        name.substring(0, 1).toUpperCase(),
                        style: AppTypography.headlineMedium.copyWith(color: AppColors.primary),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: AppSizes.dotMd,
                  height: AppSizes.dotMd,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success : AppColors.stockOut,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH8,
          Text(name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          Builder(
            builder: (ctx) {
              final isDark = Theme.of(ctx).brightness == Brightness.dark;
              return Text(
                role,
                style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SUBSCRIPTION CARD
// ─────────────────────────────────────────────────────────────

/// Subscription / plan card.
class PosSubscriptionCard extends StatelessWidget {
  const PosSubscriptionCard({
    super.key,
    required this.planName,
    required this.price,
    this.billingCycle,
    this.features = const [],
    this.isCurrentPlan = false,
    this.isFeatured = false,
    this.onSelect,
  });

  final String planName;
  final String price;
  final String? billingCycle;
  final List<String> features;
  final bool isCurrentPlan;
  final bool isFeatured;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      border: Border.all(color: isFeatured ? AppColors.primary : AppColors.borderLight, width: isFeatured ? 2 : 1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFeatured) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.borderFull),
              child: Text(
                AppLocalizations.of(context)!.subscriptionPopular,
                style: AppTypography.micro.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            AppSpacing.gapH12,
          ],
          Text(planName, style: AppTypography.headlineSmall),
          AppSpacing.gapH4,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: AppTypography.priceLarge.copyWith(color: AppColors.primary)),
              if (billingCycle != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Builder(
                    builder: (ctx) {
                      final isDark = Theme.of(ctx).brightness == Brightness.dark;
                      return Text(
                        '/ $billingCycle',
                        style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      );
                    },
                  ),
                ),
            ],
          ),
          if (features.isNotEmpty) ...[
            AppSpacing.gapH16,
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                    AppSpacing.gapW8,
                    Expanded(child: Text(f, style: AppTypography.bodySmall)),
                  ],
                ),
              ),
            ),
          ],
          if (onSelect != null) ...[
            AppSpacing.gapH16,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentPlan ? AppColors.primary10 : AppColors.primary,
                  foregroundColor: isCurrentPlan ? AppColors.primary : Colors.white,
                ),
                child: Text(isCurrentPlan ? AppLocalizations.of(context)!.currentPlan : AppLocalizations.of(context)!.selectPlan),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
