import 'dart:io';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_providers.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/features/auto_update/services/update_checker_service.dart';

/// Service that checks for app updates on login and shows
/// a force-update dialog when the backend requires it.
class AppUpdateService {
  AppUpdateService(this._ref);

  final Ref _ref;
  bool _hasChecked = false;

  /// Call after the user becomes authenticated.
  /// Checks the backend for available updates and shows
  /// a blocking dialog if a force update is required.
  /// Also starts a 6-hour periodic background check timer.
  Future<void> checkOnLogin(BuildContext context) async {
    // Only check once per app session to avoid spamming
    if (_hasChecked) return;
    _hasChecked = true;

    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version; // e.g. "1.2.3"
      final platform = _currentPlatform();

      if (platform == null) return; // unsupported platform

      // Start periodic 6-hour background timer so the app always
      // picks up a new forced update even while the user is active.
      _ref.read(updateCheckerServiceProvider).startPeriodicChecks(currentVersion: currentVersion, platform: platform);

      // Fire the immediate check
      await _ref.read(updateCheckProvider.notifier).check(currentVersion: currentVersion, platform: platform);

      final state = _ref.read(updateCheckProvider);
      if (state is! UpdateCheckLoaded) return;
      if (!state.updateAvailable) return;

      if (!context.mounted) return;

      if (state.isForceUpdate) {
        _showForceUpdateDialog(context, state);
      } else {
        _showOptionalUpdateDialog(context, state);
      }
    } catch (e) {
      debugPrint('AppUpdateService: check failed: $e');
    }
  }

  /// Reset so the next login triggers a fresh check.
  void reset() => _hasChecked = false;

  // ─── Platform Detection ──────────────────────────────

  String? _currentPlatform() {
    if (kIsWeb) return null;
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    return null;
  }

  // ─── Force Update Dialog (non-dismissible) ───────────

  void _showForceUpdateDialog(BuildContext context, UpdateCheckLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          icon: const Icon(Icons.system_update, size: 48, color: Colors.red),
          title: Text(l10n.updateRequired),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.updateRequiredVersion(state.latestVersion ?? '')),
              if (state.releaseNotes != null) ...[
                const SizedBox(height: 12),
                Text(l10n.whatsNew, style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(state.releaseNotes!, style: Theme.of(ctx).textTheme.bodySmall, maxLines: 5, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
          actions: [
            FilledButton.icon(
              onPressed: () => _openStore(state.storeUrl ?? state.downloadUrl),
              icon: const Icon(Icons.download),
              label: Text(l10n.updateNow),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Optional Update Dialog (dismissible) ────────────

  void _showOptionalUpdateDialog(BuildContext context, UpdateCheckLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.system_update, size: 48, color: Theme.of(ctx).colorScheme.primary),
        title: Text(l10n.updateAvailable),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updateAvailableVersion(state.latestVersion ?? '')),
            if (state.releaseNotes != null) ...[
              const SizedBox(height: 12),
              Text(l10n.whatsNew, style: Theme.of(ctx).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(state.releaseNotes!, style: Theme.of(ctx).textTheme.bodySmall, maxLines: 5, overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.updateLater)),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              _openStore(state.storeUrl ?? state.downloadUrl);
            },
            icon: const Icon(Icons.download),
            label: Text(AppLocalizations.of(context)!.commonUpdate),
          ),
        ],
      ),
    );
  }

  // ─── Open Store URL ──────────────────────────────────

  Future<void> _openStore(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('AppUpdateService: Could not launch $url: $e');
    }
  }
}

/// Provider for the app update service singleton.
final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService(ref);
});
