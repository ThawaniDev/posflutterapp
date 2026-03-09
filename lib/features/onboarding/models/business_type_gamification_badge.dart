import 'package:thawani_pos/features/customers/enums/badge_trigger_type.dart';

class BusinessTypeGamificationBadge {
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final String? iconUrl;
  final BadgeTriggerType triggerType;
  final int triggerThreshold;
  final int? pointsReward;
  final String? description;
  final String? descriptionAr;
  final int? sortOrder;

  const BusinessTypeGamificationBadge({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    this.iconUrl,
    required this.triggerType,
    required this.triggerThreshold,
    this.pointsReward,
    this.description,
    this.descriptionAr,
    this.sortOrder,
  });

  factory BusinessTypeGamificationBadge.fromJson(Map<String, dynamic> json) {
    return BusinessTypeGamificationBadge(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      iconUrl: json['icon_url'] as String?,
      triggerType: BadgeTriggerType.fromValue(json['trigger_type'] as String),
      triggerThreshold: (json['trigger_threshold'] as num).toInt(),
      pointsReward: (json['points_reward'] as num?)?.toInt(),
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
      'icon_url': iconUrl,
      'trigger_type': triggerType.value,
      'trigger_threshold': triggerThreshold,
      'points_reward': pointsReward,
      'description': description,
      'description_ar': descriptionAr,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeGamificationBadge copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    String? iconUrl,
    BadgeTriggerType? triggerType,
    int? triggerThreshold,
    int? pointsReward,
    String? description,
    String? descriptionAr,
    int? sortOrder,
  }) {
    return BusinessTypeGamificationBadge(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      iconUrl: iconUrl ?? this.iconUrl,
      triggerType: triggerType ?? this.triggerType,
      triggerThreshold: triggerThreshold ?? this.triggerThreshold,
      pointsReward: pointsReward ?? this.pointsReward,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeGamificationBadge && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeGamificationBadge(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, iconUrl: $iconUrl, triggerType: $triggerType, ...)';
}
