import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/features/staff/providers/staff_providers.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';

class CommissionSummaryPage extends ConsumerStatefulWidget {
  final String staffId;
  final String staffName;

  const CommissionSummaryPage({super.key, required this.staffId, required this.staffName});

  @override
  ConsumerState<CommissionSummaryPage> createState() => _CommissionSummaryPageState();
}

class _CommissionSummaryPageState extends ConsumerState<CommissionSummaryPage> {
  DateTimeRange? _dateRange;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat.currency(symbol: 'OMR ');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  void _load() {
    ref
        .read(commissionProvider(widget.staffId).notifier)
        .load(
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commissionProvider(widget.staffId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.staffName} - Commissions'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange, tooltip: 'Filter date range'),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: switch (state) {
        CommissionInitial() || CommissionLoading() => const Center(child: CircularProgressIndicator()),
        CommissionError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(msg),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
        CommissionLoaded(summary: final summary) => _buildContent(context, summary),
      },
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> summary) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalEarnings = (summary['total_earnings'] as num?)?.toDouble() ?? 0.0;
    final totalOrders = (summary['total_orders'] as num?)?.toInt() ?? 0;
    final avgPerOrder = (summary['avg_per_order'] as num?)?.toDouble() ?? 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date range indicator
        if (_dateRange != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Chip(
              label: Text('${_dateFormat.format(_dateRange!.start)} – ${_dateFormat.format(_dateRange!.end)}'),
              onDeleted: () {
                setState(() => _dateRange = null);
                _load();
              },
            ),
          ),

        // Summary cards
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Total Earnings',
                value: _currencyFormat.format(totalEarnings),
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Total Orders',
                value: totalOrders.toString(),
                icon: Icons.receipt_long,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Avg / Order',
                value: _currencyFormat.format(avgPerOrder),
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Performance section
        Text('Performance Overview', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: totalOrders == 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.analytics_outlined, size: 48, color: colorScheme.outline),
                        const SizedBox(height: 16),
                        Text('No commission data for this period', style: TextStyle(color: colorScheme.outline)),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MetricRow(label: 'Total Commission Earned', value: _currencyFormat.format(totalEarnings)),
                      const Divider(),
                      _MetricRow(label: 'Orders with Commission', value: '$totalOrders'),
                      const Divider(),
                      _MetricRow(label: 'Average per Order', value: _currencyFormat.format(avgPerOrder)),
                      const Divider(),
                      _MetricRow(
                        label: 'Effective Rate',
                        value: totalEarnings > 0 && totalOrders > 0
                            ? '${(avgPerOrder / totalEarnings * 100).toStringAsFixed(1)}%'
                            : '0.0%',
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _load();
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Summary Card
// ═══════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
