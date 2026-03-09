class AdminUser {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String? phone;
  final String? avatarUrl;
  final bool? isActive;
  final String? twoFactorSecret;
  final bool? twoFactorEnabled;
  final DateTime? twoFactorConfirmedAt;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.phone,
    this.avatarUrl,
    this.isActive,
    this.twoFactorSecret,
    this.twoFactorEnabled,
    this.twoFactorConfirmedAt,
    this.lastLoginAt,
    this.lastLoginIp,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool?,
      twoFactorSecret: json['two_factor_secret'] as String?,
      twoFactorEnabled: json['two_factor_enabled'] as bool?,
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] != null ? DateTime.parse(json['two_factor_confirmed_at'] as String) : null,
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at'] as String) : null,
      lastLoginIp: json['last_login_ip'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'two_factor_secret': twoFactorSecret,
      'two_factor_enabled': twoFactorEnabled,
      'two_factor_confirmed_at': twoFactorConfirmedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'last_login_ip': lastLoginIp,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    String? phone,
    String? avatarUrl,
    bool? isActive,
    String? twoFactorSecret,
    bool? twoFactorEnabled,
    DateTime? twoFactorConfirmedAt,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      twoFactorSecret: twoFactorSecret ?? this.twoFactorSecret,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorConfirmedAt: twoFactorConfirmedAt ?? this.twoFactorConfirmedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUser && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminUser(id: $id, name: $name, email: $email, passwordHash: $passwordHash, phone: $phone, avatarUrl: $avatarUrl, ...)';
}
