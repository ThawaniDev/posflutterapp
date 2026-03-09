enum CfdIdleLayout {
  slideshow('slideshow'),
  staticImage('static_image'),
  videoLoop('video_loop');

  const CfdIdleLayout(this.value);
  final String value;

  static CfdIdleLayout fromValue(String value) {
    return CfdIdleLayout.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CfdIdleLayout: $value'),
    );
  }

  static CfdIdleLayout? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
