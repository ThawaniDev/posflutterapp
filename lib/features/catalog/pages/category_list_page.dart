import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(categoriesProvider.notifier).load());
  }

  Future<void> _showCategoryDialog({Category? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final nameArController = TextEditingController(text: category?.nameAr ?? '');
    final isEditing = category != null;
    bool isActive = category?.isActive ?? true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'New Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(
                  controller: nameController,
                  label: 'Category Name *',
                  hint: 'Enter category name',
                ),
                const SizedBox(height: AppSpacing.md),
                PosTextField(
                  controller: nameArController,
                  label: 'Arabic Name',
                  hint: 'أدخل اسم الفئة',
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (v) => setDialogState(() => isActive = v),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  'name': nameController.text.trim(),
                  if (nameArController.text.trim().isNotEmpty) 'name_ar': nameArController.text.trim(),
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
          await ref.read(categoriesProvider.notifier).updateCategory(category!.id, result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category updated.')));
        } else {
          await ref.read(categoriesProvider.notifier).createCategory(result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category created.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  Future<void> _handleDelete(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(categoriesProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(
        label: 'New Category',
        icon: Icons.add,
        onPressed: () => _showCategoryDialog(),
      ),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ref.read(categoriesProvider.notifier).load(),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: state.categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _CategoryTile(
            category: state.categories[index],
            onEdit: () => _showCategoryDialog(category: state.categories[index]),
            onDelete: () => _handleDelete(state.categories[index]),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTile({required this.category, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: category.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(category.imageUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.category, color: AppColors.primary)),
                )
              : Icon(Icons.category, color: AppColors.primary),
        ),
        title: Text(category.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: category.nameAr != null
            ? Text(category.nameAr!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: category.isActive == true
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category.isActive == true ? 'Active' : 'Inactive',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: category.isActive == true ? AppColors.success : AppColors.error,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: onEdit, tooltip: 'Edit'),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
