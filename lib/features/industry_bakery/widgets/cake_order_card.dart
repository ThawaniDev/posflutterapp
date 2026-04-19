import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/custom_cake_order.dart';
import '../enums/custom_cake_order_status.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class CakeOrderCard extends StatelessWidget {
  final CustomCakeOrder order;
  final VoidCallback? onTap;
  final ValueChanged<CustomCakeOrderStatus>? onStatusChange;

  const CakeOrderCard({super.key, required this.order, this.onTap, this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(order.description, style: AppTypography.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  if (order.status != null) _statusBadge(order.status!),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                children: [
                  const Icon(Icons.cake, size: 16, color: AppColors.rose),
                  AppSpacing.gapW4,
                  Text('${order.size} · ${order.flavor}', style: AppTypography.bodySmall),
                ],
              ),
              AppSpacing.gapH4,
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  AppSpacing.gapW4,
                  Text(l10n.bakeryDeliveryDateWithValue(order.deliveryDate.toString()), style: AppTypography.bodySmall),
                  const Spacer(),
                  Text(
                    '${order.price.toStringAsFixed(2)} \u0081',
                    style: AppTypography.priceSmall.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(CustomCakeOrderStatus status) {
    final (label, variant) = switch (status) {
      CustomCakeOrderStatus.ordered => ('Ordered', PosStatusBadgeVariant.info),
      CustomCakeOrderStatus.inProgress => ('In Progress', PosStatusBadgeVariant.warning),
      CustomCakeOrderStatus.inProduction => ('In Production', PosStatusBadgeVariant.warning),
      CustomCakeOrderStatus.ready => ('Ready', PosStatusBadgeVariant.success),
      CustomCakeOrderStatus.delivered => ('Delivered', PosStatusBadgeVariant.neutral),
      CustomCakeOrderStatus.cancelled => ('Cancelled', PosStatusBadgeVariant.error),
    };
    return PosStatusBadge(label: label, variant: variant);
  }
}
