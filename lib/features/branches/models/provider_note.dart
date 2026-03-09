class ProviderNote {
  final String id;
  final String organizationId;
  final String adminUserId;
  final String noteText;
  final DateTime? createdAt;

  const ProviderNote({
    required this.id,
    required this.organizationId,
    required this.adminUserId,
    required this.noteText,
    this.createdAt,
  });

  factory ProviderNote.fromJson(Map<String, dynamic> json) {
    return ProviderNote(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      adminUserId: json['admin_user_id'] as String,
      noteText: json['note_text'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'admin_user_id': adminUserId,
      'note_text': noteText,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProviderNote copyWith({
    String? id,
    String? organizationId,
    String? adminUserId,
    String? noteText,
    DateTime? createdAt,
  }) {
    return ProviderNote(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      adminUserId: adminUserId ?? this.adminUserId,
      noteText: noteText ?? this.noteText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderNote && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderNote(id: $id, organizationId: $organizationId, adminUserId: $adminUserId, noteText: $noteText, createdAt: $createdAt)';
}
