import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/accessibility/services/accessibility_service.dart';

/// Plays audio feedback sounds for POS actions when audio feedback is enabled.
class AudioFeedbackService {
  AudioFeedbackService();

  final AudioPlayer _player = AudioPlayer();

  bool _enabled = true;
  double _volume = 0.7;

  bool get isEnabled => _enabled;

  void updateSettings({required bool enabled, required double volume}) {
    _enabled = enabled;
    _volume = volume;
  }

  /// Play a scan beep sound.
  Future<void> playBeep() async {
    if (!_enabled) return;
    await _play('audio/beep.wav');
  }

  /// Play a payment/sale complete chime.
  Future<void> playChime() async {
    if (!_enabled) return;
    await _play('audio/chime.wav');
  }

  /// Play an error sound.
  Future<void> playError() async {
    if (!_enabled) return;
    await _play('audio/error.wav');
  }

  /// Play a success sound.
  Future<void> playSuccess() async {
    if (!_enabled) return;
    await _play('audio/success.wav');
  }

  /// Play a click sound.
  Future<void> playClick() async {
    if (!_enabled) return;
    await _play('audio/click.wav');
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player.setVolume(_volume);
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Silently ignore audio errors — not critical
    }
  }

  void dispose() {
    _player.dispose();
  }
}

final audioFeedbackServiceProvider = Provider<AudioFeedbackService>((ref) {
  final service = AudioFeedbackService();
  final settings = ref.watch(accessibilitySettingsProvider);
  service.updateSettings(enabled: settings.audioFeedback, volume: settings.audioVolume);
  ref.onDispose(() => service.dispose());
  return service;
});
