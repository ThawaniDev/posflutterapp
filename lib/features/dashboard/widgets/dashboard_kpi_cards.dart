import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

class DashboardKpiCards extends StatelessWidget {
  final Map<String, dynamic> stats;

  const DashboardKpiCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PosKpiGrid(
      desktopCols: 4,
      tabletCols: 2,
      mobileCols: 2,
      cards: [
        PosKpiCard(
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primary,
          iconBgColor: AppColors.primary.withValues(alpha: 0.1),
          label: l10n.dashboardTodaysSales,
          value: '\u0081 ${_formatNum(stats['today_sales'])}',
          trend: _toDouble(stats['sales_trend']),
          trendLabel: l10n.dashboardVsYesterday,
        ),
        PosKpiCard(
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.info,
          iconBgColor: AppColors.info.withValues(alpha: 0.1),
          label: l10n.dashboardTransactions,
          value: '${stats['today_transactions'] ?? 0}',
          trend: _toDouble(stats['transactions_trend']),
          trendLabel: l10n.dashboardVsYesterday,
        ),
        PosKpiCard(
          icon: Icons.shopping_basket_rounded,
          iconColor: AppColors.warning,
          iconBgColor: AppColors.warning.withValues(alpha: 0.1),
          label: l10n.dashboardAvgBasket,
          value: '\u0081 ${_formatNum(stats['avg_basket'])}',
          trend: _toDouble(stats['basket_trend']),
          trendLabel: l10n.dashboardVsYesterday,
        ),
        PosKpiCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppColors.success,
          iconBgColor: AppColors.success.withValues(alpha: 0.1),
          label: l10n.dashboardNetProfit,
          value: '\u0081 ${_formatNum(stats['net_profit'])}',
          trend: _toDouble(stats['profit_trend']),
          trendLabel: l10n.dashboardVsYesterday,
        ),
      ],
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
