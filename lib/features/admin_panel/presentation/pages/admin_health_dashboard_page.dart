import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_state.dart';

class AdminHealthDashboardPage extends ConsumerStatefulWidget {
  const AdminHealthDashboardPage({super.key});

  @override
  ConsumerState<AdminHealthDashboardPage> createState() => _AdminHealthDashboardPageState();
}

class _AdminHealthDashboardPageState extends ConsumerState<AdminHealthDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(healthDashboardProvider.notifier).load();
      ref.read(storeHealthListProvider.notifier).load();
    });
  }

  Color _statusColor(String? status) => switch (status) {
    'healthy' => Colors.green,
    'degraded' => Colors.orange,
    'down' => Colors.red,
    _ => Colors.grey,
  };

  IconData _statusIcon(String? status) => switch (status) {
    'healthy' => Icons.check_circle,
    'degraded' => Icons.warning_amber,
    'down' => Icons.cancel,
    _ => Icons.help_outline,
  };

  IconData _serviceIcon(String? service) => switch (service) {
    'api' => Icons.api,
    'database' => Icons.storage,
    'queue' => Icons.queue,
    'cache' => Icons.cached,
    'storage' => Icons.folder,
    'mail' => Icons.mail_outline,
    _ => Icons.dns,
  };

  @override
  Widget build(BuildContext context) {
    final dashState = ref.watch(healthDashboardProvider);
    final storeState = ref.watch(storeHealthListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Health'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(healthDashboardProvider.notifier).load();
              ref.read(storeHealthListProvider.notifier).load();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Health Summary
            switch (dashState) {
              HealthDashboardInitial() || HealthDashboardLoading() => const Center(child: CircularProgressIndicator()),
              HealthDashboardLoaded(data: final data) => _buildDashboard(data),
              HealthDashboardError(message: final msg) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(msg, style: const TextStyle(color: Colors.red)),
                ),
              ),
            },
            const SizedBox(height: 24),
            // Store Health
            Text('Store Health', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            switch (storeState) {
              StoreHealthListInitial() || StoreHealthListLoading() => const Center(child: CircularProgressIndicator()),
              StoreHealthListLoaded(data: final data) => _buildStoreHealth(data),
              StoreHealthListError(message: final msg) => Text(msg, style: const TextStyle(color: Colors.red)),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(Map<String, dynamic> data) {
    final summary = data['data']?['summary'] as Map<String, dynamic>? ?? {};
    final services = (data['data']?['services'] as List?) ?? [];
    final healthScore = (summary['health_score'] ?? 0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: healthScore / 100,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          healthScore >= 80
                              ? Colors.green
                              : healthScore >= 50
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                      Text(
                        '${healthScore.toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Score', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statChip('Healthy', summary['healthy'] ?? 0, Colors.green),
                          const SizedBox(width: 8),
                          _statChip('Degraded', summary['degraded'] ?? 0, Colors.orange),
                          const SizedBox(width: 8),
                          _statChip('Down', summary['down'] ?? 0, Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // Service cards
        ...services.map((svc) {
          final s = svc as Map<String, dynamic>;
          final status = s['status']?.toString();
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(_serviceIcon(s['service']?.toString()), color: _statusColor(status)),
              title: Text(s['service']?.toString().toUpperCase() ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Response: ${s['response_time_ms'] ?? 'N/A'}ms • Last checked: ${s['checked_at'] ?? 'N/A'}'),
              trailing: Icon(_statusIcon(status), color: _statusColor(status), size: 28),
            ),
          );
        }),
      ],
    );
  }

  Widget _statChip(String label, dynamic value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStoreHealth(Map<String, dynamic> data) {
    final items = (data['data']?['data'] as List?) ?? [];
    if (items.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No store health data available'));
    }
    return Column(
      children: items.take(10).map((item) {
        final s = item as Map<String, dynamic>;
        final syncStatus = s['sync_status']?.toString() ?? 'ok';
        final isOk = syncStatus == 'ok';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(isOk ? Icons.check_circle : Icons.error, color: isOk ? Colors.green : Colors.red),
            title: Text('Store: ${s['store_id']?.toString().substring(0, 8) ?? ''}...'),
            subtitle: Text('Date: ${s['date'] ?? ''} • Errors: ${s['error_count'] ?? 0}'),
            trailing: Chip(
              label: Text(syncStatus, style: const TextStyle(fontSize: 11)),
              backgroundColor: isOk ? Colors.green.shade50 : Colors.red.shade50,
              side: BorderSide.none,
            ),
          ),
        );
      }).toList(),
    );
  }
}
