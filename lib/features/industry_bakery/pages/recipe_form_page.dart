import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:wameedpos/features/industry_bakery/providers/bakery_providers.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class RecipeFormPage extends ConsumerStatefulWidget {
  const RecipeFormPage({super.key, this.recipe});
  final BakeryRecipe? recipe;

  @override
  ConsumerState<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends ConsumerState<RecipeFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _saving = false;

  late final TextEditingController _nameCtrl;
  String? _selectedProductId;
  late final TextEditingController _expectedYieldCtrl;
  late final TextEditingController _prepTimeCtrl;
  late final TextEditingController _bakeTimeCtrl;
  late final TextEditingController _bakeTempCtrl;
  late final TextEditingController _instructionsCtrl;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    _isEditing = r != null;
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _selectedProductId = r?.productId;
    _expectedYieldCtrl = TextEditingController(text: r?.expectedYield.toString() ?? '');
    _prepTimeCtrl = TextEditingController(text: r?.prepTimeMinutes?.toString() ?? '');
    _bakeTimeCtrl = TextEditingController(text: r?.bakeTimeMinutes?.toString() ?? '');
    _bakeTempCtrl = TextEditingController(text: r?.bakeTemperatureC?.toString() ?? '');
    _instructionsCtrl = TextEditingController(text: r?.instructions ?? '');
    Future.microtask(() => ref.read(productsProvider.notifier).load());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _expectedYieldCtrl.dispose();
    _prepTimeCtrl.dispose();
    _bakeTimeCtrl.dispose();
    _bakeTempCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'product_id': _selectedProductId ?? '',
      'expected_yield': int.parse(_expectedYieldCtrl.text.trim()),
      if (_prepTimeCtrl.text.isNotEmpty) 'prep_time_minutes': int.parse(_prepTimeCtrl.text.trim()),
      if (_bakeTimeCtrl.text.isNotEmpty) 'bake_time_minutes': int.parse(_bakeTimeCtrl.text.trim()),
      if (_bakeTempCtrl.text.isNotEmpty) 'bake_temperature_c': int.parse(_bakeTempCtrl.text.trim()),
      if (_instructionsCtrl.text.isNotEmpty) 'instructions': _instructionsCtrl.text.trim(),
    };

    final notifier = ref.read(bakeryProvider.notifier);
    if (_isEditing) {
      await notifier.updateRecipe(widget.recipe!.id, data);
    } else {
      await notifier.createRecipe(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : <Product>[];
    return PosFormPage(
      title: _isEditing ? l10n.bakeryEditRecipe : l10n.bakeryNewRecipe,
      bottomBar: PosButton(
          label: _isEditing ? l10n.bakeryUpdateRecipe : l10n.bakeryCreateRecipe,
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _nameCtrl, label: l10n.recipeName, hint: l10n.bakeryRecipeNameHint),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectProduct,
              label: l10n.wameedAIProduct,
              items: products.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
              selectedValue: _selectedProductId,
              onChanged: (v) => setState(() => _selectedProductId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _expectedYieldCtrl,
              label: l10n.expectedYield,
              hint: l10n.bakeryNumberOfUnits,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _prepTimeCtrl,
                    label: l10n.prepTimeMin,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _bakeTimeCtrl,
                    label: l10n.bakeTimeMin,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _bakeTempCtrl,
              label: l10n.bakeTempC,
              hint: l10n.bakeryTemperature,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _instructionsCtrl,
              label: l10n.instructions,
              hint: l10n.bakeryInstructionsHint,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
