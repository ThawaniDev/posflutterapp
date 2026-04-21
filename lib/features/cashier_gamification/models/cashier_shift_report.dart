import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';

class CashierShiftReport {

  const CashierShiftReport({
    required this.id,
    required this.storeId,
    required this.cashierId,
    this.cashier,
    this.posSessionId,
    required this.reportDate,
    this.shiftStart,
    this.shiftEnd,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalItems = 0,
    this.itemsPerMinute = 0,
    this.avgBasketSize = 0,
    this.voidCount = 0,
    this.voidAmount = 0,
    this.returnCount = 0,
    this.returnAmount = 0,
    this.discountCount = 0,
    this.discountAmount = 0,
    this.noSaleCount = 0,
    this.priceOverrideCount = 0,
    this.cashVariance = 0,
    this.upsellCount = 0,
    this.upsellRate = 0,
    this.riskScore = 0,
    this.riskLevel = 'low',
    this.anomalyCount = 0,
    this.badgesEarned = const [],
    this.summaryEn,
    this.summaryAr,
    this.sentToOwner = false,
    this.sentAt,
    this.createdAt,
  });

  factory CashierShiftReport.fromJson(Map<String, dynamic> json) {
    return CashierShiftReport(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      cashierId: json['cashier_id'] as String,
      cashier: json['cashier'] != null ? CashierInfo.fromJson(json['cashier'] as Map<String, dynamic>) : null,
      posSessionId: json['pos_session_id'] as String?,
      reportDate: json['report_date'] as String,
      shiftStart: json['shift_start'] as String?,
      shiftEnd: json['shift_end'] as String?,
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
      itemsPerMinute: (json['items_per_minute'] as num?)?.toDouble() ?? 0,
      avgBasketSize: (json['avg_basket_size'] as num?)?.toDouble() ?? 0,
      voidCount: (json['void_count'] as num?)?.toInt() ?? 0,
      voidAmount: (json['void_amount'] as num?)?.toDouble() ?? 0,
      returnCount: (json['return_count'] as num?)?.toInt() ?? 0,
      returnAmount: (json['return_amount'] as num?)?.toDouble() ?? 0,
      discountCount: (json['discount_count'] as num?)?.toInt() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      noSaleCount: (json['no_sale_count'] as num?)?.toInt() ?? 0,
      priceOverrideCount: (json['price_override_count'] as num?)?.toInt() ?? 0,
      cashVariance: (json['cash_variance'] as num?)?.toDouble() ?? 0,
      upsellCount: (json['upsell_count'] as num?)?.toInt() ?? 0,
      upsellRate: (json['upsell_rate'] as num?)?.toDouble() ?? 0,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0,
      riskLevel: json['risk_level'] as String? ?? 'low',
      anomalyCount: (json['anomaly_count'] as num?)?.toInt() ?? 0,
      badgesEarned: (json['badges_earned'] as List?)?.map((e) => e.toString()).toList() ?? [],
      summaryEn: json['summary_en'] as String?,
      summaryAr: json['summary_ar'] as String?,
      sentToOwner: json['sent_to_owner'] as bool? ?? false,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String cashierId;
  final CashierInfo? cashier;
  final String? posSessionId;
  final String reportDate;
  final String? shiftStart;
  final String? shiftEnd;
  final int totalTransactions;
  final double totalRevenue;
  final int totalItems;
  final double itemsPerMinute;
  final double avgBasketSize;
  final int voidCount;
  final double voidAmount;
  final int returnCount;
  final double returnAmount;
  final int discountCount;
  final double discountAmount;
  final int noSaleCount;
  final int priceOverrideCount;
  final double cashVariance;
  final int upsellCount;
  final double upsellRate;
  final double riskScore;
  final String riskLevel;
  final int anomalyCount;
  final List<String> badgesEarned;
  final String? summaryEn;
  final String? summaryAr;
  final bool sentToOwner;
  final DateTime? sentAt;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashierShiftReport && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
