enum StoreCreditTransactionType {
  refundCredit('refund_credit'),
  topUp('top_up'),
  spend('spend'),
  adjust('adjust');

  const StoreCreditTransactionType(this.value);
  final String value;

  static StoreCreditTransactionType fromValue(String value) {
    return StoreCreditTransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StoreCreditTransactionType: $value'),
    );
  }

  static StoreCreditTransactionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
