import 'package:thawani_pos/features/auth/enums/auth_method.dart';

class AttendanceRecord {
  final String id;
  final String staffUserId;
  final String storeId;
  final DateTime clockInAt;
  final DateTime? clockOutAt;
  final int? breakMinutes;
  final String? scheduledShiftId;
  final int? overtimeMinutes;
  final String? notes;
  final AuthMethod authMethod;
  final DateTime? createdAt;

  const AttendanceRecord({
    required this.id,
    required this.staffUserId,
    required this.storeId,
    required this.clockInAt,
    this.clockOutAt,
    this.breakMinutes,
    this.scheduledShiftId,
    this.overtimeMinutes,
    this.notes,
    required this.authMethod,
    this.createdAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      storeId: json['store_id'] as String,
      clockInAt: DateTime.parse(json['clock_in_at'] as String),
      clockOutAt: json['clock_out_at'] != null ? DateTime.parse(json['clock_out_at'] as String) : null,
      breakMinutes: (json['break_minutes'] as num?)?.toInt(),
      scheduledShiftId: json['scheduled_shift_id'] as String?,
      overtimeMinutes: (json['overtime_minutes'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      authMethod: AuthMethod.fromValue(json['auth_method'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'store_id': storeId,
      'clock_in_at': clockInAt.toIso8601String(),
      'clock_out_at': clockOutAt?.toIso8601String(),
      'break_minutes': breakMinutes,
      'scheduled_shift_id': scheduledShiftId,
      'overtime_minutes': overtimeMinutes,
      'notes': notes,
      'auth_method': authMethod.value,
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
    String? scheduledShiftId,
    int? overtimeMinutes,
    String? notes,
    AuthMethod? authMethod,
    DateTime? createdAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      storeId: storeId ?? this.storeId,
      clockInAt: clockInAt ?? this.clockInAt,
      clockOutAt: clockOutAt ?? this.clockOutAt,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      scheduledShiftId: scheduledShiftId ?? this.scheduledShiftId,
      overtimeMinutes: overtimeMinutes ?? this.overtimeMinutes,
      notes: notes ?? this.notes,
      authMethod: authMethod ?? this.authMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AttendanceRecord(id: $id, staffUserId: $staffUserId, storeId: $storeId, clockInAt: $clockInAt, clockOutAt: $clockOutAt, breakMinutes: $breakMinutes, ...)';
}
