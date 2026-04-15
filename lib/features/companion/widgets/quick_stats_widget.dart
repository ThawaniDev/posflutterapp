import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';

class QuickStatsWidget extends ConsumerWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickStatsProvider);
    final theme = Theme.of(context);

    return switch (state) {
      QuickStatsInitial() || QuickStatsLoading() => const Center(child: CircularProgressIndicator()),
      QuickStatsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      QuickStatsLoaded(
        :final todayRevenue,
        :final todayTransactions,
        :final todayOrders,
        :final pendingOrders,
        :final activeStaff,
        :final lowStockItems,
        :final currency,
      ) =>
        SingleChildScrollView(
          padding: AppSpacing.paddingAll16,
          child: Column(
            children: [
              _buildStatRow(context, [
                _StatTile(
                  icon: Icons.attach_money,
                  label: 'Revenue',
                  value: '$currency ${todayRevenue.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
                _StatTile(icon: Icons.receipt_long, label: 'Transactions', value: '$todayTransactions', color: AppColors.info),
              ]),
              AppSpacing.gapH12,
              _buildStatRow(context, [
                _StatTile(icon: Icons.shopping_bag, label: 'Orders', value: '$todayOrders', color: AppColors.warning),
                _StatTile(icon: Icons.pending_actions, label: 'Pending', value: '$pendingOrders', color: AppColors.error),
              ]),
              AppSpacing.gapH12,
              _buildStatRow(context, [
                _StatTile(icon: Icons.people, label: 'Active Staff', value: '$activeStaff', color: AppColors.info),
                _StatTile(
                  icon: Icons.inventory_2,
                  label: 'Low Stock',
                  value: '$lowStockItems',
                  color: lowStockItems > 0 ? AppColors.error : AppColors.textSecondary,
                ),
              ]),
            ],
          ),
        ),
    };
  }

  Widget _buildStatRow(BuildContext context, List<_StatTile> tiles) {
    return Row(
      children: tiles
          .map(
            (tile) => Expanded(
              child: Card(
                child: Padding(
                  padding: AppSpacing.paddingAll12,
                  child: Column(
                    children: [
                      Icon(tile.icon, color: tile.color, size: 28),
                      AppSpacing.gapH8,
                      Text(tile.value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      AppSpacing.gapH4,
                      Text(tile.label, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatTile {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({required this.icon, required this.label, required this.value, required this.color});
}
