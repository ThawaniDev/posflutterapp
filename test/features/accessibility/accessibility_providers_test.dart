import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/accessibility/data/remote/accessibility_api_service.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';
import 'package:wameedpos/features/accessibility/repositories/accessibility_repository.dart';
import 'package:wameedpos/features/accessibility/services/accessibility_service.dart';
import 'package:wameedpos/features/accessibility/services/keyboard_shortcut_service.dart';

// ─── Fake repository implementations ──────────────────────────────────────────

// Fake Ref so AccessibilityApiService can be constructed without a real ProviderContainer.
// _FakeRef.noSuchMethod (from Fake) will throw UnimplementedError if ever called,
// but it never is because FakeAccessibilityRepository overrides every repository method.
class _FakeRef extends Fake implements Ref {}

// Stub API service that satisfies AccessibilityRepository's required constructor
// parameter without performing any real Dio / network operations.
class _FakeAccessibilityApiService extends AccessibilityApiService {
  _FakeAccessibilityApiService() : super(_FakeRef());
}

/// A fake [AccessibilityRepository] that returns a preset response.
///
/// Since [AccessibilityRepository] is a concrete class that requires an
/// [AccessibilityApiService] (a class backed by Dio), we extend it and
/// override every method to avoid any real network calls.
class FakeAccessibilityRepository extends AccessibilityRepository {
  FakeAccessibilityRepository({
    Map<String, dynamic>? prefsResponse,
    Map<String, dynamic>? shortcutsResponse,
    Exception? throwOnGet,
    Exception? throwOnUpdate,
    Exception? throwOnReset,
    Exception? throwOnGetShortcuts,
    Exception? throwOnUpdateShortcuts,
  })  : _prefsResponse = prefsResponse ?? _defaultPrefs,
        _shortcutsResponse = shortcutsResponse ?? _defaultShortcuts,
        _throwOnGet = throwOnGet,
        _throwOnUpdate = throwOnUpdate,
        _throwOnReset = throwOnReset,
        _throwOnGetShortcuts = throwOnGetShortcuts,
        _throwOnUpdateShortcuts = throwOnUpdateShortcuts,
        super(_FakeAccessibilityApiService());

  static final Map<String, dynamic> _defaultPrefs = {
    'data': {
      'font_scale': 1.0,
      'high_contrast': false,
      'color_blind_mode': 'none',
      'reduced_motion': false,
      'audio_feedback': true,
      'audio_volume': 0.7,
      'large_touch_targets': false,
      'visible_focus': true,
      'screen_reader_hints': true,
      'custom_shortcuts': {'new_sale': 'F2', 'pay': 'F5'},
    },
  };

  static final Map<String, dynamic> _defaultShortcuts = {
    'data': {'new_sale': 'F2', 'pay': 'F5'},
  };

  Map<String, dynamic> _prefsResponse;
  final Map<String, dynamic> _shortcutsResponse;
  final Exception? _throwOnGet;
  final Exception? _throwOnUpdate;
  final Exception? _throwOnReset;
  final Exception? _throwOnGetShortcuts;
  final Exception? _throwOnUpdateShortcuts;

  // track calls for verification
  int getPrefsCallCount = 0;
  int updatePrefsCallCount = 0;
  int resetCallCount = 0;
  Map<String, dynamic>? lastUpdatePayload;

  @override
  Future<Map<String, dynamic>> getPreferences() async {
    getPrefsCallCount++;
    if (_throwOnGet != null) throw _throwOnGet!;
    return _prefsResponse;
  }

  @override
  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) async {
    updatePrefsCallCount++;
    lastUpdatePayload = data;
    if (_throwOnUpdate != null) throw _throwOnUpdate!;
    // Simulate server merging the update into preferences
    final existing = Map<String, dynamic>.from(
      (_prefsResponse['data'] as Map<String, dynamic>?) ?? _prefsResponse,
    );
    existing.addAll(data);
    _prefsResponse = {'data': existing};
    return _prefsResponse;
  }

  @override
  Future<Map<String, dynamic>> resetPreferences() async {
    resetCallCount++;
    if (_throwOnReset != null) throw _throwOnReset!;
    _prefsResponse = _defaultPrefs;
    return _prefsResponse;
  }

  @override
  Future<Map<String, dynamic>> getShortcuts() async {
    if (_throwOnGetShortcuts != null) throw _throwOnGetShortcuts!;
    return _shortcutsResponse;
  }

  @override
  Future<Map<String, dynamic>> updateShortcuts(Map<String, String> shortcuts) async {
    if (_throwOnUpdateShortcuts != null) throw _throwOnUpdateShortcuts!;
    return {'data': {'custom_shortcuts': shortcuts}};
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

ProviderContainer makeContainer({
  FakeAccessibilityRepository? repo,
}) {
  final fakeRepo = repo ?? FakeAccessibilityRepository();
  return ProviderContainer(
    overrides: [
      accessibilityRepositoryProvider.overrideWithValue(fakeRepo),
    ],
  );
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  group('AccessibilityPrefsNotifier', () {
    // ─── Initial state ──────────────────────────────────────────────────────

    test('starts in PrefsInitial state', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      expect(container.read(accessibilityPrefsProvider), isA<PrefsInitial>());
    });

    // ─── load() ────────────────────────────────────────────────────────────

    test('load transitions to PrefsLoaded with default values', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final state = container.read(accessibilityPrefsProvider);
      expect(state, isA<PrefsLoaded>());
      final loaded = state as PrefsLoaded;
      expect(loaded.fontScale, 1.0);
      expect(loaded.highContrast, isFalse);
      expect(loaded.colorBlindMode, 'none');
      expect(loaded.audioFeedback, isTrue);
      expect(loaded.audioVolume, 0.7);
    });

    test('load with non-default values sets them correctly', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': 1.4,
            'high_contrast': true,
            'color_blind_mode': 'protanopia',
            'reduced_motion': false,
            'audio_feedback': false,
            'audio_volume': 0.3,
            'large_touch_targets': true,
            'visible_focus': false,
            'screen_reader_hints': false,
            'custom_shortcuts': {'new_sale': 'F3'},
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.4);
      expect(loaded.highContrast, isTrue);
      expect(loaded.colorBlindMode, 'protanopia');
      expect(loaded.audioFeedback, isFalse);
      expect(loaded.audioVolume, 0.3);
      expect(loaded.largeTouchTargets, isTrue);
      expect(loaded.visibleFocus, isFalse);
      expect(loaded.screenReaderHints, isFalse);
    });

    test('load sets PrefsError on repository failure', () async {
      final repo = FakeAccessibilityRepository(
        throwOnGet: Exception('Network error'),
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      expect(container.read(accessibilityPrefsProvider), isA<PrefsError>());
    });

    test('load preserves PrefsLoaded state if already loaded (no re-loading into Loading)', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();
      // Already loaded — second load should not go to Loading first
      expect(container.read(accessibilityPrefsProvider), isA<PrefsLoaded>());

      await container.read(accessibilityPrefsProvider.notifier).load();
      expect(container.read(accessibilityPrefsProvider), isA<PrefsLoaded>());
    });

    // ─── update() ──────────────────────────────────────────────────────────

    test('update changes state to PrefsLoaded with new values', () async {
      final repo = FakeAccessibilityRepository();
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();
      await container.read(accessibilityPrefsProvider.notifier).update({'font_scale': 1.3});

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.3);
    });

    test('update sends the correct payload to repository', () async {
      final repo = FakeAccessibilityRepository();
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).update({'high_contrast': true});

      expect(repo.updatePrefsCallCount, 1);
      expect(repo.lastUpdatePayload, {'high_contrast': true});
    });

    test('update sets PrefsError on repository failure', () async {
      final repo = FakeAccessibilityRepository(
        throwOnUpdate: Exception('Update failed'),
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).update({'font_scale': 1.2});

      expect(container.read(accessibilityPrefsProvider), isA<PrefsError>());
    });

    // ─── reset() ───────────────────────────────────────────────────────────

    test('reset returns to default values', () async {
      final repo = FakeAccessibilityRepository();
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      // Update first
      await container.read(accessibilityPrefsProvider.notifier).update({'font_scale': 1.5, 'high_contrast': true});
      // Then reset
      await container.read(accessibilityPrefsProvider.notifier).reset();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.0);
      expect(loaded.highContrast, isFalse);
    });

    test('reset calls repository resetPreferences once', () async {
      final repo = FakeAccessibilityRepository();
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).reset();
      expect(repo.resetCallCount, 1);
    });

    test('reset sets PrefsError on repository failure', () async {
      final repo = FakeAccessibilityRepository(
        throwOnReset: Exception('Reset failed'),
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).reset();
      expect(container.read(accessibilityPrefsProvider), isA<PrefsError>());
    });
  });

  // ─── ShortcutsNotifier ────────────────────────────────────────────────────

  group('ShortcutsNotifier', () {
    test('starts in ShortcutsInitial state', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      expect(container.read(shortcutsProvider), isA<ShortcutsInitial>());
    });

    test('load transitions to ShortcutsLoaded', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(shortcutsProvider.notifier).load();

      expect(container.read(shortcutsProvider), isA<ShortcutsLoaded>());
    });

    test('load sets correct shortcuts data', () async {
      final repo = FakeAccessibilityRepository(
        shortcutsResponse: {'data': {'new_sale': 'F3', 'pay': 'F6'}},
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(shortcutsProvider.notifier).load();

      final loaded = container.read(shortcutsProvider) as ShortcutsLoaded;
      expect(loaded.shortcuts['new_sale'], 'F3');
      expect(loaded.shortcuts['pay'], 'F6');
    });

    test('load sets ShortcutsError on failure', () async {
      final repo = FakeAccessibilityRepository(
        throwOnGetShortcuts: Exception('No shortcuts'),
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(shortcutsProvider.notifier).load();

      expect(container.read(shortcutsProvider), isA<ShortcutsError>());
    });

    test('update sets ShortcutsLoaded with new shortcuts', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(shortcutsProvider.notifier).update({'new_sale': 'F4', 'pay': 'F7'});

      final loaded = container.read(shortcutsProvider) as ShortcutsLoaded;
      expect(loaded.shortcuts['new_sale'], 'F4');
    });

    test('update sets ShortcutsError on failure', () async {
      final repo = FakeAccessibilityRepository(
        throwOnUpdateShortcuts: Exception('Update shortcuts failed'),
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(shortcutsProvider.notifier).update({'new_sale': 'F4'});

      expect(container.read(shortcutsProvider), isA<ShortcutsError>());
    });
  });

  // ─── accessibilitySettingsProvider ────────────────────────────────────────

  group('accessibilitySettingsProvider', () {
    test('returns default AccessibilitySettings when prefs not loaded', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final settings = container.read(accessibilitySettingsProvider);
      expect(settings.fontScale, 1.0);
      expect(settings.highContrast, isFalse);
      expect(settings.audioFeedback, isTrue);
    });

    test('returns loaded settings when prefs are loaded', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': 1.3,
            'high_contrast': true,
            'color_blind_mode': 'none',
            'reduced_motion': false,
            'audio_feedback': false,
            'audio_volume': 0.4,
            'large_touch_targets': false,
            'visible_focus': true,
            'screen_reader_hints': true,
            'custom_shortcuts': {},
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final settings = container.read(accessibilitySettingsProvider);
      expect(settings.fontScale, 1.3);
      expect(settings.highContrast, isTrue);
      expect(settings.audioFeedback, isFalse);
    });
  });

  // ─── keyboardShortcutServiceProvider ──────────────────────────────────────

  group('keyboardShortcutServiceProvider', () {
    test('returns a KeyboardShortcutService instance', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      final service = container.read(keyboardShortcutServiceProvider);
      expect(service, isA<KeyboardShortcutService>());
    });

    test('service has default shortcuts before any API call', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      final service = container.read(keyboardShortcutServiceProvider);
      // Default shortcuts should include F2 for new_sale
      final shortcuts = service.shortcuts;
      expect(shortcuts.containsKey('new_sale'), isTrue);
      expect(shortcuts['new_sale']!.label, contains('F2'));
    });

    test('service updates after shortcuts are loaded', () async {
      final repo = FakeAccessibilityRepository(
        shortcutsResponse: {'data': {'new_sale': 'F3', 'pay': 'F6'}},
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      // Ensure keyboard service is initialized (reads shortcutsProvider)
      final _ = container.read(keyboardShortcutServiceProvider);

      await container.read(shortcutsProvider.notifier).load();

      final service = container.read(keyboardShortcutServiceProvider);
      final shortcuts = service.shortcuts;
      // After loading shortcuts, the service should have applied custom bindings
      // The service will have the key, with label matching the loaded shortcut
      expect(shortcuts.containsKey('new_sale'), isTrue);
    });
  });

  // ─── Parsing edge cases ───────────────────────────────────────────────────

  group('AccessibilityPrefsNotifier - parsing edge cases', () {
    test('parses integer font_scale from server (integer returned as num)', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': 1, // integer from server — must be parsed to 1.0
            'high_contrast': false,
            'color_blind_mode': 'none',
            'reduced_motion': false,
            'audio_feedback': true,
            'audio_volume': 1, // integer audio_volume
            'large_touch_targets': false,
            'visible_focus': true,
            'screen_reader_hints': true,
            'custom_shortcuts': {},
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.0);
      expect(loaded.fontScale, isA<double>());
      expect(loaded.audioVolume, 1.0);
    });

    test('parses string font_scale from server gracefully', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': '1.2',
            'high_contrast': false,
            'color_blind_mode': 'none',
            'reduced_motion': false,
            'audio_feedback': true,
            'audio_volume': '0.5',
            'large_touch_targets': false,
            'visible_focus': true,
            'screen_reader_hints': true,
            'custom_shortcuts': {},
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.2);
      expect(loaded.audioVolume, 0.5);
    });

    test('uses defaults when font_scale is null', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': null,
            'high_contrast': false,
            'color_blind_mode': 'none',
            'reduced_motion': false,
            'audio_feedback': true,
            'audio_volume': null,
            'large_touch_targets': false,
            'visible_focus': true,
            'screen_reader_hints': true,
            'custom_shortcuts': {},
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.0);
      expect(loaded.audioVolume, 0.7);
    });

    test('handles missing data key in response (flat response)', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          // No 'data' wrapper — flat response
          'font_scale': 1.1,
          'high_contrast': true,
          'color_blind_mode': 'none',
          'reduced_motion': false,
          'audio_feedback': true,
          'audio_volume': 0.6,
          'large_touch_targets': false,
          'visible_focus': true,
          'screen_reader_hints': true,
          'custom_shortcuts': {},
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.fontScale, 1.1);
      expect(loaded.highContrast, isTrue);
    });

    test('handles missing custom_shortcuts field gracefully', () async {
      final repo = FakeAccessibilityRepository(
        prefsResponse: {
          'data': {
            'font_scale': 1.0,
            'high_contrast': false,
            'color_blind_mode': 'none',
            'reduced_motion': false,
            'audio_feedback': true,
            'audio_volume': 0.7,
            'large_touch_targets': false,
            'visible_focus': true,
            'screen_reader_hints': true,
            // custom_shortcuts intentionally omitted
          },
        },
      );
      final container = makeContainer(repo: repo);
      addTearDown(container.dispose);

      await container.read(accessibilityPrefsProvider.notifier).load();

      final loaded = container.read(accessibilityPrefsProvider) as PrefsLoaded;
      expect(loaded.customShortcuts, isEmpty);
    });
  });
}
