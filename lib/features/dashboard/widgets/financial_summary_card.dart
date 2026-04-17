import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class FinancialSummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const FinancialSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalRevenue = _toDouble(data['total_revenue']);
    final totalCost = _toDouble(data['total_cost']);
    final netProfit = _toDouble(data['net_profit']);
    final totalTax = _toDouble(data['total_tax']);
    final totalDiscount = _toDouble(data['total_discount']);
    final paymentMethods = (data['payment_methods'] as Map<String, dynamic>?) ?? {};

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardFinancialSummary, style: AppTypography.headlineSmall),
            ],
          ),
          AppSpacing.gapH16,
          // P&L rows
          _SummaryRow(label: l10n.dashboardTotalRevenue, value: totalRevenue, color: AppColors.success, isDark: isDark),
          _SummaryRow(label: l10n.dashboardTotalCost, value: totalCost, color: AppColors.error, isDark: isDark, negative: true),
          Divider(height: 16, color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
          _SummaryRow(
            label: l10n.dashboardNetProfit,
            value: netProfit,
            color: netProfit >= 0 ? AppColors.success : AppColors.error,
            isDark: isDark,
            bold: true,
          ),
          AppSpacing.gapH8,
          _SummaryRow(label: l10n.dashboardTotalTax, value: totalTax, color: AppColors.warning, isDark: isDark),
          _SummaryRow(label: l10n.dashboardTotalDiscount, value: totalDiscount, color: AppColors.info, isDark: isDark),
          if (paymentMethods.isNotEmpty) ...[
            AppSpacing.gapH16,
            Text(
              l10n.dashboardPaymentBreakdown,
              style: AppTypography.labelMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            AppSpacing.gapH8,
            SizedBox(
              height: 160,
              child: _PaymentPieChart(methods: paymentMethods, isDark: isDark),
            ),
          ],
        ],
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isDark;
  final bool negative;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    this.negative = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? AppTypography.titleSmall : AppTypography.bodyMedium),
          Text(
            '${negative ? "- " : ""}\u0081 ${value.toStringAsFixed(2)}',
            style: (bold ? AppTypography.titleSmall : AppTypography.labelMedium).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

const _pieColors = [
  AppColors.primary,
  AppColors.info,
  AppColors.success,
  AppColors.warning,
  AppColors.purple,
  AppColors.rose,
  AppColors.error,
];

class _PaymentPieChart extends StatelessWidget {
  final Map<String, dynamic> methods;
  final bool isDark;

  const _PaymentPieChart({required this.methods, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final entries = methods.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + ((e.value as num?)?.toDouble() ?? 0));

    final sections = <PieChartSectionData>[];
    final labels = <String>[];
    final colors = <Color>[];

    for (int i = 0; i < entries.length; i++) {
      final val = (entries[i].value as num?)?.toDouble() ?? 0;
      final pct = total > 0 ? (val / total * 100) : 0.0;
      final color = _pieColors[i % _pieColors.length];
      labels.add(entries[i].key);
      colors.add(color);
      sections.add(
        PieChartSectionData(
          value: val,
          color: color,
          radius: 24,
          title: pct >= 5 ? '${pct.toStringAsFixed(0)}%' : '',
          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 32, sectionsSpace: 2))),
        AppSpacing.gapW12,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < labels.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          labels[i],
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
