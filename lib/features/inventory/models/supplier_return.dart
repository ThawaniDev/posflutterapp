import 'package:thawani_pos/features/inventory/enums/supplier_return_status.dart';
import 'package:thawani_pos/features/inventory/models/supplier_return_item.dart';

class SupplierReturn {
  final String id;
  final String organizationId;
  final String storeId;
  final String supplierId;
  final String? supplierName;
  final String? referenceNumber;
  final SupplierReturnStatus? status;
  final String? reason;
  final double totalAmount;
  final String? notes;
  final String? createdBy;
  final String? createdByName;
  final String? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final DateTime? completedAt;
  final List<SupplierReturnItem>? items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupplierReturn({
    required this.id,
    required this.organizationId,
    required this.storeId,
    required this.supplierId,
    this.supplierName,
    this.referenceNumber,
    this.status,
    this.reason,
    this.totalAmount = 0,
    this.notes,
    this.createdBy,
    this.createdByName,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.completedAt,
    this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierReturn.fromJson(Map<String, dynamic> json) {
    final supplierMap = json['supplier'] as Map<String, dynamic>?;
    final createdByMap = json['created_by_user'] as Map<String, dynamic>?;
    final approvedByMap = json['approved_by_user'] as Map<String, dynamic>?;
    final itemsList = json['items'] as List?;

    return SupplierReturn(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String,
      supplierId: json['supplier_id'] as String,
      supplierName: supplierMap?['name'] as String?,
      referenceNumber: json['reference_number'] as String?,
      status: SupplierReturnStatus.tryFromValue(json['status'] as String?),
      reason: json['reason'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdByName: createdByMap?['name'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedByName: approvedByMap?['name'] as String?,
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      items: itemsList?.map((j) => SupplierReturnItem.fromJson(j as Map<String, dynamic>)).toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'store_id': storeId,
      'supplier_id': supplierId,
      'reference_number': referenceNumber,
      'status': status?.value,
      'reason': reason,
      'total_amount': totalAmount,
      'notes': notes,
      'created_by': createdBy,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SupplierReturn copyWith({
    String? id,
    String? organizationId,
    String? storeId,
    String? supplierId,
    String? supplierName,
    String? referenceNumber,
    SupplierReturnStatus? status,
    String? reason,
    double? totalAmount,
    String? notes,
    String? createdBy,
    String? createdByName,
    String? approvedBy,
    String? approvedByName,
    DateTime? approvedAt,
    DateTime? completedAt,
    List<SupplierReturnItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierReturn(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      storeId: storeId ?? this.storeId,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedByName: approvedByName ?? this.approvedByName,
      approvedAt: approvedAt ?? this.approvedAt,
      completedAt: completedAt ?? this.completedAt,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SupplierReturn && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
