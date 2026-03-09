import 'package:thawani_pos/features/orders/enums/order_delivery_platform.dart';

class OrderDeliveryInfo {
  final String id;
  final String orderId;
  final OrderDeliveryPlatform platform;
  final String? driverName;
  final String? driverPhone;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final double? deliveryFee;
  final String? trackingUrl;

  const OrderDeliveryInfo({
    required this.id,
    required this.orderId,
    required this.platform,
    this.driverName,
    this.driverPhone,
    this.estimatedDelivery,
    this.actualDelivery,
    this.deliveryFee,
    this.trackingUrl,
  });

  factory OrderDeliveryInfo.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryInfo(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      platform: OrderDeliveryPlatform.fromValue(json['platform'] as String),
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      estimatedDelivery: json['estimated_delivery'] != null ? DateTime.parse(json['estimated_delivery'] as String) : null,
      actualDelivery: json['actual_delivery'] != null ? DateTime.parse(json['actual_delivery'] as String) : null,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble(),
      trackingUrl: json['tracking_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'platform': platform.value,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'actual_delivery': actualDelivery?.toIso8601String(),
      'delivery_fee': deliveryFee,
      'tracking_url': trackingUrl,
    };
  }

  OrderDeliveryInfo copyWith({
    String? id,
    String? orderId,
    OrderDeliveryPlatform? platform,
    String? driverName,
    String? driverPhone,
    DateTime? estimatedDelivery,
    DateTime? actualDelivery,
    double? deliveryFee,
    String? trackingUrl,
  }) {
    return OrderDeliveryInfo(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      platform: platform ?? this.platform,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      trackingUrl: trackingUrl ?? this.trackingUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDeliveryInfo && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OrderDeliveryInfo(id: $id, orderId: $orderId, platform: $platform, driverName: $driverName, driverPhone: $driverPhone, estimatedDelivery: $estimatedDelivery, ...)';
}
