import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminInfraBackupsPage extends ConsumerStatefulWidget {
  const AdminInfraBackupsPage({super.key});

  @override
  ConsumerState<AdminInfraBackupsPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraBackupsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(infraDatabaseBackupsProvider.notifier).load(params: params);
    ref.read(infraProviderBackupsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    return PosListPage(
      title: l10n.adminInfraBackups,
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.adminDatabase),
              PosTabItem(label: l10n.hwProvider),
            ],
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: [_DatabaseBackupsTab(), _ProviderBackupsTab()]),
          ),
        ],
      ),
    );
  }
}

class _DatabaseBackupsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(infraDatabaseBackupsProvider);

    return switch (state) {
      InfraListLoading() => const Center(child: CircularProgressIndicator()),
      InfraListLoaded(data: final resp) => _buildList(context, resp),
      InfraListError(message: final msg) => Center(
        child: Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildList(BuildContext context, Map<String, dynamic> resp) {
    final l10n = AppLocalizations.of(context)!;
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.adminNoDatabaseBackups));

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final status = item['status']?.toString() ?? '';
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'completed' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              child: Icon(
                status == 'completed' ? Icons.check_circle_outline : Icons.schedule,
                size: 20,
                color: status == 'completed' ? AppColors.success : AppColors.warning,
              ),
            ),
            title: Text(
              item['disk_name']?.toString() ?? item['file_path']?.toString() ?? 'Backup',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Status: $status  •  Size: ${item['file_size'] ?? 'N/A'}'),
            trailing: Text(item['created_at']?.toString().substring(0, 10) ?? ''),
          ),
        );
      },
    );
  }
}

class _ProviderBackupsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(infraProviderBackupsProvider);

    return switch (state) {
      InfraListLoading() => const Center(child: CircularProgressIndicator()),
      InfraListLoaded(data: final resp) => _buildList(context, resp),
      InfraListError(message: final msg) => Center(
        child: Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildList(BuildContext context, Map<String, dynamic> resp) {
    final l10n = AppLocalizations.of(context)!;
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.adminNoProviderBackups));

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final status = item['status']?.toString() ?? '';
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'success' ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              child: Icon(
                status == 'success' ? Icons.cloud_done : Icons.cloud_off,
                size: 20,
                color: status == 'success' ? AppColors.success : AppColors.error,
              ),
            ),
            title: Text(
              'Provider: ${item['provider_name'] ?? item['provider_type'] ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Status: $status  •  ${item['message'] ?? ''}'),
            trailing: Text(
              item['checked_at']?.toString().substring(0, 10) ?? item['created_at']?.toString().substring(0, 10) ?? '',
            ),
          ),
        );
      },
    );
  }
}
