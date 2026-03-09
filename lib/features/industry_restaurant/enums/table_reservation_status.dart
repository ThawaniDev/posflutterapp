enum TableReservationStatus {
  confirmed('confirmed'),
  seated('seated'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  const TableReservationStatus(this.value);
  final String value;

  static TableReservationStatus fromValue(String value) {
    return TableReservationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TableReservationStatus: $value'),
    );
  }

  static TableReservationStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
