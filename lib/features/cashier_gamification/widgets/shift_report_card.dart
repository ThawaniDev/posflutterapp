import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_shift_report.dart';

class ShiftReportCard extends StatelessWidget {
  final CashierShiftReport report;
  final VoidCallback? onTap;

  const ShiftReportCard({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isPhone;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assessment_rounded, color: AppColors.primary, size: isMobile ? 20 : 24),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 12),
              Wrap(
                spacing: isMobile ? 12 : 20,
                runSpacing: 8,
                children: [
                  _StatItem(icon: Icons.receipt_rounded, label: 'TXN', value: report.totalTransactions.toString()),
                  _StatItem(icon: Icons.attach_money_rounded, label: 'Revenue', value: report.totalRevenue.toStringAsFixed(0)),
                  _StatItem(icon: Icons.speed_rounded, label: 'IPM', value: report.itemsPerMinute.toStringAsFixed(1)),
                  _StatItem(icon: Icons.block_rounded, label: 'Voids', value: report.voidCount.toString()),
                  if (report.anomalyCount > 0)
                    _StatItem(
                      icon: Icons.warning_rounded,
                      label: 'Anomalies',
                      value: report.anomalyCount.toString(),
                      color: AppColors.error,
                    ),
                  if (report.badgesEarned.isNotEmpty)
                    _StatItem(
                      icon: Icons.emoji_events_rounded,
                      label: 'Badges',
                      value: report.badgesEarned.length.toString(),
                      color: AppColors.primary,
                    ),
                ],
              ),
              if (report.sentToOwner) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.send_rounded, size: 12, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('Sent', style: TextStyle(fontSize: 11, color: AppColors.success)),
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
  final String level;
  final double score;
  const _RiskLevelChip({required this.level, required this.score});

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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
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
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatItem({required this.icon, required this.label, required this.value, this.color});

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
