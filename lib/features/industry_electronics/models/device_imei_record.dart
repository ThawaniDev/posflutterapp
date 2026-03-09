import 'package:thawani_pos/features/customers/enums/condition_grade.dart';
import 'package:thawani_pos/features/industry_electronics/enums/device_imei_status.dart';

class DeviceImeiRecord {
  final String id;
  final String productId;
  final String storeId;
  final String imei;
  final String? imei2;
  final String? serialNumber;
  final ConditionGrade? conditionGrade;
  final double? purchasePrice;
  final DeviceImeiStatus? status;
  final DateTime? warrantyEndDate;
  final DateTime? storeWarrantyEndDate;
  final String? soldOrderId;
  final DateTime? createdAt;

  const DeviceImeiRecord({
    required this.id,
    required this.productId,
    required this.storeId,
    required this.imei,
    this.imei2,
    this.serialNumber,
    this.conditionGrade,
    this.purchasePrice,
    this.status,
    this.warrantyEndDate,
    this.storeWarrantyEndDate,
    this.soldOrderId,
    this.createdAt,
  });

  factory DeviceImeiRecord.fromJson(Map<String, dynamic> json) {
    return DeviceImeiRecord(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      storeId: json['store_id'] as String,
      imei: json['imei'] as String,
      imei2: json['imei2'] as String?,
      serialNumber: json['serial_number'] as String?,
      conditionGrade: ConditionGrade.tryFromValue(json['condition_grade'] as String?),
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      status: DeviceImeiStatus.tryFromValue(json['status'] as String?),
      warrantyEndDate: json['warranty_end_date'] != null ? DateTime.parse(json['warranty_end_date'] as String) : null,
      storeWarrantyEndDate: json['store_warranty_end_date'] != null ? DateTime.parse(json['store_warranty_end_date'] as String) : null,
      soldOrderId: json['sold_order_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'store_id': storeId,
      'imei': imei,
      'imei2': imei2,
      'serial_number': serialNumber,
      'condition_grade': conditionGrade?.value,
      'purchase_price': purchasePrice,
      'status': status?.value,
      'warranty_end_date': warrantyEndDate?.toIso8601String(),
      'store_warranty_end_date': storeWarrantyEndDate?.toIso8601String(),
      'sold_order_id': soldOrderId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  DeviceImeiRecord copyWith({
    String? id,
    String? productId,
    String? storeId,
    String? imei,
    String? imei2,
    String? serialNumber,
    ConditionGrade? conditionGrade,
    double? purchasePrice,
    DeviceImeiStatus? status,
    DateTime? warrantyEndDate,
    DateTime? storeWarrantyEndDate,
    String? soldOrderId,
    DateTime? createdAt,
  }) {
    return DeviceImeiRecord(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      imei: imei ?? this.imei,
      imei2: imei2 ?? this.imei2,
      serialNumber: serialNumber ?? this.serialNumber,
      conditionGrade: conditionGrade ?? this.conditionGrade,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      status: status ?? this.status,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      storeWarrantyEndDate: storeWarrantyEndDate ?? this.storeWarrantyEndDate,
      soldOrderId: soldOrderId ?? this.soldOrderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceImeiRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeviceImeiRecord(id: $id, productId: $productId, storeId: $storeId, imei: $imei, imei2: $imei2, serialNumber: $serialNumber, ...)';
}
