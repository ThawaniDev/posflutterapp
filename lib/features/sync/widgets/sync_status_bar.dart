import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class SyncStatusBar extends StatelessWidget {

  const SyncStatusBar({
    super.key,
    required this.serverOnline,
    required this.pendingConflicts,
    required this.failedSyncs,
    this.lastSync,
  });
  final bool serverOnline;
  final int pendingConflicts;
  final int failedSyncs;
  final Map<String, dynamic>? lastSync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: AppSpacing.paddingAll12,
      decoration: BoxDecoration(
        color: serverOnline ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        children: [
          Icon(
            serverOnline ? Icons.cloud_done : Icons.cloud_off,
            color: serverOnline ? AppColors.success : AppColors.error,
            size: 24,
          ),
          AppSpacing.gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serverOnline ? l10n.syncConnected : l10n.syncOfflineStatus,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: serverOnline ? AppColors.success : AppColors.error,
                  ),
                ),
                if (lastSync != null)
                  Text(
                    l10n.syncLastSyncInfo(lastSync!['direction'] as String, lastSync!['records_count'] as int),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (pendingConflicts > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.2), borderRadius: AppRadius.borderSm),
              child: Text(
                l10n.syncPendingConflictsCount(pendingConflicts),
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
              ),
            ),
          if (failedSyncs > 0) ...[
            AppSpacing.gapW8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.2), borderRadius: AppRadius.borderSm),
              child: Text(
                l10n.syncFailedCount(failedSyncs),
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
