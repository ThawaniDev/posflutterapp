class NotificationSchedule {
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
  final bool isCancelled;
  final DateTime? sentAt;
  final DateTime? createdAt;

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
    this.isCancelled = false,
    this.sentAt,
    this.createdAt,
  });

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) {
    return NotificationSchedule(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String?,
      category: json['category'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      channel: json['channel'] as String?,
      priority: json['priority'] as String?,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      recurrenceRule: json['recurrence_rule'] as String?,
      isCancelled: json['is_cancelled'] as bool? ?? false,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

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
      'is_cancelled': isCancelled,
      'sent_at': sentAt?.toIso8601String(),
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
    bool? isCancelled,
    DateTime? sentAt,
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
      isCancelled: isCancelled ?? this.isCancelled,
      sentAt: sentAt ?? this.sentAt,
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
