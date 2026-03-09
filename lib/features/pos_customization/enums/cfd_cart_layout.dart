enum CfdCartLayout {
  list('list'),
  grid('grid');

  const CfdCartLayout(this.value);
  final String value;

  static CfdCartLayout fromValue(String value) {
    return CfdCartLayout.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CfdCartLayout: $value'),
    );
  }

  static CfdCartLayout? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
