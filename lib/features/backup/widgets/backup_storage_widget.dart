import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BackupStorageWidget extends ConsumerWidget {
  const BackupStorageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(backupStorageProvider);

    return switch (state) {
      BackupStorageInitial() => Center(child: Text(l10n.backupStorageNotLoaded)),
      BackupStorageLoading() => const PosLoading(),
      BackupStorageError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
      BackupStorageLoaded(:final data) => _buildStorage(context, data),
    };
  }

  Widget _buildStorage(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final d = data['data'] as Map<String, dynamic>? ?? data;
    final totalBytes = (d['total_backup_bytes'] as num?)?.toInt() ?? 0;
    final quotaBytes = (d['quota_bytes'] as num?)?.toInt() ?? 1;
    final usagePercent = (d['usage_percentage'] != null ? double.tryParse(d['usage_percentage'].toString()) : null) ?? 0.0;
    final backupCount = (d['backup_count'] as num?)?.toInt() ?? 0;
    final dbBytes = (d['database_backup_bytes'] as num?)?.toInt() ?? 0;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        children: [
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.backupStorage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  AppSpacing.gapH16,
                  LinearProgressIndicator(
                    value: usagePercent / 100,
                    backgroundColor: AppColors.borderFor(context),
                    minHeight: 10,
                    borderRadius: AppRadius.borderMd,
                  ),
                  AppSpacing.gapH8,
                  Text(
                    '${_formatBytes(totalBytes)} / ${_formatBytes(quotaBytes)} (${usagePercent.toStringAsFixed(1)}%)',
                    style: const TextStyle(fontSize: 14),
                  ),
                  AppSpacing.gapH16,
                  _row(context, Icons.backup, 'Backup Count', '$backupCount'),
                  _row(context, Icons.storage, 'Store Backups', _formatBytes(totalBytes)),
                  _row(context, Icons.dns, 'Database Backups', _formatBytes(dbBytes)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.mutedFor(context)),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }
}
