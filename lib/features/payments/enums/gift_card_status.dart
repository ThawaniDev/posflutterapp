enum GiftCardStatus {
  active('active'),
  redeemed('redeemed'),
  expired('expired'),
  deactivated('deactivated');

  const GiftCardStatus(this.value);
  final String value;

  static GiftCardStatus fromValue(String value) {
    return GiftCardStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GiftCardStatus: $value'),
    );
  }

  static GiftCardStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
