import 'package:wameedpos/features/sync/enums/sync_direction.dart';
import 'package:wameedpos/features/sync/enums/sync_log_status.dart';

class SyncLog {
  final String id;
  final String storeId;
  final String terminalId;
  final SyncDirection direction;
  final int recordsCount;
  final int durationMs;
  final SyncLogStatus status;
  final String? errorMessage;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const SyncLog({
    required this.id,
    required this.storeId,
    required this.terminalId,
    required this.direction,
    required this.recordsCount,
    required this.durationMs,
    required this.status,
    this.errorMessage,
    this.startedAt,
    this.completedAt,
  });

  factory SyncLog.fromJson(Map<String, dynamic> json) {
    return SyncLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      direction: SyncDirection.fromValue(json['direction'] as String),
      recordsCount: json['records_count'] as int,
      durationMs: json['duration_ms'] as int,
      status: SyncLogStatus.fromValue(json['status'] as String),
      errorMessage: json['error_message'] as String?,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

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
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
