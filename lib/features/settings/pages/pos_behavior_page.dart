import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/pages/settings_sub_page.dart';
import 'package:wameedpos/features/settings/widgets/settings_widgets.dart';

class PosBehaviorPage extends SettingsSubPage {
  const PosBehaviorPage({super.key});

  @override
  ConsumerState<PosBehaviorPage> createState() => _PosBehaviorPageState();
}

class _PosBehaviorPageState extends SettingsSubPageState<PosBehaviorPage> {
  bool _initialized = false;

  // POS
  bool _allowNegativeStock = false;
  bool _requireCustomerForSale = false;
  bool _autoPrintReceipt = true;
  int _sessionTimeoutMinutes = 480;
  int _maxDiscountPercent = 100;
  bool _enableTips = false;
  bool _enableKitchenDisplay = false;
  bool _barcodeScanSound = true;
  String _defaultSaleType = 'dine_in';
  bool _enableHoldOrders = true;
  bool _enableRefunds = true;
  bool _enableExchanges = true;
  bool _requireManagerForRefund = false;
  bool _requireManagerForDiscount = false;
  bool _enableOpenPriceItems = false;
  bool _enableQuickAddProducts = true;

  // Loyalty
  bool _enableLoyaltyPoints = false;
  final _loyaltyPointsCtrl = TextEditingController();
  final _loyaltyRedemptionCtrl = TextEditingController();

  // Inventory
  bool _trackInventory = true;
  bool _enableBatchTracking = false;
  bool _enableExpiryTracking = false;
  bool _autoDeductIngredients = false;

  // Notifications
  bool _lowStockAlert = true;
  int _lowStockThreshold = 5;

  // Display
  String _themeMode = 'system';
  bool _enableCustomerDisplay = false;
  final _customerDisplayMessageCtrl = TextEditingController();

  @override
  String pageTitle(AppLocalizations l10n) => l10n.settingsPosBehavior;

  void _init(StoreSettings s) {
    if (_initialized) return;
    _initialized = true;
    _allowNegativeStock = s.allowNegativeStock;
    _requireCustomerForSale = s.requireCustomerForSale;
    _autoPrintReceipt = s.autoPrintReceipt;
    _sessionTimeoutMinutes = s.sessionTimeoutMinutes;
    _maxDiscountPercent = s.maxDiscountPercent;
    _enableTips = s.enableTips;
    _enableKitchenDisplay = s.enableKitchenDisplay;
    _barcodeScanSound = s.barcodeScanSound;
    _defaultSaleType = s.defaultSaleType;
    _enableHoldOrders = s.enableHoldOrders;
    _enableRefunds = s.enableRefunds;
    _enableExchanges = s.enableExchanges;
    _requireManagerForRefund = s.requireManagerForRefund;
    _requireManagerForDiscount = s.requireManagerForDiscount;
    _enableOpenPriceItems = s.enableOpenPriceItems;
    _enableQuickAddProducts = s.enableQuickAddProducts;
    _enableLoyaltyPoints = s.enableLoyaltyPoints;
    _loyaltyPointsCtrl.text = s.loyaltyPointsPerCurrency.toStringAsFixed(2);
    _loyaltyRedemptionCtrl.text = s.loyaltyRedemptionValue.toStringAsFixed(2);
    _trackInventory = s.trackInventory;
    _enableBatchTracking = s.enableBatchTracking;
    _enableExpiryTracking = s.enableExpiryTracking;
    _autoDeductIngredients = s.autoDeductIngredients;
    _lowStockAlert = s.lowStockAlert;
    _lowStockThreshold = s.lowStockThreshold;
    _themeMode = s.themeMode;
    _enableCustomerDisplay = s.enableCustomerDisplay;
    _customerDisplayMessageCtrl.text = s.customerDisplayMessage ?? '';
  }

  @override
  Widget buildSettingsBody(BuildContext context, StoreSettings settings) {
    _init(settings);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // ─── Sales ──────────────────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosSales,
          icon: Icons.point_of_sale,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.settingsPosDefaultSaleType,
              value: _defaultSaleType,
              items: [
                PosDropdownItem(value: 'dine_in', label: l10n.settingsPosDineIn),
                PosDropdownItem(value: 'takeaway', label: l10n.settingsPosTakeaway),
                PosDropdownItem(value: 'delivery', label: l10n.settingsPosDelivery),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _defaultSaleType = v);
              },
            ),
            SettingsToggleRow(
              label: l10n.settingsPosRequireCustomer,
              value: _requireCustomerForSale,
              onChanged: (v) => setState(() => _requireCustomerForSale = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosAutoPrint,
              value: _autoPrintReceipt,
              onChanged: (v) => setState(() => _autoPrintReceipt = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosEnableTips,
              value: _enableTips,
              onChanged: (v) => setState(() => _enableTips = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosHoldOrders,
              value: _enableHoldOrders,
              onChanged: (v) => setState(() => _enableHoldOrders = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosOpenPriceItems,
              value: _enableOpenPriceItems,
              onChanged: (v) => setState(() => _enableOpenPriceItems = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosQuickAdd,
              value: _enableQuickAddProducts,
              onChanged: (v) => setState(() => _enableQuickAddProducts = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosBarcodeSound,
              value: _barcodeScanSound,
              onChanged: (v) => setState(() => _barcodeScanSound = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosKitchenDisplay,
              value: _enableKitchenDisplay,
              onChanged: (v) => setState(() => _enableKitchenDisplay = v),
            ),
          ],
        ),

        // ─── Returns & Refunds ──────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosReturns,
          icon: Icons.assignment_return,
          children: [
            SettingsToggleRow(
              label: l10n.settingsPosEnableRefunds,
              value: _enableRefunds,
              onChanged: (v) => setState(() => _enableRefunds = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosEnableExchanges,
              value: _enableExchanges,
              onChanged: (v) => setState(() => _enableExchanges = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosManagerRefund,
              description: l10n.settingsPosManagerRefundDesc,
              value: _requireManagerForRefund,
              onChanged: (v) => setState(() => _requireManagerForRefund = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosManagerDiscount,
              description: l10n.settingsPosManagerDiscountDesc,
              value: _requireManagerForDiscount,
              onChanged: (v) => setState(() => _requireManagerForDiscount = v),
            ),
          ],
        ),

        // ─── Limits ─────────────────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosLimits,
          icon: Icons.tune,
          children: [
            SettingsNumberRow(
              label: l10n.settingsPosMaxDiscount,
              value: _maxDiscountPercent,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => _maxDiscountPercent = v),
            ),
            SettingsNumberRow(
              label: l10n.settingsPosSessionTimeout,
              value: _sessionTimeoutMinutes,
              min: 5,
              max: 1440,
              onChanged: (v) => setState(() => _sessionTimeoutMinutes = v),
            ),
          ],
        ),

        // ─── Inventory ──────────────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosInventory,
          icon: Icons.inventory_2,
          children: [
            SettingsToggleRow(
              label: l10n.settingsPosTrackInventory,
              value: _trackInventory,
              onChanged: (v) => setState(() => _trackInventory = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosAllowNegStock,
              value: _allowNegativeStock,
              onChanged: (v) => setState(() => _allowNegativeStock = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosBatchTracking,
              value: _enableBatchTracking,
              onChanged: (v) => setState(() => _enableBatchTracking = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosExpiryTracking,
              value: _enableExpiryTracking,
              onChanged: (v) => setState(() => _enableExpiryTracking = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosAutoDeductIngredients,
              value: _autoDeductIngredients,
              onChanged: (v) => setState(() => _autoDeductIngredients = v),
            ),
            SettingsToggleRow(
              label: l10n.settingsPosLowStockAlert,
              value: _lowStockAlert,
              onChanged: (v) => setState(() => _lowStockAlert = v),
            ),
            if (_lowStockAlert)
              SettingsNumberRow(
                label: l10n.settingsPosLowStockThreshold,
                value: _lowStockThreshold,
                min: 1,
                max: 1000,
                onChanged: (v) => setState(() => _lowStockThreshold = v),
              ),
          ],
        ),

        // ─── Loyalty ────────────────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosLoyalty,
          icon: Icons.card_giftcard,
          children: [
            SettingsToggleRow(
              label: l10n.settingsPosEnableLoyalty,
              value: _enableLoyaltyPoints,
              onChanged: (v) => setState(() => _enableLoyaltyPoints = v),
            ),
            if (_enableLoyaltyPoints) ...[
              const SizedBox(height: 8),
              PosTextField(
                controller: _loyaltyPointsCtrl,
                label: l10n.settingsPosLoyaltyPointsPerCurrency,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              PosTextField(
                controller: _loyaltyRedemptionCtrl,
                label: l10n.settingsPosLoyaltyRedemptionValue,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ],
        ),

        // ─── Customer Display ───────────────────────
        SettingsSectionCard(
          title: l10n.settingsPosCustomerDisplay,
          icon: Icons.tv,
          children: [
            SettingsToggleRow(
              label: l10n.settingsPosEnableCustomerDisplay,
              value: _enableCustomerDisplay,
              onChanged: (v) => setState(() => _enableCustomerDisplay = v),
            ),
            if (_enableCustomerDisplay) ...[
              const SizedBox(height: 8),
              PosTextField(controller: _customerDisplayMessageCtrl, label: l10n.settingsPosCustomerDisplayMessage, maxLines: 2),
            ],
            const SizedBox(height: 12),
            SettingsDropdownRow<String>(
              label: l10n.settingsPosTheme,
              value: _themeMode,
              items: [
                PosDropdownItem(value: 'light', label: l10n.settingsPosThemeLight),
                PosDropdownItem(value: 'dark', label: l10n.settingsPosThemeDark),
                PosDropdownItem(value: 'system', label: l10n.settingsPosThemeSystem),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _themeMode = v);
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
    await saveSettings({
      'allow_negative_stock': _allowNegativeStock,
      'require_customer_for_sale': _requireCustomerForSale,
      'auto_print_receipt': _autoPrintReceipt,
      'session_timeout_minutes': _sessionTimeoutMinutes,
      'max_discount_percent': _maxDiscountPercent,
      'enable_tips': _enableTips,
      'enable_kitchen_display': _enableKitchenDisplay,
      'barcode_scan_sound': _barcodeScanSound,
      'default_sale_type': _defaultSaleType,
      'enable_hold_orders': _enableHoldOrders,
      'enable_refunds': _enableRefunds,
      'enable_exchanges': _enableExchanges,
      'require_manager_for_refund': _requireManagerForRefund,
      'require_manager_for_discount': _requireManagerForDiscount,
      'enable_open_price_items': _enableOpenPriceItems,
      'enable_quick_add_products': _enableQuickAddProducts,
      'enable_loyalty_points': _enableLoyaltyPoints,
      'loyalty_points_per_currency': double.tryParse(_loyaltyPointsCtrl.text) ?? 1.0,
      'loyalty_redemption_value': double.tryParse(_loyaltyRedemptionCtrl.text) ?? 0.01,
      'track_inventory': _trackInventory,
      'enable_batch_tracking': _enableBatchTracking,
      'enable_expiry_tracking': _enableExpiryTracking,
      'auto_deduct_ingredients': _autoDeductIngredients,
      'low_stock_alert': _lowStockAlert,
      'low_stock_threshold': _lowStockThreshold,
      'theme_mode': _themeMode,
      'enable_customer_display': _enableCustomerDisplay,
      'customer_display_message': _customerDisplayMessageCtrl.text.trim().isEmpty
          ? null
          : _customerDisplayMessageCtrl.text.trim(),
    });
  }

  @override
  void dispose() {
    _loyaltyPointsCtrl.dispose();
    _loyaltyRedemptionCtrl.dispose();
    _customerDisplayMessageCtrl.dispose();
    super.dispose();
  }
}
