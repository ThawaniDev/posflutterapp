enum SignageTemplateType {
  menuBoard('menu_board'),
  promoSlideshow('promo_slideshow'),
  queueDisplay('queue_display'),
  infoBoard('info_board');

  const SignageTemplateType(this.value);
  final String value;

  static SignageTemplateType fromValue(String value) {
    return SignageTemplateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SignageTemplateType: $value'),
    );
  }

  static SignageTemplateType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
