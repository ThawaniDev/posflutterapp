import 'package:wameedpos/features/industry_florist/enums/flower_subscription_frequency.dart';

class FlowerSubscription {
  final String id;
  final String storeId;
  final String customerId;
  final String? arrangementTemplateId;
  final FlowerSubscriptionFrequency frequency;
  final String? deliveryDay;
  final String deliveryAddress;
  final double pricePerDelivery;
  final bool? isActive;
  final DateTime nextDeliveryDate;
  final DateTime? createdAt;

  const FlowerSubscription({
    required this.id,
    required this.storeId,
    required this.customerId,
    this.arrangementTemplateId,
    required this.frequency,
    this.deliveryDay,
    required this.deliveryAddress,
    required this.pricePerDelivery,
    this.isActive,
    required this.nextDeliveryDate,
    this.createdAt,
  });

  factory FlowerSubscription.fromJson(Map<String, dynamic> json) {
    return FlowerSubscription(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String,
      arrangementTemplateId: json['arrangement_template_id'] as String?,
      frequency: FlowerSubscriptionFrequency.fromValue(json['frequency'] as String),
      deliveryDay: json['delivery_day'] as String?,
      deliveryAddress: json['delivery_address'] as String,
      pricePerDelivery: double.tryParse(json['price_per_delivery'].toString()) ?? 0.0,
      isActive: json['is_active'] as bool?,
      nextDeliveryDate: DateTime.parse(json['next_delivery_date'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'arrangement_template_id': arrangementTemplateId,
      'frequency': frequency.value,
      'delivery_day': deliveryDay,
      'delivery_address': deliveryAddress,
      'price_per_delivery': pricePerDelivery,
      'is_active': isActive,
      'next_delivery_date': nextDeliveryDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  FlowerSubscription copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? arrangementTemplateId,
    FlowerSubscriptionFrequency? frequency,
    String? deliveryDay,
    String? deliveryAddress,
    double? pricePerDelivery,
    bool? isActive,
    DateTime? nextDeliveryDate,
    DateTime? createdAt,
  }) {
    return FlowerSubscription(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      arrangementTemplateId: arrangementTemplateId ?? this.arrangementTemplateId,
      frequency: frequency ?? this.frequency,
      deliveryDay: deliveryDay ?? this.deliveryDay,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pricePerDelivery: pricePerDelivery ?? this.pricePerDelivery,
      isActive: isActive ?? this.isActive,
      nextDeliveryDate: nextDeliveryDate ?? this.nextDeliveryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlowerSubscription && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FlowerSubscription(id: $id, storeId: $storeId, customerId: $customerId, arrangementTemplateId: $arrangementTemplateId, frequency: $frequency, deliveryDay: $deliveryDay, ...)';
}
