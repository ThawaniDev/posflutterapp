enum AccountingProvider {
  quickbooks('quickbooks'),
  xero('xero'),
  qoyod('qoyod');

  const AccountingProvider(this.value);
  final String value;

  static AccountingProvider fromValue(String value) {
    return AccountingProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AccountingProvider: $value'),
    );
  }

  static AccountingProvider? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
