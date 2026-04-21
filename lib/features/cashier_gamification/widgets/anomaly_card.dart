import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_anomaly.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class AnomalyCard extends StatelessWidget {

  const AnomalyCard({super.key, required this.anomaly, this.onReview});
  final CashierAnomaly anomaly;
  final VoidCallback? onReview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isMobile = context.isPhone;
    final locale = Localizations.localeOf(context).languageCode;
    final title = locale == 'ar' ? (anomaly.titleAr ?? anomaly.titleEn ?? '') : (anomaly.titleEn ?? '');
    final description = locale == 'ar' ? (anomaly.descriptionAr ?? anomaly.descriptionEn ?? '') : (anomaly.descriptionEn ?? '');

    return PosCard(
      elevation: 0.5,
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(BorderSide(color: _severityColor.withValues(alpha: 0.3))),
      child: Padding(
        padding: context.responsivePagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_severityIcon, color: _severityColor, size: context.responsiveIconSize),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _SeverityChip(severity: anomaly.severity),
              ],
            ),
            if (description.isNotEmpty) ...[
              AppSpacing.gapH8,
              Text(description, style: theme.textTheme.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
            AppSpacing.gapH8,
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _InfoTag(label: l10n.posCashier, value: anomaly.cashier?.name ?? '—'),
                _InfoTag(label: l10n.txColDate, value: anomaly.detectedDate),
                _InfoTag(label: l10n.cgRisk, value: anomaly.riskScore.toStringAsFixed(0)),
                if (anomaly.metricName != null)
                  _InfoTag(label: anomaly.metricName!, value: anomaly.metricValue.toStringAsFixed(2)),
              ],
            ),
            if (!anomaly.isReviewed && onReview != null) ...[
              AppSpacing.gapH8,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: onReview,
                  icon: const Icon(Icons.rate_review_rounded, size: 16),
                  label: Text(l10n.cgReview),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ),
            ],
            if (anomaly.isReviewed) ...[
              AppSpacing.gapH4,
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                  AppSpacing.gapW4,
                  const Text('Reviewed', style: TextStyle(fontSize: 12, color: AppColors.success)),
                  if (anomaly.reviewNotes != null && anomaly.reviewNotes!.isNotEmpty) ...[
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(
                        anomaly.reviewNotes!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _severityColor {
    switch (anomaly.severity) {
      case 'critical':
        return AppColors.error;
      case 'high':
        return AppColors.rose;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  IconData get _severityIcon {
    switch (anomaly.severity) {
      case 'critical':
        return Icons.error_rounded;
      case 'high':
        return Icons.warning_amber_rounded;
      case 'medium':
        return Icons.info_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}

class _SeverityChip extends StatelessWidget {
  const _SeverityChip({required this.severity});
  final String severity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    switch (severity) {
      case 'critical':
        color = AppColors.error;
        break;
      case 'high':
        color = AppColors.rose;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.info;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
      child: Text(
        severity.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
