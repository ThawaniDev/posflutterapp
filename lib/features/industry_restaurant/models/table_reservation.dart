import 'package:thawani_pos/features/industry_restaurant/enums/table_reservation_status.dart';

class TableReservation {
  final String id;
  final String storeId;
  final String? tableId;
  final String customerName;
  final String? customerPhone;
  final int partySize;
  final DateTime reservationDate;
  final String reservationTime;
  final int? durationMinutes;
  final TableReservationStatus? status;
  final String? notes;
  final DateTime? createdAt;

  const TableReservation({
    required this.id,
    required this.storeId,
    this.tableId,
    required this.customerName,
    this.customerPhone,
    required this.partySize,
    required this.reservationDate,
    required this.reservationTime,
    this.durationMinutes,
    this.status,
    this.notes,
    this.createdAt,
  });

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    return TableReservation(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      tableId: json['table_id'] as String?,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String?,
      partySize: (json['party_size'] as num).toInt(),
      reservationDate: DateTime.parse(json['reservation_date'] as String),
      reservationTime: json['reservation_time'] as String,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      status: TableReservationStatus.tryFromValue(json['status'] as String?),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'table_id': tableId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'party_size': partySize,
      'reservation_date': reservationDate.toIso8601String(),
      'reservation_time': reservationTime,
      'duration_minutes': durationMinutes,
      'status': status?.value,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TableReservation copyWith({
    String? id,
    String? storeId,
    String? tableId,
    String? customerName,
    String? customerPhone,
    int? partySize,
    DateTime? reservationDate,
    String? reservationTime,
    int? durationMinutes,
    TableReservationStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return TableReservation(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      tableId: tableId ?? this.tableId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      partySize: partySize ?? this.partySize,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableReservation && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TableReservation(id: $id, storeId: $storeId, tableId: $tableId, customerName: $customerName, customerPhone: $customerPhone, partySize: $partySize, ...)';
}
