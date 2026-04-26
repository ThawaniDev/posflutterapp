import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maps notification event keys to asset sound files.
const _kEventSoundMap = <String, String>{
  'new_order': 'audio/notification_order.wav',
  'order_ready': 'audio/notification_chime.wav',
  'low_stock': 'audio/notification_alert.wav',
  'payment_received': 'audio/notification_payment.wav',
  'new_message': 'audio/notification_message.wav',
  'system_update': 'audio/notification_info.wav',
  'daily_report': 'audio/notification_info.wav',
  // fallback for unknown keys
  '_default': 'audio/notification_default.wav',
};

/// Cooldown in milliseconds between plays of the same event key.
const _kCooldownMs = 3000;

/// Plays notification alert sounds per event key with a per-event cooldown.
///
/// Sound files are resolved via [_kEventSoundMap]. Unknown event keys fall
/// back to `_default`. A 3-second cooldown prevents rapid-fire repeats.
class NotificationSoundService {
  NotificationSoundService();

  final AudioPlayer _player = AudioPlayer();
  bool _globalEnabled = true;
  final Map<String, DateTime> _lastPlayed = {};

  bool get isEnabled => _globalEnabled;

  void setEnabled({required bool enabled}) {
    _globalEnabled = enabled;
  }

  /// Play the sound associated with [eventKey].
  ///
  /// Respects the global enabled flag and a per-event cooldown of 3 seconds.
  /// [volume] should be 0.0–1.0 (defaults to 0.7). Silently ignores errors.
  Future<void> play(String eventKey, {double volume = 0.7}) async {
    if (!_globalEnabled) return;

    final now = DateTime.now();
    final last = _lastPlayed[eventKey];
    if (last != null && now.difference(last).inMilliseconds < _kCooldownMs) {
      return; // still in cooldown
    }
    _lastPlayed[eventKey] = now;

    final assetPath = _kEventSoundMap[eventKey] ?? _kEventSoundMap['_default']!;
    await _playAsset(assetPath, volume: volume);
  }

  Future<void> _playAsset(String assetPath, {required double volume}) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Non-critical — silently ignore audio errors
    }
  }

  void dispose() {
    _player.dispose();
  }
}

final notificationSoundServiceProvider = Provider<NotificationSoundService>((ref) {
  final service = NotificationSoundService();
  ref.onDispose(service.dispose);
  return service;
});
