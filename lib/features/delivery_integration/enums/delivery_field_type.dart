enum DeliveryFieldType {
  text('text'),
  password('password'),
  url('url');

  const DeliveryFieldType(this.value);
  final String value;

  static DeliveryFieldType fromValue(String value) {
    return DeliveryFieldType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryFieldType: $value'),
    );
  }

  static DeliveryFieldType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
