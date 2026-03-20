import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/flower_arrangement.dart';

class ArrangementCard extends StatelessWidget {
  final FlowerArrangement arrangement;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ArrangementCard({
    super.key,
    required this.arrangement,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.local_florist, color: Colors.pink, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(arrangement.name, style: AppTypography.titleSmall),
                        if (arrangement.occasion != null)
                          Text(arrangement.occasion!, style: AppTypography.caption),
                      ],
                    ),
                  ),
                  if (arrangement.isTemplate)
                    const PosStatusBadge(label: 'Template', variant: PosStatusBadgeVariant.info),
                  if (onEdit != null)
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: onEdit, visualDensity: VisualDensity.compact),
                  if (onDelete != null)
                    IconButton(icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error), onPressed: onDelete, visualDensity: VisualDensity.compact),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (arrangement.itemsJson != null)
                    Text('${arrangement.itemsJson!.length} flower types', style: AppTypography.bodySmall),
                  Text(
                    '${arrangement.totalPrice.toStringAsFixed(2)} OMR',
                    style: AppTypography.priceSmall.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
