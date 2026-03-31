import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
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
        content: Text('Delete recipe "${recipe.name ?? recipe.productName ?? recipe.productId}"?'),
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
    final isLoading = state is RecipesLoading || state is RecipesInitial;
    final error = state is RecipesError ? state.message : null;
    final recipes = state is RecipesLoaded ? state.recipes : <Recipe>[];

    return PosDataTable<Recipe>(
      columns: const [
        PosTableColumn(title: 'Product'),
        PosTableColumn(title: 'Yield', numeric: true),
        PosTableColumn(title: 'Status'),
        PosTableColumn(title: 'Created'),
      ],
      items: recipes,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(recipesProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(
        icon: Icons.restaurant_menu_outlined,
        title: 'No recipes yet',
        subtitle: 'Recipes define ingredient lists for composite products.',
      ),
      actions: [
        PosTableRowAction<Recipe>(
          label: 'Edit',
          icon: Icons.edit_outlined,
          onTap: (recipe) {
            // TODO: Navigate to edit page
          },
        ),
        PosTableRowAction<Recipe>(
          label: 'Delete',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: (recipe) => _handleDelete(recipe),
        ),
      ],
      cellBuilder: (recipe, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(recipe.name ?? recipe.productName ?? recipe.productId.substring(0, 8));
          case 1:
            return Text(recipe.yieldQuantity.toStringAsFixed(2));
          case 2:
            return PosBadge(
              label: (recipe.isActive ?? true) ? 'Active' : 'Inactive',
              variant: (recipe.isActive ?? true) ? PosBadgeVariant.success : PosBadgeVariant.neutral,
            );
          case 3:
            return Text(
              recipe.createdAt != null ? '${recipe.createdAt!.day}/${recipe.createdAt!.month}/${recipe.createdAt!.year}' : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _showCreateDialog() async {
    // Ensure products are loaded
    if (ref.read(productsProvider) is! ProductsLoaded) {
      await ref.read(productsProvider.notifier).load();
    }

    final formKey = GlobalKey<FormState>();
    final yieldController = TextEditingController(text: '1');
    final ingredientQtyController = TextEditingController();
    final wasteController = TextEditingController(text: '0');
    String? selectedProductId;
    String? selectedIngredientId;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final prodState = ref.read(productsProvider);
          final productList = prodState is ProductsLoaded ? prodState.products : <Product>[];

          return AlertDialog(
            title: const Text('New Recipe'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedProductId,
                        decoration: const InputDecoration(labelText: 'Output Product'),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedIngredientId,
                        decoration: const InputDecoration(labelText: 'Ingredient Product'),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedIngredientId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: wasteController,
                        decoration: const InputDecoration(labelText: 'Waste % (0-100)'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx, {
                      'product_id': selectedProductId,
                      'yield_quantity': double.parse(yieldController.text),
                      'ingredients': [
                        {
                          'product_id': selectedIngredientId,
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
          );
        },
      ),
    );

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

    yieldController.dispose();
    ingredientQtyController.dispose();
    wasteController.dispose();
  }
}
