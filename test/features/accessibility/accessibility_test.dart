import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_state.dart';

void main() {
  // ═══════════════ AccessibilityPrefsState ═══════════════
  group('AccessibilityPrefsState', () {
    test('initial', () {
      const s = PrefsInitial();
      expect(s, isA<AccessibilityPrefsState>());
    });

    test('loading', () {
      const s = PrefsLoading();
      expect(s, isA<AccessibilityPrefsState>());
    });

    test('loaded with defaults', () {
      const s = PrefsLoaded(
        fontScale: 1.0,
        highContrast: false,
        colorBlindMode: 'none',
        reducedMotion: false,
        audioFeedback: true,
        audioVolume: 0.7,
        largeTouchTargets: false,
        visibleFocus: true,
        screenReaderHints: true,
        customShortcuts: {'new_sale': 'F2', 'pay': 'F5'},
        raw: {},
      );
      expect(s.fontScale, 1.0);
      expect(s.highContrast, isFalse);
      expect(s.audioFeedback, isTrue);
      expect(s.visibleFocus, isTrue);
      expect(s.customShortcuts, hasLength(2));
    });

    test('loaded with custom values', () {
      const s = PrefsLoaded(
        fontScale: 1.3,
        highContrast: true,
        colorBlindMode: 'protanopia',
        reducedMotion: true,
        audioFeedback: false,
        audioVolume: 0.5,
        largeTouchTargets: true,
        visibleFocus: true,
        screenReaderHints: false,
        customShortcuts: {},
        raw: {},
      );
      expect(s.fontScale, 1.3);
      expect(s.highContrast, isTrue);
      expect(s.colorBlindMode, 'protanopia');
      expect(s.reducedMotion, isTrue);
      expect(s.audioFeedback, isFalse);
      expect(s.largeTouchTargets, isTrue);
    });

    test('error', () {
      const s = PrefsError('Failed');
      expect(s.message, 'Failed');
    });
  });

  // ═══════════════ ShortcutsState ═══════════════
  group('ShortcutsState', () {
    test('initial', () {
      const s = ShortcutsInitial();
      expect(s, isA<ShortcutsState>());
    });

    test('loading', () {
      const s = ShortcutsLoading();
      expect(s, isA<ShortcutsState>());
    });

    test('loaded', () {
      const s = ShortcutsLoaded(shortcuts: {'new_sale': 'F2', 'pay': 'F5', 'void_item': 'F8', 'help': 'F1'});
      expect(s.shortcuts, hasLength(4));
      expect(s.shortcuts['new_sale'], 'F2');
      expect(s.shortcuts['help'], 'F1');
    });

    test('error', () {
      const s = ShortcutsError('Timeout');
      expect(s.message, 'Timeout');
    });
  });

  // ═══════════════ AccessibilityOperationState ═══════════════
  group('AccessibilityOperationState', () {
    test('idle', () {
      const s = AccessibilityOpIdle();
      expect(s, isA<AccessibilityOperationState>());
    });

    test('running', () {
      const s = AccessibilityOpRunning('update');
      expect(s.operation, 'update');
    });

    test('success', () {
      const s = AccessibilityOpSuccess('Updated');
      expect(s.message, 'Updated');
    });

    test('error', () {
      const s = AccessibilityOpError('Denied');
      expect(s.message, 'Denied');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Accessibility endpoints', () {
    test('preferences', () {
      expect(ApiEndpoints.accessibilityPreferences, '/accessibility/preferences');
    });

    test('shortcuts', () {
      expect(ApiEndpoints.accessibilityShortcuts, '/accessibility/shortcuts');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Accessibility route', () {
    test('route constant', () {
      expect(Routes.accessibilityDashboard, '/accessibility');
    });
  });

  // ═══════════════ Cross-cutting ═══════════════
  group('Accessibility cross-cutting', () {
    test('all states sealed', () {
      expect(const PrefsInitial(), isA<AccessibilityPrefsState>());
      expect(const ShortcutsInitial(), isA<ShortcutsState>());
      expect(const AccessibilityOpIdle(), isA<AccessibilityOperationState>());
    });

    test('error states carry messages', () {
      expect(const PrefsError('e').message, 'e');
      expect(const ShortcutsError('e').message, 'e');
      expect(const AccessibilityOpError('e').message, 'e');
    });

    test('prefs loaded immutable via const', () {
      const s = PrefsLoaded(
        fontScale: 1.0,
        highContrast: false,
        colorBlindMode: 'none',
        reducedMotion: false,
        audioFeedback: true,
        audioVolume: 0.7,
        largeTouchTargets: false,
        visibleFocus: true,
        screenReaderHints: true,
        customShortcuts: {},
        raw: {},
      );
      expect(s.fontScale, 1.0);
    });

    test('color blind modes', () {
      for (final mode in ['none', 'protanopia', 'deuteranopia', 'tritanopia']) {
        final s = PrefsLoaded(
          fontScale: 1.0,
          highContrast: false,
          colorBlindMode: mode,
          reducedMotion: false,
          audioFeedback: true,
          audioVolume: 0.7,
          largeTouchTargets: false,
          visibleFocus: true,
          screenReaderHints: true,
          customShortcuts: const {},
          raw: const {},
        );
        expect(s.colorBlindMode, mode);
      }
    });

    test('font scale range', () {
      const low = PrefsLoaded(
        fontScale: 0.8,
        highContrast: false,
        colorBlindMode: 'none',
        reducedMotion: false,
        audioFeedback: true,
        audioVolume: 0.7,
        largeTouchTargets: false,
        visibleFocus: true,
        screenReaderHints: true,
        customShortcuts: {},
        raw: {},
      );
      const high = PrefsLoaded(
        fontScale: 1.5,
        highContrast: false,
        colorBlindMode: 'none',
        reducedMotion: false,
        audioFeedback: true,
        audioVolume: 0.7,
        largeTouchTargets: false,
        visibleFocus: true,
        screenReaderHints: true,
        customShortcuts: {},
        raw: {},
      );
      expect(low.fontScale, 0.8);
      expect(high.fontScale, 1.5);
    });
  });
}
