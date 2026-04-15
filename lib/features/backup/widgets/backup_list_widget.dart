import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';

class BackupListWidget extends ConsumerWidget {
  const BackupListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupListProvider);

    return switch (state) {
      BackupListInitial() => const Center(child: Text('No backups loaded')),
      BackupListLoading() => const Center(child: CircularProgressIndicator()),
      BackupListError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
      BackupListLoaded(:final data) => _buildList(data),
    };
  }

  Widget _buildList(Map<String, dynamic> data) {
    final backups = data['data']?['backups'] as List? ?? [];

    if (backups.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 8),
            Text('No backups yet'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.paddingAll12,
      itemCount: backups.length,
      itemBuilder: (context, index) {
        final b = backups[index] as Map<String, dynamic>;
        final status = b['status'] ?? 'unknown';
        final type = b['backup_type'] ?? 'manual';
        final size = (b['file_size_bytes'] as num?)?.toInt() ?? 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              status == 'completed'
                  ? Icons.check_circle
                  : status == 'failed'
                  ? Icons.error
                  : Icons.hourglass_empty,
              color: status == 'completed'
                  ? AppColors.success
                  : status == 'failed'
                  ? AppColors.error
                  : AppColors.warning,
            ),
            title: Text('${type[0].toUpperCase()}${type.substring(1)} Backup'),
            subtitle: Text('Size: ${_formatBytes(size)} • Status: $status'),
            trailing: b['is_verified'] == true ? const Icon(Icons.verified, color: AppColors.info, size: 20) : null,
          ),
        );
      },
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
