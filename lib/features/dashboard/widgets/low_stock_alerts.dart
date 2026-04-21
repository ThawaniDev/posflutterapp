import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class LowStockAlerts extends StatelessWidget {

  const LowStockAlerts({super.key, required this.items});
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardLowStockAlerts, style: AppTypography.headlineSmall),
              const Spacer(),
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                  child: Text('${items.length}', style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
                ),
            ],
          ),
          AppSpacing.gapH12,
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  l10n.dashboardAllWellStocked,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                ),
              ),
            )
          else
            ...items.take(5).map((item) => _LowStockRow(item: item, isDark: isDark)),
        ],
      ),
    );
  }
}

class _LowStockRow extends StatelessWidget {

  const _LowStockRow({required this.item, required this.isDark});
  final Map<String, dynamic> item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
    final reorderPoint = (item['reorder_point'] as num?)?.toInt() ?? 0;
    final isOut = quantity == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: isOut ? AppColors.error : AppColors.warning, shape: BoxShape.circle),
          ),
          AppSpacing.gapW8,
          Expanded(
            child: Text(
              item['product_name'] as String? ?? 'Unknown',
              style: AppTypography.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSpacing.gapW8,
          Text(
            '$quantity / $reorderPoint',
            style: AppTypography.labelMedium.copyWith(color: isOut ? AppColors.error : AppColors.warning),
          ),
        ],
      ),
    );
  }
}
