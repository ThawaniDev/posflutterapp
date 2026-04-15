import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/sync/providers/sync_providers.dart';
import 'package:wameedpos/features/sync/services/connectivity_service.dart';
import 'package:wameedpos/features/sync/services/sync_engine.dart';

/// A persistent banner shown at the top of the app when offline.
/// Shows pending operation count and sync status.
class OfflineIndicatorBanner extends ConsumerWidget {
  const OfflineIndicatorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final engineStatusAsync = ref.watch(syncEngineStatusProvider);

    final connectivity = connectivityAsync.valueOrNull;
    final engineStatus = engineStatusAsync.valueOrNull;

    // Only show when offline or syncing
    if (connectivity == ConnectivityStatus.online && engineStatus != SyncEngineStatus.syncing) {
      return const SizedBox.shrink();
    }

    final (bgColor, icon, message) = switch (engineStatus) {
      SyncEngineStatus.offline => (AppColors.warning, Icons.cloud_off, 'Offline — changes will sync when connected'),
      SyncEngineStatus.syncing => (AppColors.info, Icons.sync, 'Syncing...'),
      SyncEngineStatus.error => (AppColors.error, Icons.error_outline, 'Sync error — will retry'),
      _ =>
        connectivity == ConnectivityStatus.offline
            ? (AppColors.warning, Icons.cloud_off, 'No internet connection')
            : (AppColors.info, Icons.sync, 'Syncing...'),
    };

    final pendingCount = ref.watch(syncEngineProvider).pendingOperations;

    return Material(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              AppSpacing.gapW8,
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              if (pendingCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: AppRadius.borderFull),
                  child: Text(
                    '$pendingCount pending',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              if (engineStatus == SyncEngineStatus.syncing) ...[
                AppSpacing.gapW8,
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
