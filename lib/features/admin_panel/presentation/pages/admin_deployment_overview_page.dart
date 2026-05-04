import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminDeploymentOverviewPage extends ConsumerStatefulWidget {
  const AdminDeploymentOverviewPage({super.key});

  @override
  ConsumerState<AdminDeploymentOverviewPage> createState() => _AdminDeploymentOverviewPageState();
}

class _AdminDeploymentOverviewPageState extends ConsumerState<AdminDeploymentOverviewPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deploymentOverviewProvider);

    return PosListPage(
  title: l10n.deploymentOverview,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: _loadData,
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              DeploymentOverviewLoading() => const Center(child: CircularProgressIndicator()),
              DeploymentOverviewError(message: final m) => Center(
                child: Text(m, style: const TextStyle(color: AppColors.error)),
              ),
              DeploymentOverviewLoaded(data: final d) => _buildOverview(d),
              _ => Center(child: Text(l10n.adminLoadOverview)),
            },
          ),
        ],
      ),
);
  }

  Widget _buildOverview(Map<String, dynamic> data) {
    final platforms = (data['data'] as List?) ?? [];
    if (platforms.isEmpty) {
      return Center(child: Text(l10n.adminNoPlatformData));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        final p = platforms[index] as Map<String, dynamic>;
        final activeRelease = p['active_release'] as Map<String, dynamic>?;
        return PosCard(
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
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Text(
                        '${p['total_releases']} releases',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
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
                  Text('Rollout: ${activeRelease['rollout_percentage']}%', style: const TextStyle(color: AppColors.textSecondary)),
                ] else
                  Text(l10n.adminNoActiveRelease, style: const TextStyle(color: AppColors.textSecondary)),
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
