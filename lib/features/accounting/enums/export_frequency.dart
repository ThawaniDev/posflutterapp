enum ExportFrequency {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly');

  const ExportFrequency(this.value);
  final String value;

  static ExportFrequency fromValue(String value) {
    return ExportFrequency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ExportFrequency: $value'),
    );
  }

  static ExportFrequency? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
