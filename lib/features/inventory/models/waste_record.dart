import 'package:wameedpos/features/inventory/enums/waste_reason.dart';

class WasteRecord {
  const WasteRecord({
    required this.id,
    required this.storeId,
    required this.productId,
    this.productName,
    required this.quantity,
    this.unitCost,
    this.totalCost,
    this.reason,
    this.batchNumber,
    this.notes,
    this.recordedBy,
    this.createdAt,
  });

  factory WasteRecord.fromJson(Map<String, dynamic> json) {
    return WasteRecord(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: json['unit_cost'] != null ? double.tryParse(json['unit_cost'].toString()) : null,
      totalCost: json['total_cost'] != null ? double.tryParse(json['total_cost'].toString()) : null,
      reason: json['reason'] != null ? WasteReason.tryFromValue(json['reason'] as String) : null,
      batchNumber: json['batch_number'] as String?,
      notes: json['notes'] as String?,
      recordedBy: json['recorded_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  final String id;
  final String storeId;
  final String productId;
  final String? productName;
  final double quantity;
  final double? unitCost;
  final double? totalCost;
  final WasteReason? reason;
  final String? batchNumber;
  final String? notes;
  final String? recordedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'product_id': productId,
    'quantity': quantity,
    'unit_cost': unitCost,
    'total_cost': totalCost,
    'reason': reason?.value,
    'batch_number': batchNumber,
    'notes': notes,
    'recorded_by': recordedBy,
    'created_at': createdAt?.toIso8601String(),
  };

  WasteRecord copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? productName,
    double? quantity,
    double? unitCost,
    double? totalCost,
    WasteReason? reason,
    String? batchNumber,
    String? notes,
    String? recordedBy,
    DateTime? createdAt,
  }) {
    return WasteRecord(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      reason: reason ?? this.reason,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is WasteRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WasteRecord(id: $id, storeId: $storeId, productId: $productId, quantity: $quantity, reason: $reason)';
}
