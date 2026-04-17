import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class SyncLogList extends StatelessWidget {
  final List<Map<String, dynamic>> logs;

  const SyncLogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAll20,
          child: Text(l10n.noSyncHistoryYet, style: theme.textTheme.bodyMedium),
        ),
      );
    }

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Text(l10n.recentSyncActivity, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              final direction = log['direction'] as String? ?? '';
              final status = log['status'] as String? ?? '';
              final count = log['records_count'] as int? ?? 0;

              return ListTile(
                leading: Icon(_directionIcon(direction), color: _statusColor(status)),
                title: Text(
                  '${direction.toUpperCase()} - $count records',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(log['started_at'] as String? ?? ''),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(color: _statusColor(status), fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _directionIcon(String direction) {
    return switch (direction) {
      'push' => Icons.cloud_upload,
      'pull' => Icons.cloud_download,
      'full' => Icons.sync,
      _ => Icons.sync,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'success' => AppColors.success,
      'partial' => AppColors.warning,
      'failed' => AppColors.error,
      _ => AppColors.info,
    };
  }
}
