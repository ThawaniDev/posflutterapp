import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/sync/models/sync_conflict.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ConflictCard extends StatelessWidget {
  final SyncConflict conflict;
  final void Function(String resolution)? onResolve;

  const ConflictCard({super.key, required this.conflict, this.onResolve});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isResolved = conflict.resolvedAt != null;

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isResolved ? Icons.check_circle : Icons.warning_amber,
                  color: isResolved ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    '${conflict.tableName} — ${conflict.recordId.substring(0, 8)}...',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (isResolved)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: AppRadius.borderSm),
                    child: Text(
                      conflict.resolution?.value ?? 'resolved',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success),
                    ),
                  ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DataColumn(title: l10n.localData, data: conflict.localData, color: AppColors.info),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: _DataColumn(title: l10n.cloudData, data: conflict.cloudData, color: AppColors.purple),
                ),
              ],
            ),
            if (!isResolved && onResolve != null) ...[
              AppSpacing.gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PosButton(onPressed: () => onResolve!('local_wins'), variant: PosButtonVariant.outline, label: l10n.useLocal),
                  AppSpacing.gapW8,
                  PosButton(
                    onPressed: () => onResolve!('cloud_wins'),
                    variant: PosButtonVariant.soft,
                    label: l10n.useCloud,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DataColumn extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final Color color;

  const _DataColumn({required this.title, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppSpacing.paddingAll8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH4,
          ...data.entries
              .take(5)
              .map(
                (e) =>
                    Text('${e.key}: ${e.value}', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          if (data.length > 5)
            Text('+${data.length - 5} more...', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
