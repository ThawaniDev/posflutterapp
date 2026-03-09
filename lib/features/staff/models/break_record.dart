class BreakRecord {
  final String id;
  final String attendanceRecordId;
  final DateTime breakStart;
  final DateTime? breakEnd;

  const BreakRecord({
    required this.id,
    required this.attendanceRecordId,
    required this.breakStart,
    this.breakEnd,
  });

  factory BreakRecord.fromJson(Map<String, dynamic> json) {
    return BreakRecord(
      id: json['id'] as String,
      attendanceRecordId: json['attendance_record_id'] as String,
      breakStart: DateTime.parse(json['break_start'] as String),
      breakEnd: json['break_end'] != null ? DateTime.parse(json['break_end'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendance_record_id': attendanceRecordId,
      'break_start': breakStart.toIso8601String(),
      'break_end': breakEnd?.toIso8601String(),
    };
  }

  BreakRecord copyWith({
    String? id,
    String? attendanceRecordId,
    DateTime? breakStart,
    DateTime? breakEnd,
  }) {
    return BreakRecord(
      id: id ?? this.id,
      attendanceRecordId: attendanceRecordId ?? this.attendanceRecordId,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BreakRecord(id: $id, attendanceRecordId: $attendanceRecordId, breakStart: $breakStart, breakEnd: $breakEnd)';
}
