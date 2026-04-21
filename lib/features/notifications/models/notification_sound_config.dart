class NotificationSoundConfig {

  const NotificationSoundConfig({
    required this.id,
    required this.storeId,
    required this.eventKey,
    required this.soundFile,
    this.volume = 1.0,
    this.isEnabled = true,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationSoundConfig.fromJson(Map<String, dynamic> json) {
    return NotificationSoundConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      eventKey: json['event_key'] as String,
      soundFile: json['sound_file'] as String,
      volume: (json['volume'] != null ? double.tryParse(json['volume'].toString()) : null) ?? 1.0,
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String eventKey;
  final String soundFile;
  final double volume;
  final bool isEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'event_key': eventKey,
      'sound_file': soundFile,
      'volume': volume,
      'is_enabled': isEnabled,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationSoundConfig copyWith({
    String? id,
    String? storeId,
    String? eventKey,
    String? soundFile,
    double? volume,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationSoundConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      eventKey: eventKey ?? this.eventKey,
      soundFile: soundFile ?? this.soundFile,
      volume: volume ?? this.volume,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationSoundConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationSoundConfig(id: $id, eventKey: $eventKey, soundFile: $soundFile, volume: $volume, isEnabled: $isEnabled)';
}
