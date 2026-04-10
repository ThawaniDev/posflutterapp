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
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
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
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
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
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
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
      featureSlug: json['feature_slug'] as String,
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      cachedCount: (json['cached_count'] as num?)?.toInt() ?? 0,
      errorCount: (json['error_count'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      avgResponseMs: (json['avg_response_ms'] as num?)?.toInt() ?? 0,
    );
  }
}
