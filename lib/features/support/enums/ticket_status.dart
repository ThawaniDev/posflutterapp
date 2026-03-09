enum TicketStatus {
  open('open'),
  inProgress('in_progress'),
  resolved('resolved'),
  closed('closed');

  const TicketStatus(this.value);
  final String value;

  static TicketStatus fromValue(String value) {
    return TicketStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TicketStatus: $value'),
    );
  }

  static TicketStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
