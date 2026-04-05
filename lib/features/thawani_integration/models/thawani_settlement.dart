class ThawaniSettlement {
  final String id;
  final String storeId;
  final DateTime settlementDate;
  final double grossAmount;
  final double commissionAmount;
  final double netAmount;
  final int orderCount;
  final String? thawaniReference;
  final DateTime? createdAt;

  const ThawaniSettlement({
    required this.id,
    required this.storeId,
    required this.settlementDate,
    required this.grossAmount,
    required this.commissionAmount,
    required this.netAmount,
    required this.orderCount,
    this.thawaniReference,
    this.createdAt,
  });

  factory ThawaniSettlement.fromJson(Map<String, dynamic> json) {
    return ThawaniSettlement(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      settlementDate: DateTime.parse(json['settlement_date'] as String),
      grossAmount: double.tryParse(json['gross_amount'].toString()) ?? 0.0,
      commissionAmount: double.tryParse(json['commission_amount'].toString()) ?? 0.0,
      netAmount: double.tryParse(json['net_amount'].toString()) ?? 0.0,
      orderCount: (json['order_count'] as num).toInt(),
      thawaniReference: json['thawani_reference'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'settlement_date': settlementDate.toIso8601String(),
      'gross_amount': grossAmount,
      'commission_amount': commissionAmount,
      'net_amount': netAmount,
      'order_count': orderCount,
      'thawani_reference': thawaniReference,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ThawaniSettlement copyWith({
    String? id,
    String? storeId,
    DateTime? settlementDate,
    double? grossAmount,
    double? commissionAmount,
    double? netAmount,
    int? orderCount,
    String? thawaniReference,
    DateTime? createdAt,
  }) {
    return ThawaniSettlement(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      settlementDate: settlementDate ?? this.settlementDate,
      grossAmount: grossAmount ?? this.grossAmount,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      netAmount: netAmount ?? this.netAmount,
      orderCount: orderCount ?? this.orderCount,
      thawaniReference: thawaniReference ?? this.thawaniReference,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThawaniSettlement && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ThawaniSettlement(id: $id, storeId: $storeId, settlementDate: $settlementDate, grossAmount: $grossAmount, commissionAmount: $commissionAmount, netAmount: $netAmount, ...)';
}
