import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ThawaniCategoryMappingsPage extends ConsumerStatefulWidget {
  const ThawaniCategoryMappingsPage({super.key});

  @override
  ConsumerState<ThawaniCategoryMappingsPage> createState() => _ThawaniCategoryMappingsPageState();
}

class _ThawaniCategoryMappingsPageState extends ConsumerState<ThawaniCategoryMappingsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(thawaniCategoryMappingsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(thawaniCategoryMappingsProvider);
    final syncState = ref.watch(thawaniSyncProvider);
    final isLoading = syncState is ThawaniSyncLoading;

    ref.listen<ThawaniSyncState>(thawaniSyncProvider, (prev, next) {
      if (next is ThawaniSyncSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(thawaniSyncProvider.notifier).reset();
        ref.read(thawaniCategoryMappingsProvider.notifier).load();
      } else if (next is ThawaniSyncError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
  title: l10n.categoryMappings,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.cloud_upload, onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushCategories(), tooltip: 'Push to Thawani',
  ),
  PosButton.icon(
    icon: Icons.cloud_download, onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pullCategories(), tooltip: 'Pull from Thawani',
  ),
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(thawaniCategoryMappingsProvider.notifier).load(),
  ),
],
  child: switch (state) {
        ThawaniCategoryMappingsInitial() || ThawaniCategoryMappingsLoading() => Center(child: PosLoadingSkeleton.list()),
        ThawaniCategoryMappingsError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(thawaniCategoryMappingsProvider.notifier).load(),
        ),
        ThawaniCategoryMappingsLoaded(:final mappings) when mappings.isEmpty => const PosEmptyState(
          title: 'No category mappings yet',
          icon: Icons.category,
        ),
        ThawaniCategoryMappingsLoaded(:final mappings) => ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: mappings.length,
          itemBuilder: (context, index) {
            final mapping = mappings[index] as Map<String, dynamic>;
            final category = mapping['category'] as Map<String, dynamic>?;
            final syncStatus = mapping['sync_status'] as String? ?? 'unknown';
            final statusColor = switch (syncStatus) {
              'synced' => AppColors.success,
              'failed' => AppColors.error,
              'pending' => AppColors.warning,
              _ => AppColors.textSecondary,
            };

            return PosCard(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              borderRadius: AppRadius.borderMd,
              border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Icon(Icons.category, color: statusColor, size: 20),
                ),
                title: Text(
                  category?['name'] ?? category?['name_ar'] ?? 'Category #${mapping['category_id'] ?? '?'}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thawani: ${mapping['thawani_category_id'] ?? 'Unmapped'}',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    if (mapping['sync_error'] != null)
                      Text(
                        mapping['sync_error'].toString(),
                        style: TextStyle(fontSize: 11, color: AppColors.error),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
                  child: Text(
                    syncStatus.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ),
            );
          },
        ),
      },
);
  }
}
