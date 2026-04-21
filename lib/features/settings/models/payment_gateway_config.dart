import 'package:wameedpos/features/subscription/enums/gateway_environment.dart';
import 'package:wameedpos/features/subscription/enums/gateway_name.dart';

class PaymentGatewayConfig {

  const PaymentGatewayConfig({
    required this.id,
    required this.gatewayName,
    required this.credentialsEncrypted,
    this.webhookUrl,
    required this.environment,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentGatewayConfig.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayConfig(
      id: json['id'] as String,
      gatewayName: GatewayName.fromValue(json['gateway_name'] as String),
      credentialsEncrypted: Map<String, dynamic>.from(json['credentials_encrypted'] as Map),
      webhookUrl: json['webhook_url'] as String?,
      environment: GatewayEnvironment.fromValue(json['environment'] as String),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final GatewayName gatewayName;
  final Map<String, dynamic> credentialsEncrypted;
  final String? webhookUrl;
  final GatewayEnvironment environment;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gateway_name': gatewayName.value,
      'credentials_encrypted': credentialsEncrypted,
      'webhook_url': webhookUrl,
      'environment': environment.value,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PaymentGatewayConfig copyWith({
    String? id,
    GatewayName? gatewayName,
    Map<String, dynamic>? credentialsEncrypted,
    String? webhookUrl,
    GatewayEnvironment? environment,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentGatewayConfig(
      id: id ?? this.id,
      gatewayName: gatewayName ?? this.gatewayName,
      credentialsEncrypted: credentialsEncrypted ?? this.credentialsEncrypted,
      webhookUrl: webhookUrl ?? this.webhookUrl,
      environment: environment ?? this.environment,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentGatewayConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PaymentGatewayConfig(id: $id, gatewayName: $gatewayName, credentialsEncrypted: $credentialsEncrypted, webhookUrl: $webhookUrl, environment: $environment, isActive: $isActive, ...)';
}
