enum WidgetCategory {
  core('core'),
  commerce('commerce'),
  display('display'),
  utility('utility'),
  custom('custom');

  const WidgetCategory(this.value);
  final String value;

  static WidgetCategory fromValue(String value) {
    return WidgetCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid WidgetCategory: $value'),
    );
  }

  static WidgetCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
