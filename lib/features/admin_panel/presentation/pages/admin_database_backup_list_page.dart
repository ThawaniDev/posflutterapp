import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/providers/branch_context_provider.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import '../../widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AdminDatabaseBackupListPage extends ConsumerStatefulWidget {
  const AdminDatabaseBackupListPage({super.key});

  @override
  ConsumerState<AdminDatabaseBackupListPage> createState() => _AdminDatabaseBackupListPageState();
}

class _AdminDatabaseBackupListPageState extends ConsumerState<AdminDatabaseBackupListPage> {

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

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(databaseBackupListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(databaseBackupListProvider);

    return PosListPage(
  title: l10n.databaseBackups,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add, onPressed: () => _showCreateDialog(context),
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              DatabaseBackupListLoading() => const Center(child: CircularProgressIndicator()),
              DatabaseBackupListError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    PosButton(onPressed: () => _loadData(), label: l10n.retry),
                  ],
                ),
              ),
              DatabaseBackupListLoaded(data: final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
);
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No backups found'));
    }
    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          return PosCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: Icon(_backupIcon(item['status']?.toString() ?? ''), color: _backupColor(item['status']?.toString() ?? '')),
              title: Text(item['backup_type']?.toString() ?? 'Backup'),
              subtitle: Text('Status: ${item['status'] ?? 'unknown'}\n${item['created_at'] ?? ''}'),
              isThreeLine: true,
              trailing: Text(item['file_size']?.toString() ?? ''),
            ),
          );
        },
      ),
    );
  }

  IconData _backupIcon(String status) => switch (status) {
    'completed' => Icons.check_circle,
    'in_progress' => Icons.sync,
    'failed' => Icons.error,
    _ => Icons.backup,
  };

  Color _backupColor(String status) => switch (status) {
    'completed' => AppColors.success,
    'in_progress' => AppColors.warning,
    'failed' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  void _showCreateDialog(BuildContext context) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.backupCreate,
      message: 'Start a new manual database backup?',
      confirmLabel: 'Create',
      cancelLabel: 'Cancel',
    );
    if (confirmed == true) {
      ref.read(databaseBackupActionProvider.notifier).create({'backup_type': 'manual'});
    }
  }
}
