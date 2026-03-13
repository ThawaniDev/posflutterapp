import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(dashboardProvider.notifier).load())],
      ),
      body: switch (state) {
        DashboardInitial() || DashboardLoading() => const Center(child: CircularProgressIndicator()),
        DashboardError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => ref.read(dashboardProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        DashboardLoaded(:final today, :final yesterday, :final topProducts) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).load(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Today's KPIs
              Text('Today', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Revenue',
                      value: '\$${(today['total_revenue'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      label: 'Transactions',
                      value: '${today['total_transactions'] ?? 0}',
                      icon: Icons.receipt_long,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Net Revenue',
                      value: '\$${(today['net_revenue'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      label: 'Customers',
                      value: '${today['unique_customers'] ?? 0}',
                      icon: Icons.people,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Avg Basket',
                      value: '\$${(today['avg_basket_size'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.shopping_basket,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      label: 'Refunds',
                      value: '\$${(today['total_refunds'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.undo,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              // Comparison with yesterday
              const SizedBox(height: 24),
              Text('vs Yesterday', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _ComparisonRow(
                label: 'Revenue',
                todayVal: (today['total_revenue'] as num? ?? 0).toDouble(),
                yesterdayVal: (yesterday['total_revenue'] as num? ?? 0).toDouble(),
              ),
              _ComparisonRow(
                label: 'Transactions',
                todayVal: (today['total_transactions'] as num? ?? 0).toDouble(),
                yesterdayVal: (yesterday['total_transactions'] as num? ?? 0).toDouble(),
              ),

              // Top Products
              const SizedBox(height: 24),
              Text('Top Products Today', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (topProducts.isEmpty)
                const Card(
                  child: Padding(padding: EdgeInsets.all(16), child: Text('No sales data yet today')),
                )
              else
                ...topProducts.map(
                  (p) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${topProducts.indexOf(p) + 1}')),
                      title: Text(p['product_name'] as String? ?? ''),
                      subtitle: Text('Qty: ${(p['quantity_sold'] as num? ?? 0).toStringAsFixed(1)}'),
                      trailing: Text(
                        '\$${(p['revenue'] as num? ?? 0).toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(color: Colors.green.shade700),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final double todayVal;
  final double yesterdayVal;

  const _ComparisonRow({required this.label, required this.todayVal, required this.yesterdayVal});

  @override
  Widget build(BuildContext context) {
    final diff = yesterdayVal > 0 ? ((todayVal - yesterdayVal) / yesterdayVal * 100) : 0.0;
    final isPositive = diff >= 0;

    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text('Today: ${todayVal.toStringAsFixed(2)} | Yesterday: ${yesterdayVal.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ? Colors.green : Colors.red, size: 18),
            Text(
              '${diff.toStringAsFixed(1)}%',
              style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
