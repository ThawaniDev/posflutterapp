/// Complete store settings model mapping all columns from the API.
class StoreSettings {
  final String id;
  final String storeId;

  // ─── Tax ────────────────────────────────────────────────────
  final String taxLabel;
  final double taxRate;
  final bool pricesIncludeTax;
  final String? taxNumber;

  // ─── Receipt ────────────────────────────────────────────────
  final String? receiptHeader;
  final String? receiptFooter;
  final bool receiptShowLogo;
  final bool receiptShowTaxBreakdown;
  final bool receiptShowAddress;
  final bool receiptShowPhone;
  final bool receiptShowDate;
  final bool receiptShowCashier;
  final bool receiptShowBarcode;
  final String receiptPaperSize;
  final String receiptFontSize;
  final String receiptLanguage;

  // ─── Currency & Formatting ──────────────────────────────────
  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;
  final String thousandSeparator;
  final String decimalSeparator;

  // ─── POS Behaviour ──────────────────────────────────────────
  final bool allowNegativeStock;
  final bool requireCustomerForSale;
  final bool autoPrintReceipt;
  final int sessionTimeoutMinutes;
  final int maxDiscountPercent;
  final bool enableTips;
  final bool enableKitchenDisplay;
  final bool barcodeScanSound;
  final String defaultSaleType;
  final bool enableHoldOrders;
  final bool enableRefunds;
  final bool enableExchanges;
  final bool requireManagerForRefund;
  final bool requireManagerForDiscount;
  final bool enableOpenPriceItems;
  final bool enableQuickAddProducts;

  // ─── Loyalty ────────────────────────────────────────────────
  final bool enableLoyaltyPoints;
  final double loyaltyPointsPerCurrency;
  final double loyaltyRedemptionValue;

  // ─── Notifications ──────────────────────────────────────────
  final bool lowStockAlert;
  final int lowStockThreshold;

  // ─── Inventory Tracking ─────────────────────────────────────
  final bool trackInventory;
  final bool enableBatchTracking;
  final bool enableExpiryTracking;
  final bool autoDeductIngredients;

  // ─── Display ────────────────────────────────────────────────
  final String themeMode;
  final String displayLanguage;

  // ─── Customer Display ───────────────────────────────────────
  final bool enableCustomerDisplay;
  final String? customerDisplayMessage;

  // ─── Extra ──────────────────────────────────────────────────
  final Map<String, dynamic> extra;
  final DateTime? updatedAt;

  const StoreSettings({
    required this.id,
    required this.storeId,
    this.taxLabel = 'VAT',
    this.taxRate = 15.0,
    this.pricesIncludeTax = true,
    this.taxNumber,
    this.receiptHeader,
    this.receiptFooter,
    this.receiptShowLogo = true,
    this.receiptShowTaxBreakdown = true,
    this.receiptShowAddress = true,
    this.receiptShowPhone = true,
    this.receiptShowDate = true,
    this.receiptShowCashier = true,
    this.receiptShowBarcode = true,
    this.receiptPaperSize = '80mm',
    this.receiptFontSize = 'normal',
    this.receiptLanguage = 'ar',
    this.currencyCode = 'SAR',
    this.currencySymbol = '﷼',
    this.decimalPlaces = 2,
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.allowNegativeStock = false,
    this.requireCustomerForSale = false,
    this.autoPrintReceipt = true,
    this.sessionTimeoutMinutes = 480,
    this.maxDiscountPercent = 100,
    this.enableTips = false,
    this.enableKitchenDisplay = false,
    this.barcodeScanSound = true,
    this.defaultSaleType = 'dine_in',
    this.enableHoldOrders = true,
    this.enableRefunds = true,
    this.enableExchanges = true,
    this.requireManagerForRefund = false,
    this.requireManagerForDiscount = false,
    this.enableOpenPriceItems = false,
    this.enableQuickAddProducts = true,
    this.enableLoyaltyPoints = false,
    this.loyaltyPointsPerCurrency = 1.0,
    this.loyaltyRedemptionValue = 0.01,
    this.lowStockAlert = true,
    this.lowStockThreshold = 5,
    this.trackInventory = true,
    this.enableBatchTracking = false,
    this.enableExpiryTracking = false,
    this.autoDeductIngredients = false,
    this.themeMode = 'system',
    this.displayLanguage = 'ar',
    this.enableCustomerDisplay = false,
    this.customerDisplayMessage,
    this.extra = const {},
    this.updatedAt,
  });

  factory StoreSettings.fromJson(Map<String, dynamic> json) {
    return StoreSettings(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      // Tax
      taxLabel: json['tax_label'] as String? ?? 'VAT',
      taxRate: _toDouble(json['tax_rate'], 15.0),
      pricesIncludeTax: json['prices_include_tax'] as bool? ?? true,
      taxNumber: json['tax_number'] as String?,
      // Receipt
      receiptHeader: json['receipt_header'] as String?,
      receiptFooter: json['receipt_footer'] as String?,
      receiptShowLogo: json['receipt_show_logo'] as bool? ?? true,
      receiptShowTaxBreakdown: json['receipt_show_tax_breakdown'] as bool? ?? true,
      receiptShowAddress: json['receipt_show_address'] as bool? ?? true,
      receiptShowPhone: json['receipt_show_phone'] as bool? ?? true,
      receiptShowDate: json['receipt_show_date'] as bool? ?? true,
      receiptShowCashier: json['receipt_show_cashier'] as bool? ?? true,
      receiptShowBarcode: json['receipt_show_barcode'] as bool? ?? true,
      receiptPaperSize: json['receipt_paper_size'] as String? ?? '80mm',
      receiptFontSize: json['receipt_font_size'] as String? ?? 'normal',
      receiptLanguage: json['receipt_language'] as String? ?? 'ar',
      // Currency
      currencyCode: json['currency_code'] as String? ?? 'SAR',
      currencySymbol: json['currency_symbol'] as String? ?? '﷼',
      decimalPlaces: json['decimal_places'] as int? ?? 2,
      thousandSeparator: json['thousand_separator'] as String? ?? ',',
      decimalSeparator: json['decimal_separator'] as String? ?? '.',
      // POS
      allowNegativeStock: json['allow_negative_stock'] as bool? ?? false,
      requireCustomerForSale: json['require_customer_for_sale'] as bool? ?? false,
      autoPrintReceipt: json['auto_print_receipt'] as bool? ?? true,
      sessionTimeoutMinutes: json['session_timeout_minutes'] as int? ?? 480,
      maxDiscountPercent: json['max_discount_percent'] as int? ?? 100,
      enableTips: json['enable_tips'] as bool? ?? false,
      enableKitchenDisplay: json['enable_kitchen_display'] as bool? ?? false,
      barcodeScanSound: json['barcode_scan_sound'] as bool? ?? true,
      defaultSaleType: json['default_sale_type'] as String? ?? 'dine_in',
      enableHoldOrders: json['enable_hold_orders'] as bool? ?? true,
      enableRefunds: json['enable_refunds'] as bool? ?? true,
      enableExchanges: json['enable_exchanges'] as bool? ?? true,
      requireManagerForRefund: json['require_manager_for_refund'] as bool? ?? false,
      requireManagerForDiscount: json['require_manager_for_discount'] as bool? ?? false,
      enableOpenPriceItems: json['enable_open_price_items'] as bool? ?? false,
      enableQuickAddProducts: json['enable_quick_add_products'] as bool? ?? true,
      // Loyalty
      enableLoyaltyPoints: json['enable_loyalty_points'] as bool? ?? false,
      loyaltyPointsPerCurrency: _toDouble(json['loyalty_points_per_currency'], 1.0),
      loyaltyRedemptionValue: _toDouble(json['loyalty_redemption_value'], 0.01),
      // Notifications
      lowStockAlert: json['low_stock_alert'] as bool? ?? true,
      lowStockThreshold: json['low_stock_threshold'] as int? ?? 5,
      // Inventory
      trackInventory: json['track_inventory'] as bool? ?? true,
      enableBatchTracking: json['enable_batch_tracking'] as bool? ?? false,
      enableExpiryTracking: json['enable_expiry_tracking'] as bool? ?? false,
      autoDeductIngredients: json['auto_deduct_ingredients'] as bool? ?? false,
      // Display
      themeMode: json['theme_mode'] as String? ?? 'system',
      displayLanguage: json['display_language'] as String? ?? 'ar',
      // Customer display
      enableCustomerDisplay: json['enable_customer_display'] as bool? ?? false,
      customerDisplayMessage: json['customer_display_message'] as String?,
      // Extra
      extra: json['extra'] != null && json['extra'] is Map ? Map<String, dynamic>.from(json['extra'] as Map) : {},
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  /// Safely convert PostgreSQL decimal strings to double.
  static double _toDouble(dynamic value, double fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  Map<String, dynamic> toJson() {
    return {
      'tax_label': taxLabel,
      'tax_rate': taxRate,
      'prices_include_tax': pricesIncludeTax,
      'tax_number': taxNumber,
      'receipt_header': receiptHeader,
      'receipt_footer': receiptFooter,
      'receipt_show_logo': receiptShowLogo,
      'receipt_show_tax_breakdown': receiptShowTaxBreakdown,
      'receipt_show_address': receiptShowAddress,
      'receipt_show_phone': receiptShowPhone,
      'receipt_show_date': receiptShowDate,
      'receipt_show_cashier': receiptShowCashier,
      'receipt_show_barcode': receiptShowBarcode,
      'receipt_paper_size': receiptPaperSize,
      'receipt_font_size': receiptFontSize,
      'receipt_language': receiptLanguage,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'decimal_places': decimalPlaces,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
      'allow_negative_stock': allowNegativeStock,
      'require_customer_for_sale': requireCustomerForSale,
      'auto_print_receipt': autoPrintReceipt,
      'session_timeout_minutes': sessionTimeoutMinutes,
      'max_discount_percent': maxDiscountPercent,
      'enable_tips': enableTips,
      'enable_kitchen_display': enableKitchenDisplay,
      'barcode_scan_sound': barcodeScanSound,
      'default_sale_type': defaultSaleType,
      'enable_hold_orders': enableHoldOrders,
      'enable_refunds': enableRefunds,
      'enable_exchanges': enableExchanges,
      'require_manager_for_refund': requireManagerForRefund,
      'require_manager_for_discount': requireManagerForDiscount,
      'enable_open_price_items': enableOpenPriceItems,
      'enable_quick_add_products': enableQuickAddProducts,
      'enable_loyalty_points': enableLoyaltyPoints,
      'loyalty_points_per_currency': loyaltyPointsPerCurrency,
      'loyalty_redemption_value': loyaltyRedemptionValue,
      'low_stock_alert': lowStockAlert,
      'low_stock_threshold': lowStockThreshold,
      'track_inventory': trackInventory,
      'enable_batch_tracking': enableBatchTracking,
      'enable_expiry_tracking': enableExpiryTracking,
      'auto_deduct_ingredients': autoDeductIngredients,
      'theme_mode': themeMode,
      'display_language': displayLanguage,
      'enable_customer_display': enableCustomerDisplay,
      'customer_display_message': customerDisplayMessage,
      'extra': extra,
    };
  }

  StoreSettings copyWith({
    String? taxLabel,
    double? taxRate,
    bool? pricesIncludeTax,
    String? taxNumber,
    String? receiptHeader,
    String? receiptFooter,
    bool? receiptShowLogo,
    bool? receiptShowTaxBreakdown,
    bool? receiptShowAddress,
    bool? receiptShowPhone,
    bool? receiptShowDate,
    bool? receiptShowCashier,
    bool? receiptShowBarcode,
    String? receiptPaperSize,
    String? receiptFontSize,
    String? receiptLanguage,
    String? currencyCode,
    String? currencySymbol,
    int? decimalPlaces,
    String? thousandSeparator,
    String? decimalSeparator,
    bool? allowNegativeStock,
    bool? requireCustomerForSale,
    bool? autoPrintReceipt,
    int? sessionTimeoutMinutes,
    int? maxDiscountPercent,
    bool? enableTips,
    bool? enableKitchenDisplay,
    bool? barcodeScanSound,
    String? defaultSaleType,
    bool? enableHoldOrders,
    bool? enableRefunds,
    bool? enableExchanges,
    bool? requireManagerForRefund,
    bool? requireManagerForDiscount,
    bool? enableOpenPriceItems,
    bool? enableQuickAddProducts,
    bool? enableLoyaltyPoints,
    double? loyaltyPointsPerCurrency,
    double? loyaltyRedemptionValue,
    bool? lowStockAlert,
    int? lowStockThreshold,
    bool? trackInventory,
    bool? enableBatchTracking,
    bool? enableExpiryTracking,
    bool? autoDeductIngredients,
    String? themeMode,
    String? displayLanguage,
    bool? enableCustomerDisplay,
    String? customerDisplayMessage,
    Map<String, dynamic>? extra,
  }) {
    return StoreSettings(
      id: id,
      storeId: storeId,
      taxLabel: taxLabel ?? this.taxLabel,
      taxRate: taxRate ?? this.taxRate,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      taxNumber: taxNumber ?? this.taxNumber,
      receiptHeader: receiptHeader ?? this.receiptHeader,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      receiptShowLogo: receiptShowLogo ?? this.receiptShowLogo,
      receiptShowTaxBreakdown: receiptShowTaxBreakdown ?? this.receiptShowTaxBreakdown,
      receiptShowAddress: receiptShowAddress ?? this.receiptShowAddress,
      receiptShowPhone: receiptShowPhone ?? this.receiptShowPhone,
      receiptShowDate: receiptShowDate ?? this.receiptShowDate,
      receiptShowCashier: receiptShowCashier ?? this.receiptShowCashier,
      receiptShowBarcode: receiptShowBarcode ?? this.receiptShowBarcode,
      receiptPaperSize: receiptPaperSize ?? this.receiptPaperSize,
      receiptFontSize: receiptFontSize ?? this.receiptFontSize,
      receiptLanguage: receiptLanguage ?? this.receiptLanguage,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      thousandSeparator: thousandSeparator ?? this.thousandSeparator,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      requireCustomerForSale: requireCustomerForSale ?? this.requireCustomerForSale,
      autoPrintReceipt: autoPrintReceipt ?? this.autoPrintReceipt,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      maxDiscountPercent: maxDiscountPercent ?? this.maxDiscountPercent,
      enableTips: enableTips ?? this.enableTips,
      enableKitchenDisplay: enableKitchenDisplay ?? this.enableKitchenDisplay,
      barcodeScanSound: barcodeScanSound ?? this.barcodeScanSound,
      defaultSaleType: defaultSaleType ?? this.defaultSaleType,
      enableHoldOrders: enableHoldOrders ?? this.enableHoldOrders,
      enableRefunds: enableRefunds ?? this.enableRefunds,
      enableExchanges: enableExchanges ?? this.enableExchanges,
      requireManagerForRefund: requireManagerForRefund ?? this.requireManagerForRefund,
      requireManagerForDiscount: requireManagerForDiscount ?? this.requireManagerForDiscount,
      enableOpenPriceItems: enableOpenPriceItems ?? this.enableOpenPriceItems,
      enableQuickAddProducts: enableQuickAddProducts ?? this.enableQuickAddProducts,
      enableLoyaltyPoints: enableLoyaltyPoints ?? this.enableLoyaltyPoints,
      loyaltyPointsPerCurrency: loyaltyPointsPerCurrency ?? this.loyaltyPointsPerCurrency,
      loyaltyRedemptionValue: loyaltyRedemptionValue ?? this.loyaltyRedemptionValue,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      trackInventory: trackInventory ?? this.trackInventory,
      enableBatchTracking: enableBatchTracking ?? this.enableBatchTracking,
      enableExpiryTracking: enableExpiryTracking ?? this.enableExpiryTracking,
      autoDeductIngredients: autoDeductIngredients ?? this.autoDeductIngredients,
      themeMode: themeMode ?? this.themeMode,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      enableCustomerDisplay: enableCustomerDisplay ?? this.enableCustomerDisplay,
      customerDisplayMessage: customerDisplayMessage ?? this.customerDisplayMessage,
      extra: extra ?? this.extra,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreSettings && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
