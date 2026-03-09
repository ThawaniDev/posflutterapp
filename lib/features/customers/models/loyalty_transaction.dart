import 'package:thawani_pos/features/customers/enums/loyalty_transaction_type.dart';

class LoyaltyTransaction {
  final String id;
  final String customerId;
  final LoyaltyTransactionType type;
  final int points;
  final int balanceAfter;
  final String? orderId;
  final String? notes;
  final String? performedBy;
  final DateTime? createdAt;

  const LoyaltyTransaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.points,
    required this.balanceAfter,
    this.orderId,
    this.notes,
    this.performedBy,
    this.createdAt,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      type: LoyaltyTransactionType.fromValue(json['type'] as String),
      points: (json['points'] as num).toInt(),
      balanceAfter: (json['balance_after'] as num).toInt(),
      orderId: json['order_id'] as String?,
      notes: json['notes'] as String?,
      performedBy: json['performed_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'type': type.value,
      'points': points,
      'balance_after': balanceAfter,
      'order_id': orderId,
      'notes': notes,
      'performed_by': performedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  LoyaltyTransaction copyWith({
    String? id,
    String? customerId,
    LoyaltyTransactionType? type,
    int? points,
    int? balanceAfter,
    String? orderId,
    String? notes,
    String? performedBy,
    DateTime? createdAt,
  }) {
    return LoyaltyTransaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      points: points ?? this.points,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      orderId: orderId ?? this.orderId,
      notes: notes ?? this.notes,
      performedBy: performedBy ?? this.performedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyTransaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LoyaltyTransaction(id: $id, customerId: $customerId, type: $type, points: $points, balanceAfter: $balanceAfter, orderId: $orderId, ...)';
}
