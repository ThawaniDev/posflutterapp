import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAdminUserListPage extends ConsumerStatefulWidget {
  const AdminAdminUserListPage({super.key});

  @override
  ConsumerState<AdminAdminUserListPage> createState() => _AdminAdminUserListPageState();
}

class _AdminAdminUserListPageState extends ConsumerState<AdminAdminUserListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(adminUserListProvider.notifier).loadAdmins(storeId: _storeId);
      ref.read(userStatsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(adminUserListProvider.notifier).loadAdmins(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUserListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Team'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Invite Admin',
            onPressed: () {
              // Navigate to invite page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: userStatsProvider,
            cardBuilder: (data) => [
              kpi('Total Admins', data['total_admin_users'] ?? 0, AppColors.primary),
              kpi('Active Admins', data['active_admin_users'] ?? 0, AppColors.success),
              kpi('Provider Users', data['total_provider_users'] ?? 0, AppColors.info),
              kpi('New This Month', data['new_this_month'] ?? 0, AppColors.warning),
            ],
          ),
          Padding(
            padding: AppSpacing.paddingAll16,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search admins...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(adminUserListProvider.notifier).loadAdmins(storeId: _storeId);
                  },
                ),
              ),
              onSubmitted: (v) =>
                  ref.read(adminUserListProvider.notifier).loadAdmins(search: v.isEmpty ? null : v, storeId: _storeId),
            ),
          ),
          Expanded(child: _buildContent(state)),
        ],
      ),
    );
  }

  Widget _buildContent(AdminUserListState state) {
    return switch (state) {
      AdminUserListLoading() => const Center(child: CircularProgressIndicator()),
      AdminUserListError(:final message) => Center(
        child: Text(message, style: const TextStyle(color: AppColors.error)),
      ),
      AdminUserListLoaded(:final admins) =>
        admins.isEmpty
            ? const Center(child: Text('No admin users found'))
            : ListView.builder(
                itemCount: admins.length,
                padding: AppSpacing.paddingAll8,
                itemBuilder: (context, index) => _buildAdminCard(admins[index]),
              ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildAdminCard(Map<String, dynamic> admin) {
    final isActive = admin['is_active'] == true;
    final has2fa = admin['two_factor_enabled'] == true;
    final roles = admin['roles'] as List? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? AppColors.primary : AppColors.error,
          child: Text((admin['name'] as String? ?? 'A')[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Row(
          children: [
            Expanded(child: Text(admin['name']?.toString() ?? 'Unknown')),
            if (has2fa) const Icon(Icons.security, size: 16, color: AppColors.success),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(admin['email']?.toString() ?? ''),
            AppSpacing.gapH4,
            Wrap(
              spacing: 4,
              children: [
                if (!isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(l10n.inactive, style: TextStyle(fontSize: 10, color: AppColors.error)),
                  ),
                for (final r in roles)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text((r as Map)['role_name']?.toString() ?? 'Role', style: const TextStyle(fontSize: 10)),
                  ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
      ),
    );
  }
}
