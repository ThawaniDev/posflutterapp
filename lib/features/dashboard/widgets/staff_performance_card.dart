import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class StaffPerformanceCard extends StatelessWidget {

  const StaffPerformanceCard({super.key, required this.staff});
  final List<Map<String, dynamic>> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.leaderboard_rounded, color: AppColors.purple, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardStaffPerformance, style: AppTypography.headlineSmall),
            ],
          ),
          AppSpacing.gapH16,
          if (staff.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  l10n.noData,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                ),
              ),
            )
          else ...[
            // Horizontal bar chart showing sales per staff
            SizedBox(
              height: (staff.length * 44.0).clamp(100, 260),
              child: _StaffBarChart(staff: staff, isDark: isDark),
            ),
            AppSpacing.gapH12,
            // Detail rows
            ...staff.take(10).map((s) => _StaffRow(staff: s, isDark: isDark, l10n: l10n)),
          ],
        ],
      ),
    );
  }
}

class _StaffBarChart extends StatelessWidget {

  const _StaffBarChart({required this.staff, required this.isDark});
  final List<Map<String, dynamic>> staff;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < staff.length; i++) {
      final val = _toDouble(staff[i]['total_sales']);
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: _staffColors[i % _staffColors.length],
              width: 14,
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
              FlLine(color: isDark ? AppColors.borderDark.withValues(alpha: 0.3) : AppColors.borderFor(context), strokeWidth: 0.8),
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
                if (idx < 0 || idx >= staff.length) return const SizedBox.shrink();
                final name = staff[idx]['staff_name']?.toString() ?? '';
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    name.length > 8 ? '${name.substring(0, 7)}…' : name,
                    style: TextStyle(fontSize: 10, color: AppColors.mutedFor(context)),
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
                  style: TextStyle(fontSize: 10, color: AppColors.mutedFor(context)),
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

  String _formatCompact(num value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

class _StaffRow extends StatelessWidget {

  const _StaffRow({required this.staff, required this.isDark, required this.l10n});
  final Map<String, dynamic> staff;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final name = staff['staff_name'] as String? ?? 'Unknown';
    final transactions = (staff['total_transactions'] as num?)?.toInt() ?? 0;
    final sales = _toDouble(staff['total_sales']);
    final avgBasket = _toDouble(staff['avg_basket']);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.purple.withValues(alpha: 0.1),
            child: Text(
              _initials(name),
              style: AppTypography.micro.copyWith(color: AppColors.purple, fontWeight: FontWeight.w600),
            ),
          ),
          AppSpacing.gapW8,
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  '$transactions ${l10n.dashboardTransactions.toLowerCase()}',
                  style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\u0081 ${sales.toStringAsFixed(0)}', style: AppTypography.labelMedium.copyWith(color: AppColors.success)),
              Text(
                '${l10n.dashboardAvgBasket}: \u0081 ${avgBasket.toStringAsFixed(0)}',
                style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

const _staffColors = [AppColors.purple, AppColors.primary, AppColors.info, AppColors.success, AppColors.warning, AppColors.rose];

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
