import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class SalesTrendChart extends StatelessWidget {

  const SalesTrendChart({super.key, required this.salesTrend});
  final Map<String, dynamic> salesTrend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = (salesTrend['current'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final previous = (salesTrend['previous'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (current.isEmpty) {
      return PosCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              l10n.noData,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
            ),
          ),
        ),
      );
    }

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, color: AppColors.primary, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardSalesTrend, style: AppTypography.headlineSmall),
              const Spacer(),
              _LegendDot(color: AppColors.primary, label: l10n.dashboardThisPeriod),
              AppSpacing.gapW12,
              _LegendDot(color: AppColors.mutedFor(context), label: l10n.dashboardPreviousPeriod),
            ],
          ),
          AppSpacing.gapH16,
          SizedBox(
            height: 200,
            child: _SalesTrendLineChart(current: current, previous: previous, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {

  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.micro),
      ],
    );
  }
}

class _SalesTrendLineChart extends StatelessWidget {

  const _SalesTrendLineChart({required this.current, required this.previous, required this.isDark});
  final List<Map<String, dynamic>> current;
  final List<Map<String, dynamic>> previous;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final currentSpots = <FlSpot>[];
    for (int i = 0; i < current.length; i++) {
      currentSpots.add(FlSpot(i.toDouble(), _toDouble(current[i]['revenue'])));
    }

    final previousSpots = <FlSpot>[];
    for (int i = 0; i < previous.length; i++) {
      previousSpots.add(FlSpot(i.toDouble(), _toDouble(previous[i]['revenue'])));
    }

    final secondaryColor = AppColors.mutedFor(context);

    return LineChart(
      LineChartData(
        lineBarsData: [
          // Previous period (subtle dashed)
          if (previousSpots.isNotEmpty)
            LineChartBarData(
              spots: previousSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: secondaryColor,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              dashArray: [6, 4],
              belowBarData: BarAreaData(show: false),
            ),
          // Current period (prominent with area fill)
          LineChartBarData(
            spots: currentSpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: current.length <= 15),
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.08)),
          ),
        ],
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
              interval: _bottomInterval,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= current.length) return const SizedBox.shrink();
                final raw = current[idx]['date']?.toString() ?? '';
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _shortDate(raw),
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
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(getTooltipColor: (_) => isDark ? AppColors.surfaceDark : Colors.white),
        ),
      ),
    );
  }

  double get _bottomInterval {
    if (current.length <= 7) return 1;
    if (current.length <= 14) return 2;
    return (current.length / 6).ceilToDouble();
  }

  String _shortDate(String dateStr) {
    if (dateStr.length < 10) return dateStr;
    final parts = dateStr.split('-');
    if (parts.length >= 3) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final m = int.tryParse(parts[1]);
      if (m != null && m >= 1 && m <= 12) return '${months[m - 1]} ${parts[2]}';
    }
    return dateStr;
  }

  String _formatCompact(num value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
