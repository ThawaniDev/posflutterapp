enum KitchenTicketStatus {
  pending('pending'),
  preparing('preparing'),
  ready('ready'),
  served('served');

  const KitchenTicketStatus(this.value);
  final String value;

  static KitchenTicketStatus fromValue(String value) {
    return KitchenTicketStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid KitchenTicketStatus: $value'),
    );
  }

  static KitchenTicketStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
