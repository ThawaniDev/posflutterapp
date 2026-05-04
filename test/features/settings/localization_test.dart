import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/settings/enums/calendar_system.dart';
import 'package:wameedpos/features/settings/enums/locale_direction.dart';
import 'package:wameedpos/features/settings/enums/translation_category.dart';
import 'package:wameedpos/features/settings/enums/system_settings_group.dart';
import 'package:wameedpos/features/settings/models/supported_locale.dart';
import 'package:wameedpos/features/settings/models/master_translation_string.dart';
import 'package:wameedpos/features/settings/models/translation_override.dart';
import 'package:wameedpos/features/settings/models/translation_version.dart';
import 'package:wameedpos/features/settings/models/user_preference.dart';
import 'package:wameedpos/features/settings/providers/localization_state.dart';

void main() {
  // ─── Enums ──────────────────────────────────────────────────────

  group('LocaleDirection enum', () {
    test('has ltr and rtl values', () {
      expect(LocaleDirection.values.length, 2);
      expect(LocaleDirection.ltr.value, 'ltr');
      expect(LocaleDirection.rtl.value, 'rtl');
    });

    test('fromValue parses correctly', () {
      expect(LocaleDirection.fromValue('ltr'), LocaleDirection.ltr);
      expect(LocaleDirection.fromValue('rtl'), LocaleDirection.rtl);
    });

    test('fromValue throws on invalid', () {
      expect(() => LocaleDirection.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null for null/invalid', () {
      expect(LocaleDirection.tryFromValue(null), isNull);
      expect(LocaleDirection.tryFromValue('bad'), isNull);
    });
  });

  group('TranslationCategory enum', () {
    test('has 6 values', () {
      expect(TranslationCategory.values.length, 6);
      expect(TranslationCategory.ui.value, 'ui');
      expect(TranslationCategory.receipt.value, 'receipt');
      expect(TranslationCategory.notification.value, 'notification');
      expect(TranslationCategory.report.value, 'report');
    });

    test('fromValue parses correctly', () {
      expect(TranslationCategory.fromValue('receipt'), TranslationCategory.receipt);
    });
  });

  group('CalendarSystem enum', () {
    test('has 3 values', () {
      expect(CalendarSystem.values.length, 3);
      expect(CalendarSystem.gregorian.value, 'gregorian');
      expect(CalendarSystem.hijri.value, 'hijri');
      expect(CalendarSystem.both.value, 'both');
    });

    test('tryFromValue handles null', () {
      expect(CalendarSystem.tryFromValue(null), isNull);
      expect(CalendarSystem.tryFromValue('hijri'), CalendarSystem.hijri);
    });
  });

  group('SystemSettingsGroup enum', () {
    test('has locale group', () {
      expect(SystemSettingsGroup.locale.value, 'locale');
    });

    test('fromValue parses correctly', () {
      expect(SystemSettingsGroup.fromValue('zatca'), SystemSettingsGroup.zatca);
      expect(SystemSettingsGroup.fromValue('locale'), SystemSettingsGroup.locale);
    });
  });

  // ─── Models ─────────────────────────────────────────────────────

  group('SupportedLocale model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'loc-1',
        'locale_code': 'ar',
        'language_name': 'Arabic',
        'language_name_native': 'العربية',
        'direction': 'rtl',
        'date_format': 'DD/MM/YYYY',
        'number_format': 'western',
        'calendar_system': 'both',
        'is_active': true,
        'is_default': true,
        'created_at': '2024-01-01T00:00:00.000Z',
      };
      final locale = SupportedLocale.fromJson(json);

      expect(locale.id, 'loc-1');
      expect(locale.localeCode, 'ar');
      expect(locale.direction, LocaleDirection.rtl);
      expect(locale.calendarSystem, CalendarSystem.both);
      expect(locale.isDefault, true);
      expect(locale.isActive, true);
    });

    test('toJson produces correct map', () {
      const locale = SupportedLocale(
        id: 'loc-2',
        localeCode: 'en',
        languageName: 'English',
        languageNameNative: 'English',
        direction: LocaleDirection.ltr,
        isActive: true,
        isDefault: false,
      );
      final json = locale.toJson();

      expect(json['locale_code'], 'en');
      expect(json['direction'], 'ltr');
      expect(json['is_default'], false);
    });

    test('copyWith overwrites fields', () {
      const locale = SupportedLocale(
        id: 'loc-1',
        localeCode: 'ar',
        languageName: 'Arabic',
        languageNameNative: 'العربية',
        direction: LocaleDirection.rtl,
      );
      final updated = locale.copyWith(isDefault: true);
      expect(updated.isDefault, true);
      expect(updated.localeCode, 'ar');
    });

    test('equality by id', () {
      const a = SupportedLocale(
        id: 'same',
        localeCode: 'ar',
        languageName: 'A',
        languageNameNative: 'A',
        direction: LocaleDirection.rtl,
      );
      const b = SupportedLocale(
        id: 'same',
        localeCode: 'en',
        languageName: 'B',
        languageNameNative: 'B',
        direction: LocaleDirection.ltr,
      );
      expect(a, equals(b));
    });
  });

  group('MasterTranslationString model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'ts-1',
        'string_key': 'pos.checkout.title',
        'category': 'ui',
        'value_en': 'Checkout',
        'value_ar': 'الدفع',
        'description': 'Checkout title',
        'is_overridable': true,
        'updated_at': '2024-06-01T12:00:00.000Z',
      };
      final ts = MasterTranslationString.fromJson(json);
      expect(ts.stringKey, 'pos.checkout.title');
      expect(ts.category, TranslationCategory.ui);
      expect(ts.valueEn, 'Checkout');
      expect(ts.valueAr, 'الدفع');
      expect(ts.isOverridable, true);
    });

    test('toJson round-trip', () {
      final json = {
        'id': 'ts-2',
        'string_key': 'receipt.total',
        'category': 'receipt',
        'value_en': 'Total',
        'value_ar': 'الإجمالي',
        'description': null,
        'is_overridable': null,
        'updated_at': null,
      };
      final ts = MasterTranslationString.fromJson(json);
      final output = ts.toJson();
      expect(output['string_key'], 'receipt.total');
      expect(output['category'], 'receipt');
    });

    test('copyWith preserves untouched fields', () {
      const ts = MasterTranslationString(
        id: 'ts-1',
        stringKey: 'key',
        category: TranslationCategory.ui,
        valueEn: 'EN',
        valueAr: 'AR',
      );
      final updated = ts.copyWith(valueEn: 'Updated EN');
      expect(updated.valueEn, 'Updated EN');
      expect(updated.valueAr, 'AR');
    });
  });

  group('TranslationOverride model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'to-1',
        'store_id': 'store-abc',
        'string_key': 'pos.welcome',
        'locale': 'en',
        'custom_value': 'Welcome!',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };
      final o = TranslationOverride.fromJson(json);
      expect(o.storeId, 'store-abc');
      expect(o.stringKey, 'pos.welcome');
      expect(o.customValue, 'Welcome!');
    });

    test('toJson produces correct map', () {
      const o = TranslationOverride(
        id: 'to-2',
        storeId: 'store-xyz',
        stringKey: 'pos.title',
        locale: 'ar',
        customValue: 'عنوان مخصص',
      );
      final json = o.toJson();
      expect(json['store_id'], 'store-xyz');
      expect(json['locale'], 'ar');
    });

    test('equality by id', () {
      const a = TranslationOverride(id: 'same', storeId: 's1', stringKey: 'k1', locale: 'en', customValue: 'v1');
      const b = TranslationOverride(id: 'same', storeId: 's2', stringKey: 'k2', locale: 'ar', customValue: 'v2');
      expect(a, equals(b));
    });
  });

  group('TranslationVersion model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'tv-1',
        'version_hash': 'abc123def456',
        'published_at': '2024-06-15T10:30:00.000Z',
        'published_by': 'user-1',
        'notes': 'Initial release',
      };
      final v = TranslationVersion.fromJson(json);
      expect(v.versionHash, 'abc123def456');
      expect(v.publishedBy, 'user-1');
      expect(v.notes, 'Initial release');
      expect(v.publishedAt, isNotNull);
    });

    test('fromJson handles null optionals', () {
      final json = {'id': 'tv-2', 'version_hash': 'xyz789', 'published_at': null, 'published_by': null, 'notes': null};
      final v = TranslationVersion.fromJson(json);
      expect(v.publishedAt, isNull);
      expect(v.publishedBy, isNull);
      expect(v.notes, isNull);
    });

    test('toJson round-trip', () {
      const v = TranslationVersion(id: 'tv-3', versionHash: 'hash123', notes: 'v3');
      final json = v.toJson();
      expect(json['version_hash'], 'hash123');
      expect(json['notes'], 'v3');
    });
  });

  group('UserPreference model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'up-1',
        'user_id': 'user-1',
        'pos_handedness': null,
        'font_size': null,
        'theme': null,
        'pos_layout_id': null,
      };
      final pref = UserPreference.fromJson(json);
      expect(pref.userId, 'user-1');
      expect(pref.posHandedness, isNull);
    });

    test('toJson produces correct map', () {
      const pref = UserPreference(id: 'up-2', userId: 'user-2');
      final json = pref.toJson();
      expect(json['user_id'], 'user-2');
    });
  });

  // ─── States ─────────────────────────────────────────────────────

  group('LocaleListState', () {
    test('initial state', () {
      const state = LocaleListInitial();
      expect(state, isA<LocaleListState>());
    });

    test('loading state', () {
      const state = LocaleListLoading();
      expect(state, isA<LocaleListState>());
    });

    test('loaded state holds locales', () {
      final locales = [
        const SupportedLocale(
          id: '1',
          localeCode: 'en',
          languageName: 'English',
          languageNameNative: 'English',
          direction: LocaleDirection.ltr,
        ),
      ];
      final state = LocaleListLoaded(locales);
      expect(state.locales.length, 1);
    });

    test('error state holds message', () {
      const state = LocaleListError('Network error');
      expect(state.message, 'Network error');
    });
  });

  group('TranslationListState', () {
    test('loaded state holds translations and total', () {
      final items = [
        const MasterTranslationString(
          id: '1',
          stringKey: 'test.key',
          category: TranslationCategory.ui,
          valueEn: 'Test',
          valueAr: 'اختبار',
        ),
      ];
      final state = TranslationListLoaded(items, total: 42);
      expect(state.translations.length, 1);
      expect(state.total, 42);
    });
  });

  group('OverrideListState', () {
    test('loaded state holds overrides', () {
      final overrides = [const TranslationOverride(id: '1', storeId: 's', stringKey: 'k', locale: 'en', customValue: 'v')];
      final state = OverrideListLoaded(overrides);
      expect(state.overrides.length, 1);
    });
  });

  group('VersionListState', () {
    test('loaded state holds versions', () {
      final versions = [const TranslationVersion(id: '1', versionHash: 'hash')];
      final state = VersionListLoaded(versions);
      expect(state.versions.length, 1);
    });
  });

  group('TranslationExportState', () {
    test('loaded state holds translation map', () {
      const state = TranslationExportLoaded({'pos.hello': 'Hello', 'pos.bye': 'Bye'});
      expect(state.translations.length, 2);
      expect(state.translations['pos.hello'], 'Hello');
    });

    test('error state holds message', () {
      const state = TranslationExportError('Export failed');
      expect(state.message, 'Export failed');
    });
  });

  // ─── Cross-cutting ────────────────────────────────────────────

  group('Localization cross-cutting', () {
    test('SupportedLocale RTL detection', () {
      const ar = SupportedLocale(
        id: '1',
        localeCode: 'ar',
        languageName: 'Arabic',
        languageNameNative: 'العربية',
        direction: LocaleDirection.rtl,
      );
      expect(ar.direction, LocaleDirection.rtl);
    });

    test('MasterTranslationString overridable flag', () {
      const ts = MasterTranslationString(
        id: '1',
        stringKey: 'pos.title',
        category: TranslationCategory.ui,
        valueEn: 'Title',
        valueAr: 'العنوان',
        isOverridable: true,
      );
      expect(ts.isOverridable, true);
    });

    test('TranslationVersion hash integrity', () {
      const v1 = TranslationVersion(id: '1', versionHash: 'abc');
      const v2 = TranslationVersion(id: '2', versionHash: 'abc');
      expect(v1.versionHash, v2.versionHash);
      expect(v1, isNot(equals(v2))); // Different ids
    });

    test('All TranslationCategory values accessible', () {
      for (final cat in TranslationCategory.values) {
        expect(TranslationCategory.fromValue(cat.value), cat);
      }
    });

    test('All LocaleDirection values accessible', () {
      for (final dir in LocaleDirection.values) {
        expect(LocaleDirection.fromValue(dir.value), dir);
      }
    });

    test('All CalendarSystem values accessible', () {
      for (final sys in CalendarSystem.values) {
        expect(CalendarSystem.fromValue(sys.value), sys);
      }
    });
  });
}
