class ThawaniSyncLog {

  const ThawaniSyncLog({
    required this.id,
    required this.storeId,
    required this.entityType,
    this.entityId,
    required this.action,
    required this.direction,
    required this.status,
    this.requestData,
    this.responseData,
    this.errorMessage,
    this.httpStatusCode,
    this.completedAt,
    required this.createdAt,
  });

  factory ThawaniSyncLog.fromJson(Map<String, dynamic> json) {
    return ThawaniSyncLog(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      entityType: json['entity_type'] as String? ?? '',
      entityId: json['entity_id']?.toString(),
      action: json['action'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
      status: json['status'] as String? ?? '',
      requestData: json['request_data'] as Map<String, dynamic>?,
      responseData: json['response_data'] as Map<String, dynamic>?,
      errorMessage: json['error_message'] as String?,
      httpStatusCode: json['http_status_code'] as int?,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'].toString()) : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
  final String id;
  final String storeId;
  final String entityType;
  final String? entityId;
  final String action;
  final String direction;
  final String status;
  final Map<String, dynamic>? requestData;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;
  final int? httpStatusCode;
  final DateTime? completedAt;
  final DateTime createdAt;

  bool get isSuccess => status == 'success';
  bool get isFailed => status == 'failed';
}
