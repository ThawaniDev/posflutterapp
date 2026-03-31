import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../enums/flower_subscription_frequency.dart';
import '../models/flower_subscription.dart';
import '../providers/florist_providers.dart';

class SubscriptionFormPage extends ConsumerStatefulWidget {
  final FlowerSubscription? subscription;
  const SubscriptionFormPage({super.key, this.subscription});

  @override
  ConsumerState<SubscriptionFormPage> createState() => _SubscriptionFormPageState();
}

class _SubscriptionFormPageState extends ConsumerState<SubscriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.subscription != null;

  late final TextEditingController _customerIdCtrl;
  late final TextEditingController _arrangementTemplateIdCtrl;
  late final TextEditingController _deliveryDayCtrl;
  late final TextEditingController _deliveryAddressCtrl;
  late final TextEditingController _pricePerDeliveryCtrl;
  FlowerSubscriptionFrequency _frequency = FlowerSubscriptionFrequency.weekly;
  DateTime _nextDeliveryDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    _customerIdCtrl = TextEditingController(text: s?.customerId ?? '');
    _arrangementTemplateIdCtrl = TextEditingController(text: s?.arrangementTemplateId ?? '');
    _deliveryDayCtrl = TextEditingController(text: s?.deliveryDay ?? '');
    _deliveryAddressCtrl = TextEditingController(text: s?.deliveryAddress ?? '');
    _pricePerDeliveryCtrl = TextEditingController(text: s?.pricePerDelivery.toStringAsFixed(2) ?? '');
    if (s != null) {
      _frequency = s.frequency;
      _nextDeliveryDate = s.nextDeliveryDate;
    }
  }

  @override
  void dispose() {
    _customerIdCtrl.dispose();
    _arrangementTemplateIdCtrl.dispose();
    _deliveryDayCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _pricePerDeliveryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextDeliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _nextDeliveryDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'customer_id': _customerIdCtrl.text.trim(),
      'frequency': _frequency.value,
      'delivery_address': _deliveryAddressCtrl.text.trim(),
      'price_per_delivery': double.parse(_pricePerDeliveryCtrl.text.trim()),
      'next_delivery_date': _nextDeliveryDate.toIso8601String().split('T').first,
      if (_arrangementTemplateIdCtrl.text.isNotEmpty) 'arrangement_template_id': _arrangementTemplateIdCtrl.text.trim(),
      if (_deliveryDayCtrl.text.isNotEmpty) 'delivery_day': _deliveryDayCtrl.text.trim(),
    };

    final notifier = ref.read(floristProvider.notifier);
    if (_isEditing) {
      await notifier.updateSubscription(widget.subscription!.id, data);
    } else {
      await notifier.createSubscription(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Subscription' : 'New Subscription')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Subscription' : 'Create Subscription',
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
            PosTextField(controller: _customerIdCtrl, label: 'Customer ID', hint: 'Select customer'),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _arrangementTemplateIdCtrl,
              label: 'Arrangement Template (optional)',
              hint: 'Select template arrangement',
            ),
            SizedBox(height: AppSpacing.md),
            PosDropdown<FlowerSubscriptionFrequency>(
              label: 'Frequency',
              hint: 'Select frequency',
              value: _frequency,
              onChanged: (v) {
                if (v != null) setState(() => _frequency = v);
              },
              items: FlowerSubscriptionFrequency.values.map((f) => DropdownMenuItem(value: f, child: Text(f.value))).toList(),
            ),
            SizedBox(height: AppSpacing.md),
            PosDropdown<String>(
              label: 'Delivery Day',
              hint: 'Preferred day',
              value: _deliveryDayCtrl.text.isEmpty ? null : _deliveryDayCtrl.text,
              onChanged: (v) => setState(() => _deliveryDayCtrl.text = v ?? ''),
              items: [
                'monday',
                'tuesday',
                'wednesday',
                'thursday',
                'friday',
                'saturday',
                'sunday',
              ].map((d) => DropdownMenuItem(value: d, child: Text(d[0].toUpperCase() + d.substring(1)))).toList(),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _deliveryAddressCtrl, label: 'Delivery Address', hint: 'Full delivery address', maxLines: 2),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _pricePerDeliveryCtrl,
              label: 'Price Per Delivery (SAR)',
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(
                    text: '${_nextDeliveryDate.day}/${_nextDeliveryDate.month}/${_nextDeliveryDate.year}',
                  ),
                  label: 'Next Delivery Date',
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
