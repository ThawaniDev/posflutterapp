class AIFeatureResult {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;
  final bool cached;
  final int? tokensUsed;
  final double? cost;

  const AIFeatureResult({
    required this.success,
    this.message,
    this.data,
    this.cached = false,
    this.tokensUsed,
    this.cost,
  });

  factory AIFeatureResult.fromJson(Map<String, dynamic> json) {
    final innerData = json['data'] as Map<String, dynamic>?;
    return AIFeatureResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: innerData,
      cached: innerData?['cached'] as bool? ?? false,
      tokensUsed: (innerData?['tokens_used'] as num?)?.toInt(),
      cost: (innerData?['cost'] as num?)?.toDouble(),
    );
  }

  factory AIFeatureResult.error(String message) {
    return AIFeatureResult(success: false, message: message);
  }
}
