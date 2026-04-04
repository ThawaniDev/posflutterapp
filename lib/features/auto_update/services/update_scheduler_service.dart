import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Schedules update installation during the configured maintenance window.
/// Default window: 2:00 AM – 4:00 AM.
class UpdateSchedulerService {
  UpdateSchedulerService();

  Timer? _scheduleTimer;

  static const String _keyMaintenanceStart = 'update_maintenance_start';
  static const String _keyMaintenanceEnd = 'update_maintenance_end';
  static const String _keyAutoUpdateEnabled = 'auto_update_enabled';
  static const String _keyUpdateChannel = 'update_channel';

  /// Check if now is within the maintenance window.
  Future<bool> isInMaintenanceWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final startHour = prefs.getInt(_keyMaintenanceStart) ?? 2;
    final endHour = prefs.getInt(_keyMaintenanceEnd) ?? 4;
    final now = DateTime.now();
    return now.hour >= startHour && now.hour < endHour;
  }

  /// Get maintenance window preferences.
  Future<Map<String, dynamic>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'auto_update_enabled': prefs.getBool(_keyAutoUpdateEnabled) ?? true,
      'maintenance_start': prefs.getInt(_keyMaintenanceStart) ?? 2,
      'maintenance_end': prefs.getInt(_keyMaintenanceEnd) ?? 4,
      'update_channel': prefs.getString(_keyUpdateChannel) ?? 'stable',
    };
  }

  /// Save maintenance window preferences.
  Future<void> savePreferences({
    bool? autoUpdateEnabled,
    int? maintenanceStart,
    int? maintenanceEnd,
    String? updateChannel,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (autoUpdateEnabled != null) {
      await prefs.setBool(_keyAutoUpdateEnabled, autoUpdateEnabled);
    }
    if (maintenanceStart != null) {
      await prefs.setInt(_keyMaintenanceStart, maintenanceStart);
    }
    if (maintenanceEnd != null) {
      await prefs.setInt(_keyMaintenanceEnd, maintenanceEnd);
    }
    if (updateChannel != null) {
      await prefs.setString(_keyUpdateChannel, updateChannel);
    }
  }

  /// Schedule an update to be applied at the next maintenance window.
  /// Calls [onInstall] when the window opens.
  void scheduleInstall({required Future<void> Function() onInstall}) {
    _scheduleTimer?.cancel();
    // Check every 15 minutes if we're in the maintenance window
    _scheduleTimer = Timer.periodic(const Duration(minutes: 15), (_) async {
      if (await isInMaintenanceWindow()) {
        _scheduleTimer?.cancel();
        _scheduleTimer = null;
        try {
          await onInstall();
        } catch (e) {
          debugPrint('Scheduled update install failed: $e');
        }
      }
    });
  }

  void cancelSchedule() {
    _scheduleTimer?.cancel();
    _scheduleTimer = null;
  }

  void dispose() {
    cancelSchedule();
  }
}
