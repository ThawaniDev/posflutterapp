import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

enum PosStatusBadgeVariant { success, warning, error, info, neutral }

class PosStatusBadge extends StatelessWidget {
  final String label;
  final PosStatusBadgeVariant variant;
  final IconData? icon;

  const PosStatusBadge({
    super.key,
    required this.label,
    this.variant = PosStatusBadgeVariant.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor) = _colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fgColor),
            AppSpacing.gapW4,
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }

  (Color bg, Color fg) get _colors => switch (variant) {
    PosStatusBadgeVariant.success => (AppColors.success.withValues(alpha: 0.12), AppColors.success),
    PosStatusBadgeVariant.warning => (AppColors.warning.withValues(alpha: 0.12), AppColors.warning),
    PosStatusBadgeVariant.error => (AppColors.error.withValues(alpha: 0.12), AppColors.error),
    PosStatusBadgeVariant.info => (AppColors.info.withValues(alpha: 0.12), AppColors.info),
    PosStatusBadgeVariant.neutral => (Colors.grey.withValues(alpha: 0.12), Colors.grey.shade700),
  };
}
