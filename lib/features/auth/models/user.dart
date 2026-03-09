import 'package:thawani_pos/features/auth/enums/user_role.dart';

class User {
  final String id;
  final String? storeId;
  final String? organizationId;
  final String name;
  final String? email;
  final String? phone;
  final String? passwordHash;
  final String? pinHash;
  final UserRole? role;
  final String? locale;
  final bool? isActive;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    this.storeId,
    this.organizationId,
    required this.name,
    this.email,
    this.phone,
    this.passwordHash,
    this.pinHash,
    this.role,
    this.locale,
    this.isActive,
    this.emailVerifiedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      storeId: json['store_id'] as String?,
      organizationId: json['organization_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      passwordHash: json['password_hash'] as String?,
      pinHash: json['pin_hash'] as String?,
      role: UserRole.tryFromValue(json['role'] as String?),
      locale: json['locale'] as String?,
      isActive: json['is_active'] as bool?,
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at'] as String) : null,
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'organization_id': organizationId,
      'name': name,
      'email': email,
      'phone': phone,
      'password_hash': passwordHash,
      'pin_hash': pinHash,
      'role': role?.value,
      'locale': locale,
      'is_active': isActive,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? storeId,
    String? organizationId,
    String? name,
    String? email,
    String? phone,
    String? passwordHash,
    String? pinHash,
    UserRole? role,
    String? locale,
    bool? isActive,
    DateTime? emailVerifiedAt,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      role: role ?? this.role,
      locale: locale ?? this.locale,
      isActive: isActive ?? this.isActive,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, storeId: $storeId, organizationId: $organizationId, name: $name, email: $email, phone: $phone, ...)';
}
