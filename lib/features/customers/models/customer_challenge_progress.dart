class CustomerChallengeProgress {
  final String id;
  final String customerId;
  final String challengeId;
  final double? currentValue;
  final bool? isCompleted;
  final DateTime? completedAt;
  final bool? rewardClaimed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomerChallengeProgress({
    required this.id,
    required this.customerId,
    required this.challengeId,
    this.currentValue,
    this.isCompleted,
    this.completedAt,
    this.rewardClaimed,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerChallengeProgress.fromJson(Map<String, dynamic> json) {
    return CustomerChallengeProgress(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      challengeId: json['challenge_id'] as String,
      currentValue: (json['current_value'] as num?)?.toDouble(),
      isCompleted: json['is_completed'] as bool?,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      rewardClaimed: json['reward_claimed'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'challenge_id': challengeId,
      'current_value': currentValue,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'reward_claimed': rewardClaimed,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CustomerChallengeProgress copyWith({
    String? id,
    String? customerId,
    String? challengeId,
    double? currentValue,
    bool? isCompleted,
    DateTime? completedAt,
    bool? rewardClaimed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerChallengeProgress(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      challengeId: challengeId ?? this.challengeId,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerChallengeProgress && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomerChallengeProgress(id: $id, customerId: $customerId, challengeId: $challengeId, currentValue: $currentValue, isCompleted: $isCompleted, completedAt: $completedAt, ...)';
}
