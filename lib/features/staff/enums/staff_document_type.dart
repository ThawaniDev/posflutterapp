enum StaffDocumentType {
  nationalId('national_id'),
  contract('contract'),
  certificate('certificate'),
  visa('visa');

  const StaffDocumentType(this.value);
  final String value;

  static StaffDocumentType fromValue(String value) {
    return StaffDocumentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StaffDocumentType: $value'),
    );
  }

  static StaffDocumentType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
