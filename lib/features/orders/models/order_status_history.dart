import 'package:thawani_pos/features/orders/enums/order_status.dart';

class OrderStatusHistory {
  final String id;
  final String orderId;
  final OrderStatus? fromStatus;
  final OrderStatus toStatus;
  final String? changedBy;
  final String? notes;
  final DateTime? createdAt;

  const OrderStatusHistory({
    required this.id,
    required this.orderId,
    this.fromStatus,
    required this.toStatus,
    this.changedBy,
    this.notes,
    this.createdAt,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      fromStatus: OrderStatus.tryFromValue(json['from_status'] as String?),
      toStatus: OrderStatus.fromValue(json['to_status'] as String),
      changedBy: json['changed_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'from_status': fromStatus?.value,
      'to_status': toStatus.value,
      'changed_by': changedBy,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  OrderStatusHistory copyWith({
    String? id,
    String? orderId,
    OrderStatus? fromStatus,
    OrderStatus? toStatus,
    String? changedBy,
    String? notes,
    DateTime? createdAt,
  }) {
    return OrderStatusHistory(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedBy: changedBy ?? this.changedBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusHistory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OrderStatusHistory(id: $id, orderId: $orderId, fromStatus: $fromStatus, toStatus: $toStatus, changedBy: $changedBy, notes: $notes, ...)';
}
