class DeliveryStatusPushLog {

  const DeliveryStatusPushLog({
    required this.id,
    required this.deliveryOrderMappingId,
    required this.statusPushed,
    required this.platform,
    this.httpStatusCode,
    this.requestPayload,
    this.responsePayload,
    this.success = false,
    this.attemptNumber = 1,
    this.errorMessage,
    this.pushedAt,
  });

  factory DeliveryStatusPushLog.fromJson(Map<String, dynamic> json) {
    return DeliveryStatusPushLog(
      id: json['id'] as String,
      deliveryOrderMappingId: json['delivery_order_mapping_id'] as String,
      statusPushed: json['status_pushed'] as String,
      platform: json['platform'] as String,
      httpStatusCode: (json['http_status_code'] as num?)?.toInt(),
      requestPayload: json['request_payload'] as Map<String, dynamic>?,
      responsePayload: json['response_payload'] as Map<String, dynamic>?,
      success: json['success'] as bool? ?? false,
      attemptNumber: (json['attempt_number'] as num?)?.toInt() ?? 1,
      errorMessage: json['error_message'] as String?,
      pushedAt: json['pushed_at'] != null ? DateTime.parse(json['pushed_at'] as String) : null,
    );
  }
  final String id;
  final String deliveryOrderMappingId;
  final String statusPushed;
  final String platform;
  final int? httpStatusCode;
  final Map<String, dynamic>? requestPayload;
  final Map<String, dynamic>? responsePayload;
  final bool success;
  final int attemptNumber;
  final String? errorMessage;
  final DateTime? pushedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_order_mapping_id': deliveryOrderMappingId,
      'status_pushed': statusPushed,
      'platform': platform,
      'http_status_code': httpStatusCode,
      'request_payload': requestPayload,
      'response_payload': responsePayload,
      'success': success,
      'attempt_number': attemptNumber,
      'error_message': errorMessage,
      'pushed_at': pushedAt?.toIso8601String(),
    };
  }
}
