import 'package:wameedpos/features/security/enums/session_status.dart';

class OpenTab {

  const OpenTab({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.customerName,
    this.tableId,
    this.openedAt,
    this.closedAt,
    this.status,
  });

  factory OpenTab.fromJson(Map<String, dynamic> json) {
    return OpenTab(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String,
      customerName: json['customer_name'] as String,
      tableId: json['table_id'] as String?,
      openedAt: json['opened_at'] != null ? DateTime.parse(json['opened_at'] as String) : null,
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      status: SessionStatus.tryFromValue(json['status'] as String?),
    );
  }
  final String id;
  final String storeId;
  final String orderId;
  final String customerName;
  final String? tableId;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final SessionStatus? status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'customer_name': customerName,
      'table_id': tableId,
      'opened_at': openedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'status': status?.value,
    };
  }

  OpenTab copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? customerName,
    String? tableId,
    DateTime? openedAt,
    DateTime? closedAt,
    SessionStatus? status,
  }) {
    return OpenTab(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      customerName: customerName ?? this.customerName,
      tableId: tableId ?? this.tableId,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is OpenTab && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'OpenTab(id: $id, storeId: $storeId, orderId: $orderId, customerName: $customerName, tableId: $tableId, openedAt: $openedAt, ...)';
}
