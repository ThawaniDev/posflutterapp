import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';

class RecentOrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const RecentOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Orders', style: AppTypography.headlineSmall),
          AppSpacing.gapH12,
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No orders yet',
                  style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            )
          else
            ...orders.take(5).map((order) => _OrderRow(order: order, isDark: isDark)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isDark;

  const _OrderRow({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'unknown';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${order['order_number'] ?? '-'}', style: AppTypography.titleSmall),
                Text(
                  order['created_at'] as String? ?? '',
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              order['customer_name'] as String? ?? 'Walk-in',
              style: AppTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSpacing.gapW8,
          PosBadge(label: status, variant: _statusVariant(status)),
          AppSpacing.gapW8,
          Text('\u0081 ${((order['total'] != null ? double.tryParse((order['total'].toString())) : null) ?? 0).toStringAsFixed(2)}', style: AppTypography.labelMedium),
        ],
      ),
    );
  }

  PosBadgeVariant _statusVariant(String status) {
    return switch (status) {
      'completed' => PosBadgeVariant.success,
      'pending' => PosBadgeVariant.warning,
      'cancelled' || 'refunded' => PosBadgeVariant.error,
      _ => PosBadgeVariant.info,
    };
  }
}
