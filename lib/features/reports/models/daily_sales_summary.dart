class DailySalesSummary {
  final String id;
  final String storeId;
  final DateTime date;
  final int? totalTransactions;
  final double? totalRevenue;
  final double? totalCost;
  final double? totalDiscount;
  final double? totalTax;
  final double? totalRefunds;
  final double? netRevenue;
  final double? cashRevenue;
  final double? cardRevenue;
  final double? otherRevenue;
  final double? avgBasketSize;

  const DailySalesSummary({
    required this.id,
    required this.storeId,
    required this.date,
    this.totalTransactions,
    this.totalRevenue,
    this.totalCost,
    this.totalDiscount,
    this.totalTax,
    this.totalRefunds,
    this.netRevenue,
    this.cashRevenue,
    this.cardRevenue,
    this.otherRevenue,
    this.avgBasketSize,
  });

  factory DailySalesSummary.fromJson(Map<String, dynamic> json) {
    return DailySalesSummary(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      date: DateTime.parse(json['date'] as String),
      totalTransactions: (json['total_transactions'] as num?)?.toInt(),
      totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      totalDiscount: (json['total_discount'] as num?)?.toDouble(),
      totalTax: (json['total_tax'] as num?)?.toDouble(),
      totalRefunds: (json['total_refunds'] as num?)?.toDouble(),
      netRevenue: (json['net_revenue'] as num?)?.toDouble(),
      cashRevenue: (json['cash_revenue'] as num?)?.toDouble(),
      cardRevenue: (json['card_revenue'] as num?)?.toDouble(),
      otherRevenue: (json['other_revenue'] as num?)?.toDouble(),
      avgBasketSize: (json['avg_basket_size'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'date': date.toIso8601String(),
      'total_transactions': totalTransactions,
      'total_revenue': totalRevenue,
      'total_cost': totalCost,
      'total_discount': totalDiscount,
      'total_tax': totalTax,
      'total_refunds': totalRefunds,
      'net_revenue': netRevenue,
      'cash_revenue': cashRevenue,
      'card_revenue': cardRevenue,
      'other_revenue': otherRevenue,
      'avg_basket_size': avgBasketSize,
    };
  }

  DailySalesSummary copyWith({
    String? id,
    String? storeId,
    DateTime? date,
    int? totalTransactions,
    double? totalRevenue,
    double? totalCost,
    double? totalDiscount,
    double? totalTax,
    double? totalRefunds,
    double? netRevenue,
    double? cashRevenue,
    double? cardRevenue,
    double? otherRevenue,
    double? avgBasketSize,
  }) {
    return DailySalesSummary(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      date: date ?? this.date,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalCost: totalCost ?? this.totalCost,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalTax: totalTax ?? this.totalTax,
      totalRefunds: totalRefunds ?? this.totalRefunds,
      netRevenue: netRevenue ?? this.netRevenue,
      cashRevenue: cashRevenue ?? this.cashRevenue,
      cardRevenue: cardRevenue ?? this.cardRevenue,
      otherRevenue: otherRevenue ?? this.otherRevenue,
      avgBasketSize: avgBasketSize ?? this.avgBasketSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySalesSummary && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DailySalesSummary(id: $id, storeId: $storeId, date: $date, totalTransactions: $totalTransactions, totalRevenue: $totalRevenue, totalCost: $totalCost, ...)';
}
