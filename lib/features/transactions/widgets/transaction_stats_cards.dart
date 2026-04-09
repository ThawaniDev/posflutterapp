import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/features/transactions/providers/transaction_explorer_state.dart';

/// KPI stat cards for the transaction explorer page.
class TransactionStatsCards extends StatelessWidget {
  const TransactionStatsCards({super.key, required this.stats});

  final TransactionStatsLoaded stats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1100
            ? 5
            : constraints.maxWidth > 800
            ? 4
            : constraints.maxWidth > 500
            ? 2
            : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: crossAxisCount == 1 ? 3.2 : 1.85,
          children: [
            _StatTile(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.primary,
              label: l10n.txStatsTotalSales,
              value: _currency(stats.totalSales),
              changePercent: stats.salesChangePercent,
              isDark: isDark,
            ),
            _StatTile(
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.info,
              label: l10n.txStatsTotalTransactions,
              value: '${stats.totalTransactions}',
              changePercent: stats.transactionsChangePercent,
              isDark: isDark,
            ),
            _StatTile(
              icon: Icons.shopping_basket_rounded,
              iconColor: AppColors.warning,
              label: l10n.txStatsAvgBasket,
              value: _currency(stats.avgTransactionValue),
              changePercent: stats.avgBasketChangePercent,
              isDark: isDark,
            ),
            _StatTile(
              icon: Icons.undo_rounded,
              iconColor: AppColors.error,
              label: l10n.txStatsReturnsVoids,
              value: '${stats.totalReturns + stats.totalVoids}',
              subtitle: '${stats.totalReturns} ${l10n.txReturns} · ${stats.totalVoids} ${l10n.txVoids}',
              isDark: isDark,
            ),
            _StatTile(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: AppColors.success,
              label: l10n.txStatsNetRevenue,
              value: _currency(stats.netRevenue),
              subtitle: '${l10n.txStatsTax}: ${_currency(stats.totalTax)}',
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }

  String _currency(double v) => v.toStringAsFixed(3);
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDark,
    this.changePercent,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDark;
  final double? changePercent;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isPositive = (changePercent ?? 0) >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;

    return PosCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Spacer(),
              if (changePercent != null && changePercent != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: trendColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 12, color: trendColor),
                      const SizedBox(width: 2),
                      Text(
                        '${isPositive ? '+' : ''}${changePercent!.toStringAsFixed(1)}%',
                        style: AppTypography.micro.copyWith(color: trendColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          AppSpacing.gapH8,
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTypography.micro.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
