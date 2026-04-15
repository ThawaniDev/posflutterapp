import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/features/transactions/providers/transaction_explorer_state.dart';

/// KPI stat cards for the transaction explorer page.
class TransactionStatsCards extends StatelessWidget {
  const TransactionStatsCards({super.key, required this.stats});

  final TransactionStatsLoaded stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PosKpiGrid(
      desktopCols: 5,
      tabletCols: 3,
      mobileCols: 2,
      desktopAspectRatio: 1.85,
      cards: [
        PosKpiCard(
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primary,
          label: l10n.txStatsTotalSales,
          value: _currency(stats.totalSales),
          trend: stats.salesChangePercent,
        ),
        PosKpiCard(
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.info,
          label: l10n.txStatsTotalTransactions,
          value: '${stats.totalTransactions}',
          trend: stats.transactionsChangePercent,
        ),
        PosKpiCard(
          icon: Icons.shopping_basket_rounded,
          iconColor: AppColors.warning,
          label: l10n.txStatsAvgBasket,
          value: _currency(stats.avgTransactionValue),
          trend: stats.avgBasketChangePercent,
        ),
        PosKpiCard(
          icon: Icons.undo_rounded,
          iconColor: AppColors.error,
          label: l10n.txStatsReturnsVoids,
          value: '${stats.totalReturns + stats.totalVoids}',
          subtitle: '${stats.totalReturns} ${l10n.txReturns} · ${stats.totalVoids} ${l10n.txVoids}',
        ),
        PosKpiCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppColors.success,
          label: l10n.txStatsNetRevenue,
          value: _currency(stats.netRevenue),
          subtitle: '${l10n.txStatsTax}: ${_currency(stats.totalTax)}',
        ),
      ],
    );
  }

  String _currency(double v) => v.toStringAsFixed(3);
}
