class ExchangeTransaction {

  const ExchangeTransaction({
    required this.id,
    required this.returnTransactionId,
    required this.saleTransactionId,
    required this.netAmount,
    this.createdAt,
  });

  factory ExchangeTransaction.fromJson(Map<String, dynamic> json) {
    return ExchangeTransaction(
      id: json['id'] as String,
      returnTransactionId: json['return_transaction_id'] as String,
      saleTransactionId: json['sale_transaction_id'] as String,
      netAmount: double.tryParse(json['net_amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String returnTransactionId;
  final String saleTransactionId;
  final double netAmount;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'return_transaction_id': returnTransactionId,
      'sale_transaction_id': saleTransactionId,
      'net_amount': netAmount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ExchangeTransaction copyWith({
    String? id,
    String? returnTransactionId,
    String? saleTransactionId,
    double? netAmount,
    DateTime? createdAt,
  }) {
    return ExchangeTransaction(
      id: id ?? this.id,
      returnTransactionId: returnTransactionId ?? this.returnTransactionId,
      saleTransactionId: saleTransactionId ?? this.saleTransactionId,
      netAmount: netAmount ?? this.netAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeTransaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ExchangeTransaction(id: $id, returnTransactionId: $returnTransactionId, saleTransactionId: $saleTransactionId, netAmount: $netAmount, createdAt: $createdAt)';
}
