import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminDeploymentOverviewPage extends ConsumerStatefulWidget {
  const AdminDeploymentOverviewPage({super.key});

  @override
  ConsumerState<AdminDeploymentOverviewPage> createState() => _AdminDeploymentOverviewPageState();
}

class _AdminDeploymentOverviewPageState extends ConsumerState<AdminDeploymentOverviewPage> {
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
    ref.read(deploymentOverviewProvider.notifier).load(storeId: _storeId);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deploymentOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deployment Overview'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              DeploymentOverviewLoading() => const Center(child: CircularProgressIndicator()),
              DeploymentOverviewError(message: final m) => Center(
                child: Text(m, style: const TextStyle(color: AppColors.error)),
              ),
              DeploymentOverviewLoaded(data: final d) => _buildOverview(d),
              _ => const Center(child: Text('Load overview')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(Map<String, dynamic> data) {
    final platforms = (data['data'] as List?) ?? [];
    if (platforms.isEmpty) {
      return const Center(child: Text('No platform data'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        final p = platforms[index] as Map<String, dynamic>;
        final activeRelease = p['active_release'] as Map<String, dynamic>?;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_icon(p['platform'] ?? ''), color: AppColors.primary, size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      (p['platform'] ?? '').toString().toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${p['total_releases']} releases',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (activeRelease != null) ...[
                  const Divider(),
                  Text(
                    'Active: v${activeRelease['version']}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.success),
                  ),
                  Text('Rollout: ${activeRelease['rollout_percentage']}%', style: TextStyle(color: AppColors.textSecondary)),
                ] else
                  Text('No active release', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _icon(String platform) {
    return switch (platform) {
      'ios' => Icons.phone_iphone,
      'android' => Icons.android,
      'windows' => Icons.desktop_windows,
      'macos' => Icons.laptop_mac,
      _ => Icons.devices,
    };
  }
}
