enum RestaurantTableStatus {
  available('available'),
  occupied('occupied'),
  reserved('reserved'),
  cleaning('cleaning');

  const RestaurantTableStatus(this.value);
  final String value;

  static RestaurantTableStatus fromValue(String value) {
    return RestaurantTableStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid RestaurantTableStatus: $value'),
    );
  }

  static RestaurantTableStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
