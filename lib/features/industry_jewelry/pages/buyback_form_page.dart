import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_jewelry/enums/buyback_payment_method.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class BuybackFormPage extends ConsumerStatefulWidget {
  const BuybackFormPage({super.key});

  @override
  ConsumerState<BuybackFormPage> createState() => _BuybackFormPageState();
}

class _BuybackFormPageState extends ConsumerState<BuybackFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  MetalType _metalType = MetalType.gold;
  BuybackPaymentMethod _paymentMethod = BuybackPaymentMethod.cash;

  late final TextEditingController _karatCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _ratePerGramCtrl;
  String? _selectedStaffUserId;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _karatCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    _ratePerGramCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    Future.microtask(() => ref.read(staffListProvider.notifier).load());
  }

  @override
  void dispose() {
    _karatCtrl.dispose();
    _weightCtrl.dispose();
    _ratePerGramCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  double get _totalAmount {
    final w = double.tryParse(_weightCtrl.text) ?? 0;
    final r = double.tryParse(_ratePerGramCtrl.text) ?? 0;
    return w * r;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'metal_type': _metalType.value,
      'karat': _karatCtrl.text.trim(),
      'weight_g': double.parse(_weightCtrl.text.trim()),
      'rate_per_gram': double.parse(_ratePerGramCtrl.text.trim()),
      'total_amount': _totalAmount,
      'payment_method': _paymentMethod.value,
      'staff_user_id': _selectedStaffUserId ?? '',
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    };

    await ref.read(jewelryProvider.notifier).createBuyback(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    return PosFormPage(
      title: l10n.jewelryNewBuyback,
      bottomBar: PosButton(label: l10n.jewelryRecordBuyback, onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosSearchableDropdown<MetalType>(
              hint: l10n.selectMetalType,
              label: l10n.jewelryMetalType,
              items: MetalType.values
                  .map((m) => PosDropdownItem(value: m, label: m.value[0].toUpperCase() + m.value.substring(1)))
                  .toList(),
              selectedValue: _metalType,
              onChanged: (v) {
                if (v != null) setState(() => _metalType = v);
              },
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _karatCtrl, label: l10n.jewelryKarat, hint: l10n.jewelryKaratHint),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _weightCtrl,
                    label: l10n.jewelryWeight,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _ratePerGramCtrl,
                    label: l10n.jewelryRatePerGram,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                'Total: ${_totalAmount.toStringAsFixed(2)} \u0081',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<BuybackPaymentMethod>(
              hint: l10n.selectPaymentMethod,
              label: l10n.paymentMethod,
              items: BuybackPaymentMethod.values.map((m) => PosDropdownItem(value: m, label: m.value)).toList(),
              selectedValue: _paymentMethod,
              onChanged: (v) {
                if (v != null) setState(() => _paymentMethod = v);
              },
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectStaffMember,
              label: l10n.staffMember,
              items: staffList.map((s) => PosDropdownItem(value: s.id, label: l10n.electronicsStaffFullName(s.firstName, s.lastName))).toList(),
              selectedValue: _selectedStaffUserId,
              onChanged: (v) => setState(() => _selectedStaffUserId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: l10n.notesOptional, hint: l10n.jewelryDetailsHint, maxLines: 3),
          ],
        ),
      ),
    );
  }
}
