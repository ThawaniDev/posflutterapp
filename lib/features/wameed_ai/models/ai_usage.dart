// Helpers to safely parse num/String values from JSON
int _toInt(dynamic v) => v == null ? 0 : (v is num ? v.toInt() : int.tryParse(v.toString()) ?? 0);
double _toDouble(dynamic v) => v == null ? 0 : (v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0);

class AIUsageSummary {
  final AIUsageToday today;
  final AIUsageMonthly monthly;
  final List<AIUsageByFeature> byFeature;

  const AIUsageSummary({required this.today, required this.monthly, this.byFeature = const []});

  factory AIUsageSummary.fromJson(Map<String, dynamic> json) {
    return AIUsageSummary(
      today: AIUsageToday.fromJson(json['today'] as Map<String, dynamic>),
      monthly: AIUsageMonthly.fromJson(json['monthly'] as Map<String, dynamic>),
      byFeature: json['by_feature'] != null
          ? (json['by_feature'] as List).map((e) => AIUsageByFeature.fromJson(e as Map<String, dynamic>)).toList()
          : const [],
    );
  }
}

class AIUsageToday {
  final int requestCount;
  final double totalCost;
  final int totalTokens;

  const AIUsageToday({this.requestCount = 0, this.totalCost = 0, this.totalTokens = 0});

  factory AIUsageToday.fromJson(Map<String, dynamic> json) {
    return AIUsageToday(
      requestCount: _toInt(json['total_requests'] ?? json['request_count']),
      totalCost: _toDouble(json['total_cost_usd'] ?? json['total_cost']),
      totalTokens: _toInt(json['total_tokens']),
    );
  }
}

class AIUsageMonthly {
  final int requestCount;
  final double totalCost;
  final int totalTokens;

  const AIUsageMonthly({this.requestCount = 0, this.totalCost = 0, this.totalTokens = 0});

  factory AIUsageMonthly.fromJson(Map<String, dynamic> json) {
    return AIUsageMonthly(
      requestCount: _toInt(json['total_requests'] ?? json['request_count']),
      totalCost: _toDouble(json['total_estimated_cost_usd'] ?? json['total_cost']),
      totalTokens: _toInt(json['total_tokens'])
          + _toInt(json['total_input_tokens'])
          + _toInt(json['total_output_tokens']),
    );
  }
}

class AIUsageByFeature {
  final String featureSlug;
  final int requestCount;
  final double totalCost;

  const AIUsageByFeature({required this.featureSlug, this.requestCount = 0, this.totalCost = 0});

  factory AIUsageByFeature.fromJson(Map<String, dynamic> json) {
    return AIUsageByFeature(
      featureSlug: json['feature_slug'] as String,
      requestCount: _toInt(json['total_requests'] ?? json['request_count']),
      totalCost: _toDouble(json['total_cost']),
    );
  }
}

class AIDailyUsage {
  final String date;
  final String featureSlug;
  final int requestCount;
  final int cachedCount;
  final int errorCount;
  final int totalTokens;
  final double totalCost;
  final int avgResponseMs;

  const AIDailyUsage({
    required this.date,
    required this.featureSlug,
    this.requestCount = 0,
    this.cachedCount = 0,
    this.errorCount = 0,
    this.totalTokens = 0,
    this.totalCost = 0,
    this.avgResponseMs = 0,
  });

  factory AIDailyUsage.fromJson(Map<String, dynamic> json) {
    return AIDailyUsage(
      date: json['date'] as String,
      featureSlug: json['feature_slug'] as String? ?? '',
      requestCount: _toInt(json['request_count'] ?? json['total_requests']),
      cachedCount: _toInt(json['cached_count'] ?? json['cached_requests']),
      errorCount: _toInt(json['error_count'] ?? json['failed_requests']),
      totalTokens: _toInt(json['total_tokens']) + _toInt(json['total_input_tokens']) + _toInt(json['total_output_tokens']),
      totalCost: _toDouble(json['total_cost'] ?? json['total_estimated_cost_usd']),
      avgResponseMs: _toInt(json['avg_response_ms']),
    );
  }
}
