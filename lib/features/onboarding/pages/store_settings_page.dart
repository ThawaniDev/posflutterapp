import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/onboarding/models/store_settings.dart';
import 'package:thawani_pos/features/onboarding/providers/store_onboarding_providers.dart';
import 'package:thawani_pos/features/onboarding/providers/store_onboarding_state.dart';

/// Full store settings page — tax, receipt, currency, POS behaviour, alerts.
class StoreSettingsPage extends ConsumerStatefulWidget {
  final String storeId;

  const StoreSettingsPage({super.key, required this.storeId});

  @override
  ConsumerState<StoreSettingsPage> createState() => _StoreSettingsPageState();
}

class _StoreSettingsPageState extends ConsumerState<StoreSettingsPage> {
  bool _isSaving = false;

  // Tax
  late TextEditingController _taxLabelCtrl;
  late TextEditingController _taxRateCtrl;
  late TextEditingController _taxNumberCtrl;
  bool _pricesIncludeTax = true;

  // Receipt
  late TextEditingController _receiptHeaderCtrl;
  late TextEditingController _receiptFooterCtrl;
  bool _receiptShowLogo = true;
  bool _receiptShowTaxBreakdown = true;

  // Currency
  late TextEditingController _currencyCodeCtrl;
  late TextEditingController _currencySymbolCtrl;
  late TextEditingController _decimalPlacesCtrl;

  // POS
  bool _allowNegativeStock = false;
  bool _requireCustomerForSale = false;
  bool _autoPrintReceipt = true;
  late TextEditingController _sessionTimeoutCtrl;
  late TextEditingController _maxDiscountCtrl;
  bool _enableTips = false;
  bool _enableKitchenDisplay = false;

  // Alerts
  bool _lowStockAlert = true;
  late TextEditingController _lowStockThresholdCtrl;

  @override
  void initState() {
    super.initState();
    _taxLabelCtrl = TextEditingController();
    _taxRateCtrl = TextEditingController();
    _taxNumberCtrl = TextEditingController();
    _receiptHeaderCtrl = TextEditingController();
    _receiptFooterCtrl = TextEditingController();
    _currencyCodeCtrl = TextEditingController();
    _currencySymbolCtrl = TextEditingController();
    _decimalPlacesCtrl = TextEditingController();
    _sessionTimeoutCtrl = TextEditingController();
    _maxDiscountCtrl = TextEditingController();
    _lowStockThresholdCtrl = TextEditingController();

    Future.microtask(() => ref.read(storeSettingsProvider(widget.storeId).notifier).load());
  }

  @override
  void dispose() {
    _taxLabelCtrl.dispose();
    _taxRateCtrl.dispose();
    _taxNumberCtrl.dispose();
    _receiptHeaderCtrl.dispose();
    _receiptFooterCtrl.dispose();
    _currencyCodeCtrl.dispose();
    _currencySymbolCtrl.dispose();
    _decimalPlacesCtrl.dispose();
    _sessionTimeoutCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _lowStockThresholdCtrl.dispose();
    super.dispose();
  }

  void _populateFields(StoreSettings s) {
    _taxLabelCtrl.text = s.taxLabel ?? '';
    _taxRateCtrl.text = s.taxRate.toString();
    _taxNumberCtrl.text = s.taxNumber ?? '';
    _pricesIncludeTax = s.pricesIncludeTax;
    _receiptHeaderCtrl.text = s.receiptHeader ?? '';
    _receiptFooterCtrl.text = s.receiptFooter ?? '';
    _receiptShowLogo = s.receiptShowLogo;
    _receiptShowTaxBreakdown = s.receiptShowTaxBreakdown;
    _currencyCodeCtrl.text = s.currencyCode;
    _currencySymbolCtrl.text = s.currencySymbol;
    _decimalPlacesCtrl.text = s.decimalPlaces.toString();
    _allowNegativeStock = s.allowNegativeStock;
    _requireCustomerForSale = s.requireCustomerForSale;
    _autoPrintReceipt = s.autoPrintReceipt;
    _sessionTimeoutCtrl.text = s.sessionTimeoutMinutes.toString();
    _maxDiscountCtrl.text = s.maxDiscountPercent.toString();
    _enableTips = s.enableTips;
    _enableKitchenDisplay = s.enableKitchenDisplay;
    _lowStockAlert = s.lowStockAlert;
    _lowStockThresholdCtrl.text = s.lowStockThreshold.toString();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final data = {
        'tax_label': _taxLabelCtrl.text,
        'tax_rate': double.tryParse(_taxRateCtrl.text) ?? 15.0,
        'prices_include_tax': _pricesIncludeTax,
        'tax_number': _taxNumberCtrl.text.isEmpty ? null : _taxNumberCtrl.text,
        'receipt_header': _receiptHeaderCtrl.text.isEmpty ? null : _receiptHeaderCtrl.text,
        'receipt_footer': _receiptFooterCtrl.text.isEmpty ? null : _receiptFooterCtrl.text,
        'receipt_show_logo': _receiptShowLogo,
        'receipt_show_tax_breakdown': _receiptShowTaxBreakdown,
        'currency_code': _currencyCodeCtrl.text,
        'currency_symbol': _currencySymbolCtrl.text,
        'decimal_places': int.tryParse(_decimalPlacesCtrl.text) ?? 2,
        'allow_negative_stock': _allowNegativeStock,
        'require_customer_for_sale': _requireCustomerForSale,
        'auto_print_receipt': _autoPrintReceipt,
        'session_timeout_minutes': int.tryParse(_sessionTimeoutCtrl.text) ?? 480,
        'max_discount_percent': int.tryParse(_maxDiscountCtrl.text) ?? 100,
        'enable_tips': _enableTips,
        'enable_kitchen_display': _enableKitchenDisplay,
        'low_stock_alert': _lowStockAlert,
        'low_stock_threshold': int.tryParse(_lowStockThresholdCtrl.text) ?? 5,
      };

      await ref.read(storeSettingsProvider(widget.storeId).notifier).update(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(storeSettingsProvider(widget.storeId));

    // Populate form fields when loaded
    if (settingsState is StoreSettingsLoaded) {
      // Only populate once (check if empty)
      if (_taxLabelCtrl.text.isEmpty && _currencyCodeCtrl.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _populateFields(settingsState.settings);
          if (mounted) setState(() {});
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Store Settings'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: PosButton(label: 'Save', size: PosButtonSize.sm, isLoading: _isSaving, onPressed: _isSaving ? null : _save),
          ),
        ],
      ),
      body: _buildBody(settingsState),
    );
  }

  Widget _buildBody(StoreSettingsState settingsState) {
    if (settingsState is StoreSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (settingsState is StoreSettingsError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${settingsState.message}'),
            const SizedBox(height: AppSpacing.md),
            PosButton(label: 'Retry', onPressed: () => ref.read(storeSettingsProvider(widget.storeId).notifier).load()),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Tax Configuration', Icons.receipt_long, [
            _buildTextField('Tax Label', _taxLabelCtrl, hint: 'VAT'),
            _buildTextField('Tax Rate (%)', _taxRateCtrl, hint: '15', keyboard: TextInputType.number),
            _buildTextField('Tax Number', _taxNumberCtrl, hint: 'Optional'),
            _buildSwitch('Prices Include Tax', _pricesIncludeTax, (v) => setState(() => _pricesIncludeTax = v)),
          ]),
          const SizedBox(height: AppSpacing.xl),
          _buildSection('Receipt', Icons.receipt, [
            _buildTextField('Receipt Header', _receiptHeaderCtrl, hint: 'Custom header text', maxLines: 2),
            _buildTextField('Receipt Footer', _receiptFooterCtrl, hint: 'Thank you for shopping!', maxLines: 2),
            _buildSwitch('Show Logo', _receiptShowLogo, (v) => setState(() => _receiptShowLogo = v)),
            _buildSwitch('Show Tax Breakdown', _receiptShowTaxBreakdown, (v) => setState(() => _receiptShowTaxBreakdown = v)),
          ]),
          const SizedBox(height: AppSpacing.xl),
          _buildSection('Currency', Icons.attach_money, [
            _buildTextField('Currency Code', _currencyCodeCtrl, hint: '\u0081'),
            _buildTextField('Currency Symbol', _currencySymbolCtrl, hint: '﷼'),
            _buildTextField('Decimal Places', _decimalPlacesCtrl, hint: '2', keyboard: TextInputType.number),
          ]),
          const SizedBox(height: AppSpacing.xl),
          _buildSection('POS Behaviour', Icons.point_of_sale, [
            _buildSwitch('Allow Negative Stock', _allowNegativeStock, (v) => setState(() => _allowNegativeStock = v)),
            _buildSwitch(
              'Require Customer for Sale',
              _requireCustomerForSale,
              (v) => setState(() => _requireCustomerForSale = v),
            ),
            _buildSwitch('Auto-Print Receipt', _autoPrintReceipt, (v) => setState(() => _autoPrintReceipt = v)),
            _buildSwitch('Enable Tips', _enableTips, (v) => setState(() => _enableTips = v)),
            _buildSwitch('Kitchen Display', _enableKitchenDisplay, (v) => setState(() => _enableKitchenDisplay = v)),
            _buildTextField('Session Timeout (min)', _sessionTimeoutCtrl, hint: '480', keyboard: TextInputType.number),
            _buildTextField('Max Discount (%)', _maxDiscountCtrl, hint: '100', keyboard: TextInputType.number),
          ]),
          const SizedBox(height: AppSpacing.xl),
          _buildSection('Alerts', Icons.notifications_active, [
            _buildSwitch('Low Stock Alert', _lowStockAlert, (v) => setState(() => _lowStockAlert = v)),
            _buildTextField('Low Stock Threshold', _lowStockThresholdCtrl, hint: '5', keyboard: TextInputType.number),
          ]),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textMutedLight),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SwitchListTile(
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        value: value,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: onChanged,
      ),
    );
  }
}
