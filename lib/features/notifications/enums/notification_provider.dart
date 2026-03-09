enum NotificationProvider {
  unifonic('unifonic'),
  taqnyat('taqnyat'),
  msegat('msegat'),
  mailgun('mailgun'),
  ses('ses'),
  smtp('smtp');

  const NotificationProvider(this.value);
  final String value;

  static NotificationProvider fromValue(String value) {
    return NotificationProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid NotificationProvider: $value'),
    );
  }

  static NotificationProvider? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
