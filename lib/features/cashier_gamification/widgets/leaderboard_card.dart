import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';

class LeaderboardCard extends StatelessWidget {
  final CashierPerformanceSnapshot snapshot;
  final int rank;
  final VoidCallback? onTap;

  const LeaderboardCard({super.key, required this.snapshot, required this.rank, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isPhone;
    final isTop3 = rank <= 3;

    return Card(
      elevation: isTop3 ? 2 : 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTop3 ? BorderSide(color: _rankColor, width: 1.5) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: isMobile ? 36 : 44,
                height: isMobile ? 36 : 44,
                decoration: BoxDecoration(
                  color: isTop3 ? _rankColor.withValues(alpha: 0.15) : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _rankEmoji,
                  style: TextStyle(fontSize: isTop3 ? (isMobile ? 18 : 22) : (isMobile ? 14 : 16), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: isMobile ? 10 : 14),
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
                    const SizedBox(height: 2),
                    Text(snapshot.date, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              // Metrics
              if (!isMobile) ...[
                _MetricChip(label: 'TXN', value: snapshot.totalTransactions.toString(), color: AppColors.info),
                const SizedBox(width: 8),
                _MetricChip(label: 'IPM', value: snapshot.itemsPerMinute.toStringAsFixed(1), color: AppColors.success),
                const SizedBox(width: 8),
              ],
              _MetricChip(
                label: isMobile ? 'Rev' : 'Revenue',
                value: snapshot.totalRevenue.toStringAsFixed(0),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
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
  final String label;
  final String value;
  final Color color;

  const _MetricChip({required this.label, required this.value, required this.color});

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
  final double score;
  final bool compact;

  const _RiskBadge({required this.score, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = score >= 70
        ? AppColors.error
        : score >= 40
        ? AppColors.warning
        : AppColors.success;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(
        score.toStringAsFixed(0),
        style: TextStyle(fontSize: compact ? 12 : 13, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
