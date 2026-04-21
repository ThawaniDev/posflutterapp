import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';

class CashierAnomaly {

  const CashierAnomaly({
    required this.id,
    required this.storeId,
    required this.cashierId,
    this.cashier,
    this.snapshotId,
    required this.anomalyType,
    required this.severity,
    this.riskScore = 0,
    this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.metricName,
    this.metricValue = 0,
    this.storeAverage = 0,
    this.storeStddev = 0,
    this.zScore = 0,
    this.referenceIds = const [],
    required this.detectedDate,
    this.isReviewed = false,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    this.createdAt,
  });

  factory CashierAnomaly.fromJson(Map<String, dynamic> json) {
    return CashierAnomaly(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      cashierId: json['cashier_id'] as String,
      cashier: json['cashier'] != null ? CashierInfo.fromJson(json['cashier'] as Map<String, dynamic>) : null,
      snapshotId: json['snapshot_id'] as String?,
      anomalyType: json['anomaly_type'] as String,
      severity: json['severity'] as String,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0,
      titleEn: json['title_en'] as String?,
      titleAr: json['title_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      metricName: json['metric_name'] as String?,
      metricValue: (json['metric_value'] as num?)?.toDouble() ?? 0,
      storeAverage: (json['store_average'] as num?)?.toDouble() ?? 0,
      storeStddev: (json['store_stddev'] as num?)?.toDouble() ?? 0,
      zScore: (json['z_score'] as num?)?.toDouble() ?? 0,
      referenceIds: (json['reference_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
      detectedDate: json['detected_date'] as String,
      isReviewed: json['is_reviewed'] as bool? ?? false,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at'] as String) : null,
      reviewNotes: json['review_notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String cashierId;
  final CashierInfo? cashier;
  final String? snapshotId;
  final String anomalyType;
  final String severity;
  final double riskScore;
  final String? titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? metricName;
  final double metricValue;
  final double storeAverage;
  final double storeStddev;
  final double zScore;
  final List<String> referenceIds;
  final String detectedDate;
  final bool isReviewed;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashierAnomaly && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
