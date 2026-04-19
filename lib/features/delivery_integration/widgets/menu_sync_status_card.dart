import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class MenuSyncStatusCard extends StatelessWidget {
  final Map<String, dynamic> syncLog;

  const MenuSyncStatusCard({super.key, required this.syncLog});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final platformSlug = syncLog['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final status = syncLog['status'] as String? ?? 'unknown';
    final triggeredBy = syncLog['triggered_by'] as String? ?? '';
    final duration = syncLog['duration_seconds'] as int?;
    final itemsSynced = syncLog['items_synced'] as int? ?? 0;
    final itemsFailed = syncLog['items_failed'] as int? ?? 0;
    final createdAt = syncLog['created_at'] as String?;
    final errorMessage = syncLog['error_message'] as String?;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    final (statusColor, statusIcon, statusVariant) = switch (status) {
      'success' => (AppColors.success, Icons.check_circle, PosStatusBadgeVariant.success),
      'partial' => (AppColors.warning, Icons.warning_amber, PosStatusBadgeVariant.warning),
      'failed' => (AppColors.error, Icons.error_outline, PosStatusBadgeVariant.error),
      _ => (mutedColor, Icons.help_outline, PosStatusBadgeVariant.neutral),
    };

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
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
                      Text(platform?.label ?? platformSlug, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${l10n.deliveryTriggeredBy} $triggeredBy', style: TextStyle(fontSize: 11, color: mutedColor)),
                    ],
                  ),
                ),
                PosStatusBadge(label: status.toUpperCase(), variant: statusVariant),
              ],
            ),
            AppSpacing.gapH12,
            Divider(height: 1, color: Theme.of(context).dividerColor),
            AppSpacing.gapH12,
            Row(
              children: [
                _MetricChip(label: l10n.deliverySynced, value: '$itemsSynced', color: AppColors.success),
                AppSpacing.gapW16,
                if (itemsFailed > 0) _MetricChip(label: l10n.deliveryFailed, value: '$itemsFailed', color: AppColors.error),
                if (duration != null) ...[
                  AppSpacing.gapW16,
                  _MetricChip(label: l10n.deliveryDuration, value: '${duration}s', color: AppColors.info),
                ],
                const Spacer(),
                if (createdAt != null) Text(_formatTime(context, createdAt), style: TextStyle(fontSize: 10, color: mutedColor)),
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
                child: Text(errorMessage, style: TextStyle(fontSize: 11, color: AppColors.error)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, String dateString) {
    final l10n = AppLocalizations.of(context)!;
    try {
      final date = DateTime.parse(dateString);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return l10n.deliveryMinutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return l10n.deliveryHoursAgo(diff.inHours);
      return l10n.deliveryDaysAgo(diff.inDays);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.gapW4,
        Text('$label: ', style: TextStyle(fontSize: 11, color: mutedColor)),
        Text(
          value,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
