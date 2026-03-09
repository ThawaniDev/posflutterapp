import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryOrderMapping {
  final String id;
  final String orderId;
  final DeliveryConfigPlatform platform;
  final String externalOrderId;
  final String? externalStatus;
  final double? commissionAmount;
  final double? commissionPercent;
  final Map<String, dynamic>? rawPayload;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryOrderMapping({
    required this.id,
    required this.orderId,
    required this.platform,
    required this.externalOrderId,
    this.externalStatus,
    this.commissionAmount,
    this.commissionPercent,
    this.rawPayload,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryOrderMapping.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderMapping(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      platform: DeliveryConfigPlatform.fromValue(json['platform'] as String),
      externalOrderId: json['external_order_id'] as String,
      externalStatus: json['external_status'] as String?,
      commissionAmount: (json['commission_amount'] as num?)?.toDouble(),
      commissionPercent: (json['commission_percent'] as num?)?.toDouble(),
      rawPayload: json['raw_payload'] != null ? Map<String, dynamic>.from(json['raw_payload'] as Map) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'platform': platform.value,
      'external_order_id': externalOrderId,
      'external_status': externalStatus,
      'commission_amount': commissionAmount,
      'commission_percent': commissionPercent,
      'raw_payload': rawPayload,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DeliveryOrderMapping copyWith({
    String? id,
    String? orderId,
    DeliveryConfigPlatform? platform,
    String? externalOrderId,
    String? externalStatus,
    double? commissionAmount,
    double? commissionPercent,
    Map<String, dynamic>? rawPayload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryOrderMapping(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      platform: platform ?? this.platform,
      externalOrderId: externalOrderId ?? this.externalOrderId,
      externalStatus: externalStatus ?? this.externalStatus,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      commissionPercent: commissionPercent ?? this.commissionPercent,
      rawPayload: rawPayload ?? this.rawPayload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryOrderMapping && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryOrderMapping(id: $id, orderId: $orderId, platform: $platform, externalOrderId: $externalOrderId, externalStatus: $externalStatus, commissionAmount: $commissionAmount, ...)';
}
