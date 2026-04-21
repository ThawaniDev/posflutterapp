import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';
import 'package:wameedpos/features/delivery_integration/widgets/menu_sync_status_card.dart';
import 'package:wameedpos/features/delivery_integration/repositories/delivery_repository.dart';

/// Sync log list provider
final _syncLogsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final result = await ref.watch(deliveryRepositoryProvider).getSyncLogs(perPage: 20);
  final data = result['data'] as Map<String, dynamic>? ?? {};
  final items = data['data'] as List<dynamic>? ?? [];
  return items.cast<Map<String, dynamic>>();
});

class MenuSyncPage extends ConsumerWidget {
  const MenuSyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = ref.watch(deliveryMenuSyncProvider);
    final logsAsync = ref.watch(_syncLogsProvider);
    final configsState = ref.watch(deliveryConfigsProvider);

    return PosListPage(
      title: l10n.deliveryMenuSync,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.refresh, onPressed: () => ref.invalidate(_syncLogsProvider))],
      child: ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // Sync trigger section
          _SyncTriggerSection(
            syncState: syncState,
            configsState: configsState,
            onSync: (platform) {
              // trigger sync with dummy products payload — the API expects product list
              ref
                  .read(deliveryMenuSyncProvider.notifier)
                  .sync(
                    platform: platform,
                    products: [
                      {'name': 'Full menu sync', 'price': 0, 'is_available': true},
                    ],
                  );
            },
          ),
          AppSpacing.gapH24,

          // Sync history
          Text(l10n.deliverySyncHistory, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          logsAsync.when(
            data: (logs) => logs.isEmpty
                ? PosEmptyState(title: l10n.deliveryNoSyncLogs, icon: Icons.sync_disabled)
                : Column(
                    children: logs
                        .map(
                          (log) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: MenuSyncStatusCard(syncLog: log),
                          ),
                        )
                        .toList(),
                  ),
            loading: () => PosLoadingSkeleton.list(),
            error: (e, _) => PosErrorState(message: e.toString(), onRetry: () => ref.invalidate(_syncLogsProvider)),
          ),
        ],
      ),
    );
  }
}

class _SyncTriggerSection extends StatefulWidget {

  const _SyncTriggerSection({required this.syncState, required this.configsState, required this.onSync});
  final DeliveryMenuSyncState syncState;
  final DeliveryConfigsState configsState;
  final void Function(String? platform) onSync;

  @override
  State<_SyncTriggerSection> createState() => _SyncTriggerSectionState();
}

class _SyncTriggerSectionState extends State<_SyncTriggerSection> {
  String? _selectedPlatform;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = widget.syncState is DeliveryMenuSyncLoading;

    // Get enabled platforms from configs
    final enabledPlatforms = <Map<String, dynamic>>[];
    if (widget.configsState is DeliveryConfigsLoaded) {
      enabledPlatforms.addAll((widget.configsState as DeliveryConfigsLoaded).configs.where((c) => c['is_enabled'] == true));
    }

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(BorderSide(color: AppColors.info.withValues(alpha: 0.3))),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: AppColors.info),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.deliveryTriggerSync, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(l10n.deliveryTriggerSyncDesc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,

            // Platform selector
            if (enabledPlatforms.isNotEmpty) ...[
              PosSearchableDropdown<String?>(
                items: enabledPlatforms.map((c) {
                  final slug = c['platform'] as String? ?? '';
                  final platform = DeliveryConfigPlatform.tryFromValue(slug);
                  return PosDropdownItem<String?>(value: slug, label: platform?.label ?? slug, icon: platform?.icon);
                }).toList(),
                selectedValue: _selectedPlatform,
                onChanged: (v) => setState(() => _selectedPlatform = v),
                label: l10n.deliverySelectPlatform,
                hint: l10n.deliveryAllPlatforms,
                showSearch: false,
                clearable: true,
              ),
              AppSpacing.gapH12,
            ],

            // Sync button
            PosButton(
              label: isLoading ? l10n.deliverySyncing : l10n.deliverySyncNow,
              icon: Icons.sync,
              isLoading: isLoading,
              isFullWidth: true,
              onPressed: isLoading || enabledPlatforms.isEmpty ? null : () => widget.onSync(_selectedPlatform),
            ),

            // Result message
            if (widget.syncState is DeliveryMenuSyncSuccess) ...[
              AppSpacing.gapH12,
              Container(
                padding: AppSpacing.paddingAll12,
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(
                        (widget.syncState as DeliveryMenuSyncSuccess).message,
                        style: const TextStyle(fontSize: 12, color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.syncState is DeliveryMenuSyncError) ...[
              AppSpacing.gapH12,
              Container(
                padding: AppSpacing.paddingAll12,
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(
                        (widget.syncState as DeliveryMenuSyncError).message,
                        style: const TextStyle(fontSize: 12, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (enabledPlatforms.isEmpty) ...[
              AppSpacing.gapH12,
              Text(l10n.deliveryNoPlatformsForSync, style: const TextStyle(fontSize: 12, color: AppColors.warning)),
            ],
          ],
        ),
      ),
    );
  }
}
