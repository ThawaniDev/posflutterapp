enum OpenTabStatus {
  open('open'),
  closed('closed');

  const OpenTabStatus(this.value);
  final String value;

  static OpenTabStatus fromValue(String value) {
    return OpenTabStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid OpenTabStatus: $value'),
    );
  }

  static OpenTabStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
