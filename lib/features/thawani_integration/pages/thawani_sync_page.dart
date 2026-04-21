import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ThawaniSyncPage extends ConsumerStatefulWidget {
  const ThawaniSyncPage({super.key});

  @override
  ConsumerState<ThawaniSyncPage> createState() => _ThawaniSyncPageState();
}

class _ThawaniSyncPageState extends ConsumerState<ThawaniSyncPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(thawaniQueueStatsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(thawaniSyncProvider);
    final queueState = ref.watch(thawaniQueueStatsProvider);
    final isLoading = syncState is ThawaniSyncLoading;

    ref.listen<ThawaniSyncState>(thawaniSyncProvider, (prev, next) {
      if (next is ThawaniSyncSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(thawaniSyncProvider.notifier).reset();
        ref.read(thawaniStatsProvider.notifier).load();
        ref.read(thawaniQueueStatsProvider.notifier).load();
      } else if (next is ThawaniSyncError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.syncManagement,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.refresh,
          onPressed: isLoading ? null : () => ref.read(thawaniQueueStatsProvider.notifier).load(),
        ),
      ],
      child: ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // Connection Test
          _sectionCard(
            title: l10n.hwConnection,
            icon: Icons.link,
            color: AppColors.info,
            children: [
              _syncButton(
                label: l10n.deliveryTestConnection,
                icon: Icons.wifi_tethering,
                color: AppColors.info,
                isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'test-connection',
                onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).testConnection(),
              ),
            ],
          ),
          AppSpacing.gapH16,

          // Category Sync
          _sectionCard(
            title: l10n.thawaniCategorySync,
            icon: Icons.category,
            color: AppColors.purple,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _syncButton(
                      label: l10n.thawaniPushToThawani,
                      icon: Icons.cloud_upload,
                      color: AppColors.purple,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'push-categories',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushCategories(),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _syncButton(
                      label: l10n.thawaniPullFromThawani,
                      icon: Icons.cloud_download,
                      color: AppColors.info,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'pull-categories',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pullCategories(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapH16,

          // Product Sync
          _sectionCard(
            title: l10n.thawaniProductSync,
            icon: Icons.inventory,
            color: AppColors.success,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _syncButton(
                      label: l10n.thawaniPushToThawani,
                      icon: Icons.cloud_upload,
                      color: AppColors.success,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'push-products',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushProducts(),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _syncButton(
                      label: l10n.thawaniPullFromThawani,
                      icon: Icons.cloud_download,
                      color: AppColors.info,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'pull-products',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pullProducts(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapH16,

          // Queue Status & Processing
          _sectionCard(
            title: l10n.thawaniSyncQueue,
            icon: Icons.queue,
            color: AppColors.warning,
            children: [
              _buildQueueStats(queueState),
              AppSpacing.gapH12,
              _syncButton(
                label: l10n.thawaniProcessQueueNow,
                icon: Icons.play_arrow,
                color: AppColors.warning,
                isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'process-queue',
                onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).processQueue(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Color color, required List<Widget> children}) {
    return PosFormCard(
      title: title,
      action: Icon(icon, color: color, size: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _syncButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    VoidCallback? onPressed,
  }) {
    return PosButton(
      label: label,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: true,
      variant: PosButtonVariant.outline,
      onPressed: onPressed,
    );
  }

  Widget _buildQueueStats(ThawaniQueueStatsState state) {
    return switch (state) {
      ThawaniQueueStatsInitial() || ThawaniQueueStatsLoading() => const SizedBox(height: 40, child: PosLoading()),
      ThawaniQueueStatsError(:final message) => Text(message, style: const TextStyle(color: AppColors.error, fontSize: 12)),
      ThawaniQueueStatsLoaded(:final pending, :final processing, :final completed, :final failed) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _queueStat(l10n.pending, pending, AppColors.warning),
          _queueStat(l10n.genericProcessing, processing, AppColors.info),
          _queueStat(l10n.done, completed, AppColors.success),
          _queueStat(l10n.deliveryFailed, failed, AppColors.error),
        ],
      ),
    };
  }

  Widget _queueStat(String label, int count, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context))),
      ],
    );
  }
}
