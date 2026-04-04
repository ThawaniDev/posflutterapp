class NotificationReadReceipt {
  final String id;
  final String notificationId;
  final String userId;
  final String readVia;
  final DateTime? readAt;

  const NotificationReadReceipt({
    required this.id,
    required this.notificationId,
    required this.userId,
    required this.readVia,
    this.readAt,
  });

  factory NotificationReadReceipt.fromJson(Map<String, dynamic> json) {
    return NotificationReadReceipt(
      id: json['id'] as String,
      notificationId: json['notification_id'] as String,
      userId: json['user_id'] as String,
      readVia: json['read_via'] as String,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'user_id': userId,
      'read_via': readVia,
      'read_at': readAt?.toIso8601String(),
    };
  }

  NotificationReadReceipt copyWith({String? id, String? notificationId, String? userId, String? readVia, DateTime? readAt}) {
    return NotificationReadReceipt(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      readVia: readVia ?? this.readVia,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationReadReceipt && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationReadReceipt(id: $id, notificationId: $notificationId, userId: $userId, readVia: $readVia)';
}
