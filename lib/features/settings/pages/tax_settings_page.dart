import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
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
            PosTextField(controller: _taxLabelCtrl, label: l10n.settingsTaxLabel, onSubmitted: (_) => _save()),
            AppSpacing.gapH12,
            PosTextField(
              controller: _taxRateCtrl,
              label: l10n.settingsTaxRate,
              suffix: const Padding(
                padding: EdgeInsetsDirectional.only(end: 12),
                child: Center(widthFactor: 1, child: Text('%')),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _save(),
            ),
            AppSpacing.gapH12,
            PosTextField(
              controller: _taxNumberCtrl,
              label: l10n.settingsTaxNumber,
              hint: l10n.settingsTaxNumberHint,
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
          child: PosButton(onPressed: _save, icon: Icons.save, label: l10n.save),
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
