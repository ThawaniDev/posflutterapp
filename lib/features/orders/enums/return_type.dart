enum ReturnType {
  full('full'),
  partial('partial');

  const ReturnType(this.value);
  final String value;

  static ReturnType fromValue(String value) {
    return ReturnType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ReturnType: $value'),
    );
  }

  static ReturnType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
