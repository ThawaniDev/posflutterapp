import 'package:thawani_pos/features/orders/enums/order_source.dart';
import 'package:thawani_pos/features/orders/enums/order_status.dart';

class Order {
  final String id;
  final String storeId;
  final String? transactionId;
  final String? customerId;
  final String orderNumber;
  final OrderSource source;
  final OrderStatus status;
  final double subtotal;
  final double taxAmount;
  final double? discountAmount;
  final double total;
  final String? notes;
  final String? customerNotes;
  final String? externalOrderId;
  final String? deliveryAddress;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.id,
    required this.storeId,
    this.transactionId,
    this.customerId,
    required this.orderNumber,
    required this.source,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    this.discountAmount,
    required this.total,
    this.notes,
    this.customerNotes,
    this.externalOrderId,
    this.deliveryAddress,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      transactionId: json['transaction_id'] as String?,
      customerId: json['customer_id'] as String?,
      orderNumber: json['order_number'] as String,
      source: OrderSource.fromValue(json['source'] as String),
      status: OrderStatus.fromValue(json['status'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      customerNotes: json['customer_notes'] as String?,
      externalOrderId: json['external_order_id'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'transaction_id': transactionId,
      'customer_id': customerId,
      'order_number': orderNumber,
      'source': source.value,
      'status': status.value,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total': total,
      'notes': notes,
      'customer_notes': customerNotes,
      'external_order_id': externalOrderId,
      'delivery_address': deliveryAddress,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? storeId,
    String? transactionId,
    String? customerId,
    String? orderNumber,
    OrderSource? source,
    OrderStatus? status,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? total,
    String? notes,
    String? customerNotes,
    String? externalOrderId,
    String? deliveryAddress,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      transactionId: transactionId ?? this.transactionId,
      customerId: customerId ?? this.customerId,
      orderNumber: orderNumber ?? this.orderNumber,
      source: source ?? this.source,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      customerNotes: customerNotes ?? this.customerNotes,
      externalOrderId: externalOrderId ?? this.externalOrderId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Order(id: $id, storeId: $storeId, transactionId: $transactionId, customerId: $customerId, orderNumber: $orderNumber, source: $source, ...)';
}
