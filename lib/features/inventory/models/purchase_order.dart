import 'package:thawani_pos/features/inventory/enums/purchase_order_status.dart';

class PurchaseOrder {
  final String id;
  final String organizationId;
  final String storeId;
  final String supplierId;
  final String? referenceNumber;
  final PurchaseOrderStatus? status;
  final DateTime? expectedDate;
  final double? totalCost;
  final String? notes;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseOrder({
    required this.id,
    required this.organizationId,
    required this.storeId,
    required this.supplierId,
    this.referenceNumber,
    this.status,
    this.expectedDate,
    this.totalCost,
    this.notes,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String,
      supplierId: json['supplier_id'] as String,
      referenceNumber: json['reference_number'] as String?,
      status: PurchaseOrderStatus.tryFromValue(json['status'] as String?),
      expectedDate: json['expected_date'] != null ? DateTime.parse(json['expected_date'] as String) : null,
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
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
      'expected_date': expectedDate?.toIso8601String(),
      'total_cost': totalCost,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PurchaseOrder copyWith({
    String? id,
    String? organizationId,
    String? storeId,
    String? supplierId,
    String? referenceNumber,
    PurchaseOrderStatus? status,
    DateTime? expectedDate,
    double? totalCost,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      storeId: storeId ?? this.storeId,
      supplierId: supplierId ?? this.supplierId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      expectedDate: expectedDate ?? this.expectedDate,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrder && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PurchaseOrder(id: $id, organizationId: $organizationId, storeId: $storeId, supplierId: $supplierId, referenceNumber: $referenceNumber, status: $status, ...)';
}
