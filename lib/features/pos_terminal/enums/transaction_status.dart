enum TransactionStatus {
  completed('completed'),
  voided('voided'),
  pending('pending');

  const TransactionStatus(this.value);
  final String value;

  static TransactionStatus fromValue(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TransactionStatus: $value'),
    );
  }

  static TransactionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
