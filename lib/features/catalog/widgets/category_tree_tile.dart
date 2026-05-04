import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/utils/locale_helpers.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// A single node in the category tree.
/// Renders with indentation based on [depth] and shows expand/collapse
/// toggle when [hasChildren] is true.
class CategoryTreeTile extends StatelessWidget {
  const CategoryTreeTile({
    super.key,
    required this.category,
    required this.depth,
    this.hasChildren = false,
    this.isExpanded = false,
    this.isSelected = false,
    this.onToggleExpand,
    this.onTap,
    this.onEdit,
    this.onAddChild,
    this.onDelete,
  });

  final Category category;
  final int depth;
  final bool hasChildren;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onAddChild;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mutedColor = AppColors.mutedFor(context);
    final indent = depth * 28.0;

    return Material(
      color: isSelected ? AppColors.primary10 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppSpacing.md + indent,
            end: AppSpacing.sm,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
          ),
          child: Row(
            children: [
              // Expand / collapse toggle or spacer
              SizedBox(
                width: 28,
                height: 28,
                child: hasChildren
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: Icon(isExpanded ? Icons.expand_more : Icons.chevron_right, color: mutedColor),
                        onPressed: onToggleExpand,
                      )
                    : const SizedBox.shrink(),
              ),

              // Category icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderMd),
                child: category.imageUrl != null
                    ? ClipRRect(
                        borderRadius: AppRadius.borderMd,
                        child: Image.network(
                          category.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.category, size: 18, color: AppColors.primary),
                        ),
                      )
                    : const Icon(Icons.category, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Name + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            localizedName(context, name: category.name, nameAr: category.nameAr),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (category.description != null && category.description!.isNotEmpty)
                      Text(
                        category.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: mutedColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: category.isActive == true
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderXs,
                ),
                child: Text(
                  category.isActive == true ? l10n.active : l10n.inactive,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: category.isActive == true ? AppColors.success : AppColors.error),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),

              // Sort order
              if (category.sortOrder != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                  child: Tooltip(
                    message: l10n.catalogSortOrder,
                    child: Text(
                      '#${category.sortOrder}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: mutedColor),
                    ),
                  ),
                ),

              // Actions
              IconButton(icon: const Icon(Icons.add, size: 18), tooltip: l10n.addSubcategory, onPressed: onAddChild),
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), tooltip: l10n.edit, onPressed: onEdit),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                tooltip: l10n.delete,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
