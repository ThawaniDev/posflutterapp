import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminRevenueDashboardPage extends ConsumerStatefulWidget {
  const AdminRevenueDashboardPage({super.key});

  @override
  ConsumerState<AdminRevenueDashboardPage> createState() => _AdminRevenueDashboardPageState();
}

class _AdminRevenueDashboardPageState extends ConsumerState<AdminRevenueDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(revenueDashboardProvider.notifier).loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(revenueDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(revenueDashboardProvider.notifier).loadDashboard(),
          ),
        ],
      ),
      body: switch (state) {
        RevenueDashboardLoading() => const Center(child: CircularProgressIndicator()),
        RevenueDashboardLoaded() => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MRR / ARR Cards
              Row(
                children: [
                  Expanded(child: _metricCard('MRR', '${state.mrr.toStringAsFixed(2)} SAR', Icons.trending_up, Colors.green)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _metricCard('ARR', '${state.arr.toStringAsFixed(2)} SAR', Icons.calendar_today, Colors.blue)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Invoice stats
              Row(
                children: [
                  Expanded(child: _metricCard('Total Invoices', '${state.totalInvoices}', Icons.receipt, Colors.blueGrey)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _metricCard('Paid', '${state.paidInvoices}', Icons.check_circle, Colors.green)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _metricCard('Failed', '${state.failedInvoices}', Icons.error, Colors.red)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Additional metrics
              Row(
                children: [
                  Expanded(child: _metricCard('Upcoming Renewals', '${state.upcomingRenewals}', Icons.event, Colors.orange)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _metricCard(
                      'Hardware Revenue',
                      '${state.hardwareRevenue.toStringAsFixed(2)} SAR',
                      Icons.devices,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _metricCard(
                'Implementation Revenue',
                '${state.implementationRevenue.toStringAsFixed(2)} SAR',
                Icons.build_circle,
                Colors.teal,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Revenue by Status
              Text('Revenue by Status', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...state.revenueByStatus.map(
                (item) => Card(
                  child: ListTile(
                    leading: Icon(Icons.circle, color: _statusColor(item['status'] ?? '')),
                    title: Text((item['status'] as String? ?? '').toUpperCase()),
                    subtitle: Text('${item['count']} invoices'),
                    trailing: Text('${item['revenue']} SAR', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
        RevenueDashboardError(message: final msg) => Center(child: Text('Error: $msg')),
        _ => const Center(child: Text('Loading...')),
      },
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'paid' => Colors.green,
      'pending' => Colors.orange,
      'failed' => Colors.red,
      'refunded' => Colors.purple,
      _ => Colors.grey,
    };
  }
}
