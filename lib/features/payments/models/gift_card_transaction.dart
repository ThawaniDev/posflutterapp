import 'package:wameedpos/features/payments/enums/gift_card_transaction_type.dart';

class GiftCardTransaction {
  final String id;
  final String giftCardId;
  final GiftCardTransactionType type;
  final double amount;
  final double balanceAfter;
  final String? paymentId;
  final String storeId;
  final String performedBy;
  final DateTime? createdAt;

  const GiftCardTransaction({
    required this.id,
    required this.giftCardId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.paymentId,
    required this.storeId,
    required this.performedBy,
    this.createdAt,
  });

  factory GiftCardTransaction.fromJson(Map<String, dynamic> json) {
    return GiftCardTransaction(
      id: json['id'] as String,
      giftCardId: json['gift_card_id'] as String,
      type: GiftCardTransactionType.fromValue(json['type'] as String),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      balanceAfter: double.tryParse(json['balance_after'].toString()) ?? 0.0,
      paymentId: json['payment_id'] as String?,
      storeId: json['store_id'] as String,
      performedBy: json['performed_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gift_card_id': giftCardId,
      'type': type.value,
      'amount': amount,
      'balance_after': balanceAfter,
      'payment_id': paymentId,
      'store_id': storeId,
      'performed_by': performedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  GiftCardTransaction copyWith({
    String? id,
    String? giftCardId,
    GiftCardTransactionType? type,
    double? amount,
    double? balanceAfter,
    String? paymentId,
    String? storeId,
    String? performedBy,
    DateTime? createdAt,
  }) {
    return GiftCardTransaction(
      id: id ?? this.id,
      giftCardId: giftCardId ?? this.giftCardId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      paymentId: paymentId ?? this.paymentId,
      storeId: storeId ?? this.storeId,
      performedBy: performedBy ?? this.performedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GiftCardTransaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GiftCardTransaction(id: $id, giftCardId: $giftCardId, type: $type, amount: $amount, balanceAfter: $balanceAfter, paymentId: $paymentId, ...)';
}
