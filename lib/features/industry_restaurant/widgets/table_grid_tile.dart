import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/restaurant_table.dart';
import '../enums/restaurant_table_status.dart';

class TableGridTile extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback? onTap;

  const TableGridTile({super.key, required this.table, this.onTap});

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor, icon) = _statusDecoration(table.status ?? RestaurantTableStatus.available);

    return Material(
      color: bgColor,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fgColor, size: 28),
              AppSpacing.gapH4,
              Text(
                table.displayName ?? table.tableNumber,
                style: AppTypography.titleSmall.copyWith(color: fgColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH2,
              Text('${table.seats} seats', style: AppTypography.caption.copyWith(color: fgColor.withValues(alpha: 0.7))),
              if (table.zone != null) ...[
                AppSpacing.gapH2,
                Text(
                  table.zone!,
                  style: TextStyle(fontSize: 10, color: fgColor.withValues(alpha: 0.6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (Color bg, Color fg, IconData icon) _statusDecoration(RestaurantTableStatus status) {
    return switch (status) {
      RestaurantTableStatus.available => (
        AppColors.success.withValues(alpha: 0.1),
        AppColors.success,
        Icons.check_circle_outline,
      ),
      RestaurantTableStatus.occupied => (AppColors.error.withValues(alpha: 0.1), AppColors.error, Icons.dinner_dining),
      RestaurantTableStatus.reserved => (AppColors.warning.withValues(alpha: 0.1), AppColors.warning, Icons.event_seat),
      RestaurantTableStatus.cleaning => (AppColors.info.withValues(alpha: 0.1), AppColors.info, Icons.cleaning_services),
    };
  }
}
