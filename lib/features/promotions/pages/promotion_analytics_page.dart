import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_providers.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_state.dart';

class PromotionAnalyticsPage extends ConsumerStatefulWidget {
  final String promotionId;
  const PromotionAnalyticsPage({super.key, required this.promotionId});

  @override
  ConsumerState<PromotionAnalyticsPage> createState() => _PromotionAnalyticsPageState();
}

class _PromotionAnalyticsPageState extends ConsumerState<PromotionAnalyticsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(promotionAnalyticsProvider(widget.promotionId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.promotionsAnalytics)),
      body: switch (state) {
        PromotionAnalyticsInitial() || PromotionAnalyticsLoading() => const Center(child: CircularProgressIndicator()),
        PromotionAnalyticsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(message, style: TextStyle(color: theme.colorScheme.error)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
        PromotionAnalyticsLoaded(:final analytics) => _buildAnalytics(context, analytics),
      },
    );
  }

  Widget _buildAnalytics(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: l10n.promotionsTotalUses,
                value: '${data['usage_count'] ?? 0}',
                icon: Icons.receipt_long,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: l10n.promotionsTotalDiscount,
                value: '${(data['total_discount_given'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                icon: Icons.discount,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: l10n.promotionsUniqueCustomers,
                value: '${data['unique_customers'] ?? 0}',
                icon: Icons.people,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: l10n.promotionsActiveCoupons,
                value: '${data['active_coupons'] ?? 0}',
                icon: Icons.confirmation_number,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: l10n.promotionsTotalCoupons,
                value: '${data['total_coupons'] ?? 0}',
                icon: Icons.inventory_2,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.promotionsPerformance, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: l10n.promotionsAvgDiscountPerUse, value: _avgDiscount(data)),
                const Divider(),
                _InfoRow(label: l10n.promotionsCouponRedemptionRate, value: _redemptionRate(data)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _avgDiscount(Map<String, dynamic> data) {
    final total = (data['total_discount_given'] as num?)?.toDouble() ?? 0;
    final count = (data['usage_count'] as num?)?.toInt() ?? 0;
    if (count == 0) return '0.00';
    return (total / count).toStringAsFixed(2);
  }

  String _redemptionRate(Map<String, dynamic> data) {
    final totalCoupons = (data['total_coupons'] as num?)?.toInt() ?? 0;
    final activeCoupons = (data['active_coupons'] as num?)?.toInt() ?? 0;
    if (totalCoupons == 0) return 'N/A';
    final used = totalCoupons - activeCoupons;
    return '${(used / totalCoupons * 100).toStringAsFixed(1)}%';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
