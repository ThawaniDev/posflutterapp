enum OrderSource {
  pos('pos'),
  thawani('thawani'),
  hungerstation('hungerstation'),
  jahez('jahez'),
  marsool('marsool'),
  phone('phone'),
  web('web'),
  delivery('delivery');

  const OrderSource(this.value);
  final String value;

  static OrderSource fromValue(String value) {
    return OrderSource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid OrderSource: $value'),
    );
  }

  static OrderSource? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
