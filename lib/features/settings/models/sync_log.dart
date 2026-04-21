import 'package:wameedpos/features/settings/enums/sync_direction.dart';
import 'package:wameedpos/features/settings/enums/sync_log_status.dart';

class SyncLog {

  const SyncLog({
    required this.id,
    required this.storeId,
    required this.terminalId,
    required this.direction,
    required this.recordsCount,
    required this.durationMs,
    required this.status,
    this.errorMessage,
    required this.startedAt,
    this.completedAt,
  });

  factory SyncLog.fromJson(Map<String, dynamic> json) {
    return SyncLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      direction: SyncDirection.fromValue(json['direction'] as String),
      recordsCount: (json['records_count'] as num).toInt(),
      durationMs: (json['duration_ms'] as num).toInt(),
      status: SyncLogStatus.fromValue(json['status'] as String),
      errorMessage: json['error_message'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String terminalId;
  final SyncDirection direction;
  final int recordsCount;
  final int durationMs;
  final SyncLogStatus status;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'direction': direction.value,
      'records_count': recordsCount,
      'duration_ms': durationMs,
      'status': status.value,
      'error_message': errorMessage,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  SyncLog copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    SyncDirection? direction,
    int? recordsCount,
    int? durationMs,
    SyncLogStatus? status,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return SyncLog(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      direction: direction ?? this.direction,
      recordsCount: recordsCount ?? this.recordsCount,
      durationMs: durationMs ?? this.durationMs,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SyncLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SyncLog(id: $id, storeId: $storeId, terminalId: $terminalId, direction: $direction, recordsCount: $recordsCount, durationMs: $durationMs, ...)';
}
