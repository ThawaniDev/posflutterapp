import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auto_update_repository.dart';

/// Periodically checks for available updates against the update server.
/// Default interval: every 6 hours.
class UpdateCheckerService {
  UpdateCheckerService(this._repository);

  final AutoUpdateRepository _repository;
  Timer? _timer;
  static const Duration _checkInterval = Duration(hours: 6);

  bool _isChecking = false;
  Map<String, dynamic>? _lastCheckResult;

  Map<String, dynamic>? get lastCheckResult => _lastCheckResult;
  bool get isChecking => _isChecking;

  /// Start periodic update checks.
  void startPeriodicChecks({required String currentVersion, required String platform, String channel = 'stable'}) {
    _timer?.cancel();
    checkNow(currentVersion: currentVersion, platform: platform, channel: channel);
    _timer = Timer.periodic(_checkInterval, (_) {
      checkNow(currentVersion: currentVersion, platform: platform, channel: channel);
    });
  }

  /// Perform a single update check.
  Future<Map<String, dynamic>?> checkNow({
    required String currentVersion,
    required String platform,
    String channel = 'stable',
  }) async {
    if (_isChecking) return _lastCheckResult;
    _isChecking = true;
    try {
      final response = await _repository.checkForUpdate(currentVersion: currentVersion, platform: platform, channel: channel);
      _lastCheckResult = response;
      return _lastCheckResult;
    } catch (e) {
      return null;
    } finally {
      _isChecking = false;
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }
}

final updateCheckerServiceProvider = Provider<UpdateCheckerService>((ref) {
  final repo = ref.watch(autoUpdateRepositoryProvider);
  final service = UpdateCheckerService(repo);
  ref.onDispose(() => service.dispose());
  return service;
});
