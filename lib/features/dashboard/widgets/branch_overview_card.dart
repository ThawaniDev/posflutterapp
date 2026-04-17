import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BranchOverviewCard extends StatelessWidget {
  final List<Map<String, dynamic>> branches;

  const BranchOverviewCard({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (branches.length <= 1) return const SizedBox.shrink();

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store_rounded, color: AppColors.rose, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardBranchOverview, style: AppTypography.headlineSmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.rose.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                child: Text('${branches.length}', style: AppTypography.labelSmall.copyWith(color: AppColors.rose)),
              ),
            ],
          ),
          AppSpacing.gapH16,
          // Comparison bar chart
          SizedBox(
            height: 180,
            child: _BranchComparisonChart(branches: branches, isDark: isDark),
          ),
          AppSpacing.gapH12,
          // Branch detail rows
          ...branches.map((b) => _BranchRow(branch: b, isDark: isDark, l10n: l10n)),
        ],
      ),
    );
  }
}

const _branchColors = [AppColors.primary, AppColors.info, AppColors.success, AppColors.warning, AppColors.purple, AppColors.rose];

class _BranchComparisonChart extends StatelessWidget {
  final List<Map<String, dynamic>> branches;
  final bool isDark;

  const _BranchComparisonChart({required this.branches, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < branches.length; i++) {
      final sales = _toDouble(branches[i]['total_sales']);
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: sales,
              color: _branchColors[i % _branchColors.length],
              width: 18,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xs)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        barGroups: groups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: isDark ? AppColors.borderDark.withValues(alpha: 0.3) : AppColors.borderLight, strokeWidth: 0.8),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= branches.length) return const SizedBox.shrink();
                final name = branches[idx]['branch_name']?.toString() ?? '';
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    name.length > 10 ? '${name.substring(0, 9)}…' : name,
                    style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  _formatCompact(value),
                  style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => isDark ? AppColors.surfaceDark : Colors.white),
        ),
      ),
    );
  }
}

class _BranchRow extends StatelessWidget {
  final Map<String, dynamic> branch;
  final bool isDark;
  final AppLocalizations l10n;

  const _BranchRow({required this.branch, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final name = branch['branch_name'] as String? ?? 'Unknown';
    final sales = _toDouble(branch['total_sales']);
    final transactions = (branch['total_transactions'] as num?)?.toInt() ?? 0;
    final staffCount = (branch['staff_count'] as num?)?.toInt() ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.store_outlined, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          AppSpacing.gapW8,
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  '$transactions ${l10n.dashboardTransactions.toLowerCase()} · $staffCount ${l10n.staff.toLowerCase()}',
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          Text('\u0081 ${sales.toStringAsFixed(0)}', style: AppTypography.labelMedium.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

String _formatCompact(num value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
