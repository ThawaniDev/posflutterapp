import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/bakery_recipe.dart';
import '../providers/bakery_providers.dart';

class RecipeFormPage extends ConsumerStatefulWidget {
  final BakeryRecipe? recipe;
  const RecipeFormPage({super.key, this.recipe});

  @override
  ConsumerState<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends ConsumerState<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _saving = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _productIdCtrl;
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
    _productIdCtrl = TextEditingController(text: r?.productId ?? '');
    _expectedYieldCtrl = TextEditingController(text: r?.expectedYield.toString() ?? '');
    _prepTimeCtrl = TextEditingController(text: r?.prepTimeMinutes?.toString() ?? '');
    _bakeTimeCtrl = TextEditingController(text: r?.bakeTimeMinutes?.toString() ?? '');
    _bakeTempCtrl = TextEditingController(text: r?.bakeTemperatureC?.toString() ?? '');
    _instructionsCtrl = TextEditingController(text: r?.instructions ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _productIdCtrl.dispose();
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
      'product_id': _productIdCtrl.text.trim(),
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
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Recipe' : 'New Recipe')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Recipe' : 'Create Recipe',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosTextField(controller: _nameCtrl, label: 'Recipe Name', hint: 'Enter recipe name'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _productIdCtrl, label: 'Product ID', hint: 'Associated product'),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _expectedYieldCtrl,
              label: 'Expected Yield',
              hint: 'Number of units',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _prepTimeCtrl,
                    label: 'Prep Time (min)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _bakeTimeCtrl,
                    label: 'Bake Time (min)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _bakeTempCtrl,
              label: 'Bake Temp (°C)',
              hint: 'Temperature',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _instructionsCtrl,
              label: 'Instructions',
              hint: 'Detailed baking instructions...',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
