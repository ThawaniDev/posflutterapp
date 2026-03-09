enum ExportTriggeredBy {
  manual('manual'),
  scheduled('scheduled');

  const ExportTriggeredBy(this.value);
  final String value;

  static ExportTriggeredBy fromValue(String value) {
    return ExportTriggeredBy.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ExportTriggeredBy: $value'),
    );
  }

  static ExportTriggeredBy? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
