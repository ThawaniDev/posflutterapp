enum GiftCardTransactionType {
  redemption('redemption'),
  topUp('top_up'),
  refund('refund');

  const GiftCardTransactionType(this.value);
  final String value;

  static GiftCardTransactionType fromValue(String value) {
    return GiftCardTransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GiftCardTransactionType: $value'),
    );
  }

  static GiftCardTransactionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
