class DeliveryWebhookLog {

  const DeliveryWebhookLog({
    required this.id,
    required this.platform,
    this.storeId,
    required this.eventType,
    this.externalOrderId,
    this.payload,
    this.headers,
    this.signatureValid,
    this.processed = false,
    this.processingResult,
    this.errorMessage,
    this.ipAddress,
    this.receivedAt,
  });

  factory DeliveryWebhookLog.fromJson(Map<String, dynamic> json) {
    return DeliveryWebhookLog(
      id: json['id'] as String,
      platform: json['platform'] as String,
      storeId: json['store_id'] as String?,
      eventType: json['event_type'] as String,
      externalOrderId: json['external_order_id'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      headers: json['headers'] as Map<String, dynamic>?,
      signatureValid: json['signature_valid'] as bool?,
      processed: json['processed'] as bool? ?? false,
      processingResult: json['processing_result'] as String?,
      errorMessage: json['error_message'] as String?,
      ipAddress: json['ip_address'] as String?,
      receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at'] as String) : null,
    );
  }
  final String id;
  final String platform;
  final String? storeId;
  final String eventType;
  final String? externalOrderId;
  final Map<String, dynamic>? payload;
  final Map<String, dynamic>? headers;
  final bool? signatureValid;
  final bool processed;
  final String? processingResult;
  final String? errorMessage;
  final String? ipAddress;
  final DateTime? receivedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'store_id': storeId,
      'event_type': eventType,
      'external_order_id': externalOrderId,
      'payload': payload,
      'headers': headers,
      'signature_valid': signatureValid,
      'processed': processed,
      'processing_result': processingResult,
      'error_message': errorMessage,
      'ip_address': ipAddress,
      'received_at': receivedAt?.toIso8601String(),
    };
  }
}
