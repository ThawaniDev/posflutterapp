class Exchange {

  const Exchange({
    required this.id,
    required this.storeId,
    required this.originalOrderId,
    required this.returnId,
    required this.newOrderId,
    required this.netAmount,
    required this.processedBy,
    this.createdAt,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      originalOrderId: json['original_order_id'] as String,
      returnId: json['return_id'] as String,
      newOrderId: json['new_order_id'] as String,
      netAmount: double.tryParse(json['net_amount'].toString()) ?? 0.0,
      processedBy: json['processed_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String originalOrderId;
  final String returnId;
  final String newOrderId;
  final double netAmount;
  final String processedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'original_order_id': originalOrderId,
      'return_id': returnId,
      'new_order_id': newOrderId,
      'net_amount': netAmount,
      'processed_by': processedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Exchange copyWith({
    String? id,
    String? storeId,
    String? originalOrderId,
    String? returnId,
    String? newOrderId,
    double? netAmount,
    String? processedBy,
    DateTime? createdAt,
  }) {
    return Exchange(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      originalOrderId: originalOrderId ?? this.originalOrderId,
      returnId: returnId ?? this.returnId,
      newOrderId: newOrderId ?? this.newOrderId,
      netAmount: netAmount ?? this.netAmount,
      processedBy: processedBy ?? this.processedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exchange && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Exchange(id: $id, storeId: $storeId, originalOrderId: $originalOrderId, returnId: $returnId, newOrderId: $newOrderId, netAmount: $netAmount, ...)';
}
