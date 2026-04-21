import 'package:wameedpos/features/thawani_integration/enums/thawani_connection_status.dart';

class ThawaniMarketplaceConfig {

  const ThawaniMarketplaceConfig({
    required this.id,
    required this.clientIdEncrypted,
    required this.clientSecretEncrypted,
    required this.redirectUrl,
    required this.apiBaseUrl,
    this.apiVersion,
    required this.webhookUrl,
    required this.webhookSecretEncrypted,
    this.syncIntervalMinutes,
    this.isActive,
    this.lastConnectionAt,
    this.connectionStatus,
    this.updatedAt,
  });

  factory ThawaniMarketplaceConfig.fromJson(Map<String, dynamic> json) {
    return ThawaniMarketplaceConfig(
      id: json['id'] as String,
      clientIdEncrypted: json['client_id_encrypted'] as String,
      clientSecretEncrypted: json['client_secret_encrypted'] as String,
      redirectUrl: json['redirect_url'] as String,
      apiBaseUrl: json['api_base_url'] as String,
      apiVersion: json['api_version'] as String?,
      webhookUrl: json['webhook_url'] as String,
      webhookSecretEncrypted: json['webhook_secret_encrypted'] as String,
      syncIntervalMinutes: (json['sync_interval_minutes'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      lastConnectionAt: json['last_connection_at'] != null ? DateTime.parse(json['last_connection_at'] as String) : null,
      connectionStatus: ThawaniConnectionStatus.tryFromValue(json['connection_status'] as String?),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String clientIdEncrypted;
  final String clientSecretEncrypted;
  final String redirectUrl;
  final String apiBaseUrl;
  final String? apiVersion;
  final String webhookUrl;
  final String webhookSecretEncrypted;
  final int? syncIntervalMinutes;
  final bool? isActive;
  final DateTime? lastConnectionAt;
  final ThawaniConnectionStatus? connectionStatus;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id_encrypted': clientIdEncrypted,
      'client_secret_encrypted': clientSecretEncrypted,
      'redirect_url': redirectUrl,
      'api_base_url': apiBaseUrl,
      'api_version': apiVersion,
      'webhook_url': webhookUrl,
      'webhook_secret_encrypted': webhookSecretEncrypted,
      'sync_interval_minutes': syncIntervalMinutes,
      'is_active': isActive,
      'last_connection_at': lastConnectionAt?.toIso8601String(),
      'connection_status': connectionStatus?.value,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ThawaniMarketplaceConfig copyWith({
    String? id,
    String? clientIdEncrypted,
    String? clientSecretEncrypted,
    String? redirectUrl,
    String? apiBaseUrl,
    String? apiVersion,
    String? webhookUrl,
    String? webhookSecretEncrypted,
    int? syncIntervalMinutes,
    bool? isActive,
    DateTime? lastConnectionAt,
    ThawaniConnectionStatus? connectionStatus,
    DateTime? updatedAt,
  }) {
    return ThawaniMarketplaceConfig(
      id: id ?? this.id,
      clientIdEncrypted: clientIdEncrypted ?? this.clientIdEncrypted,
      clientSecretEncrypted: clientSecretEncrypted ?? this.clientSecretEncrypted,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiVersion: apiVersion ?? this.apiVersion,
      webhookUrl: webhookUrl ?? this.webhookUrl,
      webhookSecretEncrypted: webhookSecretEncrypted ?? this.webhookSecretEncrypted,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      isActive: isActive ?? this.isActive,
      lastConnectionAt: lastConnectionAt ?? this.lastConnectionAt,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThawaniMarketplaceConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ThawaniMarketplaceConfig(id: $id, clientIdEncrypted: $clientIdEncrypted, clientSecretEncrypted: $clientSecretEncrypted, redirectUrl: $redirectUrl, apiBaseUrl: $apiBaseUrl, apiVersion: $apiVersion, ...)';
}
