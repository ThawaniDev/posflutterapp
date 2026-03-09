enum WasteReasonCategory {
  spoilage('spoilage'),
  damage('damage'),
  theft('theft'),
  sampling('sampling'),
  operational('operational');

  const WasteReasonCategory(this.value);
  final String value;

  static WasteReasonCategory fromValue(String value) {
    return WasteReasonCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid WasteReasonCategory: $value'),
    );
  }

  static WasteReasonCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
