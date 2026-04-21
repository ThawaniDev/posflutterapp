import 'package:wameedpos/features/accounting/enums/accounting_provider.dart';

class StoreAccountingConfig {

  const StoreAccountingConfig({
    required this.id,
    required this.storeId,
    required this.provider,
    required this.accessTokenEncrypted,
    required this.refreshTokenEncrypted,
    required this.tokenExpiresAt,
    this.realmId,
    this.tenantId,
    this.companyName,
    this.connectedAt,
    this.lastSyncAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreAccountingConfig.fromJson(Map<String, dynamic> json) {
    return StoreAccountingConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      provider: AccountingProvider.fromValue(json['provider'] as String),
      accessTokenEncrypted: json['access_token_encrypted'] as String,
      refreshTokenEncrypted: json['refresh_token_encrypted'] as String,
      tokenExpiresAt: DateTime.parse(json['token_expires_at'] as String),
      realmId: json['realm_id'] as String?,
      tenantId: json['tenant_id'] as String?,
      companyName: json['company_name'] as String?,
      connectedAt: json['connected_at'] != null ? DateTime.parse(json['connected_at'] as String) : null,
      lastSyncAt: json['last_sync_at'] != null ? DateTime.parse(json['last_sync_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final AccountingProvider provider;
  final String accessTokenEncrypted;
  final String refreshTokenEncrypted;
  final DateTime tokenExpiresAt;
  final String? realmId;
  final String? tenantId;
  final String? companyName;
  final DateTime? connectedAt;
  final DateTime? lastSyncAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'provider': provider.value,
      'access_token_encrypted': accessTokenEncrypted,
      'refresh_token_encrypted': refreshTokenEncrypted,
      'token_expires_at': tokenExpiresAt.toIso8601String(),
      'realm_id': realmId,
      'tenant_id': tenantId,
      'company_name': companyName,
      'connected_at': connectedAt?.toIso8601String(),
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StoreAccountingConfig copyWith({
    String? id,
    String? storeId,
    AccountingProvider? provider,
    String? accessTokenEncrypted,
    String? refreshTokenEncrypted,
    DateTime? tokenExpiresAt,
    String? realmId,
    String? tenantId,
    String? companyName,
    DateTime? connectedAt,
    DateTime? lastSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreAccountingConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      provider: provider ?? this.provider,
      accessTokenEncrypted: accessTokenEncrypted ?? this.accessTokenEncrypted,
      refreshTokenEncrypted: refreshTokenEncrypted ?? this.refreshTokenEncrypted,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      realmId: realmId ?? this.realmId,
      tenantId: tenantId ?? this.tenantId,
      companyName: companyName ?? this.companyName,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreAccountingConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StoreAccountingConfig(id: $id, storeId: $storeId, provider: $provider, accessTokenEncrypted: $accessTokenEncrypted, refreshTokenEncrypted: $refreshTokenEncrypted, tokenExpiresAt: $tokenExpiresAt, ...)';
}
