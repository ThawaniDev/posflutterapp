import 'package:wameedpos/features/industry_restaurant/enums/kitchen_ticket_status.dart';

class KitchenTicket {

  const KitchenTicket({
    required this.id,
    required this.storeId,
    required this.orderId,
    this.tableId,
    required this.ticketNumber,
    required this.itemsJson,
    this.station,
    this.status,
    this.courseNumber,
    this.fireAt,
    this.createdAt,
    this.completedAt,
  });

  factory KitchenTicket.fromJson(Map<String, dynamic> json) {
    return KitchenTicket(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String,
      tableId: json['table_id'] as String?,
      ticketNumber: (json['ticket_number'] as num).toInt(),
      itemsJson: Map<String, dynamic>.from(json['items_json'] as Map),
      station: json['station'] as String?,
      status: KitchenTicketStatus.tryFromValue(json['status'] as String?),
      courseNumber: (json['course_number'] as num?)?.toInt(),
      fireAt: json['fire_at'] != null ? DateTime.parse(json['fire_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String orderId;
  final String? tableId;
  final int ticketNumber;
  final Map<String, dynamic> itemsJson;
  final String? station;
  final KitchenTicketStatus? status;
  final int? courseNumber;
  final DateTime? fireAt;
  final DateTime? createdAt;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'table_id': tableId,
      'ticket_number': ticketNumber,
      'items_json': itemsJson,
      'station': station,
      'status': status?.value,
      'course_number': courseNumber,
      'fire_at': fireAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  KitchenTicket copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? tableId,
    int? ticketNumber,
    Map<String, dynamic>? itemsJson,
    String? station,
    KitchenTicketStatus? status,
    int? courseNumber,
    DateTime? fireAt,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return KitchenTicket(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      tableId: tableId ?? this.tableId,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      itemsJson: itemsJson ?? this.itemsJson,
      station: station ?? this.station,
      status: status ?? this.status,
      courseNumber: courseNumber ?? this.courseNumber,
      fireAt: fireAt ?? this.fireAt,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is KitchenTicket && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'KitchenTicket(id: $id, storeId: $storeId, orderId: $orderId, tableId: $tableId, ticketNumber: $ticketNumber, itemsJson: $itemsJson, ...)';
}
