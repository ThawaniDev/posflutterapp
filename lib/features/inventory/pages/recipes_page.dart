import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.inventoryDeleteRecipeTitle),
        content: Text('Delete recipe "${recipe.name ?? recipe.productName ?? recipe.productId}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryRecipeDeleted)));
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryRecipes),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(recipesProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: l10n.inventoryNewRecipe, icon: Icons.add, onPressed: () => _showCreateDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(RecipesState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is RecipesLoading || state is RecipesInitial;
    final error = state is RecipesError ? state.message : null;
    final recipes = state is RecipesLoaded ? state.recipes : <Recipe>[];

    return PosDataTable<Recipe>(
      columns: [
        PosTableColumn(title: l10n.inventoryProduct),
        PosTableColumn(title: l10n.inventoryYield, numeric: true),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.commonDate),
      ],
      items: recipes,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(recipesProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.restaurant_menu_outlined,
        title: l10n.inventoryNoRecipes,
        subtitle: l10n.inventoryNoRecipesHint,
      ),
      actions: [
        PosTableRowAction<Recipe>(
          label: l10n.commonEdit,
          icon: Icons.edit_outlined,
          onTap: (recipe) {
            // TODO: Navigate to edit page
          },
        ),
        PosTableRowAction<Recipe>(
          label: l10n.commonDelete,
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
              label: (recipe.isActive ?? true) ? l10n.commonActive : l10n.commonInactive,
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
    final l10n = AppLocalizations.of(context)!;
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
            title: Text(l10n.inventoryNewRecipe),
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
                        decoration: InputDecoration(labelText: l10n.inventoryOutputProduct),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: yieldController,
                        decoration: InputDecoration(labelText: l10n.inventoryYieldQuantity),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.commonInvalid;
                          return null;
                        },
                      ),
                      const Divider(height: 24),
                      Text(l10n.inventoryIngredient, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedIngredientId,
                        decoration: InputDecoration(labelText: l10n.inventoryIngredientProduct),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedIngredientId = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: ingredientQtyController,
                        decoration: InputDecoration(labelText: l10n.inventoryQuantity),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.commonInvalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: wasteController,
                        decoration: InputDecoration(labelText: l10n.inventoryWastePercent),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
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
                child: Text(l10n.commonCreate),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryRecipeCreated)));
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
