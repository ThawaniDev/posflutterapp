import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

class DashboardKpiCards extends StatelessWidget {
  final Map<String, dynamic> stats;

  const DashboardKpiCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
            ? 2
            : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
          children: [
            _KpiTile(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.primary.withValues(alpha: 0.1),
              label: l10n.dashboardTodaysSales,
              value: '\u0081 ${_formatNum(stats['today_sales'])}',
              trend: _toDouble(stats['sales_trend']),
              trendLabel: l10n.dashboardVsYesterday,
              isDark: isDark,
            ),
            _KpiTile(
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.info,
              iconBgColor: AppColors.info.withValues(alpha: 0.1),
              label: l10n.dashboardTransactions,
              value: '${stats['today_transactions'] ?? 0}',
              trend: _toDouble(stats['transactions_trend']),
              trendLabel: l10n.dashboardVsYesterday,
              isDark: isDark,
            ),
            _KpiTile(
              icon: Icons.shopping_basket_rounded,
              iconColor: AppColors.warning,
              iconBgColor: AppColors.warning.withValues(alpha: 0.1),
              label: l10n.dashboardAvgBasket,
              value: '\u0081 ${_formatNum(stats['avg_basket'])}',
              trend: _toDouble(stats['basket_trend']),
              trendLabel: l10n.dashboardVsYesterday,
              isDark: isDark,
            ),
            _KpiTile(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: AppColors.success,
              iconBgColor: AppColors.success.withValues(alpha: 0.1),
              label: l10n.dashboardNetProfit,
              value: '\u0081 ${_formatNum(stats['net_profit'])}',
              trend: _toDouble(stats['profit_trend']),
              trendLabel: l10n.dashboardVsYesterday,
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }

  String _formatNum(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    if (value is String) return double.tryParse(value)?.toStringAsFixed(2) ?? '0.00';
    return '0.00';
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;
  final double? trend;
  final String? trendLabel;
  final bool isDark;

  const _KpiTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    this.trend,
    this.trendLabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PosCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: AppRadius.borderMd),
            child: Center(child: Icon(icon, size: 20, color: iconColor)),
          ),
          AppSpacing.gapH8,
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          AppSpacing.gapH4,
          Text(value, style: AppTypography.headlineMedium),
          if (trend != null) ...[
            AppSpacing.gapH4,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trend! >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 16,
                  color: trend! >= 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trend! >= 0 ? '+' : ''}${trend!.toStringAsFixed(1)}%',
                  style: AppTypography.labelSmall.copyWith(color: trend! >= 0 ? AppColors.success : AppColors.error),
                ),
                if (trendLabel != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    trendLabel!,
                    style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
