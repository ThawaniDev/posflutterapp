import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════
// Report Chart Widgets — using fl_chart for comprehensive charts
// ═══════════════════════════════════════════════════════════════

const _chartColors = [
  AppColors.primary,
  AppColors.info,
  AppColors.success,
  AppColors.warning,
  AppColors.purple,
  AppColors.rose,
  AppColors.error,
  AppColors.infoDark,
];

// ─── Revenue / Trend Line Chart ─────────────────────────────

class ReportLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final List<String> yKeys;
  final List<String> yLabels;
  final List<Color>? colors;
  final double height;
  final bool showArea;

  const ReportLineChart({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKeys,
    required this.yLabels,
    this.colors,
    this.height = 220,
    this.showArea = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColors = colors ?? _chartColors;

    final lines = <LineChartBarData>[];
    for (int k = 0; k < yKeys.length; k++) {
      final spots = <FlSpot>[];
      for (int i = 0; i < data.length; i++) {
        final val = (data[i][yKeys[k]] as num?)?.toDouble() ?? 0;
        spots.add(FlSpot(i.toDouble(), val));
      }
      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: lineColors[k % lineColors.length],
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: data.length <= 15),
          belowBarData: showArea
              ? BarAreaData(show: true, color: lineColors[k % lineColors.length].withValues(alpha: 0.1))
              : BarAreaData(show: false),
        ),
      );
    }

    return _ChartContainer(
      height: height,
      legend: yLabels.length > 1 ? _Legend(labels: yLabels, colors: lineColors) : null,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
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
                interval: _bottomInterval,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  final raw = data[idx][xKey]?.toString() ?? '';
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _shortenLabel(raw),
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
                    formatCompact(value),
                    style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
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
    );
  }

  double get _bottomInterval {
    if (data.length <= 7) return 1;
    if (data.length <= 14) return 2;
    if (data.length <= 31) return 5;
    return (data.length / 6).ceilToDouble();
  }
}

// ─── Bar Chart (comparison: categories, staff, products) ────

class ReportBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String labelKey;
  final String valueKey;
  final String? secondaryValueKey;
  final Color? barColor;
  final Color? secondaryBarColor;
  final double height;
  final bool horizontal;

  const ReportBarChart({
    super.key,
    required this.data,
    required this.labelKey,
    required this.valueKey,
    this.secondaryValueKey,
    this.barColor,
    this.secondaryBarColor,
    this.height = 220,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color1 = barColor ?? AppColors.primary;
    final color2 = secondaryBarColor ?? AppColors.info;
    final maxItems = data.length > 12 ? 12 : data.length;
    final items = data.sublist(0, maxItems);

    return _ChartContainer(
      height: height,
      child: horizontal ? _buildHorizontal(items, isDark, color1, color2) : _buildVertical(items, isDark, color1, color2),
    );
  }

  Widget _buildVertical(List<Map<String, dynamic>> items, bool isDark, Color c1, Color c2) {
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < items.length; i++) {
      final val = (items[i][valueKey] as num?)?.toDouble() ?? 0;
      final rods = <BarChartRodData>[
        BarChartRodData(
          toY: val,
          color: c1,
          width: secondaryValueKey != null ? 8 : 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ];
      if (secondaryValueKey != null) {
        final v2 = (items[i][secondaryValueKey] as num?)?.toDouble() ?? 0;
        rods.add(
          BarChartRodData(
            toY: v2,
            color: c2,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        );
      }
      groups.add(BarChartGroupData(x: i, barRods: rods));
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
                if (idx < 0 || idx >= items.length) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _shortenLabel(items[idx][labelKey]?.toString() ?? ''),
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
                  formatCompact(value),
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

  Widget _buildHorizontal(List<Map<String, dynamic>> items, bool isDark, Color c1, Color c2) {
    return RotatedBox(quarterTurns: 1, child: _buildVertical(items.reversed.toList(), isDark, c1, c2));
  }
}

// ─── Pie / Donut Chart ──────────────────────────────────────

class ReportPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String labelKey;
  final String valueKey;
  final double height;
  final bool donut;

  const ReportPieChart({
    super.key,
    required this.data,
    required this.labelKey,
    required this.valueKey,
    this.height = 220,
    this.donut = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart(height: height);

    final total = data.fold<double>(0, (sum, d) => sum + ((d[valueKey] as num?)?.toDouble() ?? 0));
    final maxItems = data.length > 8 ? 8 : data.length;
    final items = data.sublist(0, maxItems);

    final sections = <PieChartSectionData>[];
    final labels = <String>[];
    final colors = <Color>[];

    for (int i = 0; i < items.length; i++) {
      final val = (items[i][valueKey] as num?)?.toDouble() ?? 0;
      final pct = total > 0 ? (val / total * 100) : 0.0;
      final color = _chartColors[i % _chartColors.length];
      labels.add(items[i][labelKey]?.toString() ?? 'Unknown');
      colors.add(color);
      sections.add(
        PieChartSectionData(
          value: val,
          color: color,
          radius: donut ? 28 : 50,
          title: pct >= 5 ? '${pct.toStringAsFixed(1)}%' : '',
          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    return _ChartContainer(
      height: height,
      legend: _Legend(labels: labels, colors: colors),
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: donut ? 40 : 0,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(touchCallback: (_, __) {}),
        ),
      ),
    );
  }
}

// ─── Hourly Heatmap / Bar (24-hour pattern) ─────────────────

class ReportHourlyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String valueKey;
  final double height;

  const ReportHourlyChart({super.key, required this.data, required this.valueKey, this.height = 180});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = data.fold<double>(0, (max, d) => math.max(max, (d[valueKey] as num?)?.toDouble() ?? 0));

    final groups = <BarChartGroupData>[];
    for (final item in data) {
      final hour = (item['hour'] as num?)?.toInt() ?? 0;
      final val = (item[valueKey] as num?)?.toDouble() ?? 0;
      final intensity = maxVal > 0 ? val / maxVal : 0.0;
      groups.add(
        BarChartGroupData(
          x: hour,
          barRods: [
            BarChartRodData(
              toY: val,
              color: Color.lerp(AppColors.primary.withValues(alpha: 0.3), AppColors.primary, intensity)!,
              width: 10,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
          ],
        ),
      );
    }

    return _ChartContainer(
      height: height,
      child: BarChart(
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
                reservedSize: 22,
                interval: 3,
                getTitlesWidget: (value, meta) {
                  final h = value.toInt();
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      '${h}h',
                      style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    formatCompact(value),
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
      ),
    );
  }
}

// ─── Area Chart (Financial P&L trend) ───────────────────────

class ReportAreaChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final String revenueKey;
  final String costKey;
  final String profitKey;
  final double height;

  const ReportAreaChart({
    super.key,
    required this.data,
    required this.xKey,
    required this.revenueKey,
    required this.costKey,
    required this.profitKey,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (data.isEmpty) return _EmptyChart(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    LineChartBarData buildLine(String key, Color color, {bool area = false}) {
      final spots = <FlSpot>[];
      for (int i = 0; i < data.length; i++) {
        spots.add(FlSpot(i.toDouble(), (data[i][key] as num?)?.toDouble() ?? 0));
      }
      return LineChartBarData(
        spots: spots,
        isCurved: true,
        curveSmoothness: 0.3,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: area ? BarAreaData(show: true, color: color.withValues(alpha: 0.08)) : BarAreaData(show: false),
      );
    }

    return _ChartContainer(
      height: height,
      legend: _Legend(
        labels: [l10n.reportLegendRevenue, l10n.reportLegendCost, l10n.reportLegendNetProfit],
        colors: const [AppColors.primary, AppColors.error, AppColors.success],
      ),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            buildLine(revenueKey, AppColors.primary, area: true),
            buildLine(costKey, AppColors.error),
            buildLine(profitKey, AppColors.success, area: true),
          ],
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
                interval: data.length > 14 ? (data.length / 6).ceilToDouble() : 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _shortenLabel(data[idx][xKey]?.toString() ?? ''),
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
                    formatCompact(value),
                    style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
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
    );
  }
}

// ─── Shared Helpers ─────────────────────────────────────────

String _shortenLabel(String label) {
  if (label.length <= 6) return label;
  // try date shortening: 2024-01-15 → Jan 15
  if (label.length == 10 && label[4] == '-') {
    final parts = label.split('-');
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = int.tryParse(parts[1]);
    if (m != null && m >= 1 && m <= 12) return '${months[m - 1]} ${parts[2]}';
  }
  // year-month: 2024-01 → Jan
  if (label.length == 7 && label[4] == '-') {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = int.tryParse(label.substring(5));
    if (m != null && m >= 1 && m <= 12) return months[m - 1];
  }
  return label.length > 8 ? '${label.substring(0, 7)}…' : label;
}

class _ChartContainer extends StatelessWidget {
  final double height;
  final Widget child;
  final Widget? legend;

  const _ChartContainer({required this.height, required this.child, this.legend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (legend != null) ...[legend!, const SizedBox(height: 12)],
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<String> labels;
  final List<Color> colors;

  const _Legend({required this.labels, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        for (int i = 0; i < labels.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(width: 6),
              Text(
                labels[i],
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final double height;
  const _EmptyChart({required this.height});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 40, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            const SizedBox(height: 8),
            Text(l10n.noData,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ],
        ),
      ),
    );
  }
}
