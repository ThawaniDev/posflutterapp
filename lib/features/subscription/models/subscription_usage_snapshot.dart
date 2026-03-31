import 'package:thawani_pos/features/subscription/enums/subscription_resource_type.dart';

class SubscriptionUsageSnapshot {
  final String id;
  final String organizationId;
  final SubscriptionResourceType resourceType;
  final int currentCount;
  final int planLimit;
  final DateTime snapshotDate;
  final DateTime? createdAt;

  const SubscriptionUsageSnapshot({
    required this.id,
    required this.organizationId,
    required this.resourceType,
    required this.currentCount,
    required this.planLimit,
    required this.snapshotDate,
    this.createdAt,
  });

  factory SubscriptionUsageSnapshot.fromJson(Map<String, dynamic> json) {
    return SubscriptionUsageSnapshot(
      id: json['id'] as String,
      organizationId: (json['organization_id'] ?? json['store_id']) as String,
      resourceType: SubscriptionResourceType.fromValue(json['resource_type'] as String),
      currentCount: (json['current_count'] as num).toInt(),
      planLimit: (json['plan_limit'] as num).toInt(),
      snapshotDate: DateTime.parse(json['snapshot_date'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'resource_type': resourceType.value,
      'current_count': currentCount,
      'plan_limit': planLimit,
      'snapshot_date': snapshotDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SubscriptionUsageSnapshot copyWith({
    String? id,
    String? organizationId,
    SubscriptionResourceType? resourceType,
    int? currentCount,
    int? planLimit,
    DateTime? snapshotDate,
    DateTime? createdAt,
  }) {
    return SubscriptionUsageSnapshot(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      resourceType: resourceType ?? this.resourceType,
      currentCount: currentCount ?? this.currentCount,
      planLimit: planLimit ?? this.planLimit,
      snapshotDate: snapshotDate ?? this.snapshotDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscriptionUsageSnapshot && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SubscriptionUsageSnapshot(id: $id, organizationId: $organizationId, resourceType: $resourceType, currentCount: $currentCount, planLimit: $planLimit, snapshotDate: $snapshotDate, ...)';
}
