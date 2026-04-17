import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/flower_arrangement.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ArrangementCard extends StatelessWidget {
  final FlowerArrangement arrangement;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ArrangementCard({super.key, required this.arrangement, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
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
                      color: AppColors.rose.withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: const Icon(Icons.local_florist, color: AppColors.rose, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(arrangement.name, style: AppTypography.titleSmall),
                        if (arrangement.occasion != null) Text(arrangement.occasion!, style: AppTypography.caption),
                      ],
                    ),
                  ),
                  if (arrangement.isTemplate == true)
                    PosStatusBadge(label: l10n.labelTemplate, variant: PosStatusBadgeVariant.info),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      visualDensity: VisualDensity.compact,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                      onPressed: onDelete,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${arrangement.itemsJson.length} flower types', style: AppTypography.bodySmall),
                  Text(
                    '${arrangement.totalPrice.toStringAsFixed(2)} \u0081',
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
