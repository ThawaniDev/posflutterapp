import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminAnalyticsSystemHealthPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSystemHealthPage({super.key});

  @override
  ConsumerState<AdminAnalyticsSystemHealthPage> createState() => _AdminAnalyticsSystemHealthPageState();
}

class _AdminAnalyticsSystemHealthPageState extends ConsumerState<AdminAnalyticsSystemHealthPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(analyticsSystemHealthProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsSystemHealthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('System Health'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: switch (state) {
        AnalyticsSystemHealthLoading() => const Center(child: CircularProgressIndicator()),
        AnalyticsSystemHealthLoaded(
          storesMonitored: final monitored,
          storesWithErrors: final withErrors,
          totalErrorsToday: final errors,
          syncStatusBreakdown: final syncStatus,
        ) =>
          RefreshIndicator(
            onRefresh: () => ref.read(analyticsSystemHealthProvider.notifier).load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // KPI cards
                Row(
                  children: [
                    Expanded(child: _metricCard('Monitored', '$monitored', Colors.blue, Icons.monitor_heart)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _metricCard('With Errors', '$withErrors', Colors.red, Icons.error)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _metricCard('Total Errors Today', '$errors', Colors.orange, Icons.warning),
                const SizedBox(height: AppSpacing.lg),

                // Sync status breakdown
                const Text('Sync Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                if (syncStatus.isEmpty)
                  const Card(
                    child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No sync data')),
                  )
                else
                  ...syncStatus.entries.map((e) {
                    final isOk = e.key == 'ok' || e.key == 'synced';
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ListTile(
                        leading: Icon(isOk ? Icons.check_circle : Icons.sync_problem, color: isOk ? Colors.green : Colors.orange),
                        title: Text(e.key.toUpperCase()),
                        trailing: Text('${e.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }),
              ],
            ),
          ),
        AnalyticsSystemHealthError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $msg'),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton(
                onPressed: () => ref.read(analyticsSystemHealthProvider.notifier).load(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        _ => const Center(child: Text('Loading system health...')),
      },
    );
  }

  Widget _metricCard(String label, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
                Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
