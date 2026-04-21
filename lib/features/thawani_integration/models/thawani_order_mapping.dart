import 'package:wameedpos/features/thawani_integration/enums/thawani_delivery_type.dart';
import 'package:wameedpos/features/thawani_integration/enums/thawani_order_status.dart';

class ThawaniOrderMapping {

  const ThawaniOrderMapping({
    required this.id,
    required this.storeId,
    this.orderId,
    required this.thawaniOrderId,
    required this.thawaniOrderNumber,
    required this.status,
    required this.deliveryType,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    required this.orderTotal,
    this.commissionAmount,
    this.rejectionReason,
    this.acceptedAt,
    this.preparedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ThawaniOrderMapping.fromJson(Map<String, dynamic> json) {
    return ThawaniOrderMapping(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String?,
      thawaniOrderId: json['thawani_order_id'] as String,
      thawaniOrderNumber: json['thawani_order_number'] as String,
      status: ThawaniOrderStatus.fromValue(json['status'] as String),
      deliveryType: ThawaniDeliveryType.fromValue(json['delivery_type'] as String),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      orderTotal: double.tryParse(json['order_total'].toString()) ?? 0.0,
      commissionAmount: (json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null),
      rejectionReason: json['rejection_reason'] as String?,
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at'] as String) : null,
      preparedAt: json['prepared_at'] != null ? DateTime.parse(json['prepared_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? orderId;
  final String thawaniOrderId;
  final String thawaniOrderNumber;
  final ThawaniOrderStatus status;
  final ThawaniDeliveryType deliveryType;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final double orderTotal;
  final double? commissionAmount;
  final String? rejectionReason;
  final DateTime? acceptedAt;
  final DateTime? preparedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'thawani_order_id': thawaniOrderId,
      'thawani_order_number': thawaniOrderNumber,
      'status': status.value,
      'delivery_type': deliveryType.value,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'order_total': orderTotal,
      'commission_amount': commissionAmount,
      'rejection_reason': rejectionReason,
      'accepted_at': acceptedAt?.toIso8601String(),
      'prepared_at': preparedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ThawaniOrderMapping copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? thawaniOrderId,
    String? thawaniOrderNumber,
    ThawaniOrderStatus? status,
    ThawaniDeliveryType? deliveryType,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    double? orderTotal,
    double? commissionAmount,
    String? rejectionReason,
    DateTime? acceptedAt,
    DateTime? preparedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThawaniOrderMapping(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      thawaniOrderId: thawaniOrderId ?? this.thawaniOrderId,
      thawaniOrderNumber: thawaniOrderNumber ?? this.thawaniOrderNumber,
      status: status ?? this.status,
      deliveryType: deliveryType ?? this.deliveryType,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderTotal: orderTotal ?? this.orderTotal,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      preparedAt: preparedAt ?? this.preparedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThawaniOrderMapping && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ThawaniOrderMapping(id: $id, storeId: $storeId, orderId: $orderId, thawaniOrderId: $thawaniOrderId, thawaniOrderNumber: $thawaniOrderNumber, status: $status, ...)';
}
