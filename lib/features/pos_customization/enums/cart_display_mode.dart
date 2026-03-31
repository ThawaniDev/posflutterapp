enum CartDisplayMode {
  compact('compact'),
  detailed('detailed'),
  list('list');

  const CartDisplayMode(this.value);
  final String value;

  static CartDisplayMode fromValue(String value) {
    return CartDisplayMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CartDisplayMode: $value'),
    );
  }

  static CartDisplayMode? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
