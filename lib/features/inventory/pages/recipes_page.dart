import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/models/recipe.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(recipesProvider.notifier).load());
  }

  Future<void> _handleDelete(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Delete recipe for product "${recipe.productId}"?'),
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
        await ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe deleted.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(recipesProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Recipe', icon: Icons.add, onPressed: () => _showCreateDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(RecipesState state) {
    if (state is RecipesLoading || state is RecipesInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RecipesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
              onPressed: () => ref.read(recipesProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is RecipesLoaded) {
      if (state.recipes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No recipes yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Recipes define ingredient lists for composite products.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: _buildTable(state.recipes));
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<Recipe> recipes) {
    return PosDataTable(
      columns: const [
        DataColumn(label: Text('PRODUCT')),
        DataColumn(label: Text('YIELD'), numeric: true),
        DataColumn(label: Text('STATUS')),
        DataColumn(label: Text('CREATED')),
        DataColumn(label: Text('ACTIONS')),
      ],
      rows: recipes.map((recipe) {
        return DataRow(
          cells: [
            DataCell(Text(recipe.productId.substring(0, 8))),
            DataCell(Text(recipe.yieldQuantity.toStringAsFixed(2))),
            DataCell(
              PosBadge(
                label: (recipe.isActive ?? true) ? 'Active' : 'Inactive',
                variant: (recipe.isActive ?? true) ? PosBadgeVariant.success : PosBadgeVariant.neutral,
              ),
            ),
            DataCell(
              Text(
                recipe.createdAt != null ? '${recipe.createdAt!.day}/${recipe.createdAt!.month}/${recipe.createdAt!.year}' : '-',
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Edit',
                    onPressed: () {
                      // TODO: Navigate to edit page
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    tooltip: 'Delete',
                    onPressed: () => _handleDelete(recipe),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _showCreateDialog() async {
    final formKey = GlobalKey<FormState>();
    final productIdController = TextEditingController();
    final yieldController = TextEditingController(text: '1');
    final ingredientProductController = TextEditingController();
    final ingredientQtyController = TextEditingController();
    final wasteController = TextEditingController(text: '0');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Recipe'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: productIdController,
                  decoration: const InputDecoration(labelText: 'Product ID (output)'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: yieldController,
                  decoration: const InputDecoration(labelText: 'Yield Quantity'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (double.tryParse(v) == null) return 'Invalid';
                    return null;
                  },
                ),
                const Divider(height: 24),
                const Text('Ingredient', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: ingredientProductController,
                  decoration: const InputDecoration(labelText: 'Ingredient Product ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: ingredientQtyController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (double.tryParse(v) == null) return 'Invalid';
                    return null;
                  },
                ),
                TextFormField(
                  controller: wasteController,
                  decoration: const InputDecoration(labelText: 'Waste % (0-100)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, {
                  'product_id': productIdController.text,
                  'yield_quantity': double.parse(yieldController.text),
                  'ingredients': [
                    {
                      'product_id': ingredientProductController.text,
                      'quantity': double.parse(ingredientQtyController.text),
                      'waste_percent': double.tryParse(wasteController.text) ?? 0,
                    },
                  ],
                });
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    productIdController.dispose();
    yieldController.dispose();
    ingredientProductController.dispose();
    ingredientQtyController.dispose();
    wasteController.dispose();

    if (result != null && mounted) {
      try {
        await ref.read(recipesProvider.notifier).createRecipe(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe created.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }
}
