enum StockTransferStatus {
  pending('pending'),
  inTransit('in_transit'),
  completed('completed'),
  cancelled('cancelled');

  const StockTransferStatus(this.value);
  final String value;

  static StockTransferStatus fromValue(String value) {
    return StockTransferStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StockTransferStatus: $value'),
    );
  }

  static StockTransferStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
