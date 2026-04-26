import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_bakery/models/custom_cake_order.dart';
import 'package:wameedpos/features/industry_bakery/providers/bakery_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class CakeOrderFormPage extends ConsumerStatefulWidget {
  const CakeOrderFormPage({super.key, this.order});
  final CustomCakeOrder? order;

  @override
  ConsumerState<CakeOrderFormPage> createState() => _CakeOrderFormPageState();
}

class _CakeOrderFormPageState extends ConsumerState<CakeOrderFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.order != null;

  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _sizeCtrl;
  late final TextEditingController _flavorCtrl;
  late final TextEditingController _decorationCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _depositCtrl;
  late final TextEditingController _deliveryTimeCtrl;
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 3));

  @override
  void initState() {
    super.initState();
    final o = widget.order;
    _descriptionCtrl = TextEditingController(text: o?.description ?? '');
    _sizeCtrl = TextEditingController(text: o?.size ?? '');
    _flavorCtrl = TextEditingController(text: o?.flavor ?? '');
    _decorationCtrl = TextEditingController(text: o?.decorationNotes ?? '');
    _priceCtrl = TextEditingController(text: o?.price.toStringAsFixed(2) ?? '');
    _depositCtrl = TextEditingController(text: o?.depositPaid?.toStringAsFixed(2) ?? '');
    _deliveryTimeCtrl = TextEditingController(text: o?.deliveryTime ?? '');
    if (o != null) _deliveryDate = o.deliveryDate;
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _sizeCtrl.dispose();
    _flavorCtrl.dispose();
    _decorationCtrl.dispose();
    _priceCtrl.dispose();
    _depositCtrl.dispose();
    _deliveryTimeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _deliveryDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'description': _descriptionCtrl.text.trim(),
      'delivery_date': _deliveryDate.toIso8601String().split('T').first,
      'price': double.parse(_priceCtrl.text.trim()),
      if (_sizeCtrl.text.isNotEmpty) 'size': _sizeCtrl.text.trim(),
      if (_flavorCtrl.text.isNotEmpty) 'flavor': _flavorCtrl.text.trim(),
      if (_decorationCtrl.text.isNotEmpty) 'decoration_notes': _decorationCtrl.text.trim(),
      if (_depositCtrl.text.isNotEmpty) 'deposit_paid': double.parse(_depositCtrl.text.trim()),
      if (_deliveryTimeCtrl.text.isNotEmpty) 'delivery_time': _deliveryTimeCtrl.text.trim(),
    };

    final notifier = ref.read(bakeryProvider.notifier);
    if (_isEditing) {
      await notifier.updateCakeOrder(widget.order!.id, data);
    } else {
      await notifier.createCakeOrder(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosFormPage(
      title: _isEditing ? l10n.bakeryEditCakeOrder : l10n.bakeryNewCakeOrder,
      bottomBar: PosButton(
          label: _isEditing ? l10n.bakeryUpdateOrder : l10n.bakeryCreateOrder,
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _descriptionCtrl, label: l10n.description, hint: l10n.bakeryCakeDescription, maxLines: 3),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _sizeCtrl, label: l10n.labelSize, hint: 'e.g. 8 inch'),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _flavorCtrl, label: l10n.bakeryFlavor, hint: l10n.bakeryFlavorHint),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _decorationCtrl,
              label: l10n.bakeryDecorationNotes,
              hint: l10n.bakeryDecorationHint,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}'),
                  label: l10n.bakeryDeliveryDate,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _deliveryTimeCtrl, label: l10n.bakeryDeliveryTime, hint: 'e.g. 14:00'),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _priceCtrl,
                    label: l10n.bakeryPriceSar,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _depositCtrl,
                    label: l10n.bakeryDepositPaid,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
