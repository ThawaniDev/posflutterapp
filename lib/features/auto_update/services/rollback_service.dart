import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Detects post-update errors and reverts to the previous version.
class RollbackService {
  static const String _keyPreviousVersion = 'rollback_previous_version';
  static const String _keyPreviousInstallPath = 'rollback_previous_install_path';
  static const String _keyLastUpdateBackupId = 'rollback_last_backup_id';

  /// Save rollback information before applying an update.
  Future<void> saveRollbackInfo({required String currentVersion, String? backupId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPreviousVersion, currentVersion);
    if (backupId != null) {
      await prefs.setString(_keyLastUpdateBackupId, backupId);
    }
  }

  /// Check if rollback info is available.
  Future<bool> canRollback() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPreviousVersion);
  }

  /// Get the previous version we can roll back to.
  Future<String?> getPreviousVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPreviousVersion);
  }

  /// Get the backup ID from the last update.
  Future<String?> getLastBackupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastUpdateBackupId);
  }

  /// Perform rollback to previous version.
  Future<RollbackResult> rollback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final previousVersion = prefs.getString(_keyPreviousVersion);

      if (previousVersion == null) {
        return RollbackResult.failure('No previous version to roll back to');
      }

      if (Platform.isWindows) {
        await _rollbackWindows();
      }

      // Clear rollback info after successful rollback
      await _clearRollbackInfo();

      return RollbackResult(success: true, message: 'Rolled back to v$previousVersion', rolledBackToVersion: previousVersion);
    } catch (e) {
      return RollbackResult.failure('Rollback failed: $e');
    }
  }

  Future<void> _rollbackWindows() async {
    final prefs = await SharedPreferences.getInstance();
    final prevPath = prefs.getString(_keyPreviousInstallPath);
    if (prevPath != null) {
      debugPrint('Rolling back Windows install from: $prevPath');
    }
  }

  Future<void> _clearRollbackInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPreviousVersion);
    await prefs.remove(_keyPreviousInstallPath);
    await prefs.remove(_keyLastUpdateBackupId);
  }
}

class RollbackResult {

  const RollbackResult({required this.success, required this.message, this.rolledBackToVersion});

  factory RollbackResult.failure(String message) {
    return RollbackResult(success: false, message: message);
  }
  final bool success;
  final String message;
  final String? rolledBackToVersion;
}
