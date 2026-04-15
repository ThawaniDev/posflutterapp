import 'package:wameedpos/features/customers/enums/gamification_challenge_type.dart';
import 'package:wameedpos/features/customers/enums/gamification_reward_type.dart';

class BusinessTypeGamificationChallenge {
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final GamificationChallengeType challengeType;
  final int targetValue;
  final GamificationRewardType rewardType;
  final String rewardValue;
  final int? durationDays;
  final bool? isRecurring;
  final String? description;
  final String? descriptionAr;
  final int? sortOrder;

  const BusinessTypeGamificationChallenge({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    required this.challengeType,
    required this.targetValue,
    required this.rewardType,
    required this.rewardValue,
    this.durationDays,
    this.isRecurring,
    this.description,
    this.descriptionAr,
    this.sortOrder,
  });

  factory BusinessTypeGamificationChallenge.fromJson(Map<String, dynamic> json) {
    return BusinessTypeGamificationChallenge(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      challengeType: GamificationChallengeType.fromValue(json['challenge_type'] as String),
      targetValue: (json['target_value'] as num).toInt(),
      rewardType: GamificationRewardType.fromValue(json['reward_type'] as String),
      rewardValue: json['reward_value'] as String,
      durationDays: (json['duration_days'] as num?)?.toInt(),
      isRecurring: json['is_recurring'] as bool?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'challenge_type': challengeType.value,
      'target_value': targetValue,
      'reward_type': rewardType.value,
      'reward_value': rewardValue,
      'duration_days': durationDays,
      'is_recurring': isRecurring,
      'description': description,
      'description_ar': descriptionAr,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeGamificationChallenge copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    GamificationChallengeType? challengeType,
    int? targetValue,
    GamificationRewardType? rewardType,
    String? rewardValue,
    int? durationDays,
    bool? isRecurring,
    String? description,
    String? descriptionAr,
    int? sortOrder,
  }) {
    return BusinessTypeGamificationChallenge(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      challengeType: challengeType ?? this.challengeType,
      targetValue: targetValue ?? this.targetValue,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      durationDays: durationDays ?? this.durationDays,
      isRecurring: isRecurring ?? this.isRecurring,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessTypeGamificationChallenge && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BusinessTypeGamificationChallenge(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, challengeType: $challengeType, targetValue: $targetValue, ...)';
}
