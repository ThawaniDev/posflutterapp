import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/accessibility/services/accessibility_service.dart';
import 'package:wameedpos/features/accessibility/services/audio_feedback_service.dart';

// ---------------------------------------------------------------------------
// Fake AudioPlayer — avoids platform channels in unit tests.
// noSuchMethod (from Fake) throws UnimplementedError for every method call;
// AudioFeedbackService._play() wraps all player calls in a try-catch that
// silently ignores errors, so the behaviour under test is unaffected.
// dispose() is explicitly overridden to be a no-op so tearDown never throws.
// ---------------------------------------------------------------------------
class _FakeAudioPlayer extends Fake implements AudioPlayer {
  @override
  Future<void> dispose() async {}
}

/// Unit tests for [AudioFeedbackService].
///
/// Since audio playback needs platform channels (unavailable in unit tests),
/// we only verify the service's settings/state behaviour and guard logic.
/// Audio play calls are expected to silently swallow platform exceptions.
void main() {
  group('AudioFeedbackService', () {
    late AudioFeedbackService service;

    setUp(() {
      service = AudioFeedbackService(player: _FakeAudioPlayer());
    });

    tearDown(() {
      service.dispose();
    });

    // ─── Initial state ────────────────────────────────────────

    test('is enabled by default', () {
      expect(service.isEnabled, isTrue);
    });

    // ─── updateSettings ───────────────────────────────────────

    test('updateSettings disables audio', () {
      service.updateSettings(enabled: false, volume: 0.7);
      expect(service.isEnabled, isFalse);
    });

    test('updateSettings re-enables audio', () {
      service.updateSettings(enabled: false, volume: 0.7);
      service.updateSettings(enabled: true, volume: 0.7);
      expect(service.isEnabled, isTrue);
    });

    test('updateSettings applies volume changes', () {
      // Volume cannot be directly read out but this must not throw
      expect(() => service.updateSettings(enabled: true, volume: 0.3), returnsNormally);
      expect(() => service.updateSettings(enabled: true, volume: 0.0), returnsNormally);
      expect(() => service.updateSettings(enabled: true, volume: 1.0), returnsNormally);
    });

    // ─── Play guards ──────────────────────────────────────────

    test('playBeep does not throw when disabled', () async {
      service.updateSettings(enabled: false, volume: 0.7);
      // Should return immediately without any error
      await expectLater(service.playBeep(), completes);
    });

    test('playChime does not throw when disabled', () async {
      service.updateSettings(enabled: false, volume: 0.7);
      await expectLater(service.playChime(), completes);
    });

    test('playError does not throw when disabled', () async {
      service.updateSettings(enabled: false, volume: 0.7);
      await expectLater(service.playError(), completes);
    });

    test('playSuccess does not throw when disabled', () async {
      service.updateSettings(enabled: false, volume: 0.7);
      await expectLater(service.playSuccess(), completes);
    });

    test('playClick does not throw when disabled', () async {
      service.updateSettings(enabled: false, volume: 0.7);
      await expectLater(service.playClick(), completes);
    });

    test('play methods do not throw when enabled (platform channel silently swallowed)', () async {
      // Platform channels are not available in unit test environment.
      // AudioFeedbackService swallows all audio errors gracefully.
      service.updateSettings(enabled: true, volume: 0.7);
      await expectLater(service.playBeep(), completes);
      await expectLater(service.playChime(), completes);
      await expectLater(service.playError(), completes);
      await expectLater(service.playSuccess(), completes);
      await expectLater(service.playClick(), completes);
    });
  });

  // ─── AccessibilitySettings integration with AudioFeedback ─────────────────

  group('AccessibilitySettings - audio fields', () {
    test('default audioFeedback is true', () {
      const settings = AccessibilitySettings();
      expect(settings.audioFeedback, isTrue);
    });

    test('default audioVolume is 0.7', () {
      const settings = AccessibilitySettings();
      expect(settings.audioVolume, 0.7);
    });

    test('copyWith correctly overrides audioFeedback and audioVolume', () {
      const settings = AccessibilitySettings();
      final updated = settings.copyWith(audioFeedback: false, audioVolume: 0.3);
      expect(updated.audioFeedback, isFalse);
      expect(updated.audioVolume, 0.3);
      // Other fields unchanged
      expect(updated.fontScale, 1.0);
      expect(updated.highContrast, isFalse);
    });

    test('volume 0.0 is valid', () {
      const settings = AccessibilitySettings(audioVolume: 0.0);
      expect(settings.audioVolume, 0.0);
    });

    test('volume 1.0 is valid', () {
      const settings = AccessibilitySettings(audioVolume: 1.0);
      expect(settings.audioVolume, 1.0);
    });
  });
}
