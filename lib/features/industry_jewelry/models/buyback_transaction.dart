import 'package:thawani_pos/features/industry_jewelry/enums/buyback_payment_method.dart';
import 'package:thawani_pos/features/industry_jewelry/enums/metal_type.dart';

class BuybackTransaction {
  final String id;
  final String storeId;
  final String? customerId;
  final MetalType metalType;
  final String karat;
  final double weightG;
  final double ratePerGram;
  final double totalAmount;
  final BuybackPaymentMethod paymentMethod;
  final String staffUserId;
  final String? notes;
  final DateTime? createdAt;

  const BuybackTransaction({
    required this.id,
    required this.storeId,
    this.customerId,
    required this.metalType,
    required this.karat,
    required this.weightG,
    required this.ratePerGram,
    required this.totalAmount,
    required this.paymentMethod,
    required this.staffUserId,
    this.notes,
    this.createdAt,
  });

  factory BuybackTransaction.fromJson(Map<String, dynamic> json) {
    return BuybackTransaction(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      metalType: MetalType.fromValue(json['metal_type'] as String),
      karat: json['karat'] as String,
      weightG: (json['weight_g'] as num).toDouble(),
      ratePerGram: (json['rate_per_gram'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentMethod: BuybackPaymentMethod.fromValue(json['payment_method'] as String),
      staffUserId: json['staff_user_id'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'metal_type': metalType.value,
      'karat': karat,
      'weight_g': weightG,
      'rate_per_gram': ratePerGram,
      'total_amount': totalAmount,
      'payment_method': paymentMethod.value,
      'staff_user_id': staffUserId,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  BuybackTransaction copyWith({
    String? id,
    String? storeId,
    String? customerId,
    MetalType? metalType,
    String? karat,
    double? weightG,
    double? ratePerGram,
    double? totalAmount,
    BuybackPaymentMethod? paymentMethod,
    String? staffUserId,
    String? notes,
    DateTime? createdAt,
  }) {
    return BuybackTransaction(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      metalType: metalType ?? this.metalType,
      karat: karat ?? this.karat,
      weightG: weightG ?? this.weightG,
      ratePerGram: ratePerGram ?? this.ratePerGram,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      staffUserId: staffUserId ?? this.staffUserId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuybackTransaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BuybackTransaction(id: $id, storeId: $storeId, customerId: $customerId, metalType: $metalType, karat: $karat, weightG: $weightG, ...)';
}
