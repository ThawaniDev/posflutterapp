import 'package:wameedpos/features/cashier_gamification/models/cashier_badge.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';

class CashierBadgeAward {
  final String id;
  final String storeId;
  final String cashierId;
  final CashierInfo? cashier;
  final String badgeId;
  final CashierBadge? badge;
  final String? snapshotId;
  final String earnedDate;
  final String period;
  final double metricValue;
  final DateTime? createdAt;

  const CashierBadgeAward({
    required this.id,
    required this.storeId,
    required this.cashierId,
    this.cashier,
    required this.badgeId,
    this.badge,
    this.snapshotId,
    required this.earnedDate,
    required this.period,
    this.metricValue = 0,
    this.createdAt,
  });

  factory CashierBadgeAward.fromJson(Map<String, dynamic> json) {
    return CashierBadgeAward(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      cashierId: json['cashier_id'] as String,
      cashier: json['cashier'] != null ? CashierInfo.fromJson(json['cashier'] as Map<String, dynamic>) : null,
      badgeId: json['badge_id'] as String,
      badge: json['badge'] != null ? CashierBadge.fromJson(json['badge'] as Map<String, dynamic>) : null,
      snapshotId: json['snapshot_id'] as String?,
      earnedDate: json['earned_date'] as String,
      period: json['period'] as String,
      metricValue: (json['metric_value'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashierBadgeAward && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
