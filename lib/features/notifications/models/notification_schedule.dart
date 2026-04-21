class NotificationSchedule {

  const NotificationSchedule({
    required this.id,
    required this.storeId,
    this.userId,
    required this.category,
    required this.title,
    required this.message,
    this.channel,
    this.priority,
    required this.scheduledAt,
    this.recurrenceRule,
    this.scheduleType,
    this.isActive = true,
    this.lastSentAt,
    this.createdAt,
  });

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) {
    return NotificationSchedule(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      userId: json['created_by'] as String? ?? json['user_id'] as String?,
      category: json['category'] as String? ?? json['event_key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      channel: json['channel'] as String?,
      priority: json['priority'] as String?,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      recurrenceRule: json['cron_expression'] as String? ?? json['recurrence_rule'] as String?,
      scheduleType: json['schedule_type'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      lastSentAt: json['last_sent_at'] != null ? DateTime.parse(json['last_sent_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? userId;
  final String category;
  final String title;
  final String message;
  final String? channel;
  final String? priority;
  final DateTime scheduledAt;
  final String? recurrenceRule;
  final String? scheduleType;
  final bool isActive;
  final DateTime? lastSentAt;
  final DateTime? createdAt;

  bool get isCancelled => !isActive;
  bool get isSent => lastSentAt != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'category': category,
      'title': title,
      'message': message,
      'channel': channel,
      'priority': priority,
      'scheduled_at': scheduledAt.toIso8601String(),
      'recurrence_rule': recurrenceRule,
      'schedule_type': scheduleType,
      'is_active': isActive,
      'last_sent_at': lastSentAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  NotificationSchedule copyWith({
    String? id,
    String? storeId,
    String? userId,
    String? category,
    String? title,
    String? message,
    String? channel,
    String? priority,
    DateTime? scheduledAt,
    String? recurrenceRule,
    String? scheduleType,
    bool? isActive,
    DateTime? lastSentAt,
    DateTime? createdAt,
  }) {
    return NotificationSchedule(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      channel: channel ?? this.channel,
      priority: priority ?? this.priority,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      scheduleType: scheduleType ?? this.scheduleType,
      isActive: isActive ?? this.isActive,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationSchedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationSchedule(id: $id, category: $category, title: $title, scheduledAt: $scheduledAt, isCancelled: $isCancelled)';
}
