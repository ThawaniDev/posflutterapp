class TradeInRecord {
  final String id;
  final String storeId;
  final String? customerId;
  final String deviceDescription;
  final String? imei;
  final String conditionGrade;
  final double assessedValue;
  final String? appliedToOrderId;
  final String staffUserId;
  final DateTime? createdAt;

  const TradeInRecord({
    required this.id,
    required this.storeId,
    this.customerId,
    required this.deviceDescription,
    this.imei,
    required this.conditionGrade,
    required this.assessedValue,
    this.appliedToOrderId,
    required this.staffUserId,
    this.createdAt,
  });

  factory TradeInRecord.fromJson(Map<String, dynamic> json) {
    return TradeInRecord(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      deviceDescription: json['device_description'] as String,
      imei: json['imei'] as String?,
      conditionGrade: json['condition_grade'] as String,
      assessedValue: (json['assessed_value'] as num).toDouble(),
      appliedToOrderId: json['applied_to_order_id'] as String?,
      staffUserId: json['staff_user_id'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'device_description': deviceDescription,
      'imei': imei,
      'condition_grade': conditionGrade,
      'assessed_value': assessedValue,
      'applied_to_order_id': appliedToOrderId,
      'staff_user_id': staffUserId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TradeInRecord copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? deviceDescription,
    String? imei,
    String? conditionGrade,
    double? assessedValue,
    String? appliedToOrderId,
    String? staffUserId,
    DateTime? createdAt,
  }) {
    return TradeInRecord(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      deviceDescription: deviceDescription ?? this.deviceDescription,
      imei: imei ?? this.imei,
      conditionGrade: conditionGrade ?? this.conditionGrade,
      assessedValue: assessedValue ?? this.assessedValue,
      appliedToOrderId: appliedToOrderId ?? this.appliedToOrderId,
      staffUserId: staffUserId ?? this.staffUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeInRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TradeInRecord(id: $id, storeId: $storeId, customerId: $customerId, deviceDescription: $deviceDescription, imei: $imei, conditionGrade: $conditionGrade, ...)';
}
