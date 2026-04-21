import 'package:wameedpos/features/payments/enums/payment_method_category.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';

class PaymentMethod {

  const PaymentMethod({
    required this.id,
    required this.methodKey,
    required this.name,
    required this.nameAr,
    this.icon,
    required this.category,
    this.requiresTerminal,
    this.requiresCustomerProfile,
    this.providerConfigSchema,
    this.isActive,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      methodKey: PaymentMethodKey.fromValue(json['method_key'] as String),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      icon: json['icon'] as String?,
      category: PaymentMethodCategory.fromValue(json['category'] as String),
      requiresTerminal: json['requires_terminal'] as bool?,
      requiresCustomerProfile: json['requires_customer_profile'] as bool?,
      providerConfigSchema: json['provider_config_schema'] != null
          ? Map<String, dynamic>.from(json['provider_config_schema'] as Map)
          : null,
      isActive: json['is_active'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final PaymentMethodKey methodKey;
  final String name;
  final String nameAr;
  final String? icon;
  final PaymentMethodCategory category;
  final bool? requiresTerminal;
  final bool? requiresCustomerProfile;
  final Map<String, dynamic>? providerConfigSchema;
  final bool? isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method_key': methodKey.value,
      'name': name,
      'name_ar': nameAr,
      'icon': icon,
      'category': category.value,
      'requires_terminal': requiresTerminal,
      'requires_customer_profile': requiresCustomerProfile,
      'provider_config_schema': providerConfigSchema,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PaymentMethod copyWith({
    String? id,
    PaymentMethodKey? methodKey,
    String? name,
    String? nameAr,
    String? icon,
    PaymentMethodCategory? category,
    bool? requiresTerminal,
    bool? requiresCustomerProfile,
    Map<String, dynamic>? providerConfigSchema,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      methodKey: methodKey ?? this.methodKey,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      requiresTerminal: requiresTerminal ?? this.requiresTerminal,
      requiresCustomerProfile: requiresCustomerProfile ?? this.requiresCustomerProfile,
      providerConfigSchema: providerConfigSchema ?? this.providerConfigSchema,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentMethod && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PaymentMethod(id: $id, methodKey: $methodKey, name: $name, nameAr: $nameAr, icon: $icon, category: $category, ...)';
}
