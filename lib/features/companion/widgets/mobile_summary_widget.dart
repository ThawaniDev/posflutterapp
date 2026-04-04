import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/companion/providers/companion_providers.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

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
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_actions,
                    label: l10n.companionPendingOrders,
                    value: '$pendingOrders',
                    color: pendingOrders > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    label: l10n.companionActiveStaff,
                    value: '$activeStaff',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.inventory_2,
                    label: l10n.companionLowStock,
                    value: '$lowStockItems',
                    color: lowStockItems > 0 ? AppColors.error : AppColors.success,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: _StatCard(
                    icon: Icons.sync,
                    label: l10n.companionLastSync,
                    value: lastSync ?? '-',
                    color: AppColors.textSecondary,
                    isSmallText: true,
                  ),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, this.isSmallText = false});

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isSmallText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            AppSpacing.gapH8,
            Text(
              value,
              style: isSmallText
                  ? theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)
                  : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapH4,
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
