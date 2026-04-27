import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';

class DeliveryOrderMapping {
  const DeliveryOrderMapping({
    required this.id,
    this.orderId,
    this.storeId,
    required this.platform,
    required this.externalOrderId,
    this.externalStatus,
    this.deliveryStatus,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryFee,
    this.subtotal,
    this.totalAmount,
    this.itemsCount,
    this.commissionAmount,
    this.commissionPercent,
    this.rejectionReason,
    this.notes,
    this.estimatedPrepMinutes,
    this.rawPayload,
    this.acceptedAt,
    this.readyAt,
    this.dispatchedAt,
    this.deliveredAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryOrderMapping.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderMapping(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      storeId: json['store_id'] as String?,
      platform: DeliveryConfigPlatform.fromValue(json['platform'] as String),
      externalOrderId: json['external_order_id'] as String,
      externalStatus: json['external_status'] as String?,
      deliveryStatus: DeliveryOrderStatus.tryFromValue(json['delivery_status'] as String?),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      deliveryFee: (json['delivery_fee'] != null ? double.tryParse(json['delivery_fee'].toString()) : null),
      subtotal: (json['subtotal'] != null ? double.tryParse(json['subtotal'].toString()) : null),
      totalAmount: (json['total_amount'] != null ? double.tryParse(json['total_amount'].toString()) : null),
      itemsCount: (json['items_count'] as num?)?.toInt(),
      commissionAmount: (json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null),
      commissionPercent: (json['commission_percent'] != null ? double.tryParse(json['commission_percent'].toString()) : null),
      rejectionReason: json['rejection_reason'] as String?,
      notes: json['notes'] as String?,
      estimatedPrepMinutes: (json['estimated_prep_minutes'] as num?)?.toInt(),
      rawPayload: json['raw_payload'] != null ? Map<String, dynamic>.from(json['raw_payload'] as Map) : null,
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at'] as String) : null,
      readyAt: json['ready_at'] != null ? DateTime.parse(json['ready_at'] as String) : null,
      dispatchedAt: json['dispatched_at'] != null ? DateTime.parse(json['dispatched_at'] as String) : null,
      deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String? orderId;
  final String? storeId;
  final DeliveryConfigPlatform platform;
  final String externalOrderId;
  final String? externalStatus;
  final DeliveryOrderStatus? deliveryStatus;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final double? deliveryFee;
  final double? subtotal;
  final double? totalAmount;
  final int? itemsCount;
  final double? commissionAmount;
  final double? commissionPercent;
  final String? rejectionReason;
  final String? notes;
  final int? estimatedPrepMinutes;
  final Map<String, dynamic>? rawPayload;
  final DateTime? acceptedAt;
  final DateTime? readyAt;
  final DateTime? dispatchedAt;
  final DateTime? deliveredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'store_id': storeId,
      'platform': platform.value,
      'external_order_id': externalOrderId,
      'external_status': externalStatus,
      'delivery_status': deliveryStatus?.value,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'delivery_fee': deliveryFee,
      'subtotal': subtotal,
      'total_amount': totalAmount,
      'items_count': itemsCount,
      'commission_amount': commissionAmount,
      'commission_percent': commissionPercent,
      'rejection_reason': rejectionReason,
      'notes': notes,
      'estimated_prep_minutes': estimatedPrepMinutes,
      'raw_payload': rawPayload,
      'accepted_at': acceptedAt?.toIso8601String(),
      'ready_at': readyAt?.toIso8601String(),
      'dispatched_at': dispatchedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeliveryOrderMapping && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
