class CashierInfo {
  final String id;
  final String name;
  final String? email;

  const CashierInfo({required this.id, required this.name, this.email});

  factory CashierInfo.fromJson(Map<String, dynamic> json) {
    return CashierInfo(id: json['id'] as String, name: json['name'] as String? ?? '', email: json['email'] as String?);
  }
}

class CashierPerformanceSnapshot {
  final String id;
  final String storeId;
  final String cashierId;
  final CashierInfo? cashier;
  final String? posSessionId;
  final String date;
  final String periodType;
  final String? shiftStart;
  final String? shiftEnd;
  final int activeMinutes;
  final int totalTransactions;
  final int totalItemsSold;
  final double totalRevenue;
  final double totalDiscountGiven;
  final double avgBasketSize;
  final double itemsPerMinute;
  final int avgTransactionTimeSeconds;
  final int voidCount;
  final double voidAmount;
  final double voidRate;
  final int returnCount;
  final double returnAmount;
  final int discountCount;
  final double discountRate;
  final int priceOverrideCount;
  final int noSaleCount;
  final int upsellCount;
  final double upsellRate;
  final double cashVariance;
  final double cashVarianceAbsolute;
  final double riskScore;
  final List<String> anomalyFlags;
  final DateTime? createdAt;

  const CashierPerformanceSnapshot({
    required this.id,
    required this.storeId,
    required this.cashierId,
    this.cashier,
    this.posSessionId,
    required this.date,
    required this.periodType,
    this.shiftStart,
    this.shiftEnd,
    this.activeMinutes = 0,
    this.totalTransactions = 0,
    this.totalItemsSold = 0,
    this.totalRevenue = 0,
    this.totalDiscountGiven = 0,
    this.avgBasketSize = 0,
    this.itemsPerMinute = 0,
    this.avgTransactionTimeSeconds = 0,
    this.voidCount = 0,
    this.voidAmount = 0,
    this.voidRate = 0,
    this.returnCount = 0,
    this.returnAmount = 0,
    this.discountCount = 0,
    this.discountRate = 0,
    this.priceOverrideCount = 0,
    this.noSaleCount = 0,
    this.upsellCount = 0,
    this.upsellRate = 0,
    this.cashVariance = 0,
    this.cashVarianceAbsolute = 0,
    this.riskScore = 0,
    this.anomalyFlags = const [],
    this.createdAt,
  });

  factory CashierPerformanceSnapshot.fromJson(Map<String, dynamic> json) {
    return CashierPerformanceSnapshot(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      cashierId: json['cashier_id'] as String,
      cashier: json['cashier'] != null ? CashierInfo.fromJson(json['cashier'] as Map<String, dynamic>) : null,
      posSessionId: json['pos_session_id'] as String?,
      date: json['date'] as String,
      periodType: json['period_type'] as String,
      shiftStart: json['shift_start'] as String?,
      shiftEnd: json['shift_end'] as String?,
      activeMinutes: (json['active_minutes'] as num?)?.toInt() ?? 0,
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      totalItemsSold: (json['total_items_sold'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      totalDiscountGiven: (json['total_discount_given'] as num?)?.toDouble() ?? 0,
      avgBasketSize: (json['avg_basket_size'] as num?)?.toDouble() ?? 0,
      itemsPerMinute: (json['items_per_minute'] as num?)?.toDouble() ?? 0,
      avgTransactionTimeSeconds: (json['avg_transaction_time_seconds'] as num?)?.toInt() ?? 0,
      voidCount: (json['void_count'] as num?)?.toInt() ?? 0,
      voidAmount: (json['void_amount'] as num?)?.toDouble() ?? 0,
      voidRate: (json['void_rate'] as num?)?.toDouble() ?? 0,
      returnCount: (json['return_count'] as num?)?.toInt() ?? 0,
      returnAmount: (json['return_amount'] as num?)?.toDouble() ?? 0,
      discountCount: (json['discount_count'] as num?)?.toInt() ?? 0,
      discountRate: (json['discount_rate'] as num?)?.toDouble() ?? 0,
      priceOverrideCount: (json['price_override_count'] as num?)?.toInt() ?? 0,
      noSaleCount: (json['no_sale_count'] as num?)?.toInt() ?? 0,
      upsellCount: (json['upsell_count'] as num?)?.toInt() ?? 0,
      upsellRate: (json['upsell_rate'] as num?)?.toDouble() ?? 0,
      cashVariance: (json['cash_variance'] as num?)?.toDouble() ?? 0,
      cashVarianceAbsolute: (json['cash_variance_absolute'] as num?)?.toDouble() ?? 0,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0,
      anomalyFlags: (json['anomaly_flags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashierPerformanceSnapshot && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
