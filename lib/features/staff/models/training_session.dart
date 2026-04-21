class TrainingSession {

  const TrainingSession({
    required this.id,
    required this.staffUserId,
    required this.storeId,
    required this.startedAt,
    this.endedAt,
    this.transactionsCount,
    this.notes,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      storeId: json['store_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at'] as String) : null,
      transactionsCount: (json['transactions_count'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );
  }
  final String id;
  final String staffUserId;
  final String storeId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? transactionsCount;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'store_id': storeId,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'transactions_count': transactionsCount,
      'notes': notes,
    };
  }

  TrainingSession copyWith({
    String? id,
    String? staffUserId,
    String? storeId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? transactionsCount,
    String? notes,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      storeId: storeId ?? this.storeId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      transactionsCount: transactionsCount ?? this.transactionsCount,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingSession && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TrainingSession(id: $id, staffUserId: $staffUserId, storeId: $storeId, startedAt: $startedAt, endedAt: $endedAt, transactionsCount: $transactionsCount, ...)';
}
