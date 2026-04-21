import 'package:wameedpos/features/settings/enums/calendar_system.dart';
import 'package:wameedpos/features/settings/enums/locale_direction.dart';

class SupportedLocale {

  const SupportedLocale({
    required this.id,
    required this.localeCode,
    required this.languageName,
    required this.languageNameNative,
    required this.direction,
    this.dateFormat,
    this.numberFormat,
    this.calendarSystem,
    this.isActive,
    this.isDefault,
    this.createdAt,
  });

  factory SupportedLocale.fromJson(Map<String, dynamic> json) {
    return SupportedLocale(
      id: json['id'] as String,
      localeCode: json['locale_code'] as String,
      languageName: json['language_name'] as String,
      languageNameNative: json['language_name_native'] as String,
      direction: LocaleDirection.fromValue(json['direction'] as String),
      dateFormat: json['date_format'] as String?,
      numberFormat: json['number_format'] as String?,
      calendarSystem: CalendarSystem.tryFromValue(json['calendar_system'] as String?),
      isActive: json['is_active'] as bool?,
      isDefault: json['is_default'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String localeCode;
  final String languageName;
  final String languageNameNative;
  final LocaleDirection direction;
  final String? dateFormat;
  final String? numberFormat;
  final CalendarSystem? calendarSystem;
  final bool? isActive;
  final bool? isDefault;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locale_code': localeCode,
      'language_name': languageName,
      'language_name_native': languageNameNative,
      'direction': direction.value,
      'date_format': dateFormat,
      'number_format': numberFormat,
      'calendar_system': calendarSystem?.value,
      'is_active': isActive,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SupportedLocale copyWith({
    String? id,
    String? localeCode,
    String? languageName,
    String? languageNameNative,
    LocaleDirection? direction,
    String? dateFormat,
    String? numberFormat,
    CalendarSystem? calendarSystem,
    bool? isActive,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return SupportedLocale(
      id: id ?? this.id,
      localeCode: localeCode ?? this.localeCode,
      languageName: languageName ?? this.languageName,
      languageNameNative: languageNameNative ?? this.languageNameNative,
      direction: direction ?? this.direction,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      calendarSystem: calendarSystem ?? this.calendarSystem,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SupportedLocale && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SupportedLocale(id: $id, localeCode: $localeCode, languageName: $languageName, languageNameNative: $languageNameNative, direction: $direction, dateFormat: $dateFormat, ...)';
}
