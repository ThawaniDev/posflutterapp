import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

class TopProductsTable extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const TopProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Products', style: AppTypography.headlineSmall),
          AppSpacing.gapH12,
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No sales data yet',
                  style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            )
          else
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text(
                          '#',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Product',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qty',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Revenue',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                ...products.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: idx < 3
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : (isDark ? AppColors.surfaceDark : AppColors.inputBgLight),
                            child: Text(
                              '${idx + 1}',
                              style: AppTypography.labelSmall.copyWith(color: idx < 3 ? AppColors.primary : null),
                            ),
                          ),
                        ),
                        AppSpacing.gapW8,
                        Expanded(
                          flex: 3,
                          child: Text(
                            p['product_name'] as String? ?? '',
                            style: AppTypography.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${(p['total_quantity'] as num?)?.toInt() ?? 0}',
                            style: AppTypography.bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'SAR ${((p['total_revenue'] as num?)?.toDouble() ?? 0).toStringAsFixed(0)}',
                            style: AppTypography.labelMedium.copyWith(color: AppColors.success),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }
}
