import 'package:thawani_pos/features/customers/enums/milestone_reward_type.dart';
import 'package:thawani_pos/features/customers/enums/milestone_type.dart';

class BusinessTypeGamificationMilestone {
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final MilestoneType milestoneType;
  final double thresholdValue;
  final MilestoneRewardType rewardType;
  final String rewardValue;
  final int? sortOrder;

  const BusinessTypeGamificationMilestone({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    required this.milestoneType,
    required this.thresholdValue,
    required this.rewardType,
    required this.rewardValue,
    this.sortOrder,
  });

  factory BusinessTypeGamificationMilestone.fromJson(Map<String, dynamic> json) {
    return BusinessTypeGamificationMilestone(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      milestoneType: MilestoneType.fromValue(json['milestone_type'] as String),
      thresholdValue: (json['threshold_value'] as num).toDouble(),
      rewardType: MilestoneRewardType.fromValue(json['reward_type'] as String),
      rewardValue: json['reward_value'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'milestone_type': milestoneType.value,
      'threshold_value': thresholdValue,
      'reward_type': rewardType.value,
      'reward_value': rewardValue,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeGamificationMilestone copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    MilestoneType? milestoneType,
    double? thresholdValue,
    MilestoneRewardType? rewardType,
    String? rewardValue,
    int? sortOrder,
  }) {
    return BusinessTypeGamificationMilestone(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      milestoneType: milestoneType ?? this.milestoneType,
      thresholdValue: thresholdValue ?? this.thresholdValue,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeGamificationMilestone && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeGamificationMilestone(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, milestoneType: $milestoneType, thresholdValue: $thresholdValue, ...)';
}
