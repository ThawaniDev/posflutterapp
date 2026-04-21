import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_florist/enums/flower_subscription_frequency.dart';
import 'package:wameedpos/features/industry_florist/models/flower_subscription.dart';
import 'package:wameedpos/features/industry_florist/providers/florist_providers.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class SubscriptionFormPage extends ConsumerStatefulWidget {
  const SubscriptionFormPage({super.key, this.subscription});
  final FlowerSubscription? subscription;

  @override
  ConsumerState<SubscriptionFormPage> createState() => _SubscriptionFormPageState();
}

class _SubscriptionFormPageState extends ConsumerState<SubscriptionFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.subscription != null;

  String? _selectedCustomerId;
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
    _selectedCustomerId = s?.customerId;
    _arrangementTemplateIdCtrl = TextEditingController(text: s?.arrangementTemplateId ?? '');
    _deliveryDayCtrl = TextEditingController(text: s?.deliveryDay ?? '');
    _deliveryAddressCtrl = TextEditingController(text: s?.deliveryAddress ?? '');
    _pricePerDeliveryCtrl = TextEditingController(text: s?.pricePerDelivery.toStringAsFixed(2) ?? '');
    if (s != null) {
      _frequency = s.frequency;
      _nextDeliveryDate = s.nextDeliveryDate;
    }
    Future.microtask(() => ref.read(customersProvider.notifier).load());
  }

  @override
  void dispose() {
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
      'customer_id': _selectedCustomerId ?? '',
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
    final customersState = ref.watch(customersProvider);
    final customers = customersState is CustomersLoaded ? customersState.customers : <Customer>[];
    return PosFormPage(
      title: _isEditing ? 'Edit Subscription' : 'New Subscription',
      bottomBar: PosButton(
          label: _isEditing ? 'Update Subscription' : 'Create Subscription',
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
              hint: l10n.selectCustomer,
              label: l10n.debitsCustomer,
              items: customers.map((c) => PosDropdownItem(value: c.id, label: c.name)).toList(),
              selectedValue: _selectedCustomerId,
              onChanged: (v) => setState(() => _selectedCustomerId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _arrangementTemplateIdCtrl,
              label: l10n.floristArrangementOptional,
              hint: l10n.floristSelectTemplate,
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<FlowerSubscriptionFrequency>(
              hint: l10n.selectFrequency,
              label: l10n.floristFrequency,
              items: FlowerSubscriptionFrequency.values.map((f) => PosDropdownItem(value: f, label: f.value)).toList(),
              selectedValue: _frequency,
              onChanged: (v) {
                if (v != null) setState(() => _frequency = v);
              },
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectDay,
              label: l10n.floristDeliveryDay,
              items: [
                'monday',
                'tuesday',
                'wednesday',
                'thursday',
                'friday',
                'saturday',
                'sunday',
              ].map((d) => PosDropdownItem(value: d, label: d[0].toUpperCase() + d.substring(1))).toList(),
              selectedValue: _deliveryDayCtrl.text.isEmpty ? null : _deliveryDayCtrl.text,
              onChanged: (v) => setState(() => _deliveryDayCtrl.text = v ?? ''),
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _deliveryAddressCtrl, label: l10n.floristDeliveryAddress, hint: l10n.floristDeliveryAddressHint, maxLines: 2),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _pricePerDeliveryCtrl,
              label: l10n.floristPricePerDelivery,
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(
                    text: '${_nextDeliveryDate.day}/${_nextDeliveryDate.month}/${_nextDeliveryDate.year}',
                  ),
                  label: l10n.floristNextDeliveryDate,
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
