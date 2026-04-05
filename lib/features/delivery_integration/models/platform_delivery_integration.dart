class PlatformDeliveryIntegration {
  final String id;
  final String platformSlug;
  final String displayName;
  final String? displayNameAr;
  final String apiBaseUrl;
  final String? clientId;
  final String? clientSecretEncrypted;
  final String? webhookSecretEncrypted;
  final double? defaultCommissionPercent;
  final bool? isActive;
  final Map<String, dynamic>? supportedCountries;
  final String? logoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlatformDeliveryIntegration({
    required this.id,
    required this.platformSlug,
    required this.displayName,
    this.displayNameAr,
    required this.apiBaseUrl,
    this.clientId,
    this.clientSecretEncrypted,
    this.webhookSecretEncrypted,
    this.defaultCommissionPercent,
    this.isActive,
    this.supportedCountries,
    this.logoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformDeliveryIntegration.fromJson(Map<String, dynamic> json) {
    return PlatformDeliveryIntegration(
      id: json['id'] as String,
      platformSlug: json['platform_slug'] as String,
      displayName: json['display_name'] as String,
      displayNameAr: json['display_name_ar'] as String?,
      apiBaseUrl: json['api_base_url'] as String,
      clientId: json['client_id'] as String?,
      clientSecretEncrypted: json['client_secret_encrypted'] as String?,
      webhookSecretEncrypted: json['webhook_secret_encrypted'] as String?,
      defaultCommissionPercent: (json['default_commission_percent'] != null ? double.tryParse(json['default_commission_percent'].toString()) : null),
      isActive: json['is_active'] as bool?,
      supportedCountries: json['supported_countries'] != null ? Map<String, dynamic>.from(json['supported_countries'] as Map) : null,
      logoUrl: json['logo_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform_slug': platformSlug,
      'display_name': displayName,
      'display_name_ar': displayNameAr,
      'api_base_url': apiBaseUrl,
      'client_id': clientId,
      'client_secret_encrypted': clientSecretEncrypted,
      'webhook_secret_encrypted': webhookSecretEncrypted,
      'default_commission_percent': defaultCommissionPercent,
      'is_active': isActive,
      'supported_countries': supportedCountries,
      'logo_url': logoUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PlatformDeliveryIntegration copyWith({
    String? id,
    String? platformSlug,
    String? displayName,
    String? displayNameAr,
    String? apiBaseUrl,
    String? clientId,
    String? clientSecretEncrypted,
    String? webhookSecretEncrypted,
    double? defaultCommissionPercent,
    bool? isActive,
    Map<String, dynamic>? supportedCountries,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlatformDeliveryIntegration(
      id: id ?? this.id,
      platformSlug: platformSlug ?? this.platformSlug,
      displayName: displayName ?? this.displayName,
      displayNameAr: displayNameAr ?? this.displayNameAr,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      clientId: clientId ?? this.clientId,
      clientSecretEncrypted: clientSecretEncrypted ?? this.clientSecretEncrypted,
      webhookSecretEncrypted: webhookSecretEncrypted ?? this.webhookSecretEncrypted,
      defaultCommissionPercent: defaultCommissionPercent ?? this.defaultCommissionPercent,
      isActive: isActive ?? this.isActive,
      supportedCountries: supportedCountries ?? this.supportedCountries,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformDeliveryIntegration && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlatformDeliveryIntegration(id: $id, platformSlug: $platformSlug, displayName: $displayName, displayNameAr: $displayNameAr, apiBaseUrl: $apiBaseUrl, clientId: $clientId, ...)';
}
