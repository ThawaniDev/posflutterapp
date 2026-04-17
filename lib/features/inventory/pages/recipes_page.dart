import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/models/recipe.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

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
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.inventoryDeleteRecipeTitle,
      message: l10n.recipeDeleteConfirm(recipe.name ?? recipe.productName ?? recipe.productId),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.inventoryRecipeDeleted);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(recipesProvider);

    return PosListPage(
      title: l10n.inventoryRecipes,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showRecipesInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(recipesProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.inventoryNewRecipe, icon: Icons.add, onPressed: () => _showCreateDialog()),
      ],
      child: _buildBody(state),
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
                      PosSearchableDropdown<String>(
                        items: productList.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
                        selectedValue: selectedProductId,
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        label: l10n.inventoryOutputProduct,
                        hint: l10n.inventoryOutputProduct,
                        showSearch: true,
                        clearable: false,
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
                      PosSearchableDropdown<String>(
                        items: productList.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
                        selectedValue: selectedIngredientId,
                        onChanged: (v) => setDialogState(() => selectedIngredientId = v),
                        label: l10n.inventoryIngredientProduct,
                        hint: l10n.inventoryIngredientProduct,
                        showSearch: true,
                        clearable: false,
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
              PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
              PosButton(
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
                variant: PosButtonVariant.ghost,
                label: l10n.commonCreate,
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
          showPosSuccessSnackbar(context, l10n.inventoryRecipeCreated);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    yieldController.dispose();
    ingredientQtyController.dispose();
    wasteController.dispose();
  }
}
