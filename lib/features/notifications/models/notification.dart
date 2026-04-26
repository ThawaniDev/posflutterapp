class Notification {

  const Notification({
    required this.id,
    this.userId,
    this.storeId,
    this.category,
    this.title,
    this.message,
    this.actionUrl,
    this.referenceType,
    this.referenceId,
    this.isRead = false,
    this.createdAt,
    this.priority,
    this.channel,
    this.expiresAt,
    this.readAt,
    this.metadata,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      storeId: json['store_id'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      actionUrl: json['action_url'] as String?,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      priority: json['priority'] as String?,
      channel: json['channel'] as String?,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
    );
  }
  final String id;
  final String? userId;
  final String? storeId;
  final String? category;
  final String? title;
  final String? message;
  final String? actionUrl;
  final String? referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime? createdAt;
  final String? priority;
  final String? channel;
  final DateTime? expiresAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_id': storeId,
      'category': category,
      'title': title,
      'message': message,
      'action_url': actionUrl,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
      'priority': priority,
      'channel': channel,
      'expires_at': expiresAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? storeId,
    String? category,
    String? title,
    String? message,
    String? actionUrl,
    String? referenceType,
    String? referenceId,
    bool? isRead,
    DateTime? createdAt,
    String? priority,
    String? channel,
    DateTime? expiresAt,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      actionUrl: actionUrl ?? this.actionUrl,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      channel: channel ?? this.channel,
      expiresAt: expiresAt ?? this.expiresAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Notification && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Notification(id: $id, userId: $userId, storeId: $storeId, category: $category, title: $title, isRead: $isRead, priority: $priority, channel: $channel)';
}
