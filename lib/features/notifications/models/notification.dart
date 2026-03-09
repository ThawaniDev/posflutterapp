class Notification {
  final String id;
  final String type;
  final String notifiableType;
  final String notifiableId;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime? createdAt;

  const Notification({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      type: json['type'] as String,
      notifiableType: json['notifiable_type'] as String,
      notifiableId: json['notifiable_id'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
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
    };
  }

  Notification copyWith({
    String? id,
    String? type,
    String? notifiableType,
    String? notifiableId,
    Map<String, dynamic>? data,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notification && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Notification(id: $id, type: $type, notifiableType: $notifiableType, notifiableId: $notifiableId, data: $data, readAt: $readAt, ...)';
}
