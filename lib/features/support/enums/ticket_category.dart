enum TicketCategory {
  billing('billing'),
  technical('technical'),
  zatca('zatca'),
  featureRequest('feature_request'),
  general('general'),
  hardware('hardware');

  const TicketCategory(this.value);
  final String value;

  static TicketCategory fromValue(String value) {
    return TicketCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TicketCategory: $value'),
    );
  }

  static TicketCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
