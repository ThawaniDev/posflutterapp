class PlatformUiDefault {

  const PlatformUiDefault({
    this.key,
    required this.value,
  });

  factory PlatformUiDefault.fromJson(Map<String, dynamic> json) {
    return PlatformUiDefault(
      key: json['key'] as String?,
      value: json['value'] as String,
    );
  }
  final String? key;
  final String value;

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  PlatformUiDefault copyWith({
    String? key,
    String? value,
  }) {
    return PlatformUiDefault(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformUiDefault && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'PlatformUiDefault(key: $key, value: $value)';
}
