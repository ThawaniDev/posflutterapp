import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class LeaderboardCard extends StatelessWidget {

  const LeaderboardCard({super.key, required this.snapshot, required this.rank, this.onTap});
  final CashierPerformanceSnapshot snapshot;
  final int rank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isMobile = context.isPhone;
    final isTop3 = rank <= 3;

    return PosCard(
      elevation: isTop3 ? 2 : 0.5,
      borderRadius: AppRadius.borderLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Padding(
          padding: context.responsivePagePadding,
          child: Row(
            children: [
              // Rank badge
              Container(
                width: context.responsiveAvatarSize - 4,
                height: context.responsiveAvatarSize - 4,
                decoration: BoxDecoration(
                  color: isTop3 ? _rankColor.withValues(alpha: 0.15) : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _rankEmoji,
                  style: TextStyle(
                    fontSize: isTop3 ? context.responsiveIconSize : context.responsiveIconSizeSm,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppSpacing.gapW12,
              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.cashier?.name ?? 'Cashier',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapH2,
                    Text(snapshot.date, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              // Metrics
              if (!isMobile) ...[
                _MetricChip(label: l10n.cgTxnAbbr, value: snapshot.totalTransactions.toString(), color: AppColors.info),
                AppSpacing.gapW8,
                _MetricChip(label: l10n.cgIpmAbbr, value: snapshot.itemsPerMinute.toStringAsFixed(1), color: AppColors.success),
                AppSpacing.gapW8,
              ],
              _MetricChip(
                label: isMobile ? 'Rev' : 'Revenue',
                value: snapshot.totalRevenue.toStringAsFixed(0),
                color: AppColors.primary,
              ),
              AppSpacing.gapW8,
              // Risk score
              _RiskBadge(score: snapshot.riskScore, compact: isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Color get _rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // gold
      case 2:
        return const Color(0xFFC0C0C0); // silver
      case 3:
        return const Color(0xFFCD7F32); // bronze
      default:
        return Colors.grey;
    }
  }

  String get _rankEmoji {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }
}

class _MetricChip extends StatelessWidget {

  const _MetricChip({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {

  const _RiskBadge({required this.score, this.compact = false});
  final double score;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = score >= 70
        ? AppColors.error
        : score >= 40
        ? AppColors.warning
        : AppColors.success;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
      child: Text(
        score.toStringAsFixed(0),
        style: TextStyle(fontSize: compact ? 12 : 13, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
