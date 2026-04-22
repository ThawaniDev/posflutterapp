import 'package:wameedpos/features/inventory/enums/stock_movement_type.dart';
import 'package:wameedpos/features/inventory/enums/stock_reference_type.dart';

class StockMovement {
  const StockMovement({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.type,
    required this.quantity,
    this.unitCost,
    this.referenceType,
    this.referenceId,
    this.reason,
    this.performedBy,
    this.createdAt,
    this.productName,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      type: StockMovementType.fromValue(json['type'] as String),
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: (json['unit_cost'] != null ? double.tryParse(json['unit_cost'].toString()) : null),
      referenceType: StockReferenceType.tryFromValue(json['reference_type'] as String?),
      referenceId: json['reference_id'] as String?,
      reason: json['reason'] as String?,
      performedBy: json['performed_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String productId;
  final StockMovementType type;
  final double quantity;
  final double? unitCost;
  final StockReferenceType? referenceType;
  final String? referenceId;
  final String? reason;
  final String? performedBy;
  final DateTime? createdAt;
  final String? productName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'type': type.value,
      'quantity': quantity,
      'unit_cost': unitCost,
      'reference_type': referenceType?.value,
      'reference_id': referenceId,
      'reason': reason,
      'performed_by': performedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StockMovement copyWith({
    String? id,
    String? storeId,
    String? productId,
    StockMovementType? type,
    double? quantity,
    double? unitCost,
    StockReferenceType? referenceType,
    String? referenceId,
    String? reason,
    String? performedBy,
    DateTime? createdAt,
  }) {
    return StockMovement(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      reason: reason ?? this.reason,
      performedBy: performedBy ?? this.performedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StockMovement && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockMovement(id: $id, storeId: $storeId, productId: $productId, type: $type, quantity: $quantity, unitCost: $unitCost, ...)';
}
