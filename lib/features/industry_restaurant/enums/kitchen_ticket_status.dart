enum KitchenTicketStatus {
  pending('pending'),
  inProgress('in_progress'),
  preparing('preparing'),
  ready('ready'),
  served('served'),
  cancelled('cancelled');

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
