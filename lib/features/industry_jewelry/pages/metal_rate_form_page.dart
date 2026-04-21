import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';
import 'package:wameedpos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class MetalRateFormPage extends ConsumerStatefulWidget {
  const MetalRateFormPage({super.key, this.rate});
  final DailyMetalRate? rate;

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
      bottomBar: PosButton(label: l10n.jewelrySaveRate, onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
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
            PosTextField(controller: _karatCtrl, label: l10n.jewelryKaratOptional, hint: l10n.jewelryKaratHint),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _ratePerGramCtrl,
                    label: l10n.jewelrySellRatePerGram,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _buybackRateCtrl,
                    label: l10n.jewelryBuybackRatePerGram,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_effectiveDate.day}/${_effectiveDate.month}/${_effectiveDate.year}'),
                  label: l10n.jewelryEffectiveDate,
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
