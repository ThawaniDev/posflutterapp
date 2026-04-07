import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/branch_context_provider.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import '../../widgets/admin_branch_bar.dart';

class AdminDataManagementOverviewPage extends ConsumerStatefulWidget {
  const AdminDataManagementOverviewPage({super.key});

  @override
  ConsumerState<AdminDataManagementOverviewPage> createState() => _AdminDataManagementOverviewPageState();
}

class _AdminDataManagementOverviewPageState extends ConsumerState<AdminDataManagementOverviewPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(dataManagementOverviewProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(dataManagementOverviewProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dataManagementOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Management'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              DataManagementOverviewLoading() => const Center(child: CircularProgressIndicator()),
              DataManagementOverviewError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.read(dataManagementOverviewProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              DataManagementOverviewLoaded(data: final data) => _buildOverview(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(Map<String, dynamic> data) {
    final overview = data['data'] as Map<String, dynamic>? ?? data;
    return RefreshIndicator(
      onRefresh: () => ref.read(dataManagementOverviewProvider.notifier).load(storeId: _storeId),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _StatCard(
            title: 'Database Backups',
            icon: Icons.backup,
            stats: overview['database_backups'] as Map<String, dynamic>? ?? {},
          ),
          const SizedBox(height: AppSpacing.md),
          _StatCard(title: 'Sync Operations', icon: Icons.sync, stats: overview['sync'] as Map<String, dynamic>? ?? {}),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, dynamic> stats;

  const _StatCard({required this.title, required this.icon, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...stats.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key.replaceAll('_', ' ').toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
                    Text('${e.value}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
