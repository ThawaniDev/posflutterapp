import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/zatca_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ComplianceStatusCard extends StatelessWidget {
  final ZatcaComplianceSummaryLoaded data;

  const ComplianceStatusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_outlined,
                  color: data.successRate >= 90
                      ? AppColors.success
                      : data.successRate >= 70
                          ? AppColors.warning
                          : AppColors.error,
                  size: 28),
              AppSpacing.gapH8,
              Text(l10n.zatcaTitle,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          AppSpacing.gapH20,
          // Success rate
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: l10n.adminWameedAISuccessRate,
                  value: '${data.successRate.toStringAsFixed(1)}%',
                  color: data.successRate >= 90
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: 'Total Invoices',
                  value: '${data.totalInvoices}',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          AppSpacing.gapH12,
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: l10n.deliveryAccepted,
                  value: '${data.accepted}',
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.rejected,
                  value: '${data.rejected}',
                  color: AppColors.error,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.pending,
                  value: '${data.pending}',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          if (data.certificate != null) ...[
            AppSpacing.gapH20,
            Divider(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.06)),
            AppSpacing.gapH8,
            Row(
              children: [
                const Icon(Icons.badge_outlined,
                    size: 18, color: AppColors.info),
                AppSpacing.gapH4,
                Text('Certificate: ${data.certificate!.ccsid}',
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700, color: color)),
        AppSpacing.gapH2,
        Text(label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.hintColor)),
      ],
    );
  }
}
