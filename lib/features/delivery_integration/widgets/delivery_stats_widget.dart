import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class DeliveryStatsWidget extends StatelessWidget {

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
  final int todayOrders;
  final double todayRevenue;
  final int activeOrders;
  final int pendingOrders;
  final int completedOrders;
  final int activePlatforms;
  final int totalPlatforms;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mutedColor = AppColors.mutedFor(context);

    return PosStatsGrid(
      children: [
        PosKpiCard(label: l10n.deliveryTodayOrders, value: '$todayOrders', icon: Icons.receipt_long, iconColor: AppColors.info),
        PosKpiCard(
          label: l10n.deliveryTodayRevenue,
          value: '${todayRevenue.toStringAsFixed(2)} \u0081',
          icon: Icons.payments_outlined,
          iconColor: AppColors.success,
        ),
        PosKpiCard(
          label: l10n.deliveryActiveOrders,
          value: '$activeOrders',
          icon: Icons.local_shipping,
          iconColor: AppColors.primary,
        ),
        PosKpiCard(
          label: l10n.deliveryPending,
          value: '$pendingOrders',
          icon: Icons.schedule,
          iconColor: pendingOrders > 0 ? AppColors.warning : mutedColor,
        ),
        PosKpiCard(
          label: l10n.deliveryCompleted,
          value: '$completedOrders',
          icon: Icons.check_circle,
          iconColor: AppColors.success,
        ),
        PosKpiCard(
          label: l10n.deliveryPlatforms,
          value: '$activePlatforms/$totalPlatforms',
          icon: Icons.delivery_dining,
          iconColor: AppColors.info,
        ),
      ],
    );
  }
}
