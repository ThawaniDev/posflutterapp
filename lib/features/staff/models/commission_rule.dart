import 'package:thawani_pos/features/staff/enums/commission_rule_type.dart';

class CommissionRule {
  final String id;
  final String storeId;
  final String? staffUserId;
  final CommissionRuleType type;
  final double? percentage;
  final Map<String, dynamic>? tiersJson;
  final String? productCategoryId;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommissionRule({
    required this.id,
    required this.storeId,
    this.staffUserId,
    required this.type,
    this.percentage,
    this.tiersJson,
    this.productCategoryId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CommissionRule.fromJson(Map<String, dynamic> json) {
    return CommissionRule(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      staffUserId: json['staff_user_id'] as String?,
      type: CommissionRuleType.fromValue(json['type'] as String),
      percentage: (json['percentage'] != null ? double.tryParse(json['percentage'].toString()) : null),
      tiersJson: json['tiers_json'] != null ? Map<String, dynamic>.from(json['tiers_json'] as Map) : null,
      productCategoryId: json['product_category_id'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'staff_user_id': staffUserId,
      'type': type.value,
      'percentage': percentage,
      'tiers_json': tiersJson,
      'product_category_id': productCategoryId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CommissionRule copyWith({
    String? id,
    String? storeId,
    String? staffUserId,
    CommissionRuleType? type,
    double? percentage,
    Map<String, dynamic>? tiersJson,
    String? productCategoryId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommissionRule(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      staffUserId: staffUserId ?? this.staffUserId,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      tiersJson: tiersJson ?? this.tiersJson,
      productCategoryId: productCategoryId ?? this.productCategoryId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionRule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CommissionRule(id: $id, storeId: $storeId, staffUserId: $staffUserId, type: $type, percentage: $percentage, tiersJson: $tiersJson, ...)';
}
