enum TransactionType {
  sale('sale'),
  returnValue('return'),
  voidValue('void'),
  exchange('exchange');

  const TransactionType(this.value);
  final String value;

  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TransactionType: $value'),
    );
  }

  static TransactionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
