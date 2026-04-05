import 'package:thawani_pos/features/customers/enums/challenge_reward_type.dart';
import 'package:thawani_pos/features/customers/enums/challenge_type.dart';

class LoyaltyChallenge {
  final String id;
  final String storeId;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final ChallengeType challengeType;
  final double targetValue;
  final ChallengeRewardType rewardType;
  final double? rewardValue;
  final String? rewardBadgeId;
  final DateTime startDate;
  final DateTime? endDate;
  final bool? isActive;
  final DateTime? createdAt;

  const LoyaltyChallenge({
    required this.id,
    required this.storeId,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.challengeType,
    required this.targetValue,
    required this.rewardType,
    this.rewardValue,
    this.rewardBadgeId,
    required this.startDate,
    this.endDate,
    this.isActive,
    this.createdAt,
  });

  factory LoyaltyChallenge.fromJson(Map<String, dynamic> json) {
    return LoyaltyChallenge(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      challengeType: ChallengeType.fromValue(json['challenge_type'] as String),
      targetValue: double.tryParse(json['target_value'].toString()) ?? 0.0,
      rewardType: ChallengeRewardType.fromValue(json['reward_type'] as String),
      rewardValue: (json['reward_value'] != null ? double.tryParse(json['reward_value'].toString()) : null),
      rewardBadgeId: json['reward_badge_id'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'challenge_type': challengeType.value,
      'target_value': targetValue,
      'reward_type': rewardType.value,
      'reward_value': rewardValue,
      'reward_badge_id': rewardBadgeId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  LoyaltyChallenge copyWith({
    String? id,
    String? storeId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    ChallengeType? challengeType,
    double? targetValue,
    ChallengeRewardType? rewardType,
    double? rewardValue,
    String? rewardBadgeId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return LoyaltyChallenge(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      challengeType: challengeType ?? this.challengeType,
      targetValue: targetValue ?? this.targetValue,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      rewardBadgeId: rewardBadgeId ?? this.rewardBadgeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyChallenge && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LoyaltyChallenge(id: $id, storeId: $storeId, nameAr: $nameAr, nameEn: $nameEn, descriptionAr: $descriptionAr, descriptionEn: $descriptionEn, ...)';
}
