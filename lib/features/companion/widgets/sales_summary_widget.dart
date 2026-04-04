import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/companion/providers/companion_providers.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

class SalesSummaryWidget extends ConsumerStatefulWidget {
  const SalesSummaryWidget({super.key});

  @override
  ConsumerState<SalesSummaryWidget> createState() => _SalesSummaryWidgetState();
}

class _SalesSummaryWidgetState extends ConsumerState<SalesSummaryWidget> {
  String _selectedPeriod = 'today';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesSummaryProvider.notifier).load(period: _selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesSummaryProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        // Period selector
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll12,
            child: Row(
              children: [
                Icon(Icons.date_range, size: 20, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(l10n.companionSalesPeriod, style: theme.textTheme.titleSmall),
                const Spacer(),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'today', label: Text(l10n.companionToday)),
                    ButtonSegment(value: 'week', label: Text(l10n.companionThisWeek)),
                    ButtonSegment(value: 'month', label: Text(l10n.companionThisMonth)),
                  ],
                  selected: {_selectedPeriod},
                  onSelectionChanged: (v) {
                    setState(() => _selectedPeriod = v.first);
                    ref.read(salesSummaryProvider.notifier).load(period: _selectedPeriod);
                  },
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapH12,
        // Content
        switch (state) {
          SalesSummaryInitial() || SalesSummaryLoading() => const Center(
            child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
          ),
          SalesSummaryError(:final message) => Card(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
            ),
          ),
          SalesSummaryLoaded(:final totalRevenue, :final totalOrders, :final averageOrderValue, :final dailyBreakdown) => Column(
            children: [
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.attach_money,
                      label: l10n.companionTotalRevenue,
                      value: totalRevenue.toStringAsFixed(2),
                      color: AppColors.success,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.receipt_long,
                      label: l10n.companionTotalOrders,
                      value: '$totalOrders',
                      color: AppColors.primary,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.analytics,
                      label: l10n.companionAvgOrderValue,
                      value: averageOrderValue.toStringAsFixed(2),
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              // Daily breakdown
              if (dailyBreakdown.isNotEmpty)
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppSpacing.paddingAll16,
                        child: Text(l10n.companionDailyBreakdown, style: theme.textTheme.titleSmall),
                      ),
                      const Divider(height: 1),
                      ...dailyBreakdown.map(
                        (day) => ListTile(
                          title: Text(day['date'] as String? ?? '-'),
                          subtitle: Text('${l10n.companionOrders}: ${day['orders'] ?? 0}'),
                          trailing: Text(
                            '${day['revenue'] ?? 0}',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        },
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

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
            Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapH4,
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
