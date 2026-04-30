import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';
import 'package:wameedpos/features/accessibility/repositories/accessibility_repository.dart';
import 'package:wameedpos/features/accessibility/services/keyboard_shortcut_service.dart';

// ─── Preferences Provider ─────────────────────────────
final accessibilityPrefsProvider = StateNotifierProvider<AccessibilityPrefsNotifier, AccessibilityPrefsState>(
  (ref) => AccessibilityPrefsNotifier(ref.read(accessibilityRepositoryProvider)),
);

class AccessibilityPrefsNotifier extends StateNotifier<AccessibilityPrefsState> {
  AccessibilityPrefsNotifier(this._repo) : super(const PrefsInitial());
  final AccessibilityRepository _repo;

  double _parseDoubleOrDefault(dynamic value, double fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  Future<void> load() async {
    if (state is! PrefsLoaded) state = const PrefsLoading();
    try {
      final res = await _repo.getPreferences();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = PrefsLoaded(
        fontScale: _parseDoubleOrDefault(d['font_scale'], 1.0),
        highContrast: d['high_contrast'] == true,
        colorBlindMode: d['color_blind_mode']?.toString() ?? 'none',
        reducedMotion: d['reduced_motion'] == true,
        audioFeedback: d['audio_feedback'] != false,
        audioVolume: _parseDoubleOrDefault(d['audio_volume'], 0.7),
        largeTouchTargets: d['large_touch_targets'] == true,
        visibleFocus: d['visible_focus'] != false,
        screenReaderHints: d['screen_reader_hints'] != false,
        customShortcuts: Map<String, dynamic>.from(d['custom_shortcuts'] as Map? ?? {}),
        raw: d,
      );
    } catch (e) {
      if (state is! PrefsLoaded) state = PrefsError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    state = const PrefsLoading();
    try {
      final res = await _repo.updatePreferences(data);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = PrefsLoaded(
        fontScale: _parseDoubleOrDefault(d['font_scale'], 1.0),
        highContrast: d['high_contrast'] == true,
        colorBlindMode: d['color_blind_mode']?.toString() ?? 'none',
        reducedMotion: d['reduced_motion'] == true,
        audioFeedback: d['audio_feedback'] != false,
        audioVolume: _parseDoubleOrDefault(d['audio_volume'], 0.7),
        largeTouchTargets: d['large_touch_targets'] == true,
        visibleFocus: d['visible_focus'] != false,
        screenReaderHints: d['screen_reader_hints'] != false,
        customShortcuts: Map<String, dynamic>.from(d['custom_shortcuts'] as Map? ?? {}),
        raw: d,
      );
    } catch (e) {
      state = PrefsError(e.toString());
    }
  }

  Future<void> reset() async {
    state = const PrefsLoading();
    try {
      final res = await _repo.resetPreferences();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = PrefsLoaded(
        fontScale: _parseDoubleOrDefault(d['font_scale'], 1.0),
        highContrast: d['high_contrast'] == true,
        colorBlindMode: d['color_blind_mode']?.toString() ?? 'none',
        reducedMotion: d['reduced_motion'] == true,
        audioFeedback: d['audio_feedback'] != false,
        audioVolume: _parseDoubleOrDefault(d['audio_volume'], 0.7),
        largeTouchTargets: d['large_touch_targets'] == true,
        visibleFocus: d['visible_focus'] != false,
        screenReaderHints: d['screen_reader_hints'] != false,
        customShortcuts: Map<String, dynamic>.from(d['custom_shortcuts'] as Map? ?? {}),
        raw: d,
      );
    } catch (e) {
      state = PrefsError(e.toString());
    }
  }
}

// ─── Shortcuts Provider ──────────────────────────────
final shortcutsProvider = StateNotifierProvider<ShortcutsNotifier, ShortcutsState>(
  (ref) => ShortcutsNotifier(ref.read(accessibilityRepositoryProvider)),
);

class ShortcutsNotifier extends StateNotifier<ShortcutsState> {
  ShortcutsNotifier(this._repo) : super(const ShortcutsInitial());
  final AccessibilityRepository _repo;

  Future<void> load() async {
    if (state is! ShortcutsLoaded) state = const ShortcutsLoading();
    try {
      final res = await _repo.getShortcuts();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = ShortcutsLoaded(shortcuts: d);
    } catch (e) {
      if (state is! ShortcutsLoaded) state = ShortcutsError(e.toString());
    }
  }

  Future<void> update(Map<String, String> shortcuts) async {
    state = const ShortcutsLoading();
    try {
      final res = await _repo.updateShortcuts(shortcuts);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final sc = d['custom_shortcuts'] as Map<String, dynamic>? ?? d;
      state = ShortcutsLoaded(shortcuts: sc);
    } catch (e) {
      state = ShortcutsError(e.toString());
    }
  }
}

// ─── Keyboard Shortcut Service Provider ──────────────
/// Singleton service that always reflects the latest custom shortcuts
/// loaded from the API. Auto-updates whenever [shortcutsProvider] changes.
final keyboardShortcutServiceProvider = Provider<KeyboardShortcutService>((ref) {
  final service = KeyboardShortcutService();
  ref.listen<ShortcutsState>(shortcutsProvider, (_, next) {
    if (next is ShortcutsLoaded) {
      service.resetToDefaults();
      service.applyCustomShortcuts(next.shortcuts);
    }
  });
  return service;
});
