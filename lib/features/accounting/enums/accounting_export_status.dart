enum AccountingExportStatus {
  pending('pending'),
  processing('processing'),
  success('success'),
  failed('failed');

  const AccountingExportStatus(this.value);
  final String value;

  static AccountingExportStatus fromValue(String value) {
    return AccountingExportStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AccountingExportStatus: $value'),
    );
  }

  static AccountingExportStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
