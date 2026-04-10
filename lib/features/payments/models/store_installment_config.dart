import 'package:thawani_pos/features/payments/enums/installment_provider.dart';
import 'package:thawani_pos/features/payments/models/installment_provider_config.dart';

/// Store-level configuration for an installment provider.
class StoreInstallmentConfig {
  final String id;
  final String storeId;
  final InstallmentProvider provider;
  final bool isEnabled;
  final String environment;
  final bool isFullyConfigured;
  final bool isAvailable;
  final Map<String, String> maskedCredentials;
  final String? successUrl;
  final String? cancelUrl;
  final String? failureUrl;
  final InstallmentProviderConfig? providerConfig;
  final String? createdAt;
  final String? updatedAt;

  const StoreInstallmentConfig({
    required this.id,
    required this.storeId,
    required this.provider,
    this.isEnabled = false,
    this.environment = 'sandbox',
    this.isFullyConfigured = false,
    this.isAvailable = false,
    this.maskedCredentials = const {},
    this.successUrl,
    this.cancelUrl,
    this.failureUrl,
    this.providerConfig,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreInstallmentConfig.fromJson(Map<String, dynamic> json) {
    return StoreInstallmentConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      provider: InstallmentProvider.fromValue(json['provider'] as String),
      isEnabled: json['is_enabled'] as bool? ?? false,
      environment: json['environment'] as String? ?? 'sandbox',
      isFullyConfigured: json['is_fully_configured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? false,
      maskedCredentials: (json['masked_credentials'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      successUrl: json['success_url'] as String?,
      cancelUrl: json['cancel_url'] as String?,
      failureUrl: json['failure_url'] as String?,
      providerConfig: json['provider_config'] != null
          ? InstallmentProviderConfig.fromJson(json['provider_config'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'provider': provider.value,
    'is_enabled': isEnabled,
    'environment': environment,
    'is_fully_configured': isFullyConfigured,
    'is_available': isAvailable,
    'masked_credentials': maskedCredentials,
    'success_url': successUrl,
    'cancel_url': cancelUrl,
    'failure_url': failureUrl,
  };

  StoreInstallmentConfig copyWith({
    String? id,
    String? storeId,
    InstallmentProvider? provider,
    bool? isEnabled,
    String? environment,
    bool? isFullyConfigured,
    bool? isAvailable,
    Map<String, String>? maskedCredentials,
    String? successUrl,
    String? cancelUrl,
    String? failureUrl,
    InstallmentProviderConfig? providerConfig,
  }) {
    return StoreInstallmentConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      provider: provider ?? this.provider,
      isEnabled: isEnabled ?? this.isEnabled,
      environment: environment ?? this.environment,
      isFullyConfigured: isFullyConfigured ?? this.isFullyConfigured,
      isAvailable: isAvailable ?? this.isAvailable,
      maskedCredentials: maskedCredentials ?? this.maskedCredentials,
      successUrl: successUrl ?? this.successUrl,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      failureUrl: failureUrl ?? this.failureUrl,
      providerConfig: providerConfig ?? this.providerConfig,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreInstallmentConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
