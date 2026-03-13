import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
        SalesSummaryInitial() || SalesSummaryLoading() => const Center(child: CircularProgressIndicator()),
        SalesSummaryError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
        SalesSummaryLoaded(:final totals, :final daily) => ListView(
          padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),

            // Totals cards
            Text('Overview', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _SummaryCard(
              items: [
                _SummaryItem('Total Revenue', '\$${(totals['total_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Net Revenue', '\$${(totals['net_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Transactions', '${totals['total_transactions']}'),
                _SummaryItem('Avg Basket', '\$${(totals['avg_basket_size'] as num).toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              items: [
                _SummaryItem('Cost', '\$${(totals['total_cost'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Discounts', '\$${(totals['total_discount'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Tax', '\$${(totals['total_tax'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Refunds', '\$${(totals['total_refunds'] as num).toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              items: [
                _SummaryItem('Cash', '\$${(totals['cash_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Card', '\$${(totals['card_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Other', '\$${(totals['other_revenue'] as num).toStringAsFixed(2)}'),
                _SummaryItem('Customers', '${totals['unique_customers']}'),
              ],
            ),

            // Daily breakdown
            const SizedBox(height: 24),
            Text('Daily Breakdown', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (daily.isEmpty)
              const Card(
                child: Padding(padding: EdgeInsets.all(16), child: Text('No data for selected period')),
              )
            else
              ...daily.map(
                (d) => Card(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      Text(item.label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
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
