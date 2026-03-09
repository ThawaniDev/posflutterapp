enum TicketPriority {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const TicketPriority(this.value);
  final String value;

  static TicketPriority fromValue(String value) {
    return TicketPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TicketPriority: $value'),
    );
  }

  static TicketPriority? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
