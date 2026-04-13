import 'package:thawani_pos/features/inventory/enums/stock_adjustment_type.dart';

class StockAdjustment {
  final String id;
  final String storeId;
  final StockAdjustmentType? type;
  final String? reasonCode;
  final String? notes;
  final String? adjustedBy;
  final DateTime? createdAt;

  const StockAdjustment({
    required this.id,
    required this.storeId,
    this.type,
    this.reasonCode,
    this.notes,
    this.adjustedBy,
    this.createdAt,
  });

  factory StockAdjustment.fromJson(Map<String, dynamic> json) {
    return StockAdjustment(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      type: json['type'] != null ? StockAdjustmentType.fromValue(json['type'] as String) : null,
      reasonCode: json['reason_code'] as String?,
      notes: json['notes'] as String?,
      adjustedBy: json['adjusted_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'type': type?.value,
      'reason_code': reasonCode,
      'notes': notes,
      'adjusted_by': adjustedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StockAdjustment copyWith({
    String? id,
    String? storeId,
    StockAdjustmentType? type,
    String? reasonCode,
    String? notes,
    String? adjustedBy,
    DateTime? createdAt,
  }) {
    return StockAdjustment(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      type: type ?? this.type,
      reasonCode: reasonCode ?? this.reasonCode,
      notes: notes ?? this.notes,
      adjustedBy: adjustedBy ?? this.adjustedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StockAdjustment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockAdjustment(id: $id, storeId: $storeId, type: $type, reasonCode: $reasonCode, notes: $notes, adjustedBy: $adjustedBy, ...)';
}
