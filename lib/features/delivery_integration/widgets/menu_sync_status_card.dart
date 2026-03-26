import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';

class MenuSyncStatusCard extends StatelessWidget {
  final Map<String, dynamic> syncLog;

  const MenuSyncStatusCard({super.key, required this.syncLog});

  @override
  Widget build(BuildContext context) {
    final platformSlug = syncLog['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final status = syncLog['status'] as String? ?? 'unknown';
    final triggeredBy = syncLog['triggered_by'] as String? ?? '';
    final duration = syncLog['duration_seconds'] as int?;
    final itemsSynced = syncLog['items_synced'] as int? ?? 0;
    final itemsFailed = syncLog['items_failed'] as int? ?? 0;
    final createdAt = syncLog['created_at'] as String?;
    final errorMessage = syncLog['error_message'] as String?;

    final (statusColor, statusIcon) = switch (status) {
      'success' => (AppColors.success, Icons.check_circle),
      'partial' => (AppColors.warning, Icons.warning_amber),
      'failed' => (AppColors.error, Icons.error_outline),
      _ => (AppColors.textSecondary, Icons.help_outline),
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: statusColor.withValues(alpha: 0.12),
                  child: Icon(statusIcon, color: statusColor, size: 18),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platform?.label ?? platformSlug,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Triggered by: $triggeredBy',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH12,
            Divider(height: 1, color: Theme.of(context).dividerColor),
            AppSpacing.gapH12,
            Row(
              children: [
                _MetricChip(label: 'Synced', value: '$itemsSynced', color: AppColors.success),
                AppSpacing.gapW16,
                if (itemsFailed > 0)
                  _MetricChip(label: 'Failed', value: '$itemsFailed', color: AppColors.error),
                if (duration != null) ...[
                  AppSpacing.gapW16,
                  _MetricChip(label: 'Duration', value: '${duration}s', color: AppColors.info),
                ],
                const Spacer(),
                if (createdAt != null)
                  Text(
                    _formatTime(createdAt),
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
              ],
            ),
            if (errorMessage != null) ...[
              AppSpacing.gapH8,
              Container(
                width: double.infinity,
                padding: AppSpacing.paddingAll8,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(fontSize: 11, color: AppColors.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return dateString;
    }
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        AppSpacing.gapW4,
        Text('$label: ', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
