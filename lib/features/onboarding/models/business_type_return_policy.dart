class BusinessTypeReturnPolicy {
  final String id;
  final String businessTypeId;
  final int returnWindowDays;
  final Map<String, dynamic>? refundMethods;
  final bool? requireReceipt;
  final double? restockingFeePercentage;
  final int? voidGracePeriodMinutes;
  final bool? requireManagerApproval;
  final double? maxReturnWithoutApproval;
  final bool? returnReasonRequired;
  final bool? partialReturnAllowed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessTypeReturnPolicy({
    required this.id,
    required this.businessTypeId,
    required this.returnWindowDays,
    this.refundMethods,
    this.requireReceipt,
    this.restockingFeePercentage,
    this.voidGracePeriodMinutes,
    this.requireManagerApproval,
    this.maxReturnWithoutApproval,
    this.returnReasonRequired,
    this.partialReturnAllowed,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessTypeReturnPolicy.fromJson(Map<String, dynamic> json) {
    return BusinessTypeReturnPolicy(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      returnWindowDays: (json['return_window_days'] as num).toInt(),
      refundMethods: json['refund_methods'] != null ? Map<String, dynamic>.from(json['refund_methods'] as Map) : null,
      requireReceipt: json['require_receipt'] as bool?,
      restockingFeePercentage: (json['restocking_fee_percentage'] as num?)?.toDouble(),
      voidGracePeriodMinutes: (json['void_grace_period_minutes'] as num?)?.toInt(),
      requireManagerApproval: json['require_manager_approval'] as bool?,
      maxReturnWithoutApproval: (json['max_return_without_approval'] as num?)?.toDouble(),
      returnReasonRequired: json['return_reason_required'] as bool?,
      partialReturnAllowed: json['partial_return_allowed'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'return_window_days': returnWindowDays,
      'refund_methods': refundMethods,
      'require_receipt': requireReceipt,
      'restocking_fee_percentage': restockingFeePercentage,
      'void_grace_period_minutes': voidGracePeriodMinutes,
      'require_manager_approval': requireManagerApproval,
      'max_return_without_approval': maxReturnWithoutApproval,
      'return_reason_required': returnReasonRequired,
      'partial_return_allowed': partialReturnAllowed,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BusinessTypeReturnPolicy copyWith({
    String? id,
    String? businessTypeId,
    int? returnWindowDays,
    Map<String, dynamic>? refundMethods,
    bool? requireReceipt,
    double? restockingFeePercentage,
    int? voidGracePeriodMinutes,
    bool? requireManagerApproval,
    double? maxReturnWithoutApproval,
    bool? returnReasonRequired,
    bool? partialReturnAllowed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessTypeReturnPolicy(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      returnWindowDays: returnWindowDays ?? this.returnWindowDays,
      refundMethods: refundMethods ?? this.refundMethods,
      requireReceipt: requireReceipt ?? this.requireReceipt,
      restockingFeePercentage: restockingFeePercentage ?? this.restockingFeePercentage,
      voidGracePeriodMinutes: voidGracePeriodMinutes ?? this.voidGracePeriodMinutes,
      requireManagerApproval: requireManagerApproval ?? this.requireManagerApproval,
      maxReturnWithoutApproval: maxReturnWithoutApproval ?? this.maxReturnWithoutApproval,
      returnReasonRequired: returnReasonRequired ?? this.returnReasonRequired,
      partialReturnAllowed: partialReturnAllowed ?? this.partialReturnAllowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeReturnPolicy && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeReturnPolicy(id: $id, businessTypeId: $businessTypeId, returnWindowDays: $returnWindowDays, refundMethods: $refundMethods, requireReceipt: $requireReceipt, restockingFeePercentage: $restockingFeePercentage, ...)';
}
