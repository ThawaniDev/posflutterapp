import 'package:wameedpos/features/wameed_ai/enums/ai_feature_category.dart';

class AIFeatureDefinition {
  final String id;
  final String slug;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final AIFeatureCategory category;
  final String? icon;
  final String? defaultModel;
  final bool isActive;
  final bool isPremium;
  final int dailyLimit;
  final int monthlyLimit;
  final int sortOrder;
  final List<AIStoreFeatureConfig>? storeConfigs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AIFeatureDefinition({
    required this.id,
    required this.slug,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.category,
    this.icon,
    this.defaultModel,
    this.isActive = true,
    this.isPremium = false,
    this.dailyLimit = 50,
    this.monthlyLimit = 500,
    this.sortOrder = 0,
    this.storeConfigs,
    this.createdAt,
    this.updatedAt,
  });

  factory AIFeatureDefinition.fromJson(Map<String, dynamic> json) {
    return AIFeatureDefinition(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      category: AIFeatureCategory.fromValue(json['category'] as String),
      icon: json['icon'] as String?,
      defaultModel: json['default_model'] as String?,
      isActive: json['is_enabled'] as bool? ?? json['is_active'] as bool? ?? true,
      isPremium: json['is_premium'] as bool? ?? false,
      dailyLimit: (json['daily_limit'] as num?)?.toInt() ?? 50,
      monthlyLimit: (json['monthly_limit'] as num?)?.toInt() ?? 500,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      storeConfigs: json['store_configs'] != null
          ? (json['store_configs'] as List).map((e) => AIStoreFeatureConfig.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'category': category.value,
      'icon': icon,
      'default_model': defaultModel,
      'is_enabled': isActive,
      'is_premium': isPremium,
      'daily_limit': dailyLimit,
      'monthly_limit': monthlyLimit,
      'sort_order': sortOrder,
    };
  }

  AIFeatureDefinition copyWith({
    String? id,
    String? slug,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    AIFeatureCategory? category,
    String? icon,
    String? defaultModel,
    bool? isActive,
    bool? isPremium,
    int? dailyLimit,
    int? monthlyLimit,
    int? sortOrder,
    List<AIStoreFeatureConfig>? storeConfigs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AIFeatureDefinition(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      defaultModel: defaultModel ?? this.defaultModel,
      isActive: isActive ?? this.isActive,
      isPremium: isPremium ?? this.isPremium,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      sortOrder: sortOrder ?? this.sortOrder,
      storeConfigs: storeConfigs ?? this.storeConfigs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AIFeatureDefinition && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class AIStoreFeatureConfig {
  final String id;
  final String storeId;
  final String featureId;
  final bool isEnabled;
  final int? dailyLimit;
  final int? monthlyLimit;
  final Map<String, dynamic>? customConfig;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AIStoreFeatureConfig({
    required this.id,
    required this.storeId,
    required this.featureId,
    this.isEnabled = true,
    this.dailyLimit,
    this.monthlyLimit,
    this.customConfig,
    this.createdAt,
    this.updatedAt,
  });

  factory AIStoreFeatureConfig.fromJson(Map<String, dynamic> json) {
    return AIStoreFeatureConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      featureId: json['feature_id'] as String? ?? json['ai_feature_definition_id'] as String? ?? '',
      isEnabled: json['is_enabled'] as bool? ?? true,
      dailyLimit: (json['daily_limit'] as num?)?.toInt(),
      monthlyLimit: (json['monthly_limit'] as num?)?.toInt(),
      customConfig: json['custom_config'] as Map<String, dynamic>? ?? json['settings_json'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'is_enabled': isEnabled, 'daily_limit': dailyLimit, 'monthly_limit': monthlyLimit, 'custom_config': customConfig};
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AIStoreFeatureConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
