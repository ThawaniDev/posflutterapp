enum CashEventType {
  cashIn('cash_in'),
  cashOut('cash_out');

  const CashEventType(this.value);
  final String value;

  static CashEventType fromValue(String value) {
    return CashEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CashEventType: $value'),
    );
  }

  static CashEventType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
