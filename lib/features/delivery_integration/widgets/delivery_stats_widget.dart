import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class DeliveryStatsWidget extends StatelessWidget {
  final int todayOrders;
  final double todayRevenue;
  final int activeOrders;
  final int pendingOrders;
  final int completedOrders;
  final int activePlatforms;
  final int totalPlatforms;

  const DeliveryStatsWidget({
    super.key,
    required this.todayOrders,
    required this.todayRevenue,
    required this.activeOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.activePlatforms,
    required this.totalPlatforms,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            _StatTile(label: l10n.deliveryTodayOrders, value: '$todayOrders', icon: Icons.receipt_long, color: AppColors.info),
            AppSpacing.gapW12,
            _StatTile(
              label: l10n.deliveryTodayRevenue,
              value: '${todayRevenue.toStringAsFixed(2)} \u0081',
              icon: Icons.payments_outlined,
              color: AppColors.success,
            ),
          ],
        ),
        AppSpacing.gapH12,
        Row(
          children: [
            _StatTile(
              label: l10n.deliveryActiveOrders,
              value: '$activeOrders',
              icon: Icons.local_shipping,
              color: AppColors.primary,
            ),
            AppSpacing.gapW12,
            _StatTile(
              label: l10n.deliveryPending,
              value: '$pendingOrders',
              icon: Icons.schedule,
              color: pendingOrders > 0 ? AppColors.warning : AppColors.textSecondary,
            ),
          ],
        ),
        AppSpacing.gapH12,
        Row(
          children: [
            _StatTile(
              label: l10n.deliveryCompleted,
              value: '$completedOrders',
              icon: Icons.check_circle,
              color: AppColors.success,
            ),
            AppSpacing.gapW12,
            _StatTile(
              label: l10n.deliveryPlatforms,
              value: '$activePlatforms/$totalPlatforms',
              icon: Icons.delivery_dining,
              color: AppColors.info,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSpacing.paddingAll16,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            AppSpacing.gapH8,
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.gapH4,
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
