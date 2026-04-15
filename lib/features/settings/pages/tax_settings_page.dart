import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/pages/settings_sub_page.dart';
import 'package:wameedpos/features/settings/widgets/settings_widgets.dart';

class TaxSettingsPage extends SettingsSubPage {
  const TaxSettingsPage({super.key});

  @override
  ConsumerState<TaxSettingsPage> createState() => _TaxSettingsPageState();
}

class _TaxSettingsPageState extends SettingsSubPageState<TaxSettingsPage> {
  final _taxLabelCtrl = TextEditingController();
  final _taxRateCtrl = TextEditingController();
  final _taxNumberCtrl = TextEditingController();
  bool _pricesIncludeTax = true;
  bool _initialized = false;

  @override
  String pageTitle(AppLocalizations l10n) => l10n.settingsTax;

  void _init(StoreSettings s) {
    if (_initialized) return;
    _initialized = true;
    _taxLabelCtrl.text = s.taxLabel;
    _taxRateCtrl.text = s.taxRate.toStringAsFixed(2);
    _taxNumberCtrl.text = s.taxNumber ?? '';
    _pricesIncludeTax = s.pricesIncludeTax;
  }

  @override
  Widget buildSettingsBody(BuildContext context, StoreSettings settings) {
    _init(settings);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSectionCard(
          title: l10n.settingsTaxConfig,
          icon: Icons.receipt_long,
          children: [
            TextField(
              controller: _taxLabelCtrl,
              decoration: InputDecoration(labelText: l10n.settingsTaxLabel),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taxRateCtrl,
              decoration: InputDecoration(labelText: l10n.settingsTaxRate, suffixText: '%'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taxNumberCtrl,
              decoration: InputDecoration(labelText: l10n.settingsTaxNumber, hintText: l10n.settingsTaxNumberHint),
              onSubmitted: (_) => _save(),
            ),
            SettingsToggleRow(
              label: l10n.settingsPricesIncludeTax,
              description: l10n.settingsPricesIncludeTaxDesc,
              value: _pricesIncludeTax,
              onChanged: (v) {
                setState(() => _pricesIncludeTax = v);
                _save();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save, size: 18), label: Text(l10n.save)),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final rate = double.tryParse(_taxRateCtrl.text);
    if (rate == null || rate < 0 || rate > 100) return;
    await saveSettings({
      'tax_label': _taxLabelCtrl.text.trim(),
      'tax_rate': rate,
      'tax_number': _taxNumberCtrl.text.trim().isEmpty ? null : _taxNumberCtrl.text.trim(),
      'prices_include_tax': _pricesIncludeTax,
    });
  }

  @override
  void dispose() {
    _taxLabelCtrl.dispose();
    _taxRateCtrl.dispose();
    _taxNumberCtrl.dispose();
    super.dispose();
  }
}
