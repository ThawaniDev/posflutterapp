import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeMode = 'app_theme_mode';
const _kLocale = 'app_locale';

/// Shared instance – set once in main() before runApp.
late final SharedPreferences _prefs;

Future<void> initAppSettings() async {
  _prefs = await SharedPreferences.getInstance();
}

/// Provides the current [ThemeMode]. Persists to SharedPreferences.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final saved = _prefs.getString(_kThemeMode);
  final initial = switch (saved) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
  return ThemeModeNotifier(initial);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(super.initial);

  void set(ThemeMode mode) {
    state = mode;
    _prefs.setString(_kThemeMode, mode.name);
  }
}

/// Provides the current [Locale]. Persists to SharedPreferences.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final saved = _prefs.getString(_kLocale);
  final initial = saved != null ? Locale(saved) : null;
  return LocaleNotifier(initial);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(super.initial);

  void set(Locale? locale) {
    state = locale;
    if (locale != null) {
      _prefs.setString(_kLocale, locale.languageCode);
    } else {
      _prefs.remove(_kLocale);
    }
  }
}
