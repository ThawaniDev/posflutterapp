import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
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
    final indent = depth * 28.0;

    return Material(
      color: isSelected ? AppColors.primary10 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: AppSpacing.md + indent, right: AppSpacing.sm, top: AppSpacing.xs, bottom: AppSpacing.xs),
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
                        icon: Icon(isExpanded ? Icons.expand_more : Icons.chevron_right, color: AppColors.textMutedLight),
                        onPressed: onToggleExpand,
                      )
                    : const SizedBox.shrink(),
              ),

              // Category icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(8)),
                child: category.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          category.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.category, size: 18, color: AppColors.primary),
                        ),
                      )
                    : Icon(Icons.category, size: 18, color: AppColors.primary),
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
                            category.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (category.nameAr != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              '(${category.nameAr})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (category.description != null && category.description!.isNotEmpty)
                      Text(
                        category.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
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
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category.isActive == true ? 'Active' : 'Inactive',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: category.isActive == true ? AppColors.success : AppColors.error),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),

              // Sort order
              if (category.sortOrder != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Tooltip(
                    message: 'Sort order',
                    child: Text(
                      '#${category.sortOrder}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
                    ),
                  ),
                ),

              // Actions
              IconButton(icon: Icon(Icons.add, size: 18), tooltip: l10n.addSubcategory, onPressed: onAddChild),
              IconButton(icon: Icon(Icons.edit_outlined, size: 18), tooltip: l10n.edit, onPressed: onEdit),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
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
