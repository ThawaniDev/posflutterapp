enum SessionStatus {
  /// Actively running session (backend: 'active')
  active('active'),

  /// Session has expired due to inactivity (backend: 'expired')
  expired('expired'),

  /// Session was forcefully revoked (backend: 'revoked')
  revoked('revoked'),

  /// Session was normally closed / ended (backend: 'closed')
  closed('closed'),

  /// Legacy alias for 'active' (may come from older client data)
  open('open');

  const SessionStatus(this.value);
  final String value;

  bool get isActive => this == SessionStatus.active || this == SessionStatus.open;

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
