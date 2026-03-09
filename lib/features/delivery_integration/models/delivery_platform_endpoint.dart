import 'package:thawani_pos/features/delivery_integration/enums/delivery_endpoint_operation.dart';
import 'package:thawani_pos/features/delivery_integration/enums/http_method.dart';

class DeliveryPlatformEndpoint {
  final String id;
  final String deliveryPlatformId;
  final DeliveryEndpointOperation operation;
  final String urlTemplate;
  final HttpMethod httpMethod;
  final Map<String, dynamic>? requestMapping;

  const DeliveryPlatformEndpoint({
    required this.id,
    required this.deliveryPlatformId,
    required this.operation,
    required this.urlTemplate,
    required this.httpMethod,
    this.requestMapping,
  });

  factory DeliveryPlatformEndpoint.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatformEndpoint(
      id: json['id'] as String,
      deliveryPlatformId: json['delivery_platform_id'] as String,
      operation: DeliveryEndpointOperation.fromValue(json['operation'] as String),
      urlTemplate: json['url_template'] as String,
      httpMethod: HttpMethod.fromValue(json['http_method'] as String),
      requestMapping: json['request_mapping'] != null ? Map<String, dynamic>.from(json['request_mapping'] as Map) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_platform_id': deliveryPlatformId,
      'operation': operation.value,
      'url_template': urlTemplate,
      'http_method': httpMethod.value,
      'request_mapping': requestMapping,
    };
  }

  DeliveryPlatformEndpoint copyWith({
    String? id,
    String? deliveryPlatformId,
    DeliveryEndpointOperation? operation,
    String? urlTemplate,
    HttpMethod? httpMethod,
    Map<String, dynamic>? requestMapping,
  }) {
    return DeliveryPlatformEndpoint(
      id: id ?? this.id,
      deliveryPlatformId: deliveryPlatformId ?? this.deliveryPlatformId,
      operation: operation ?? this.operation,
      urlTemplate: urlTemplate ?? this.urlTemplate,
      httpMethod: httpMethod ?? this.httpMethod,
      requestMapping: requestMapping ?? this.requestMapping,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryPlatformEndpoint && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryPlatformEndpoint(id: $id, deliveryPlatformId: $deliveryPlatformId, operation: $operation, urlTemplate: $urlTemplate, httpMethod: $httpMethod, requestMapping: $requestMapping)';
}
