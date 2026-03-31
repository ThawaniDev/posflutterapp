enum WasteReason {
  expired('expired'),
  damaged('damaged'),
  spillage('spillage'),
  overproduction('overproduction'),
  qualityIssue('quality_issue'),
  other('other');

  const WasteReason(this.value);
  final String value;

  static WasteReason fromValue(String value) {
    return WasteReason.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid WasteReason: $value'),
    );
  }

  static WasteReason? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
