class SecurityIncident {
  final String id;
  final String storeId;
  final String type;
  final String severity;
  final String title;
  final String? description;
  final String? userId;
  final String? deviceId;
  final String? ipAddress;
  final Map<String, dynamic>? details;
  final bool isResolved;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final String? resolutionNotes;
  final DateTime? createdAt;

  const SecurityIncident({
    required this.id,
    required this.storeId,
    required this.type,
    required this.severity,
    required this.title,
    this.description,
    this.userId,
    this.deviceId,
    this.ipAddress,
    this.details,
    this.isResolved = false,
    this.resolvedBy,
    this.resolvedAt,
    this.resolutionNotes,
    this.createdAt,
  });

  factory SecurityIncident.fromJson(Map<String, dynamic> json) {
    return SecurityIncident(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      deviceId: json['device_id'] as String?,
      ipAddress: json['ip_address'] as String?,
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      isResolved: json['is_resolved'] as bool? ?? false,
      resolvedBy: json['resolved_by'] as String?,
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
      resolutionNotes: json['resolution_notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'type': type,
      'severity': severity,
      'title': title,
      'description': description,
      'user_id': userId,
      'device_id': deviceId,
      'ip_address': ipAddress,
      'details': details,
      'is_resolved': isResolved,
      'resolved_by': resolvedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolution_notes': resolutionNotes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SecurityIncident copyWith({
    String? id,
    String? storeId,
    String? type,
    String? severity,
    String? title,
    String? description,
    String? userId,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? details,
    bool? isResolved,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? resolutionNotes,
    DateTime? createdAt,
  }) {
    return SecurityIncident(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      ipAddress: ipAddress ?? this.ipAddress,
      details: details ?? this.details,
      isResolved: isResolved ?? this.isResolved,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SecurityIncident && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SecurityIncident(id: $id, type: $type, severity: $severity, title: $title, isResolved: $isResolved)';
}
