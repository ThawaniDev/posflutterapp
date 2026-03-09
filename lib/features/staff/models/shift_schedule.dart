import 'package:thawani_pos/features/staff/enums/shift_schedule_status.dart';

class ShiftSchedule {
  final String id;
  final String storeId;
  final String staffUserId;
  final String shiftTemplateId;
  final DateTime date;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final ShiftScheduleStatus? status;
  final String? swappedWithId;
  final DateTime? createdAt;

  const ShiftSchedule({
    required this.id,
    required this.storeId,
    required this.staffUserId,
    required this.shiftTemplateId,
    required this.date,
    this.actualStart,
    this.actualEnd,
    this.status,
    this.swappedWithId,
    this.createdAt,
  });

  factory ShiftSchedule.fromJson(Map<String, dynamic> json) {
    return ShiftSchedule(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      staffUserId: json['staff_user_id'] as String,
      shiftTemplateId: json['shift_template_id'] as String,
      date: DateTime.parse(json['date'] as String),
      actualStart: json['actual_start'] != null ? DateTime.parse(json['actual_start'] as String) : null,
      actualEnd: json['actual_end'] != null ? DateTime.parse(json['actual_end'] as String) : null,
      status: ShiftScheduleStatus.tryFromValue(json['status'] as String?),
      swappedWithId: json['swapped_with_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'staff_user_id': staffUserId,
      'shift_template_id': shiftTemplateId,
      'date': date.toIso8601String(),
      'actual_start': actualStart?.toIso8601String(),
      'actual_end': actualEnd?.toIso8601String(),
      'status': status?.value,
      'swapped_with_id': swappedWithId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ShiftSchedule copyWith({
    String? id,
    String? storeId,
    String? staffUserId,
    String? shiftTemplateId,
    DateTime? date,
    DateTime? actualStart,
    DateTime? actualEnd,
    ShiftScheduleStatus? status,
    String? swappedWithId,
    DateTime? createdAt,
  }) {
    return ShiftSchedule(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      staffUserId: staffUserId ?? this.staffUserId,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      date: date ?? this.date,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      status: status ?? this.status,
      swappedWithId: swappedWithId ?? this.swappedWithId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftSchedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ShiftSchedule(id: $id, storeId: $storeId, staffUserId: $staffUserId, shiftTemplateId: $shiftTemplateId, date: $date, actualStart: $actualStart, ...)';
}
