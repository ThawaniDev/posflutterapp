import 'package:thawani_pos/features/reports/enums/store_health_sync_status.dart';

class StoreHealthSnapshot {
  final String id;
  final String storeId;
  final DateTime date;
  final StoreHealthSyncStatus? syncStatus;
  final bool? zatcaCompliance;
  final int? errorCount;
  final DateTime? lastActivityAt;

  const StoreHealthSnapshot({
    required this.id,
    required this.storeId,
    required this.date,
    this.syncStatus,
    this.zatcaCompliance,
    this.errorCount,
    this.lastActivityAt,
  });

  factory StoreHealthSnapshot.fromJson(Map<String, dynamic> json) {
    return StoreHealthSnapshot(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      date: DateTime.parse(json['date'] as String),
      syncStatus: StoreHealthSyncStatus.tryFromValue(json['sync_status'] as String?),
      zatcaCompliance: json['zatca_compliance'] as bool?,
      errorCount: (json['error_count'] as num?)?.toInt(),
      lastActivityAt: json['last_activity_at'] != null ? DateTime.parse(json['last_activity_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'date': date.toIso8601String(),
      'sync_status': syncStatus?.value,
      'zatca_compliance': zatcaCompliance,
      'error_count': errorCount,
      'last_activity_at': lastActivityAt?.toIso8601String(),
    };
  }

  StoreHealthSnapshot copyWith({
    String? id,
    String? storeId,
    DateTime? date,
    StoreHealthSyncStatus? syncStatus,
    bool? zatcaCompliance,
    int? errorCount,
    DateTime? lastActivityAt,
  }) {
    return StoreHealthSnapshot(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      date: date ?? this.date,
      syncStatus: syncStatus ?? this.syncStatus,
      zatcaCompliance: zatcaCompliance ?? this.zatcaCompliance,
      errorCount: errorCount ?? this.errorCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreHealthSnapshot && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StoreHealthSnapshot(id: $id, storeId: $storeId, date: $date, syncStatus: $syncStatus, zatcaCompliance: $zatcaCompliance, errorCount: $errorCount, ...)';
}
