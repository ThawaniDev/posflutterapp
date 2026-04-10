import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminHealthDashboardPage extends ConsumerStatefulWidget {
  const AdminHealthDashboardPage({super.key});

  @override
  ConsumerState<AdminHealthDashboardPage> createState() => _AdminHealthDashboardPageState();
}

class _AdminHealthDashboardPageState extends ConsumerState<AdminHealthDashboardPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _loadData() {
    ref.read(healthDashboardProvider.notifier).load(storeId: _storeId);
    ref.read(storeHealthListProvider.notifier).load(params: _storeId != null ? {'store_id': _storeId} : null);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  Color _statusColor(String? status) => switch (status) {
    'healthy' => AppColors.success,
    'degraded' => AppColors.warning,
    'down' => AppColors.error,
    _ => AppColors.textSecondary,
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
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: SingleChildScrollView(
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
                        child: Text(msg, style: const TextStyle(color: AppColors.error)),
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
                    StoreHealthListError(message: final msg) => Text(msg, style: const TextStyle(color: AppColors.error)),
                  },
                ],
              ),
            ),
          ),
        ],
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
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation(
                          healthScore >= 80
                              ? AppColors.success
                              : healthScore >= 50
                              ? AppColors.warning
                              : AppColors.error,
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _statChip('Healthy', summary['healthy'] ?? 0, AppColors.success),
                          _statChip('Degraded', summary['degraded'] ?? 0, AppColors.warning),
                          _statChip('Down', summary['down'] ?? 0, AppColors.error),
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
            leading: Icon(isOk ? Icons.check_circle : Icons.error, color: isOk ? AppColors.success : AppColors.error),
            title: Text('Store: ${s['store_id']?.toString().substring(0, 8) ?? ''}...'),
            subtitle: Text('Date: ${s['date'] ?? ''} • Errors: ${s['error_count'] ?? 0}'),
            trailing: Chip(
              label: Text(syncStatus, style: const TextStyle(fontSize: 11)),
              backgroundColor: isOk ? AppColors.success.withValues(alpha: 0.08) : AppColors.error.withValues(alpha: 0.08),
              side: BorderSide.none,
            ),
          ),
        );
      }).toList(),
    );
  }
}
