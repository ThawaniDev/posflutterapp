import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/bakery_recipe.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class RecipeCard extends StatelessWidget {
  final BakeryRecipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RecipeCard({super.key, required this.recipe, this.onTap, this.onEdit, this.onDelete});

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
                    decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderSm),
                    child: const Icon(Icons.bakery_dining, color: AppColors.primary, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(recipe.name, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
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
              if (recipe.bakeTimeMinutes != null || recipe.bakeTemperatureC != null) ...[
                AppSpacing.gapH12,
                Row(
                  children: [
                    if (recipe.prepTimeMinutes != null) ...[
                      Icon(Icons.timer_outlined, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      AppSpacing.gapW4,
                      Text(l10n.bakeryPrepTimeMin(recipe.prepTimeMinutes.toString()), style: AppTypography.bodySmall),
                      AppSpacing.gapW16,
                    ],
                    if (recipe.bakeTimeMinutes != null) ...[
                      const Icon(Icons.local_fire_department, size: 16, color: AppColors.warning),
                      AppSpacing.gapW4,
                      Text(l10n.bakeryBakeTimeMin(recipe.bakeTimeMinutes.toString()), style: AppTypography.bodySmall),
                      AppSpacing.gapW16,
                    ],
                    if (recipe.bakeTemperatureC != null) ...[
                      const Icon(Icons.thermostat, size: 16, color: AppColors.error),
                      AppSpacing.gapW4,
                      Text('${recipe.bakeTemperatureC}°C', style: AppTypography.bodySmall),
                    ],
                  ],
                ),
              ],
              ...[
                AppSpacing.gapH8,
                PosStatusBadge(
                  label: l10n.bakeryYieldUnits(recipe.expectedYield.toString()),
                  variant: PosStatusBadgeVariant.info,
                  icon: Icons.inventory_2_outlined,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
