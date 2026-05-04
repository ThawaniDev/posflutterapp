import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/features/transactions/providers/transaction_explorer_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

const _chartColors = [
  AppColors.primary,
  AppColors.info,
  AppColors.success,
  AppColors.warning,
  AppColors.purple,
  AppColors.rose,
  AppColors.error,
];

/// Payment method breakdown + hourly distribution + daily trend charts.
class TransactionAnalyticsCharts extends StatelessWidget {
  const TransactionAnalyticsCharts({super.key, required this.stats});

  final TransactionStatsLoaded stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PaymentBreakdownChart(breakdown: stats.paymentMethodBreakdown)),
              AppSpacing.gapW12,
              Expanded(child: _HourlyDistributionChart(distribution: stats.hourlyDistribution)),
            ],
          );
        }
        return Column(
          children: [
            _PaymentBreakdownChart(breakdown: stats.paymentMethodBreakdown),
            AppSpacing.gapH12,
            _HourlyDistributionChart(distribution: stats.hourlyDistribution),
          ],
        );
      },
    );
  }
}

/// Daily sales trend line chart.
class TransactionDailyTrendChart extends StatelessWidget {
  const TransactionDailyTrendChart({super.key, required this.data});

  final List<DailyTrendPoint> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (data.isEmpty) {
      return PosCard(
        child: SizedBox(
          height: 180,
          child: Center(child: Text(l10n.txNoDataAvailable, style: AppTypography.bodySmall)),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].sales));
    }

    return PosCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txDailySalesTrend, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: data.length <= 14),
                    belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.1)),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark ? AppColors.borderDark.withValues(alpha: 0.3) : AppColors.borderFor(context),
                    strokeWidth: 0.8,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: data.length > 12 ? (data.length / 6).ceilToDouble() : 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                        final d = data[idx].date;
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${d.day}/${d.month}',
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
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment Breakdown Donut ─────────────────────────────────

class _PaymentBreakdownChart extends StatelessWidget {
  const _PaymentBreakdownChart({required this.breakdown});

  final Map<String, double> breakdown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (breakdown.isEmpty) {
      return PosCard(
        child: SizedBox(
          height: 220,
          child: Center(child: Text(l10n.txNoDataAvailable, style: AppTypography.bodySmall)),
        ),
      );
    }

    final total = breakdown.values.fold<double>(0, (s, v) => s + v);
    final entries = breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final sections = <PieChartSectionData>[];
    final labels = <String>[];
    final colors = <Color>[];

    for (int i = 0; i < entries.length; i++) {
      final pct = total > 0 ? (entries[i].value / total * 100) : 0.0;
      final color = _chartColors[i % _chartColors.length];
      labels.add(_formatMethodName(entries[i].key));
      colors.add(color);
      sections.add(
        PieChartSectionData(
          value: entries[i].value,
          color: color,
          radius: 28,
          title: pct >= 5 ? '${pct.toStringAsFixed(0)}%' : '',
          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    return PosCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txPaymentBreakdown, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 36, sectionsSpace: 2))),
                AppSpacing.gapW12,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(labels.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(2)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            labels[i],
                            style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMethodName(String raw) {
    return raw.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}

// ─── Hourly Distribution Bar ─────────────────────────────────

class _HourlyDistributionChart extends StatelessWidget {
  const _HourlyDistributionChart({required this.distribution});

  final Map<int, int> distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (distribution.isEmpty) {
      return PosCard(
        child: SizedBox(
          height: 220,
          child: Center(child: Text(l10n.txNoDataAvailable, style: AppTypography.bodySmall)),
        ),
      );
    }

    final maxVal = distribution.values.fold<int>(0, (m, v) => v > m ? v : m);
    final groups = <BarChartGroupData>[];

    for (int h = 0; h < 24; h++) {
      final val = (distribution[h] ?? 0).toDouble();
      final intensity = maxVal > 0 ? val / maxVal : 0.0;
      groups.add(
        BarChartGroupData(
          x: h,
          barRods: [
            BarChartRodData(
              toY: val,
              color: Color.lerp(AppColors.info.withValues(alpha: 0.3), AppColors.info, intensity)!,
              width: 8,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
          ],
        ),
      );
    }

    return PosCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txHourlyDistribution, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                barGroups: groups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark ? AppColors.borderDark.withValues(alpha: 0.3) : AppColors.borderFor(context),
                    strokeWidth: 0.8,
                  ),
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
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value.toInt()}h',
                            style: TextStyle(fontSize: 10, color: AppColors.mutedFor(context)),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────

String _formatCompact(double v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
  return v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1);
}
