import 'package:wameedpos/features/inventory/enums/stock_transfer_status.dart';

class StockTransfer {

  const StockTransfer({
    required this.id,
    required this.organizationId,
    required this.fromStoreId,
    required this.toStoreId,
    this.fromStoreName,
    this.toStoreName,
    this.status,
    this.referenceNumber,
    this.notes,
    required this.createdBy,
    this.approvedBy,
    this.receivedBy,
    this.createdAt,
    this.approvedAt,
    this.receivedAt,
  });

  factory StockTransfer.fromJson(Map<String, dynamic> json) {
    return StockTransfer(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      fromStoreId: json['from_store_id'] as String,
      toStoreId: json['to_store_id'] as String,
      fromStoreName: (json['from_store'] as Map<String, dynamic>?)?['name'] as String?,
      toStoreName: (json['to_store'] as Map<String, dynamic>?)?['name'] as String?,
      status: StockTransferStatus.tryFromValue(json['status'] as String?),
      referenceNumber: json['reference_number'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      approvedBy: json['approved_by'] as String?,
      receivedBy: json['received_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at'] as String) : null,
      receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at'] as String) : null,
    );
  }
  final String id;
  final String organizationId;
  final String fromStoreId;
  final String toStoreId;
  final String? fromStoreName;
  final String? toStoreName;
  final StockTransferStatus? status;
  final String? referenceNumber;
  final String? notes;
  final String createdBy;
  final String? approvedBy;
  final String? receivedBy;
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final DateTime? receivedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'from_store_id': fromStoreId,
      'to_store_id': toStoreId,
      'status': status?.value,
      'reference_number': referenceNumber,
      'notes': notes,
      'created_by': createdBy,
      'approved_by': approvedBy,
      'received_by': receivedBy,
      'created_at': createdAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'received_at': receivedAt?.toIso8601String(),
    };
  }

  StockTransfer copyWith({
    String? id,
    String? organizationId,
    String? fromStoreId,
    String? toStoreId,
    String? fromStoreName,
    String? toStoreName,
    StockTransferStatus? status,
    String? referenceNumber,
    String? notes,
    String? createdBy,
    String? approvedBy,
    String? receivedBy,
    DateTime? createdAt,
    DateTime? approvedAt,
    DateTime? receivedAt,
  }) {
    return StockTransfer(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      fromStoreId: fromStoreId ?? this.fromStoreId,
      toStoreId: toStoreId ?? this.toStoreId,
      fromStoreName: fromStoreName ?? this.fromStoreName,
      toStoreName: toStoreName ?? this.toStoreName,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      approvedBy: approvedBy ?? this.approvedBy,
      receivedBy: receivedBy ?? this.receivedBy,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StockTransfer && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockTransfer(id: $id, organizationId: $organizationId, fromStoreId: $fromStoreId, toStoreId: $toStoreId, status: $status, referenceNumber: $referenceNumber, ...)';
}
