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
    icon: Icons.refresh, onPressed: isLoading ? null : () => ref.read(thawaniQueueStatsProvider.notifier).load(),
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
            title: 'Category Sync',
            icon: Icons.category,
            color: AppColors.purple,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _syncButton(
                      label: 'Push to Thawani',
                      icon: Icons.cloud_upload,
                      color: AppColors.purple,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'push-categories',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushCategories(),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _syncButton(
                      label: 'Pull from Thawani',
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
            title: 'Product Sync',
            icon: Icons.inventory,
            color: AppColors.success,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _syncButton(
                      label: 'Push to Thawani',
                      icon: Icons.cloud_upload,
                      color: AppColors.success,
                      isLoading: isLoading && (syncState as ThawaniSyncLoading?)?.operation == 'push-products',
                      onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushProducts(),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _syncButton(
                      label: 'Pull from Thawani',
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
            title: 'Sync Queue',
            icon: Icons.queue,
            color: AppColors.warning,
            children: [
              _buildQueueStats(queueState),
              AppSpacing.gapH12,
              _syncButton(
                label: 'Process Queue Now',
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
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                AppSpacing.gapW8,
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            AppSpacing.gapH12,
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _syncButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color))
            : Icon(icon, color: color, size: 18),
        label: Text(label, style: TextStyle(color: color, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildQueueStats(ThawaniQueueStatsState state) {
    return switch (state) {
      ThawaniQueueStatsInitial() ||
      ThawaniQueueStatsLoading() => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      ThawaniQueueStatsError(:final message) => Text(message, style: TextStyle(color: AppColors.error, fontSize: 12)),
      ThawaniQueueStatsLoaded(:final pending, :final processing, :final completed, :final failed) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _queueStat('Pending', pending, AppColors.warning),
          _queueStat('Processing', processing, AppColors.info),
          _queueStat('Done', completed, AppColors.success),
          _queueStat('Failed', failed, AppColors.error),
        ],
      ),
    };
  }

  Widget _queueStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
