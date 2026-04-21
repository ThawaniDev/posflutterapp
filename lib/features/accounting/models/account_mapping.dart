class AccountMapping {

  const AccountMapping({
    required this.id,
    required this.storeId,
    required this.posAccountKey,
    required this.providerAccountId,
    required this.providerAccountName,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountMapping.fromJson(Map<String, dynamic> json) {
    return AccountMapping(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      posAccountKey: json['pos_account_key'] as String,
      providerAccountId: json['provider_account_id'] as String,
      providerAccountName: json['provider_account_name'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String posAccountKey;
  final String providerAccountId;
  final String providerAccountName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'pos_account_key': posAccountKey,
      'provider_account_id': providerAccountId,
      'provider_account_name': providerAccountName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AccountMapping copyWith({
    String? id,
    String? storeId,
    String? posAccountKey,
    String? providerAccountId,
    String? providerAccountName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountMapping(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      posAccountKey: posAccountKey ?? this.posAccountKey,
      providerAccountId: providerAccountId ?? this.providerAccountId,
      providerAccountName: providerAccountName ?? this.providerAccountName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountMapping && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AccountMapping(id: $id, storeId: $storeId, posAccountKey: $posAccountKey, providerAccountId: $providerAccountId, providerAccountName: $providerAccountName, createdAt: $createdAt, ...)';
}
