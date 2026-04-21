class GamificationSettings {

  const GamificationSettings({
    required this.id,
    required this.storeId,
    this.leaderboardEnabled = true,
    this.badgesEnabled = true,
    this.anomalyDetectionEnabled = true,
    this.shiftReportsEnabled = true,
    this.autoGenerateOnSessionClose = true,
    this.anomalyZScoreThreshold = 2.0,
    this.riskScoreVoidWeight = 0.35,
    this.riskScoreNoSaleWeight = 0.25,
    this.riskScoreDiscountWeight = 0.20,
    this.riskScorePriceOverrideWeight = 0.20,
    this.createdAt,
    this.updatedAt,
  });

  factory GamificationSettings.fromJson(Map<String, dynamic> json) {
    return GamificationSettings(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      leaderboardEnabled: json['leaderboard_enabled'] as bool? ?? true,
      badgesEnabled: json['badges_enabled'] as bool? ?? true,
      anomalyDetectionEnabled: json['anomaly_detection_enabled'] as bool? ?? true,
      shiftReportsEnabled: json['shift_reports_enabled'] as bool? ?? true,
      autoGenerateOnSessionClose: json['auto_generate_on_session_close'] as bool? ?? true,
      anomalyZScoreThreshold: (json['anomaly_z_score_threshold'] as num?)?.toDouble() ?? 2.0,
      riskScoreVoidWeight: (json['risk_score_void_weight'] as num?)?.toDouble() ?? 0.35,
      riskScoreNoSaleWeight: (json['risk_score_no_sale_weight'] as num?)?.toDouble() ?? 0.25,
      riskScoreDiscountWeight: (json['risk_score_discount_weight'] as num?)?.toDouble() ?? 0.20,
      riskScorePriceOverrideWeight: (json['risk_score_price_override_weight'] as num?)?.toDouble() ?? 0.20,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final bool leaderboardEnabled;
  final bool badgesEnabled;
  final bool anomalyDetectionEnabled;
  final bool shiftReportsEnabled;
  final bool autoGenerateOnSessionClose;
  final double anomalyZScoreThreshold;
  final double riskScoreVoidWeight;
  final double riskScoreNoSaleWeight;
  final double riskScoreDiscountWeight;
  final double riskScorePriceOverrideWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'leaderboard_enabled': leaderboardEnabled,
      'badges_enabled': badgesEnabled,
      'anomaly_detection_enabled': anomalyDetectionEnabled,
      'shift_reports_enabled': shiftReportsEnabled,
      'auto_generate_on_session_close': autoGenerateOnSessionClose,
      'anomaly_z_score_threshold': anomalyZScoreThreshold,
      'risk_score_void_weight': riskScoreVoidWeight,
      'risk_score_no_sale_weight': riskScoreNoSaleWeight,
      'risk_score_discount_weight': riskScoreDiscountWeight,
      'risk_score_price_override_weight': riskScorePriceOverrideWeight,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GamificationSettings && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
