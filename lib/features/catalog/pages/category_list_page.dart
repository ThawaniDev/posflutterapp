import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/utils/locale_helpers.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/catalog/widgets/category_tree_tile.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(categoriesProvider.notifier).load());
  }

  // ─── Category Dialog (Create / Edit) ─────────────────────────

  Future<void> _showCategoryDialog({Category? category, String? parentId}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final nameArController = TextEditingController(text: category?.nameAr ?? '');
    final descController = TextEditingController(text: category?.description ?? '');
    final descArController = TextEditingController(text: category?.descriptionAr ?? '');
    final sortOrderController = TextEditingController(text: category?.sortOrder?.toString() ?? '');
    final isEditing = category != null;
    bool isActive = category?.isActive ?? true;
    String? selectedParentId = parentId ?? category?.parentId;

    // Get current categories for parent picker
    final catState = ref.read(categoriesProvider);
    final allCategories = catState is CategoriesLoaded ? catState.categories : <Category>[];

    // Filter out self and descendants to prevent cycles
    List<Category> availableParents = allCategories;
    if (isEditing) {
      final selfAndDescendants = _collectDescendants(category.id, allCategories)..add(category.id);
      availableParents = allCategories.where((c) => !selfAndDescendants.contains(c.id)).toList();
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEditing ? l10n.catalogEditCategory : l10n.catalogNewCategory),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosTextField(
                    controller: nameController,
                    label: l10n.catalogCategoryNameRequired,
                    hint: l10n.catalogCategoryNameHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: nameArController,
                    label: l10n.catalogArabicName,
                    hint: 'أدخل اسم الفئة',
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: descController,
                    label: l10n.description,
                    hint: l10n.catalogCategoryDescHint,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: descArController,
                    label: l10n.catalogArabicDescription,
                    hint: 'وصف مختصر للفئة',
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Parent category dropdown
                  PosSearchableDropdown<String>(
                    selectedValue: selectedParentId,
                    items: availableParents
                        .map((c) => PosDropdownItem(value: c.id, label: _buildCategoryPath(c, allCategories)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => selectedParentId = v),
                    label: l10n.catalogParentCategory,
                    hint: l10n.catalogNoneRootLevel,
                    clearable: true,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Sort order
                  PosTextField(
                    controller: sortOrderController,
                    label: l10n.catalogSortOrder,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Active toggle
                  SwitchListTile(
                    title: Text(l10n.active),
                    subtitle: Text(l10n.catalogVisibleInPosCatalog),
                    value: isActive,
                    onChanged: (v) => setDialogState(() => isActive = v),
                    activeThumbColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  'name': nameController.text.trim(),
                  if (nameArController.text.trim().isNotEmpty) 'name_ar': nameArController.text.trim(),
                  if (descController.text.trim().isNotEmpty) 'description': descController.text.trim(),
                  if (descArController.text.trim().isNotEmpty) 'description_ar': descArController.text.trim(),
                  'parent_id': selectedParentId,
                  if (sortOrderController.text.trim().isNotEmpty) 'sort_order': int.parse(sortOrderController.text.trim()),
                  'is_active': isActive,
                });
              },
              variant: PosButtonVariant.soft,
              label: isEditing ? l10n.update : l10n.create,
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      try {
        if (isEditing) {
          await ref.read(categoriesProvider.notifier).updateCategory(category.id, result);
          if (mounted) {
            showPosSuccessSnackbar(context, AppLocalizations.of(context)!.categoryUpdated);
          }
        } else {
          await ref.read(categoriesProvider.notifier).createCategory(result);
          if (mounted) {
            showPosSuccessSnackbar(context, AppLocalizations.of(context)!.categoryCreated);
          }
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  Future<void> _handleDelete(Category category) async {
    // Check if it has children
    final catState = ref.read(categoriesProvider);
    final allCats = catState is CategoriesLoaded ? catState.categories : <Category>[];
    final childCount = allCats.where((c) => c.parentId == category.id).length;

    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.catalogDeleteCategoryTitle,
      message:
          'Are you sure you want to delete "${localizedName(context, name: category.name, nameAr: category.nameAr)}"?'
          '${childCount > 0 ? '\nThis category has $childCount subcategories that will also be removed.' : ''}',
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(categoriesProvider.notifier).deleteCategory(category.id);
        if (mounted) {
          showPosSuccessSnackbar(
            context,
            AppLocalizations.of(context)!.categoryDeleted(localizedName(context, name: category.name, nameAr: category.nameAr)),
          );
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────

  Set<String> _collectDescendants(String parentId, List<Category> allCats) {
    final ids = <String>{};
    for (final c in allCats.where((c) => c.parentId == parentId)) {
      ids.add(c.id);
      ids.addAll(_collectDescendants(c.id, allCats));
    }
    return ids;
  }

  String _buildCategoryPath(Category cat, List<Category> allCats) {
    final parts = <String>[localizedName(context, name: cat.name, nameAr: cat.nameAr)];
    String? pid = cat.parentId;
    int safe = 0;
    while (pid != null && safe < 10) {
      final parent = allCats.where((c) => c.id == pid).firstOrNull;
      if (parent == null) break;
      parts.insert(0, localizedName(context, name: parent.name, nameAr: parent.nameAr));
      pid = parent.parentId;
      safe++;
    }
    return parts.join(' › ');
  }

  // ─── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);

    return PosListPage(
      title: l10n.categories,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showCategoryListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        if (categoriesState is CategoriesLoaded) ...[
          PosButton.icon(
            icon: Icons.unfold_more,
            tooltip: l10n.expandAll,
            onPressed: () => ref.read(categoriesProvider.notifier).expandAll(),
            variant: PosButtonVariant.ghost,
          ),
          PosButton.icon(
            icon: Icons.unfold_less,
            tooltip: l10n.collapseAll,
            onPressed: () => ref.read(categoriesProvider.notifier).collapseAll(),
            variant: PosButtonVariant.ghost,
          ),
        ],
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(categoriesProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.catalogNewCategory, icon: Icons.add, onPressed: () => _showCategoryDialog()),
      ],
      child: _buildBody(categoriesState),
    );
  }

  Widget _buildBody(CategoriesState state) {
    if (state is CategoriesLoading || state is CategoriesInitial) {
      return const PosLoading();
    }

    if (state is CategoriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: l10n.retry,
              onPressed: () => ref.read(categoriesProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is CategoriesLoaded) {
      if (state.categories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.catalogNoCategoriesYet, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create categories to organise your products.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              PosButton(label: l10n.catalogCreateFirstCategory, icon: Icons.add, onPressed: () => _showCategoryDialog()),
            ],
          ),
        );
      }

      // Summary bar
      final rootCount = state.roots.length;
      final totalCount = state.categories.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
            ),
            child: Row(
              children: [
                Icon(Icons.account_tree_outlined, size: 16, color: AppColors.mutedFor(context)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$totalCount categories ($rootCount root)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                ),
              ],
            ),
          ),

          // Tree list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: _buildTreeNodes(state, state.roots, 0),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  List<Widget> _buildTreeNodes(CategoriesLoaded state, List<Category> nodes, int depth) {
    final widgets = <Widget>[];
    for (final cat in nodes) {
      final children = state.childrenOf(cat.id);
      final hasChildren = children.isNotEmpty;
      final isExpanded = state.isExpanded(cat.id);

      widgets.add(
        CategoryTreeTile(
          category: cat,
          depth: depth,
          hasChildren: hasChildren,
          isExpanded: isExpanded,
          isSelected: _selectedCategoryId == cat.id,
          onToggleExpand: () => ref.read(categoriesProvider.notifier).toggleExpanded(cat.id),
          onTap: () => setState(() {
            _selectedCategoryId = _selectedCategoryId == cat.id ? null : cat.id;
          }),
          onEdit: () => _showCategoryDialog(category: cat),
          onAddChild: () => _showCategoryDialog(parentId: cat.id),
          onDelete: () => _handleDelete(cat),
        ),
      );

      // Render children if expanded
      if (hasChildren && isExpanded) {
        widgets.addAll(_buildTreeNodes(state, children, depth + 1));
      }
    }
    return widgets;
  }
}
