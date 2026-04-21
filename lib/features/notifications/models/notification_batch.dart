class NotificationBatch {

  const NotificationBatch({
    required this.id,
    required this.storeId,
    required this.category,
    required this.title,
    required this.message,
    this.priority,
    this.channel,
    this.totalRecipients = 0,
    this.sentCount = 0,
    this.failedCount = 0,
    this.createdAt,
  });

  factory NotificationBatch.fromJson(Map<String, dynamic> json) {
    return NotificationBatch(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      priority: json['priority'] as String?,
      channel: json['channel'] as String?,
      totalRecipients: (json['total_recipients'] as num?)?.toInt() ?? 0,
      sentCount: (json['sent_count'] as num?)?.toInt() ?? 0,
      failedCount: (json['failed_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String category;
  final String title;
  final String message;
  final String? priority;
  final String? channel;
  final int totalRecipients;
  final int sentCount;
  final int failedCount;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'category': category,
      'title': title,
      'message': message,
      'priority': priority,
      'channel': channel,
      'total_recipients': totalRecipients,
      'sent_count': sentCount,
      'failed_count': failedCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  NotificationBatch copyWith({
    String? id,
    String? storeId,
    String? category,
    String? title,
    String? message,
    String? priority,
    String? channel,
    int? totalRecipients,
    int? sentCount,
    int? failedCount,
    DateTime? createdAt,
  }) {
    return NotificationBatch(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      channel: channel ?? this.channel,
      totalRecipients: totalRecipients ?? this.totalRecipients,
      sentCount: sentCount ?? this.sentCount,
      failedCount: failedCount ?? this.failedCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationBatch && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationBatch(id: $id, category: $category, title: $title, totalRecipients: $totalRecipients)';
}
