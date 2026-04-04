class Notification {
  final String id;
  final String type;
  final String notifiableType;
  final String notifiableId;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime? createdAt;
  final String? priority;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;
  final String? channel;
  final String? category;
  final String? title;
  final String? message;

  const Notification({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    this.createdAt,
    this.priority,
    this.expiresAt,
    this.metadata,
    this.channel,
    this.category,
    this.title,
    this.message,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      notifiableType: json['notifiable_type'] as String? ?? '',
      notifiableId: json['notifiable_id'] as String? ?? '',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data'] as Map) : {},
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      priority: json['priority'] as String?,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
      channel: json['channel'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'data': data,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'priority': priority,
      'expires_at': expiresAt?.toIso8601String(),
      'metadata': metadata,
      'channel': channel,
      'category': category,
      'title': title,
      'message': message,
    };
  }

  bool get isRead => readAt != null;

  Notification copyWith({
    String? id,
    String? type,
    String? notifiableType,
    String? notifiableId,
    Map<String, dynamic>? data,
    DateTime? readAt,
    DateTime? createdAt,
    String? priority,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
    String? channel,
    String? category,
    String? title,
    String? message,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
      channel: channel ?? this.channel,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Notification && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Notification(id: $id, type: $type, notifiableType: $notifiableType, notifiableId: $notifiableId, data: $data, readAt: $readAt, ...)';
}
