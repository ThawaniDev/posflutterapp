enum TicketSenderType {
  provider('provider'),
  admin('admin');

  const TicketSenderType(this.value);
  final String value;

  static TicketSenderType fromValue(String value) {
    return TicketSenderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TicketSenderType: $value'),
    );
  }

  static TicketSenderType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
