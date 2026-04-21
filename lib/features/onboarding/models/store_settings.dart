class StoreSettings {

  const StoreSettings({
    this.id,
    this.storeId,
    this.taxLabel,
    this.taxRate = 15.0,
    this.pricesIncludeTax = true,
    this.taxNumber,
    this.receiptHeader,
    this.receiptFooter,
    this.receiptShowLogo = true,
    this.receiptShowTaxBreakdown = true,
    this.currencyCode = '\u0081',
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
    this.lowStockAlert = true,
    this.lowStockThreshold = 5,
    this.extra = const {},
    this.updatedAt,
  });

  factory StoreSettings.fromJson(Map<String, dynamic> json) {
    return StoreSettings(
      id: json['id'] as String?,
      storeId: json['store_id'] as String?,
      taxLabel: json['tax_label'] as String?,
      taxRate: (json['tax_rate'] != null ? double.tryParse(json['tax_rate'].toString()) : null) ?? 15.0,
      pricesIncludeTax: json['prices_include_tax'] as bool? ?? true,
      taxNumber: json['tax_number'] as String?,
      receiptHeader: json['receipt_header'] as String?,
      receiptFooter: json['receipt_footer'] as String?,
      receiptShowLogo: json['receipt_show_logo'] as bool? ?? true,
      receiptShowTaxBreakdown: json['receipt_show_tax_breakdown'] as bool? ?? true,
      currencyCode: json['currency_code'] as String? ?? '\u0081',
      currencySymbol: json['currency_symbol'] as String? ?? '﷼',
      decimalPlaces: (json['decimal_places'] as num?)?.toInt() ?? 2,
      thousandSeparator: json['thousand_separator'] as String? ?? ',',
      decimalSeparator: json['decimal_separator'] as String? ?? '.',
      allowNegativeStock: json['allow_negative_stock'] as bool? ?? false,
      requireCustomerForSale: json['require_customer_for_sale'] as bool? ?? false,
      autoPrintReceipt: json['auto_print_receipt'] as bool? ?? true,
      sessionTimeoutMinutes: (json['session_timeout_minutes'] as num?)?.toInt() ?? 480,
      maxDiscountPercent: (json['max_discount_percent'] as num?)?.toInt() ?? 100,
      enableTips: json['enable_tips'] as bool? ?? false,
      enableKitchenDisplay: json['enable_kitchen_display'] as bool? ?? false,
      lowStockAlert: json['low_stock_alert'] as bool? ?? true,
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 5,
      extra: json['extra'] != null ? Map<String, dynamic>.from(json['extra'] as Map) : {},
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String? id;
  final String? storeId;
  // Tax
  final String? taxLabel;
  final double taxRate;
  final bool pricesIncludeTax;
  final String? taxNumber;
  // Receipt
  final String? receiptHeader;
  final String? receiptFooter;
  final bool receiptShowLogo;
  final bool receiptShowTaxBreakdown;
  // Currency
  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;
  final String thousandSeparator;
  final String decimalSeparator;
  // POS Behaviour
  final bool allowNegativeStock;
  final bool requireCustomerForSale;
  final bool autoPrintReceipt;
  final int sessionTimeoutMinutes;
  final int maxDiscountPercent;
  final bool enableTips;
  final bool enableKitchenDisplay;
  // Notifications
  final bool lowStockAlert;
  final int lowStockThreshold;
  // Extra
  final Map<String, dynamic> extra;
  final DateTime? updatedAt;

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
      'low_stock_alert': lowStockAlert,
      'low_stock_threshold': lowStockThreshold,
      'extra': extra,
    };
  }

  StoreSettings copyWith({
    String? id,
    String? storeId,
    String? taxLabel,
    double? taxRate,
    bool? pricesIncludeTax,
    String? taxNumber,
    String? receiptHeader,
    String? receiptFooter,
    bool? receiptShowLogo,
    bool? receiptShowTaxBreakdown,
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
    bool? lowStockAlert,
    int? lowStockThreshold,
    Map<String, dynamic>? extra,
    DateTime? updatedAt,
  }) {
    return StoreSettings(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      taxLabel: taxLabel ?? this.taxLabel,
      taxRate: taxRate ?? this.taxRate,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      taxNumber: taxNumber ?? this.taxNumber,
      receiptHeader: receiptHeader ?? this.receiptHeader,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      receiptShowLogo: receiptShowLogo ?? this.receiptShowLogo,
      receiptShowTaxBreakdown: receiptShowTaxBreakdown ?? this.receiptShowTaxBreakdown,
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
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      extra: extra ?? this.extra,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreSettings && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
