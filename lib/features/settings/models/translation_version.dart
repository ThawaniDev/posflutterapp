class TranslationVersion {

  const TranslationVersion({
    required this.id,
    required this.versionHash,
    this.publishedAt,
    this.publishedBy,
    this.notes,
  });

  factory TranslationVersion.fromJson(Map<String, dynamic> json) {
    return TranslationVersion(
      id: json['id'] as String,
      versionHash: json['version_hash'] as String,
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : null,
      publishedBy: json['published_by'] as String?,
      notes: json['notes'] as String?,
    );
  }
  final String id;
  final String versionHash;
  final DateTime? publishedAt;
  final String? publishedBy;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version_hash': versionHash,
      'published_at': publishedAt?.toIso8601String(),
      'published_by': publishedBy,
      'notes': notes,
    };
  }

  TranslationVersion copyWith({
    String? id,
    String? versionHash,
    DateTime? publishedAt,
    String? publishedBy,
    String? notes,
  }) {
    return TranslationVersion(
      id: id ?? this.id,
      versionHash: versionHash ?? this.versionHash,
      publishedAt: publishedAt ?? this.publishedAt,
      publishedBy: publishedBy ?? this.publishedBy,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationVersion && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TranslationVersion(id: $id, versionHash: $versionHash, publishedAt: $publishedAt, publishedBy: $publishedBy, notes: $notes)';
}
