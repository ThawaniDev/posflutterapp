import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_shift_report.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ShiftReportCard extends StatelessWidget {

  const ShiftReportCard({super.key, required this.report, this.onTap});
  final CashierShiftReport report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isMobile = context.isPhone;

    return PosCard(
      elevation: 0.5,
      borderRadius: AppRadius.borderLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Padding(
          padding: context.responsivePagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assessment_rounded, color: AppColors.primary, size: context.responsiveIconSize),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.cashier?.name ?? 'Cashier',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          report.reportDate,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  _RiskLevelChip(level: report.riskLevel, score: report.riskScore),
                ],
              ),
              AppSpacing.gapH12,
              Wrap(
                spacing: isMobile ? 12 : 20,
                runSpacing: 8,
                children: [
                  _StatItem(icon: Icons.receipt_rounded, label: l10n.cgTxnAbbr, value: report.totalTransactions.toString()),
                  _StatItem(icon: Icons.attach_money_rounded, label: l10n.reportsRevenue, value: report.totalRevenue.toStringAsFixed(0)),
                  _StatItem(icon: Icons.speed_rounded, label: l10n.cgIpmAbbr, value: report.itemsPerMinute.toStringAsFixed(1)),
                  _StatItem(icon: Icons.block_rounded, label: l10n.posVoids, value: report.voidCount.toString()),
                  if (report.anomalyCount > 0)
                    _StatItem(
                      icon: Icons.warning_rounded,
                      label: l10n.gamificationAnomalies,
                      value: report.anomalyCount.toString(),
                      color: AppColors.error,
                    ),
                  if (report.badgesEarned.isNotEmpty)
                    _StatItem(
                      icon: Icons.emoji_events_rounded,
                      label: l10n.gamificationBadges,
                      value: report.badgesEarned.length.toString(),
                      color: AppColors.primary,
                    ),
                ],
              ),
              if (report.sentToOwner) ...[
                AppSpacing.gapH8,
                Row(
                  children: [
                    const Icon(Icons.send_rounded, size: 12, color: AppColors.success),
                    AppSpacing.gapW4,
                    Text(l10n.notifLogSent, style: const TextStyle(fontSize: 11, color: AppColors.success)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskLevelChip extends StatelessWidget {
  const _RiskLevelChip({required this.level, required this.score});
  final String level;
  final double score;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (level) {
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
        color = AppColors.success;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score.toStringAsFixed(0),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
          Text(level, style: TextStyle(fontSize: 9, color: color)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {

  const _StatItem({required this.icon, required this.label, required this.value, this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 3),
        Text(
          '$value ',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
