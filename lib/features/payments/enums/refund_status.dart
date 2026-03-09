enum RefundStatus {
  completed('completed'),
  pending('pending'),
  failed('failed');

  const RefundStatus(this.value);
  final String value;

  static RefundStatus fromValue(String value) {
    return RefundStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid RefundStatus: $value'),
    );
  }

  static RefundStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
