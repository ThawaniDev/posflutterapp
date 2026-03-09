enum SystemSettingsGroup {
  zatca('zatca'),
  payment('payment'),
  sms('sms'),
  email('email'),
  push('push'),
  whatsapp('whatsapp'),
  sync('sync'),
  vat('vat'),
  locale('locale'),
  maintenance('maintenance');

  const SystemSettingsGroup(this.value);
  final String value;

  static SystemSettingsGroup fromValue(String value) {
    return SystemSettingsGroup.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SystemSettingsGroup: $value'),
    );
  }

  static SystemSettingsGroup? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
