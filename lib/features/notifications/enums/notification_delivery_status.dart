enum NotificationDeliveryStatus {
  pending('pending'),
  sent('sent'),
  delivered('delivered'),
  failed('failed');

  const NotificationDeliveryStatus(this.value);
  final String value;

  static NotificationDeliveryStatus fromValue(String value) {
    return NotificationDeliveryStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid NotificationDeliveryStatus: $value'),
    );
  }

  static NotificationDeliveryStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
