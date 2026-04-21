import 'package:wameedpos/features/accounting/enums/export_frequency.dart';

class AutoExportConfig {

  const AutoExportConfig({
    required this.id,
    required this.storeId,
    this.enabled,
    required this.frequency,
    this.dayOfWeek,
    this.dayOfMonth,
    required this.exportTypes,
    this.notifyEmail,
    this.retryOnFailure,
    this.lastRunAt,
    this.nextRunAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AutoExportConfig.fromJson(Map<String, dynamic> json) {
    return AutoExportConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      enabled: json['enabled'] as bool?,
      frequency: ExportFrequency.fromValue(json['frequency'] as String),
      dayOfWeek: (json['day_of_week'] as num?)?.toInt(),
      dayOfMonth: (json['day_of_month'] as num?)?.toInt(),
      exportTypes: Map<String, dynamic>.from(json['export_types'] as Map),
      notifyEmail: json['notify_email'] as String?,
      retryOnFailure: json['retry_on_failure'] as bool?,
      lastRunAt: json['last_run_at'] != null ? DateTime.parse(json['last_run_at'] as String) : null,
      nextRunAt: json['next_run_at'] != null ? DateTime.parse(json['next_run_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final bool? enabled;
  final ExportFrequency frequency;
  final int? dayOfWeek;
  final int? dayOfMonth;
  final Map<String, dynamic> exportTypes;
  final String? notifyEmail;
  final bool? retryOnFailure;
  final DateTime? lastRunAt;
  final DateTime? nextRunAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'enabled': enabled,
      'frequency': frequency.value,
      'day_of_week': dayOfWeek,
      'day_of_month': dayOfMonth,
      'export_types': exportTypes,
      'notify_email': notifyEmail,
      'retry_on_failure': retryOnFailure,
      'last_run_at': lastRunAt?.toIso8601String(),
      'next_run_at': nextRunAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AutoExportConfig copyWith({
    String? id,
    String? storeId,
    bool? enabled,
    ExportFrequency? frequency,
    int? dayOfWeek,
    int? dayOfMonth,
    Map<String, dynamic>? exportTypes,
    String? notifyEmail,
    bool? retryOnFailure,
    DateTime? lastRunAt,
    DateTime? nextRunAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AutoExportConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      enabled: enabled ?? this.enabled,
      frequency: frequency ?? this.frequency,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      exportTypes: exportTypes ?? this.exportTypes,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      retryOnFailure: retryOnFailure ?? this.retryOnFailure,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AutoExportConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AutoExportConfig(id: $id, storeId: $storeId, enabled: $enabled, frequency: $frequency, dayOfWeek: $dayOfWeek, dayOfMonth: $dayOfMonth, ...)';
}
