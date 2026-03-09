class StoreAddOn {
  final String storeId;
  final String planAddOnId;
  final DateTime? activatedAt;
  final bool? isActive;

  const StoreAddOn({
    required this.storeId,
    required this.planAddOnId,
    this.activatedAt,
    this.isActive,
  });

  factory StoreAddOn.fromJson(Map<String, dynamic> json) {
    return StoreAddOn(
      storeId: json['store_id'] as String,
      planAddOnId: json['plan_add_on_id'] as String,
      activatedAt: json['activated_at'] != null ? DateTime.parse(json['activated_at'] as String) : null,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'plan_add_on_id': planAddOnId,
      'activated_at': activatedAt?.toIso8601String(),
      'is_active': isActive,
    };
  }

  StoreAddOn copyWith({
    String? storeId,
    String? planAddOnId,
    DateTime? activatedAt,
    bool? isActive,
  }) {
    return StoreAddOn(
      storeId: storeId ?? this.storeId,
      planAddOnId: planAddOnId ?? this.planAddOnId,
      activatedAt: activatedAt ?? this.activatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAddOn && other.storeId == storeId && other.planAddOnId == planAddOnId && other.activatedAt == activatedAt && other.isActive == isActive;

  @override
  int get hashCode => storeId.hashCode ^ planAddOnId.hashCode ^ activatedAt.hashCode ^ isActive.hashCode;

  @override
  String toString() => 'StoreAddOn(storeId: $storeId, planAddOnId: $planAddOnId, activatedAt: $activatedAt, isActive: $isActive)';
}
