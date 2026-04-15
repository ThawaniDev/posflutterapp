import 'package:wameedpos/features/hardware/enums/hardware_sale_item_type.dart';

class HardwareSale {
  final String id;
  final String storeId;
  final String soldBy;
  final HardwareSaleItemType itemType;
  final String? itemDescription;
  final String? serialNumber;
  final double amount;
  final String? notes;
  final DateTime? soldAt;

  const HardwareSale({
    required this.id,
    required this.storeId,
    required this.soldBy,
    required this.itemType,
    this.itemDescription,
    this.serialNumber,
    required this.amount,
    this.notes,
    this.soldAt,
  });

  factory HardwareSale.fromJson(Map<String, dynamic> json) {
    return HardwareSale(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      soldBy: json['sold_by'] as String,
      itemType: HardwareSaleItemType.fromValue(json['item_type'] as String),
      itemDescription: json['item_description'] as String?,
      serialNumber: json['serial_number'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      notes: json['notes'] as String?,
      soldAt: json['sold_at'] != null ? DateTime.parse(json['sold_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'sold_by': soldBy,
      'item_type': itemType.value,
      'item_description': itemDescription,
      'serial_number': serialNumber,
      'amount': amount,
      'notes': notes,
      'sold_at': soldAt?.toIso8601String(),
    };
  }

  HardwareSale copyWith({
    String? id,
    String? storeId,
    String? soldBy,
    HardwareSaleItemType? itemType,
    String? itemDescription,
    String? serialNumber,
    double? amount,
    String? notes,
    DateTime? soldAt,
  }) {
    return HardwareSale(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      soldBy: soldBy ?? this.soldBy,
      itemType: itemType ?? this.itemType,
      itemDescription: itemDescription ?? this.itemDescription,
      serialNumber: serialNumber ?? this.serialNumber,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      soldAt: soldAt ?? this.soldAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HardwareSale && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'HardwareSale(id: $id, storeId: $storeId, soldBy: $soldBy, itemType: $itemType, itemDescription: $itemDescription, serialNumber: $serialNumber, ...)';
}
