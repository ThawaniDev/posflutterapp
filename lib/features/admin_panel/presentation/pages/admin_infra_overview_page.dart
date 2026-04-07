import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_failed_jobs_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_backups_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_health_page.dart';

class AdminInfraOverviewPage extends ConsumerStatefulWidget {
  const AdminInfraOverviewPage({super.key});

  @override
  ConsumerState<AdminInfraOverviewPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraOverviewPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(infraOverviewProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(infraOverviewProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infraOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Infrastructure'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              InfraOverviewLoading() => const Center(child: CircularProgressIndicator()),
              InfraOverviewLoaded(data: final resp) => _buildContent(resp),
              InfraOverviewError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.read(infraOverviewProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;

    final failedJobs = data['failed_jobs'] as Map<String, dynamic>? ?? {};
    final backups = data['database_backups'] as Map<String, dynamic>? ?? {};
    final health = data['health_checks'] as Map<String, dynamic>? ?? {};
    final providerBackups = data['provider_backups'] as Map<String, dynamic>? ?? {};

    return RefreshIndicator(
      onRefresh: () async => ref.read(infraOverviewProvider.notifier).load(storeId: _storeId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
              children: [
                _KpiCard(
                  icon: Icons.error_outline,
                  label: 'Failed Jobs (24h)',
                  value: '${failedJobs['last_24h'] ?? 0}',
                  color: (failedJobs['last_24h'] ?? 0) > 0 ? AppColors.error : AppColors.success,
                ),
                _KpiCard(
                  icon: Icons.backup,
                  label: 'Backups',
                  value: '${backups['completed'] ?? 0} / ${backups['total'] ?? 0}',
                  color: AppColors.info,
                ),
                _KpiCard(
                  icon: Icons.monitor_heart,
                  label: 'Health Checks',
                  value: '${health['healthy'] ?? 0} healthy',
                  color: (health['critical'] ?? 0) > 0 ? AppColors.error : AppColors.success,
                ),
                _KpiCard(
                  icon: Icons.cloud_sync,
                  label: 'Provider Backups',
                  value: '${providerBackups['healthy'] ?? 0} / ${providerBackups['total'] ?? 0}',
                  color: (providerBackups['critical'] ?? 0) > 0 ? AppColors.warning : AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Navigation
            const Text('Sections', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            ...[
              _NavTile(
                'Failed Jobs',
                Icons.warning_amber,
                'View & retry failed background jobs',
                () => _navigate(const AdminInfraFailedJobsPage()),
              ),
              _NavTile(
                'Database Backups',
                Icons.storage,
                'Backup history & status',
                () => _navigate(const AdminInfraBackupsPage()),
              ),
              _NavTile(
                'Health Checks',
                Icons.monitor_heart,
                'Service health monitoring',
                () => _navigate(const AdminInfraHealthPage()),
              ),
              _NavTile('Server Metrics', Icons.speed, 'Runtime server information', () => _showServerMetrics()),
            ],
          ],
        ),
      ),
    );
  }

  void _navigate(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _showServerMetrics() async {
    ref.read(infraServerMetricsProvider.notifier).load();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final state = ref.watch(infraServerMetricsProvider);
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            expand: false,
            builder: (ctx, scrollController) => Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: switch (state) {
                InfraListLoading() => const Center(child: CircularProgressIndicator()),
                InfraListLoaded(data: final resp) => _buildMetrics(resp, scrollController),
                InfraListError(message: final msg) => Center(child: Text('Error: $msg')),
                _ => const Center(child: Text('Loading...')),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetrics(Map<String, dynamic> resp, ScrollController scrollController) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    return ListView(
      controller: scrollController,
      children: [
        const Text('Server Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        ...data.entries.map(
          (e) => ListTile(
            dense: true,
            title: Text(
              e.key.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            trailing: Text('${e.value}', style: const TextStyle(fontFamily: 'monospace')),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile(this.title, this.icon, this.subtitle, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
