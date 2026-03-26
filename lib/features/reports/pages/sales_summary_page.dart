import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class SalesSummaryPage extends ConsumerStatefulWidget {
  const SalesSummaryPage({super.key});

  @override
  ConsumerState<SalesSummaryPage> createState() => _SalesSummaryPageState();
}

class _SalesSummaryPageState extends ConsumerState<SalesSummaryPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    ref
        .read(salesSummaryProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.end) : null,
        );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesSummaryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _selectDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        SalesSummaryInitial() || SalesSummaryLoading() => PosLoadingSkeleton.list(),
        SalesSummaryError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        SalesSummaryLoaded(:final totals, :final daily) => ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            if (_dateRange != null)
              Chip(
                label: Text(
                  '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_dateRange!.end)}',
                ),
                onDeleted: () {
                  setState(() => _dateRange = null);
                  _loadData();
                },
              ),
            AppSpacing.gapH8,

            Text('Overview', style: theme.textTheme.titleLarge),
            AppSpacing.gapH12,
            _SummaryCard(
              items: [
                _SummaryItem('Total Revenue', '\$${(totals['total_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Net Revenue', '\$${(totals['net_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Transactions', '${totals['total_transactions']}'),
                _SummaryItem('Avg Basket', '\$${(totals['avg_basket_size'] as num).toStringAsFixed(2)}'),
              ],
            ),
            AppSpacing.gapH12,
            _SummaryCard(
              items: [
                _SummaryItem('Cost', '\$${(totals['total_cost'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Discounts', '\$${(totals['total_discount'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Tax', '\$${(totals['total_tax'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Refunds', '\$${(totals['total_refunds'] as num).toStringAsFixed(2)}'),
              ],
            ),
            AppSpacing.gapH12,
            _SummaryCard(
              items: [
                _SummaryItem('Cash', '\$${(totals['cash_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Card', '\$${(totals['card_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Other', '\$${(totals['other_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Customers', '${totals['unique_customers']}'),
              ],
            ),

            AppSpacing.gapH24,
            Text('Daily Breakdown', style: theme.textTheme.titleLarge),
            AppSpacing.gapH8,
            if (daily.isEmpty)
              const PosEmptyState(title: 'No data for selected period', icon: Icons.calendar_today)
            else
              ...daily.map(
                (d) => Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                  child: ListTile(
                    title: Text(d['date'] as String),
                    subtitle: Text('${d['total_transactions']} orders'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(d['total_revenue'] as num).toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text('Net: \$${(d['net_revenue'] as num).toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      },
    );
  }
}

class _SummaryItem {
  final String label;
  final String value;
  const _SummaryItem(this.label, this.value);
}

class _SummaryCard extends StatelessWidget {
  final List<_SummaryItem> items;
  const _SummaryCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Wrap(
          spacing: 24,
          runSpacing: 12,
          children: items
              .map(
                (item) => SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(item.label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
