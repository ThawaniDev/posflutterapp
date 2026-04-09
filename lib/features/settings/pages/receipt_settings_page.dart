import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/settings/models/store_settings.dart';
import 'package:thawani_pos/features/settings/pages/settings_sub_page.dart';
import 'package:thawani_pos/features/settings/widgets/settings_widgets.dart';

class ReceiptSettingsPage extends SettingsSubPage {
  const ReceiptSettingsPage({super.key});

  @override
  ConsumerState<ReceiptSettingsPage> createState() => _ReceiptSettingsPageState();
}

class _ReceiptSettingsPageState extends SettingsSubPageState<ReceiptSettingsPage> {
  final _headerCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();
  bool _showLogo = true;
  bool _showTaxBreakdown = true;
  bool _showAddress = true;
  bool _showPhone = true;
  bool _showDate = true;
  bool _showCashier = true;
  bool _showBarcode = true;
  String _paperSize = '80mm';
  String _fontSize = 'normal';
  String _language = 'ar';
  bool _initialized = false;

  @override
  String pageTitle(AppLocalizations l10n) => l10n.settingsReceipt;

  void _init(StoreSettings s) {
    if (_initialized) return;
    _initialized = true;
    _headerCtrl.text = s.receiptHeader ?? '';
    _footerCtrl.text = s.receiptFooter ?? '';
    _showLogo = s.receiptShowLogo;
    _showTaxBreakdown = s.receiptShowTaxBreakdown;
    _showAddress = s.receiptShowAddress;
    _showPhone = s.receiptShowPhone;
    _showDate = s.receiptShowDate;
    _showCashier = s.receiptShowCashier;
    _showBarcode = s.receiptShowBarcode;
    _paperSize = s.receiptPaperSize;
    _fontSize = s.receiptFontSize;
    _language = s.receiptLanguage;
  }

  @override
  Widget buildSettingsBody(BuildContext context, StoreSettings settings) {
    _init(settings);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // ─── Header & Footer ─────────────────────────
        SettingsSectionCard(
          title: l10n.settingsReceiptContent,
          icon: Icons.text_snippet,
          children: [
            TextField(
              controller: _headerCtrl,
              decoration: InputDecoration(labelText: l10n.settingsReceiptHeader, hintText: l10n.settingsReceiptHeaderHint),
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _footerCtrl,
              decoration: InputDecoration(labelText: l10n.settingsReceiptFooter, hintText: l10n.settingsReceiptFooterHint),
              maxLines: 3,
              minLines: 2,
            ),
          ],
        ),

        // ─── Display toggles ────────────────────────
        SettingsSectionCard(
          title: l10n.settingsReceiptDisplay,
          icon: Icons.visibility,
          children: [
            SettingsToggleRow(
              label: l10n.settingsReceiptShowLogo,
              value: _showLogo,
              onChanged: (v) => setState(() => _showLogo = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowTax,
              value: _showTaxBreakdown,
              onChanged: (v) => setState(() => _showTaxBreakdown = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowAddress,
              value: _showAddress,
              onChanged: (v) => setState(() => _showAddress = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowPhone,
              value: _showPhone,
              onChanged: (v) => setState(() => _showPhone = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowDate,
              value: _showDate,
              onChanged: (v) => setState(() => _showDate = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowCashier,
              value: _showCashier,
              onChanged: (v) => setState(() => _showCashier = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsReceiptShowBarcode,
              value: _showBarcode,
              onChanged: (v) => setState(() => _showBarcode = v),
            ),
          ],
        ),

        // ─── Format ─────────────────────────────────
        SettingsSectionCard(
          title: l10n.settingsReceiptFormat,
          icon: Icons.settings,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.settingsReceiptPaperSize,
              value: _paperSize,
              items: const [
                PosDropdownItem(value: '58mm', label: '58mm'),
                PosDropdownItem(value: '80mm', label: '80mm'),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _paperSize = v);
              },
            ),
            SettingsDropdownRow<String>(
              label: l10n.settingsReceiptFontSize,
              value: _fontSize,
              items: [
                PosDropdownItem(value: 'small', label: l10n.settingsFontSmall),
                PosDropdownItem(value: 'normal', label: l10n.settingsFontNormal),
                PosDropdownItem(value: 'large', label: l10n.settingsFontLarge),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _fontSize = v);
              },
            ),
            SettingsDropdownRow<String>(
              label: l10n.settingsReceiptLanguage,
              value: _language,
              items: [
                PosDropdownItem(value: 'ar', label: l10n.settingsLangArabic),
                PosDropdownItem(value: 'en', label: l10n.settingsLangEnglish),
                PosDropdownItem(value: 'both', label: l10n.settingsLangBoth),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _language = v);
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
      'receipt_header': _headerCtrl.text.trim().isEmpty ? null : _headerCtrl.text.trim(),
      'receipt_footer': _footerCtrl.text.trim().isEmpty ? null : _footerCtrl.text.trim(),
      'receipt_show_logo': _showLogo,
      'receipt_show_tax_breakdown': _showTaxBreakdown,
      'receipt_show_address': _showAddress,
      'receipt_show_phone': _showPhone,
      'receipt_show_date': _showDate,
      'receipt_show_cashier': _showCashier,
      'receipt_show_barcode': _showBarcode,
      'receipt_paper_size': _paperSize,
      'receipt_font_size': _fontSize,
      'receipt_language': _language,
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }
}
