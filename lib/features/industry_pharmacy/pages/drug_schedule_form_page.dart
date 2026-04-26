import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_pharmacy/enums/drug_schedule_type.dart';
import 'package:wameedpos/features/industry_pharmacy/models/drug_schedule.dart';
import 'package:wameedpos/features/industry_pharmacy/providers/pharmacy_providers.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class DrugScheduleFormPage extends ConsumerStatefulWidget {
  const DrugScheduleFormPage({super.key, this.schedule});
  final DrugSchedule? schedule;

  @override
  ConsumerState<DrugScheduleFormPage> createState() => _DrugScheduleFormPageState();
}

class _DrugScheduleFormPageState extends ConsumerState<DrugScheduleFormPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.schedule != null;

  String? _selectedProductId;
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
    _selectedProductId = s?.productId;
    _activeIngredientCtrl = TextEditingController(text: s?.activeIngredient ?? '');
    _dosageFormCtrl = TextEditingController(text: s?.dosageForm ?? '');
    _strengthCtrl = TextEditingController(text: s?.strength ?? '');
    _manufacturerCtrl = TextEditingController(text: s?.manufacturer ?? '');
    if (s != null) {
      _scheduleType = s.scheduleType;
      _requiresPrescription = s.requiresPrescription ?? false;
    }
    Future.microtask(() => ref.read(productsProvider.notifier).load());
  }

  @override
  void dispose() {
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
      'product_id': _selectedProductId ?? '',
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
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : <Product>[];
    return PosFormPage(
      title: _isEditing ? l10n.pharmacyEditDrugSchedule : l10n.pharmacyNewDrugSchedule,
      bottomBar: PosButton(
        label: _isEditing ? l10n.pharmacyUpdateSchedule : l10n.pharmacyCreateSchedule,
        onPressed: _saving ? null : _handleSave,
        isLoading: _saving,
        isFullWidth: true,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosSearchableDropdown<String>(
              hint: l10n.selectProduct,
              label: l10n.wameedAIProduct,
              items: products.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
              selectedValue: _selectedProductId,
              onChanged: _isEditing ? null : (v) => setState(() => _selectedProductId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<DrugScheduleType>(
              hint: l10n.selectScheduleType,
              label: l10n.notifScheduleType,
              items: DrugScheduleType.values.map((t) {
                final label = switch (t) {
                  DrugScheduleType.otc => 'OTC (Over-the-Counter)',
                  DrugScheduleType.prescriptionOnly => 'Prescription Only',
                  DrugScheduleType.controlled => 'Controlled Substance',
                };
                return PosDropdownItem(value: t, label: label);
              }).toList(),
              selectedValue: _scheduleType,
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
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _activeIngredientCtrl,
              label: l10n.pharmacyActiveIngredient,
              hint: l10n.pharmacyDrugNameHint,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _dosageFormCtrl, label: l10n.pharmacyDosageForm, hint: l10n.pharmacyFormHint),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _strengthCtrl, label: l10n.pharmacyStrength, hint: 'e.g. 500mg'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _manufacturerCtrl, label: l10n.pharmacyManufacturer, hint: l10n.pharmacyManufacturerHint),
            const SizedBox(height: AppSpacing.md),
            PosToggle(
              value: _requiresPrescription,
              onChanged: (v) => setState(() => _requiresPrescription = v),
              label: l10n.pharmacyRequiresPrescription,
              subtitle: l10n.pharmacyPrescriptionRequired,
            ),
          ],
        ),
      ),
    );
  }
}
