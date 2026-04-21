import 'package:wameedpos/features/industry_jewelry/enums/making_charges_type.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';

class JewelryProductDetail {

  const JewelryProductDetail({
    required this.id,
    required this.productId,
    required this.metalType,
    this.karat,
    required this.grossWeightG,
    required this.netWeightG,
    this.makingChargesType,
    required this.makingChargesValue,
    this.stoneType,
    this.stoneWeightCarat,
    this.stoneCount,
    this.certificateNumber,
    this.certificateUrl,
  });

  factory JewelryProductDetail.fromJson(Map<String, dynamic> json) {
    return JewelryProductDetail(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      metalType: MetalType.fromValue(json['metal_type'] as String),
      karat: json['karat'] as String?,
      grossWeightG: double.tryParse(json['gross_weight_g'].toString()) ?? 0.0,
      netWeightG: double.tryParse(json['net_weight_g'].toString()) ?? 0.0,
      makingChargesType: MakingChargesType.tryFromValue(json['making_charges_type'] as String?),
      makingChargesValue: double.tryParse(json['making_charges_value'].toString()) ?? 0.0,
      stoneType: json['stone_type'] as String?,
      stoneWeightCarat: (json['stone_weight_carat'] != null ? double.tryParse(json['stone_weight_carat'].toString()) : null),
      stoneCount: (json['stone_count'] as num?)?.toInt(),
      certificateNumber: json['certificate_number'] as String?,
      certificateUrl: json['certificate_url'] as String?,
    );
  }
  final String id;
  final String productId;
  final MetalType metalType;
  final String? karat;
  final double grossWeightG;
  final double netWeightG;
  final MakingChargesType? makingChargesType;
  final double makingChargesValue;
  final String? stoneType;
  final double? stoneWeightCarat;
  final int? stoneCount;
  final String? certificateNumber;
  final String? certificateUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'metal_type': metalType.value,
      'karat': karat,
      'gross_weight_g': grossWeightG,
      'net_weight_g': netWeightG,
      'making_charges_type': makingChargesType?.value,
      'making_charges_value': makingChargesValue,
      'stone_type': stoneType,
      'stone_weight_carat': stoneWeightCarat,
      'stone_count': stoneCount,
      'certificate_number': certificateNumber,
      'certificate_url': certificateUrl,
    };
  }

  JewelryProductDetail copyWith({
    String? id,
    String? productId,
    MetalType? metalType,
    String? karat,
    double? grossWeightG,
    double? netWeightG,
    MakingChargesType? makingChargesType,
    double? makingChargesValue,
    String? stoneType,
    double? stoneWeightCarat,
    int? stoneCount,
    String? certificateNumber,
    String? certificateUrl,
  }) {
    return JewelryProductDetail(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      metalType: metalType ?? this.metalType,
      karat: karat ?? this.karat,
      grossWeightG: grossWeightG ?? this.grossWeightG,
      netWeightG: netWeightG ?? this.netWeightG,
      makingChargesType: makingChargesType ?? this.makingChargesType,
      makingChargesValue: makingChargesValue ?? this.makingChargesValue,
      stoneType: stoneType ?? this.stoneType,
      stoneWeightCarat: stoneWeightCarat ?? this.stoneWeightCarat,
      stoneCount: stoneCount ?? this.stoneCount,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      certificateUrl: certificateUrl ?? this.certificateUrl,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JewelryProductDetail && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'JewelryProductDetail(id: $id, productId: $productId, metalType: $metalType, karat: $karat, grossWeightG: $grossWeightG, netWeightG: $netWeightG, ...)';
}
