import 'package:wameedpos/features/auth/enums/user_role.dart';

class User {

  const User({
    required this.id,
    this.storeId,
    this.organizationId,
    required this.name,
    this.email,
    this.phone,
    this.role,
    this.locale,
    this.isActive = true,
    this.emailVerifiedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.organization,
    this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? (json['store'] as Map<String, dynamic>?)?['id'] as String?,
      organizationId: json['organization_id'] as String? ?? (json['organization'] as Map<String, dynamic>?)?['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: UserRole.tryFromValue(json['role'] as String?),
      locale: json['locale'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at'] as String) : null,
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      store: json['store'] != null ? UserStore.fromJson(json['store'] as Map<String, dynamic>) : null,
      organization: json['organization'] != null ? UserOrganization.fromJson(json['organization'] as Map<String, dynamic>) : null,
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
  final String id;
  final String? storeId;
  final String? organizationId;
  final String name;
  final String? email;
  final String? phone;
  final UserRole? role;
  final String? locale;
  final bool isActive;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserStore? store;
  final UserOrganization? organization;
  final List<String>? permissions;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone, 'role': role?.value, 'locale': locale, 'is_active': isActive};
  }

  User copyWith({
    String? id,
    String? storeId,
    String? organizationId,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? locale,
    bool? isActive,
    DateTime? emailVerifiedAt,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStore? store,
    UserOrganization? organization,
    List<String>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      locale: locale ?? this.locale,
      isActive: isActive ?? this.isActive,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      store: store ?? this.store,
      organization: organization ?? this.organization,
      permissions: permissions ?? this.permissions,
    );
  }

  bool get isOwner => role == UserRole.owner;
  bool get isManager => role == UserRole.branchManager || role == UserRole.chainManager;

  @override
  bool operator ==(Object other) => identical(this, other) || other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: ${role?.value})';
}

/// Nested store info returned with auth responses.
class UserStore {

  const UserStore({
    required this.id,
    required this.name,
    this.nameAr,
    this.slug,
    this.currency,
    this.locale,
    this.businessType,
    this.isMainBranch = false,
  });

  factory UserStore.fromJson(Map<String, dynamic> json) {
    return UserStore(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String?,
      currency: json['currency'] as String?,
      locale: json['locale'] as String?,
      businessType: json['business_type'] as String?,
      isMainBranch: json['is_main_branch'] as bool? ?? false,
    );
  }
  final String id;
  final String name;
  final String? nameAr;
  final String? slug;
  final String? currency;
  final String? locale;
  final String? businessType;
  final bool isMainBranch;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_ar': nameAr,
    'slug': slug,
    'currency': currency,
    'locale': locale,
    'business_type': businessType,
    'is_main_branch': isMainBranch,
  };
}

/// Nested organization info returned with auth responses.
class UserOrganization {

  const UserOrganization({required this.id, required this.name, this.nameAr, this.slug, this.country});

  factory UserOrganization.fromJson(Map<String, dynamic> json) {
    return UserOrganization(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String?,
      country: json['country'] as String?,
    );
  }
  final String id;
  final String name;
  final String? nameAr;
  final String? slug;
  final String? country;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'name_ar': nameAr, 'slug': slug, 'country': country};
}
