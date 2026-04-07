class Permission {
  final int id;
  final String name;
  final String displayName;
  final String? displayNameAr;
  final String module;
  final String guardName;
  final bool? requiresPin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Permission({
    required this.id,
    required this.name,
    required this.displayName,
    this.displayNameAr,
    required this.module,
    this.guardName = 'staff',
    this.requiresPin,
    this.createdAt,
    this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      displayNameAr: json['display_name_ar'] as String?,
      module: json['module'] as String? ?? (json['name'] as String).split('.').first,
      guardName: json['guard_name'] as String? ?? 'staff',
      requiresPin: json['requires_pin'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'display_name_ar': displayNameAr,
      'module': module,
      'guard_name': guardName,
      'requires_pin': requiresPin,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Permission copyWith({
    int? id,
    String? name,
    String? displayName,
    String? displayNameAr,
    String? module,
    String? guardName,
    bool? requiresPin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      displayNameAr: displayNameAr ?? this.displayNameAr,
      module: module ?? this.module,
      guardName: guardName ?? this.guardName,
      requiresPin: requiresPin ?? this.requiresPin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Permission && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Permission(id: $id, name: $name, displayName: $displayName, module: $module, guardName: $guardName, requiresPin: $requiresPin, ...)';
}
