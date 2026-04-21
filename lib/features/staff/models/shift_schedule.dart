import 'package:wameedpos/features/staff/enums/shift_schedule_status.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';

/// Minimal nested staff info returned inline by the API.
class ShiftStaffUser {

  const ShiftStaffUser({required this.id, required this.firstName, required this.lastName, this.photoUrl});

  factory ShiftStaffUser.fromJson(Map<String, dynamic> json) {
    return ShiftStaffUser(
      id: json['id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
    );
  }
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  String get fullName => '$firstName $lastName'.trim();
}

class ShiftSchedule {

  const ShiftSchedule({
    required this.id,
    required this.storeId,
    required this.staffUserId,
    required this.shiftTemplateId,
    required this.startDate,
    required this.endDate,
    this.actualStart,
    this.actualEnd,
    this.status,
    this.swappedWithId,
    this.notes,
    this.createdAt,
    this.staffUser,
    this.shiftTemplate,
  });

  factory ShiftSchedule.fromJson(Map<String, dynamic> json) {
    return ShiftSchedule(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      staffUserId: json['staff_user_id'] as String,
      shiftTemplateId: json['shift_template_id'] as String,
      startDate: DateTime.parse((json['start_date'] ?? json['date']) as String),
      endDate: DateTime.parse((json['end_date'] ?? json['start_date'] ?? json['date']) as String),
      actualStart: json['actual_start'] != null ? DateTime.parse(json['actual_start'] as String) : null,
      actualEnd: json['actual_end'] != null ? DateTime.parse(json['actual_end'] as String) : null,
      status: ShiftScheduleStatus.tryFromValue(json['status'] as String?),
      swappedWithId: json['swapped_with_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      staffUser: json['staff_user'] != null && json['staff_user'] is Map<String, dynamic>
          ? ShiftStaffUser.fromJson(json['staff_user'] as Map<String, dynamic>)
          : null,
      shiftTemplate: json['shift_template'] != null && json['shift_template'] is Map<String, dynamic>
          ? ShiftTemplate.fromJson(json['shift_template'] as Map<String, dynamic>)
          : null,
    );
  }
  final String id;
  final String storeId;
  final String staffUserId;
  final String shiftTemplateId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final ShiftScheduleStatus? status;
  final String? swappedWithId;
  final String? notes;
  final DateTime? createdAt;
  final ShiftStaffUser? staffUser;
  final ShiftTemplate? shiftTemplate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'staff_user_id': staffUserId,
      'shift_template_id': shiftTemplateId,
      'start_date': startDate.toIso8601String().substring(0, 10),
      'end_date': endDate.toIso8601String().substring(0, 10),
      'actual_start': actualStart?.toIso8601String(),
      'actual_end': actualEnd?.toIso8601String(),
      'status': status?.value,
      'swapped_with_id': swappedWithId,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ShiftSchedule copyWith({
    String? id,
    String? storeId,
    String? staffUserId,
    String? shiftTemplateId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? actualStart,
    DateTime? actualEnd,
    ShiftScheduleStatus? status,
    String? swappedWithId,
    String? notes,
    DateTime? createdAt,
    ShiftStaffUser? staffUser,
    ShiftTemplate? shiftTemplate,
  }) {
    return ShiftSchedule(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      staffUserId: staffUserId ?? this.staffUserId,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      status: status ?? this.status,
      swappedWithId: swappedWithId ?? this.swappedWithId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      staffUser: staffUser ?? this.staffUser,
      shiftTemplate: shiftTemplate ?? this.shiftTemplate,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ShiftSchedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ShiftSchedule(id: $id, storeId: $storeId, staffUserId: $staffUserId, shiftTemplateId: $shiftTemplateId, startDate: $startDate, endDate: $endDate, ...)';
}
