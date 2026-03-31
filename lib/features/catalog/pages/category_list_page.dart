import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
import 'package:thawani_pos/features/catalog/widgets/category_tree_tile.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
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
          title: Text(isEditing ? 'Edit Category' : 'New Category'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosTextField(controller: nameController, label: 'Category Name *', hint: 'Enter category name'),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: nameArController,
                    label: 'Arabic Name',
                    hint: 'أدخل اسم الفئة',
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: descController,
                    label: 'Description',
                    hint: 'Brief description of this category',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PosTextField(
                    controller: descArController,
                    label: 'Arabic Description',
                    hint: 'وصف مختصر للفئة',
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Parent category dropdown
                  Text('Parent Category', style: Theme.of(ctx).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: selectedParentId,
                    decoration: InputDecoration(
                      hintText: 'None (root level)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem<String>(value: null, child: Text('None (root level)')),
                      ...availableParents.map(
                        (c) => DropdownMenuItem<String>(value: c.id, child: Text(_buildCategoryPath(c, allCategories))),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => selectedParentId = v),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Sort order
                  PosTextField(
                    controller: sortOrderController,
                    label: 'Sort Order',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Active toggle
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Visible in POS and catalog'),
                    value: isActive,
                    onChanged: (v) => setDialogState(() => isActive = v),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
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
              child: Text(isEditing ? 'Update' : 'Create'),
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category updated.')));
          }
        } else {
          await ref.read(categoriesProvider.notifier).createCategory(result);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category created.')));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  Future<void> _handleDelete(Category category) async {
    // Check if it has children
    final catState = ref.read(categoriesProvider);
    final allCats = catState is CategoriesLoaded ? catState.categories : <Category>[];
    final childCount = allCats.where((c) => c.parentId == category.id).length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${category.name}"?'),
            if (childCount > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'This category has $childCount subcategories that will also be removed.',
                        style: TextStyle(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(categoriesProvider.notifier).deleteCategory(category.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category "${category.name}" deleted.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
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
    final parts = <String>[cat.name];
    String? pid = cat.parentId;
    int safe = 0;
    while (pid != null && safe < 10) {
      final parent = allCats.where((c) => c.id == pid).firstOrNull;
      if (parent == null) break;
      parts.insert(0, parent.name);
      pid = parent.parentId;
      safe++;
    }
    return parts.join(' › ');
  }

  // ─── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          if (categoriesState is CategoriesLoaded) ...[
            IconButton(
              icon: const Icon(Icons.unfold_more),
              tooltip: 'Expand all',
              onPressed: () => ref.read(categoriesProvider.notifier).expandAll(),
            ),
            IconButton(
              icon: const Icon(Icons.unfold_less),
              tooltip: 'Collapse all',
              onPressed: () => ref.read(categoriesProvider.notifier).collapseAll(),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(categoriesProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Category', icon: Icons.add, onPressed: () => _showCategoryDialog()),
      body: _buildBody(categoriesState),
    );
  }

  Widget _buildBody(CategoriesState state) {
    if (state is CategoriesLoading || state is CategoriesInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CategoriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
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
              Text('No categories yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create categories to organise your products.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              PosButton(label: 'Create First Category', icon: Icons.add, onPressed: () => _showCategoryDialog()),
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
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Icon(Icons.account_tree_outlined, size: 16, color: AppColors.textMutedLight),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$totalCount categories ($rootCount root)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
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
