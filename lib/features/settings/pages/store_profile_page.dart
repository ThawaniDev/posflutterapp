import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/pages/settings_sub_page.dart';
import 'package:wameedpos/features/settings/widgets/settings_widgets.dart';

/// Store profile settings: currency, formatting, and display info.
class StoreProfilePage extends SettingsSubPage {
  const StoreProfilePage({super.key});

  @override
  ConsumerState<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends SettingsSubPageState<StoreProfilePage> {
  bool _initialized = false;
  final _currencyCodeCtrl = TextEditingController();
  final _currencySymbolCtrl = TextEditingController();
  int _decimalPlaces = 2;
  String _thousandSeparator = ',';
  String _decimalSeparator = '.';

  @override
  String pageTitle(AppLocalizations l10n) => l10n.settingsStoreProfile;

  void _init(StoreSettings s) {
    if (_initialized) return;
    _initialized = true;
    _currencyCodeCtrl.text = s.currencyCode;
    _currencySymbolCtrl.text = s.currencySymbol;
    _decimalPlaces = s.decimalPlaces;
    _thousandSeparator = s.thousandSeparator;
    _decimalSeparator = s.decimalSeparator;
  }

  @override
  Widget buildSettingsBody(BuildContext context, StoreSettings settings) {
    _init(settings);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSectionCard(
          title: l10n.settingsProfileCurrency,
          icon: Icons.attach_money,
          children: [
            TextField(
              controller: _currencyCodeCtrl,
              decoration: InputDecoration(labelText: l10n.settingsProfileCurrencyCode, hintText: '\u0081'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _currencySymbolCtrl,
              decoration: InputDecoration(labelText: l10n.settingsProfileCurrencySymbol, hintText: '﷼'),
            ),
          ],
        ),

        SettingsSectionCard(
          title: l10n.settingsProfileFormatting,
          icon: Icons.format_list_numbered,
          children: [
            SettingsNumberRow(
              label: l10n.settingsProfileDecimalPlaces,
              value: _decimalPlaces,
              min: 0,
              max: 4,
              onChanged: (v) => setState(() => _decimalPlaces = v),
            ),
            const SizedBox(height: 8),
            SettingsDropdownRow<String>(
              label: l10n.settingsProfileThousandSep,
              value: _thousandSeparator,
              items: const [
                PosDropdownItem(value: ',', label: ','),
                PosDropdownItem(value: '.', label: '.'),
                PosDropdownItem(value: ' ', label: 'Space'),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _thousandSeparator = v);
              },
            ),
            SettingsDropdownRow<String>(
              label: l10n.settingsProfileDecimalSep,
              value: _decimalSeparator,
              items: const [
                PosDropdownItem(value: '.', label: '.'),
                PosDropdownItem(value: ',', label: ','),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _decimalSeparator = v);
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
    await saveSettings({
      'currency_code': _currencyCodeCtrl.text.trim(),
      'currency_symbol': _currencySymbolCtrl.text.trim(),
      'decimal_places': _decimalPlaces,
      'thousand_separator': _thousandSeparator,
      'decimal_separator': _decimalSeparator,
    });
  }

  @override
  void dispose() {
    _currencyCodeCtrl.dispose();
    _currencySymbolCtrl.dispose();
    super.dispose();
  }
}
