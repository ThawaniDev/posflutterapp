import 'package:wameedpos/features/accounting/enums/accounting_provider.dart';

class AccountingIntegrationConfig {
  final String id;
  final AccountingProvider providerName;
  final String clientIdEncrypted;
  final String clientSecretEncrypted;
  final String redirectUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AccountingIntegrationConfig({
    required this.id,
    required this.providerName,
    required this.clientIdEncrypted,
    required this.clientSecretEncrypted,
    required this.redirectUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountingIntegrationConfig.fromJson(Map<String, dynamic> json) {
    return AccountingIntegrationConfig(
      id: json['id'] as String,
      providerName: AccountingProvider.fromValue(json['provider_name'] as String),
      clientIdEncrypted: json['client_id_encrypted'] as String,
      clientSecretEncrypted: json['client_secret_encrypted'] as String,
      redirectUrl: json['redirect_url'] as String,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_name': providerName.value,
      'client_id_encrypted': clientIdEncrypted,
      'client_secret_encrypted': clientSecretEncrypted,
      'redirect_url': redirectUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AccountingIntegrationConfig copyWith({
    String? id,
    AccountingProvider? providerName,
    String? clientIdEncrypted,
    String? clientSecretEncrypted,
    String? redirectUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingIntegrationConfig(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      clientIdEncrypted: clientIdEncrypted ?? this.clientIdEncrypted,
      clientSecretEncrypted: clientSecretEncrypted ?? this.clientSecretEncrypted,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountingIntegrationConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AccountingIntegrationConfig(id: $id, providerName: $providerName, clientIdEncrypted: $clientIdEncrypted, clientSecretEncrypted: $clientSecretEncrypted, redirectUrl: $redirectUrl, isActive: $isActive, ...)';
}
