import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';

/// Widget that shows the mobile summary view — essentially what the
/// companion mobile app would see as its dashboard.
class MobileSummaryWidget extends ConsumerWidget {
  const MobileSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(quickStatsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (stats) {
      QuickStatsInitial() || QuickStatsLoading() => const Center(child: CircularProgressIndicator()),
      QuickStatsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      QuickStatsLoaded(
        :final todayRevenue,
        :final todayOrders,
        :final todayTransactions,
        :final pendingOrders,
        :final activeStaff,
        :final lowStockItems,
        :final lastSync,
        :final currency,
      ) =>
        ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // ─── Revenue Banner ─────────────
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.companionTodayRevenue,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    AppSpacing.gapH4,
                    Text(
                      '$currency ${todayRevenue.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.gapH8,
                    Row(
                      children: [
                        _MiniStat(label: l10n.companionOrders, value: '$todayOrders', color: Colors.white),
                        AppSpacing.gapW16,
                        _MiniStat(label: l10n.companionTransactions, value: '$todayTransactions', color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapH12,
            // ─── Quick Stats Grid ─────────────
            PosKpiGrid(
              desktopCols: 4,
              mobileCols: 2,
              cards: [
                PosKpiCard(
                  icon: Icons.pending_actions,
                  label: l10n.companionPendingOrders,
                  value: '$pendingOrders',
                  iconColor: pendingOrders > 0 ? AppColors.warning : AppColors.success,
                ),
                PosKpiCard(
                  icon: Icons.people,
                  label: l10n.companionActiveStaff,
                  value: '$activeStaff',
                  iconColor: AppColors.info,
                ),
                PosKpiCard(
                  icon: Icons.inventory_2,
                  label: l10n.companionLowStock,
                  value: '$lowStockItems',
                  iconColor: lowStockItems > 0 ? AppColors.error : AppColors.success,
                ),
                PosKpiCard(
                  icon: Icons.sync,
                  label: l10n.companionLastSync,
                  value: lastSync ?? '-',
                  iconColor: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
    };
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color.withValues(alpha: 0.8))),
      ],
    );
  }
}

// _StatCard removed — using PosKpiCard via PosKpiGrid
