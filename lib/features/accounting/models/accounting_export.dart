import 'package:wameedpos/features/accounting/enums/accounting_export_status.dart';
import 'package:wameedpos/features/accounting/enums/export_triggered_by.dart';

class AccountingExport {
  final String id;
  final String storeId;
  final String provider;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> exportTypes;
  final AccountingExportStatus status;
  final int? entriesCount;
  final String? errorMessage;
  final Map<String, dynamic>? journalEntryIds;
  final String? csvUrl;
  final ExportTriggeredBy triggeredBy;
  final DateTime? createdAt;
  final DateTime? completedAt;

  const AccountingExport({
    required this.id,
    required this.storeId,
    required this.provider,
    required this.startDate,
    required this.endDate,
    required this.exportTypes,
    required this.status,
    this.entriesCount,
    this.errorMessage,
    this.journalEntryIds,
    this.csvUrl,
    required this.triggeredBy,
    this.createdAt,
    this.completedAt,
  });

  factory AccountingExport.fromJson(Map<String, dynamic> json) {
    return AccountingExport(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      provider: json['provider'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      exportTypes: Map<String, dynamic>.from(json['export_types'] as Map),
      status: AccountingExportStatus.fromValue(json['status'] as String),
      entriesCount: (json['entries_count'] as num?)?.toInt(),
      errorMessage: json['error_message'] as String?,
      journalEntryIds: json['journal_entry_ids'] != null ? Map<String, dynamic>.from(json['journal_entry_ids'] as Map) : null,
      csvUrl: json['csv_url'] as String?,
      triggeredBy: ExportTriggeredBy.fromValue(json['triggered_by'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'provider': provider,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'export_types': exportTypes,
      'status': status.value,
      'entries_count': entriesCount,
      'error_message': errorMessage,
      'journal_entry_ids': journalEntryIds,
      'csv_url': csvUrl,
      'triggered_by': triggeredBy.value,
      'created_at': createdAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  AccountingExport copyWith({
    String? id,
    String? storeId,
    String? provider,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? exportTypes,
    AccountingExportStatus? status,
    int? entriesCount,
    String? errorMessage,
    Map<String, dynamic>? journalEntryIds,
    String? csvUrl,
    ExportTriggeredBy? triggeredBy,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return AccountingExport(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      provider: provider ?? this.provider,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      exportTypes: exportTypes ?? this.exportTypes,
      status: status ?? this.status,
      entriesCount: entriesCount ?? this.entriesCount,
      errorMessage: errorMessage ?? this.errorMessage,
      journalEntryIds: journalEntryIds ?? this.journalEntryIds,
      csvUrl: csvUrl ?? this.csvUrl,
      triggeredBy: triggeredBy ?? this.triggeredBy,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountingExport && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AccountingExport(id: $id, storeId: $storeId, provider: $provider, startDate: $startDate, endDate: $endDate, exportTypes: $exportTypes, ...)';
}
