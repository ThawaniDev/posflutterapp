import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class HourlySalesChart extends StatelessWidget {

  const HourlySalesChart({super.key, required this.data});
  final List<Map<String, dynamic>> data;

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
              const Icon(Icons.schedule_rounded, color: AppColors.info, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardHourlySales, style: AppTypography.headlineSmall),
            ],
          ),
          AppSpacing.gapH16,
          if (data.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  l10n.noData,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: _HourlyBarChart(data: data, isDark: isDark),
            ),
        ],
      ),
    );
  }
}

class _HourlyBarChart extends StatelessWidget {

  const _HourlyBarChart({required this.data, required this.isDark});
  final List<Map<String, dynamic>> data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final maxVal = data.fold<double>(0, (max, d) => math.max(max, _toDouble(d['sales'])));

    final groups = <BarChartGroupData>[];
    for (final item in data) {
      final hour = (item['hour'] as num?)?.toInt() ?? 0;
      final val = _toDouble(item['sales']);
      final intensity = maxVal > 0 ? val / maxVal : 0.0;
      groups.add(
        BarChartGroupData(
          x: hour,
          barRods: [
            BarChartRodData(
              toY: val,
              color: Color.lerp(AppColors.info.withValues(alpha: 0.25), AppColors.info, intensity)!,
              width: 10,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
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
              reservedSize: 22,
              interval: 3,
              getTitlesWidget: (value, meta) {
                final h = value.toInt();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '${h}h',
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
}
