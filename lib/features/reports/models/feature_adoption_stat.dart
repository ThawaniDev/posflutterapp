class FeatureAdoptionStat {

  const FeatureAdoptionStat({
    required this.id,
    required this.featureKey,
    required this.date,
    required this.storesUsingCount,
    required this.totalEvents,
  });

  factory FeatureAdoptionStat.fromJson(Map<String, dynamic> json) {
    return FeatureAdoptionStat(
      id: json['id'] as String,
      featureKey: json['feature_key'] as String,
      date: DateTime.parse(json['date'] as String),
      storesUsingCount: (json['stores_using_count'] as num).toInt(),
      totalEvents: (json['total_events'] as num).toInt(),
    );
  }
  final String id;
  final String featureKey;
  final DateTime date;
  final int storesUsingCount;
  final int totalEvents;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feature_key': featureKey,
      'date': date.toIso8601String(),
      'stores_using_count': storesUsingCount,
      'total_events': totalEvents,
    };
  }

  FeatureAdoptionStat copyWith({
    String? id,
    String? featureKey,
    DateTime? date,
    int? storesUsingCount,
    int? totalEvents,
  }) {
    return FeatureAdoptionStat(
      id: id ?? this.id,
      featureKey: featureKey ?? this.featureKey,
      date: date ?? this.date,
      storesUsingCount: storesUsingCount ?? this.storesUsingCount,
      totalEvents: totalEvents ?? this.totalEvents,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureAdoptionStat && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FeatureAdoptionStat(id: $id, featureKey: $featureKey, date: $date, storesUsingCount: $storesUsingCount, totalEvents: $totalEvents)';
}
