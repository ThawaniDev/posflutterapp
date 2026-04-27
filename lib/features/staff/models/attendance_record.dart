import 'package:wameedpos/features/auth/enums/auth_method.dart';
import 'package:wameedpos/features/staff/models/break_record.dart';

/// Minimal nested staff info returned inline by the API.
class AttendanceStaffUser {
  const AttendanceStaffUser({required this.id, required this.firstName, required this.lastName, this.photoUrl});

  factory AttendanceStaffUser.fromJson(Map<String, dynamic> json) {
    return AttendanceStaffUser(
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

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.staffUserId,
    required this.storeId,
    required this.clockInAt,
    this.clockOutAt,
    this.breakMinutes,
    this.workMinutes,
    this.scheduledShiftId,
    this.overtimeMinutes,
    this.notes,
    required this.authMethod,
    this.status,
    this.createdAt,
    this.staffUser,
    this.breakRecords = const [],
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      storeId: json['store_id'] as String,
      clockInAt: DateTime.parse(json['clock_in_at'] as String),
      clockOutAt: json['clock_out_at'] != null ? DateTime.parse(json['clock_out_at'] as String) : null,
      breakMinutes: (json['break_minutes'] as num?)?.toInt(),
      workMinutes: (json['work_minutes'] as num?)?.toInt(),
      scheduledShiftId: json['scheduled_shift_id'] as String?,
      overtimeMinutes: (json['overtime_minutes'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      authMethod: AuthMethod.fromValue(json['auth_method'] as String? ?? 'pin'),
      status: json['status'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      staffUser: json['staff_user'] != null && json['staff_user'] is Map<String, dynamic>
          ? AttendanceStaffUser.fromJson(json['staff_user'] as Map<String, dynamic>)
          : null,
      breakRecords: json['break_records'] != null && json['break_records'] is List
          ? (json['break_records'] as List).map((b) => BreakRecord.fromJson(b as Map<String, dynamic>)).toList()
          : const [],
    );
  }
  final String id;
  final String staffUserId;
  final String storeId;
  final DateTime clockInAt;
  final DateTime? clockOutAt;
  final int? breakMinutes;

  /// Net work minutes from API (total time minus breaks), pre-calculated by backend.
  final int? workMinutes;
  final String? scheduledShiftId;
  final int? overtimeMinutes;
  final String? notes;
  final AuthMethod authMethod;
  final String? status;
  final DateTime? createdAt;
  final AttendanceStaffUser? staffUser;
  final List<BreakRecord> breakRecords;

  bool get isOpen => clockOutAt == null;
  bool get isOnBreak => breakRecords.any((b) => b.breakEnd == null);

  Duration get workedDuration {
    final end = clockOutAt ?? DateTime.now();
    return end.difference(clockInAt);
  }

  Duration get netWorkedDuration {
    final total = workedDuration;
    final breakDur = Duration(minutes: breakMinutes ?? 0);
    return total - breakDur;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'store_id': storeId,
      'clock_in_at': clockInAt.toIso8601String(),
      'clock_out_at': clockOutAt?.toIso8601String(),
      'break_minutes': breakMinutes,
      'work_minutes': workMinutes,
      'scheduled_shift_id': scheduledShiftId,
      'overtime_minutes': overtimeMinutes,
      'notes': notes,
      'auth_method': authMethod.value,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? staffUserId,
    String? storeId,
    DateTime? clockInAt,
    DateTime? clockOutAt,
    int? breakMinutes,
    int? workMinutes,
    String? scheduledShiftId,
    int? overtimeMinutes,
    String? notes,
    AuthMethod? authMethod,
    String? status,
    DateTime? createdAt,
    AttendanceStaffUser? staffUser,
    List<BreakRecord>? breakRecords,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      storeId: storeId ?? this.storeId,
      clockInAt: clockInAt ?? this.clockInAt,
      clockOutAt: clockOutAt ?? this.clockOutAt,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      workMinutes: workMinutes ?? this.workMinutes,
      scheduledShiftId: scheduledShiftId ?? this.scheduledShiftId,
      overtimeMinutes: overtimeMinutes ?? this.overtimeMinutes,
      notes: notes ?? this.notes,
      authMethod: authMethod ?? this.authMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      staffUser: staffUser ?? this.staffUser,
      breakRecords: breakRecords ?? this.breakRecords,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AttendanceRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AttendanceRecord(id: $id, staffUserId: $staffUserId, storeId: $storeId, clockInAt: $clockInAt, clockOutAt: $clockOutAt, breakMinutes: $breakMinutes, ...)';
}
