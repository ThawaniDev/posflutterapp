import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../enums/drug_schedule_type.dart';
import '../models/drug_schedule.dart';
import '../providers/pharmacy_providers.dart';

class DrugScheduleFormPage extends ConsumerStatefulWidget {
  final DrugSchedule? schedule;
  const DrugScheduleFormPage({super.key, this.schedule});

  @override
  ConsumerState<DrugScheduleFormPage> createState() => _DrugScheduleFormPageState();
}

class _DrugScheduleFormPageState extends ConsumerState<DrugScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.schedule != null;

  late final TextEditingController _productIdCtrl;
  late final TextEditingController _activeIngredientCtrl;
  late final TextEditingController _dosageFormCtrl;
  late final TextEditingController _strengthCtrl;
  late final TextEditingController _manufacturerCtrl;
  DrugScheduleType _scheduleType = DrugScheduleType.otc;
  bool _requiresPrescription = false;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _productIdCtrl = TextEditingController(text: s?.productId ?? '');
    _activeIngredientCtrl = TextEditingController(text: s?.activeIngredient ?? '');
    _dosageFormCtrl = TextEditingController(text: s?.dosageForm ?? '');
    _strengthCtrl = TextEditingController(text: s?.strength ?? '');
    _manufacturerCtrl = TextEditingController(text: s?.manufacturer ?? '');
    if (s != null) {
      _scheduleType = s.scheduleType;
      _requiresPrescription = s.requiresPrescription ?? false;
    }
  }

  @override
  void dispose() {
    _productIdCtrl.dispose();
    _activeIngredientCtrl.dispose();
    _dosageFormCtrl.dispose();
    _strengthCtrl.dispose();
    _manufacturerCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'product_id': _productIdCtrl.text.trim(),
      'schedule_type': _scheduleType.value,
      'requires_prescription': _requiresPrescription,
      if (_activeIngredientCtrl.text.isNotEmpty) 'active_ingredient': _activeIngredientCtrl.text.trim(),
      if (_dosageFormCtrl.text.isNotEmpty) 'dosage_form': _dosageFormCtrl.text.trim(),
      if (_strengthCtrl.text.isNotEmpty) 'strength': _strengthCtrl.text.trim(),
      if (_manufacturerCtrl.text.isNotEmpty) 'manufacturer': _manufacturerCtrl.text.trim(),
    };

    final notifier = ref.read(pharmacyProvider.notifier);
    if (_isEditing) {
      await notifier.updateDrugSchedule(widget.schedule!.id, data);
    } else {
      await notifier.createDrugSchedule(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Drug Schedule' : 'New Drug Schedule')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Schedule' : 'Create Schedule',
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
            PosTextField(controller: _productIdCtrl, label: 'Product ID', hint: 'Select product', readOnly: _isEditing),
            SizedBox(height: AppSpacing.md),
            PosDropdown<DrugScheduleType>(
              label: 'Schedule Type',
              hint: 'Select type',
              value: _scheduleType,
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _scheduleType = v;
                    if (v == DrugScheduleType.prescriptionOnly || v == DrugScheduleType.controlled) {
                      _requiresPrescription = true;
                    }
                  });
                }
              },
              items: DrugScheduleType.values.map((t) {
                final label = switch (t) {
                  DrugScheduleType.otc => 'OTC (Over-the-Counter)',
                  DrugScheduleType.prescriptionOnly => 'Prescription Only',
                  DrugScheduleType.controlled => 'Controlled Substance',
                };
                return DropdownMenuItem(value: t, child: Text(label));
              }).toList(),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _activeIngredientCtrl, label: 'Active Ingredient', hint: 'e.g. Paracetamol'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _dosageFormCtrl, label: 'Dosage Form', hint: 'e.g. Tablet, Syrup'),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _strengthCtrl, label: 'Strength', hint: 'e.g. 500mg'),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _manufacturerCtrl, label: 'Manufacturer', hint: 'Drug manufacturer'),
            SizedBox(height: AppSpacing.md),
            PosToggle(
              value: _requiresPrescription,
              onChanged: (v) => setState(() => _requiresPrescription = v),
              label: 'Requires Prescription',
              subtitle: 'Must present valid prescription to purchase',
            ),
          ],
        ),
      ),
    );
  }
}
