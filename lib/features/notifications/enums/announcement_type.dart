enum AnnouncementType {
  info('info'),
  warning('warning'),
  maintenance('maintenance'),
  update('update');

  const AnnouncementType(this.value);
  final String value;

  static AnnouncementType fromValue(String value) {
    return AnnouncementType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AnnouncementType: $value'),
    );
  }

  static AnnouncementType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
