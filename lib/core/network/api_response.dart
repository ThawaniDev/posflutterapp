class ApiResponse<T> {

  const ApiResponse({required this.success, required this.message, this.data, this.errors});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromData) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromData != null ? fromData(json['data']) : null,
      errors: json['errors'] != null ? Map<String, dynamic>.from(json['errors'] as Map) : null,
    );
  }
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  /// Extract the items list from [data], handling both plain lists and
  /// Laravel paginated responses (`{"data": [...], "current_page": ...}`).
  List<dynamic> get dataList {
    final d = data;
    if (d is List) return d;
    if (d is Map<String, dynamic>) return d['data'] as List? ?? [];
    return [];
  }
}
