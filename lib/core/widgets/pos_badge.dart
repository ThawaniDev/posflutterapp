import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────────────────────

/// Semantic status badge: success, warning, error, info, neutral, or custom.
enum PosBadgeVariant { success, warning, error, info, neutral, primary }

class PosBadge extends StatelessWidget {
  const PosBadge({
    super.key,
    required this.label,
    this.variant = PosBadgeVariant.neutral,
    this.icon,
    this.customColor,
    this.customBgColor,
    this.isSmall = false,
  });

  final String label;
  final PosBadgeVariant variant;
  final IconData? icon;
  final Color? customColor;
  final Color? customBgColor;
  final bool isSmall;

  Color _fg(bool isDark) {
    if (customColor != null) return customColor!;
    switch (variant) {
      case PosBadgeVariant.success:
        return AppColors.successDark;
      case PosBadgeVariant.warning:
        return AppColors.warningDark;
      case PosBadgeVariant.error:
        return AppColors.errorDark;
      case PosBadgeVariant.info:
        return AppColors.infoDark;
      case PosBadgeVariant.primary:
        return AppColors.primary;
      case PosBadgeVariant.neutral:
        return isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    }
  }

  Color _bg(bool isDark) {
    if (customBgColor != null) return customBgColor!;
    switch (variant) {
      case PosBadgeVariant.success:
        return AppColors.success.withValues(alpha: 0.10);
      case PosBadgeVariant.warning:
        return AppColors.warning.withValues(alpha: 0.10);
      case PosBadgeVariant.error:
        return AppColors.error.withValues(alpha: 0.10);
      case PosBadgeVariant.info:
        return AppColors.info.withValues(alpha: 0.10);
      case PosBadgeVariant.primary:
        return AppColors.primary10;
      case PosBadgeVariant.neutral:
        return isDark ? AppColors.surfaceDark : AppColors.inputBgLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = _fg(isDark);
    final bg = _bg(isDark);
    final textStyle = isSmall ? AppTypography.micro : AppTypography.labelSmall;
    final hPad = isSmall ? 6.0 : 8.0;
    final vPad = isSmall ? 2.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.borderFull),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: isSmall ? 10 : 12, color: fg), SizedBox(width: isSmall ? 3 : 4)],
          Text(
            label,
            style: textStyle.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TREND BADGE (↑ +12.5% or ↓ -3.2%)
// ─────────────────────────────────────────────────────────────

class PosTrendBadge extends StatelessWidget {
  const PosTrendBadge({super.key, required this.value, this.suffix = '%', this.showIcon = true});

  final double value;
  final String suffix;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    return PosBadge(
      label: '${isPositive ? '+' : ''}${value.toStringAsFixed(1)}$suffix',
      icon: showIcon ? (isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded) : null,
      customColor: color,
      customBgColor: color.withValues(alpha: 0.10),
      isSmall: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STOCK INDICATOR DOT
// ─────────────────────────────────────────────────────────────

class PosStockDot extends StatelessWidget {
  const PosStockDot({super.key, required this.status, this.showLabel = false, this.size});

  /// 'in_stock' | 'low' | 'medium' | 'out'
  final String status;
  final bool showLabel;
  final double? size;

  Color get _color {
    switch (status) {
      case 'low':
      case 'medium':
        return AppColors.stockMedium;
      case 'out':
        return AppColors.stockOut;
      default:
        return AppColors.stockInStock;
    }
  }

  String get _label {
    switch (status) {
      case 'low':
        return 'Low Stock';
      case 'medium':
        return 'Medium';
      case 'out':
        return 'Out of Stock';
      default:
        return 'In Stock';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = size ?? AppSizes.dotSm;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        ),
        if (showLabel) ...[const SizedBox(width: 6), Text(_label, style: AppTypography.labelSmall.copyWith(color: _color))],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NOTIFICATION COUNT BADGE
// ─────────────────────────────────────────────────────────────

/// Circular notification count overlay (wraps a child widget).
class PosCountBadge extends StatelessWidget {
  const PosCountBadge({super.key, required this.count, required this.child, this.showZero = false, this.maxCount = 99});

  final int count;
  final Widget child;
  final bool showZero;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: showZero || count > 0,
      label: Text(count > maxCount ? '$maxCount+' : '$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
      child: child,
    );
  }
}
