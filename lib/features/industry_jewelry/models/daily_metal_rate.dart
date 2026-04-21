import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';

class DailyMetalRate {

  const DailyMetalRate({
    required this.id,
    required this.storeId,
    required this.metalType,
    this.karat,
    required this.ratePerGram,
    this.buybackRatePerGram,
    required this.effectiveDate,
    this.createdAt,
  });

  factory DailyMetalRate.fromJson(Map<String, dynamic> json) {
    return DailyMetalRate(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      metalType: MetalType.fromValue(json['metal_type'] as String),
      karat: json['karat'] as String?,
      ratePerGram: double.tryParse(json['rate_per_gram'].toString()) ?? 0.0,
      buybackRatePerGram: (json['buyback_rate_per_gram'] != null
          ? double.tryParse(json['buyback_rate_per_gram'].toString())
          : null),
      effectiveDate: DateTime.parse(json['effective_date'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final MetalType metalType;
  final String? karat;
  final double ratePerGram;
  final double? buybackRatePerGram;
  final DateTime effectiveDate;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'metal_type': metalType.value,
      'karat': karat,
      'rate_per_gram': ratePerGram,
      'buyback_rate_per_gram': buybackRatePerGram,
      'effective_date': effectiveDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  DailyMetalRate copyWith({
    String? id,
    String? storeId,
    MetalType? metalType,
    String? karat,
    double? ratePerGram,
    double? buybackRatePerGram,
    DateTime? effectiveDate,
    DateTime? createdAt,
  }) {
    return DailyMetalRate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      metalType: metalType ?? this.metalType,
      karat: karat ?? this.karat,
      ratePerGram: ratePerGram ?? this.ratePerGram,
      buybackRatePerGram: buybackRatePerGram ?? this.buybackRatePerGram,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DailyMetalRate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DailyMetalRate(id: $id, storeId: $storeId, metalType: $metalType, karat: $karat, ratePerGram: $ratePerGram, buybackRatePerGram: $buybackRatePerGram, ...)';
}
