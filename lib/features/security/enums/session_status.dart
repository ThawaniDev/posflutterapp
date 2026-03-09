enum SessionStatus {
  open('open'),
  closed('closed');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromValue(String value) {
    return SessionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SessionStatus: $value'),
    );
  }

  static SessionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
