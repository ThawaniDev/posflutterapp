import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';

class AdminDatabaseBackupListPage extends ConsumerStatefulWidget {
  const AdminDatabaseBackupListPage({super.key});

  @override
  ConsumerState<AdminDatabaseBackupListPage> createState() => _AdminDatabaseBackupListPageState();
}

class _AdminDatabaseBackupListPageState extends ConsumerState<AdminDatabaseBackupListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(databaseBackupListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(databaseBackupListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Backups'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showCreateDialog(context))],
      ),
      body: switch (state) {
        DatabaseBackupListLoading() => const Center(child: CircularProgressIndicator()),
        DatabaseBackupListError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: () => ref.read(databaseBackupListProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        DatabaseBackupListLoaded(data: final data) => _buildList(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No backups found'));
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(databaseBackupListProvider.notifier).load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          return Card(
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

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Backup'),
        content: const Text('Start a new manual database backup?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(databaseBackupActionProvider.notifier).create({'backup_type': 'manual'});
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
