import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/custom_cake_order.dart';
import '../providers/bakery_providers.dart';

class CakeOrderFormPage extends ConsumerStatefulWidget {
  final CustomCakeOrder? order;
  const CakeOrderFormPage({super.key, this.order});

  @override
  ConsumerState<CakeOrderFormPage> createState() => _CakeOrderFormPageState();
}

class _CakeOrderFormPageState extends ConsumerState<CakeOrderFormPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Cake Order' : 'New Cake Order')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Order' : 'Create Order',
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
            PosTextField(controller: _descriptionCtrl, label: 'Description', hint: 'Cake description', maxLines: 3),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _sizeCtrl, label: 'Size', hint: 'e.g. 8 inch'),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _flavorCtrl, label: 'Flavor', hint: 'e.g. Chocolate'),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _decorationCtrl,
              label: 'Decoration Notes',
              hint: 'Special decoration requests...',
              maxLines: 3,
            ),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}'),
                  label: 'Delivery Date',
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _deliveryTimeCtrl, label: 'Delivery Time', hint: 'e.g. 14:00'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _priceCtrl,
                    label: 'Price (SAR)',
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _depositCtrl,
                    label: 'Deposit Paid',
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
