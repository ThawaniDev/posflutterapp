import 'package:wameedpos/features/inventory/enums/goods_receipt_status.dart';

class GoodsReceipt {

  const GoodsReceipt({
    required this.id,
    required this.storeId,
    this.supplierId,
    this.supplierName,
    this.purchaseOrderId,
    this.referenceNumber,
    this.status,
    this.totalCost,
    this.notes,
    required this.receivedBy,
    this.receivedAt,
    this.confirmedAt,
  });

  factory GoodsReceipt.fromJson(Map<String, dynamic> json) {
    return GoodsReceipt(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      supplierId: json['supplier_id'] as String?,
      supplierName: (json['supplier'] as Map<String, dynamic>?)?['name'] as String?,
      purchaseOrderId: json['purchase_order_id'] as String?,
      referenceNumber: json['reference_number'] as String?,
      status: GoodsReceiptStatus.tryFromValue(json['status'] as String?),
      totalCost: (json['total_cost'] != null ? double.tryParse(json['total_cost'].toString()) : null),
      notes: json['notes'] as String?,
      receivedBy: json['received_by'] as String,
      receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at'] as String) : null,
      confirmedAt: json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? supplierId;
  final String? supplierName;
  final String? purchaseOrderId;
  final String? referenceNumber;
  final GoodsReceiptStatus? status;
  final double? totalCost;
  final String? notes;
  final String receivedBy;
  final DateTime? receivedAt;
  final DateTime? confirmedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'supplier_id': supplierId,
      'purchase_order_id': purchaseOrderId,
      'reference_number': referenceNumber,
      'status': status?.value,
      'total_cost': totalCost,
      'notes': notes,
      'received_by': receivedBy,
      'received_at': receivedAt?.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
    };
  }

  GoodsReceipt copyWith({
    String? id,
    String? storeId,
    String? supplierId,
    String? supplierName,
    String? purchaseOrderId,
    String? referenceNumber,
    GoodsReceiptStatus? status,
    double? totalCost,
    String? notes,
    String? receivedBy,
    DateTime? receivedAt,
    DateTime? confirmedAt,
  }) {
    return GoodsReceipt(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      receivedBy: receivedBy ?? this.receivedBy,
      receivedAt: receivedAt ?? this.receivedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GoodsReceipt && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GoodsReceipt(id: $id, storeId: $storeId, supplierId: $supplierId, purchaseOrderId: $purchaseOrderId, referenceNumber: $referenceNumber, status: $status, ...)';
}
