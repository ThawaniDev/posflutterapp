enum OrderStatus {
  newValue('new'),
  confirmed('confirmed'),
  preparing('preparing'),
  ready('ready'),
  dispatched('dispatched'),
  delivered('delivered'),
  pickedUp('picked_up'),
  completed('completed'),
  cancelled('cancelled'),
  voided('voided');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromValue(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid OrderStatus: $value'),
    );
  }

  static OrderStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
