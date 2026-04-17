import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../enums/metal_type.dart';
import '../models/daily_metal_rate.dart';
import '../providers/jewelry_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class MetalRateFormPage extends ConsumerStatefulWidget {
  final DailyMetalRate? rate;
  const MetalRateFormPage({super.key, this.rate});

  @override
  ConsumerState<MetalRateFormPage> createState() => _MetalRateFormPageState();
}

class _MetalRateFormPageState extends ConsumerState<MetalRateFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  MetalType _metalType = MetalType.gold;
  late final TextEditingController _karatCtrl;
  late final TextEditingController _ratePerGramCtrl;
  late final TextEditingController _buybackRateCtrl;
  DateTime _effectiveDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final r = widget.rate;
    if (r != null) _metalType = r.metalType;
    _karatCtrl = TextEditingController(text: r?.karat ?? '');
    _ratePerGramCtrl = TextEditingController(text: r?.ratePerGram.toStringAsFixed(2) ?? '');
    _buybackRateCtrl = TextEditingController(text: r?.buybackRatePerGram?.toStringAsFixed(2) ?? '');
    if (r != null) _effectiveDate = r.effectiveDate;
  }

  @override
  void dispose() {
    _karatCtrl.dispose();
    _ratePerGramCtrl.dispose();
    _buybackRateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) setState(() => _effectiveDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'metal_type': _metalType.value,
      'rate_per_gram': double.parse(_ratePerGramCtrl.text.trim()),
      'effective_date': _effectiveDate.toIso8601String().split('T').first,
      if (_karatCtrl.text.isNotEmpty) 'karat': _karatCtrl.text.trim(),
      if (_buybackRateCtrl.text.isNotEmpty) 'buyback_rate_per_gram': double.parse(_buybackRateCtrl.text.trim()),
    };

    await ref.read(jewelryProvider.notifier).upsertMetalRate(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosFormPage(
      title: l10n.jewelrySetMetalRate,
      bottomBar: PosButton(label: 'Save Rate', onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosSearchableDropdown<MetalType>(
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
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _karatCtrl, label: 'Karat (optional)', hint: 'e.g. 24K, 22K, 18K'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _ratePerGramCtrl,
                    label: 'Sell Rate/g (\u0081)',
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _buybackRateCtrl,
                    label: 'Buyback Rate/g',
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_effectiveDate.day}/${_effectiveDate.month}/${_effectiveDate.year}'),
                  label: 'Effective Date',
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
