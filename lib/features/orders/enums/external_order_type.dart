enum ExternalOrderType {
  thawani('thawani'),
  hungerstation('hungerstation'),
  keeta('keeta');

  const ExternalOrderType(this.value);
  final String value;

  static ExternalOrderType fromValue(String value) {
    return ExternalOrderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ExternalOrderType: $value'),
    );
  }

  static ExternalOrderType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
