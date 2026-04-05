class PlatformDailyStat {
  final String id;
  final DateTime date;
  final int totalActiveStores;
  final int newRegistrations;
  final int totalOrders;
  final double totalGmv;
  final double totalMrr;
  final int churnCount;
  final DateTime? createdAt;

  const PlatformDailyStat({
    required this.id,
    required this.date,
    required this.totalActiveStores,
    required this.newRegistrations,
    required this.totalOrders,
    required this.totalGmv,
    required this.totalMrr,
    required this.churnCount,
    this.createdAt,
  });

  factory PlatformDailyStat.fromJson(Map<String, dynamic> json) {
    return PlatformDailyStat(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      totalActiveStores: (json['total_active_stores'] as num).toInt(),
      newRegistrations: (json['new_registrations'] as num).toInt(),
      totalOrders: (json['total_orders'] as num).toInt(),
      totalGmv: double.tryParse(json['total_gmv'].toString()) ?? 0.0,
      totalMrr: double.tryParse(json['total_mrr'].toString()) ?? 0.0,
      churnCount: (json['churn_count'] as num).toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'total_active_stores': totalActiveStores,
      'new_registrations': newRegistrations,
      'total_orders': totalOrders,
      'total_gmv': totalGmv,
      'total_mrr': totalMrr,
      'churn_count': churnCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PlatformDailyStat copyWith({
    String? id,
    DateTime? date,
    int? totalActiveStores,
    int? newRegistrations,
    int? totalOrders,
    double? totalGmv,
    double? totalMrr,
    int? churnCount,
    DateTime? createdAt,
  }) {
    return PlatformDailyStat(
      id: id ?? this.id,
      date: date ?? this.date,
      totalActiveStores: totalActiveStores ?? this.totalActiveStores,
      newRegistrations: newRegistrations ?? this.newRegistrations,
      totalOrders: totalOrders ?? this.totalOrders,
      totalGmv: totalGmv ?? this.totalGmv,
      totalMrr: totalMrr ?? this.totalMrr,
      churnCount: churnCount ?? this.churnCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformDailyStat && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlatformDailyStat(id: $id, date: $date, totalActiveStores: $totalActiveStores, newRegistrations: $newRegistrations, totalOrders: $totalOrders, totalGmv: $totalGmv, ...)';
}
