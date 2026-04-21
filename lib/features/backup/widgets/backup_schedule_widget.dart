import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class BackupScheduleWidget extends ConsumerWidget {
  const BackupScheduleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(backupScheduleProvider);

    return switch (state) {
      BackupScheduleInitial() => Center(child: Text(l10n.backupScheduleNotLoaded)),
      BackupScheduleLoading() => const PosLoading(),
      BackupScheduleError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
      BackupScheduleLoaded(:final data) => _buildSchedule(context, data),
    };
  }

  Widget _buildSchedule(BuildContext context, Map<String, dynamic> data) {
    final d = data['data'] as Map<String, dynamic>? ?? data;
    final enabled = d['auto_backup_enabled'] as bool? ?? false;
    final frequency = d['frequency'] as String? ?? 'daily';
    final retentionDays = d['retention_days'] as int? ?? 30;
    final encrypt = d['encrypt_backups'] as bool? ?? false;
    final totalBackups = d['total_backups'] as int? ?? 0;

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
                  const Text('Auto-Backup Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  AppSpacing.gapH16,
                  _row(context, Icons.cloud_upload, 'Auto-Backup', enabled ? 'Enabled' : 'Disabled'),
                  _row(context, Icons.schedule, 'Frequency', frequency[0].toUpperCase() + frequency.substring(1)),
                  _row(context, Icons.date_range, 'Retention', '$retentionDays days'),
                  _row(context, Icons.lock, 'Encryption', encrypt ? 'Enabled' : 'Disabled'),
                  _row(context, Icons.backup, 'Total Backups', '$totalBackups'),
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
}
