class StoreAddOn {

  const StoreAddOn({required this.organizationId, required this.planAddOnId, this.activatedAt, this.isActive});

  factory StoreAddOn.fromJson(Map<String, dynamic> json) {
    return StoreAddOn(
      organizationId: (json['organization_id'] ?? json['store_id']) as String,
      planAddOnId: json['plan_add_on_id'] as String,
      activatedAt: json['activated_at'] != null ? DateTime.parse(json['activated_at'] as String) : null,
      isActive: json['is_active'] as bool?,
    );
  }
  final String organizationId;
  final String planAddOnId;
  final DateTime? activatedAt;
  final bool? isActive;

  Map<String, dynamic> toJson() {
    return {
      'organization_id': organizationId,
      'plan_add_on_id': planAddOnId,
      'activated_at': activatedAt?.toIso8601String(),
      'is_active': isActive,
    };
  }

  StoreAddOn copyWith({String? organizationId, String? planAddOnId, DateTime? activatedAt, bool? isActive}) {
    return StoreAddOn(
      organizationId: organizationId ?? this.organizationId,
      planAddOnId: planAddOnId ?? this.planAddOnId,
      activatedAt: activatedAt ?? this.activatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAddOn &&
          other.organizationId == organizationId &&
          other.planAddOnId == planAddOnId &&
          other.activatedAt == activatedAt &&
          other.isActive == isActive;

  @override
  int get hashCode => organizationId.hashCode ^ planAddOnId.hashCode ^ activatedAt.hashCode ^ isActive.hashCode;

  @override
  String toString() =>
      'StoreAddOn(organizationId: $organizationId, planAddOnId: $planAddOnId, activatedAt: $activatedAt, isActive: $isActive)';
}
