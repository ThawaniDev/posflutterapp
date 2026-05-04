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
          icon: Icons.cloud_upload,
          onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pushCategories(),
          tooltip: l10n.thawaniPushToThawani,
        ),
        PosButton.icon(
          icon: Icons.cloud_download,
          onPressed: isLoading ? null : () => ref.read(thawaniSyncProvider.notifier).pullCategories(),
          tooltip: l10n.thawaniPullFromThawani,
        ),
        PosButton.icon(icon: Icons.refresh, onPressed: () => ref.read(thawaniCategoryMappingsProvider.notifier).load()),
      ],
      child: switch (state) {
        ThawaniCategoryMappingsInitial() || ThawaniCategoryMappingsLoading() => Center(child: PosLoadingSkeleton.list()),
        ThawaniCategoryMappingsError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(thawaniCategoryMappingsProvider.notifier).load(),
        ),
        ThawaniCategoryMappingsLoaded(:final mappings) when mappings.isEmpty => PosEmptyState(
          title: l10n.thawaniNoCategoryMappings,
          icon: Icons.category,
        ),
        ThawaniCategoryMappingsLoaded(:final mappings) => ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: mappings.length,
          itemBuilder: (context, index) {
            final mapping = mappings[index] as Map<String, dynamic>;
            final category = mapping['category'] as Map<String, dynamic>?;
            final syncStatus = mapping['sync_status'] as String? ?? 'unknown';
            final (statusColor, badgeVariant) = switch (syncStatus) {
              'synced' => (AppColors.success, PosStatusBadgeVariant.success),
              'failed' => (AppColors.error, PosStatusBadgeVariant.error),
              'pending' => (AppColors.warning, PosStatusBadgeVariant.warning),
              _ => (Colors.grey, PosStatusBadgeVariant.neutral),
            };
            final mutedColor = AppColors.mutedFor(context);
            final categoryName =
                category?['name'] ?? category?['name_ar'] ?? l10n.thawaniCategoryNum('${mapping['category_id'] ?? '?'}');

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
                title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.thawaniThawaniLine((mapping['thawani_category_id'] ?? l10n.thawaniUnmapped).toString()),
                      style: TextStyle(fontSize: 12, color: mutedColor),
                    ),
                    if (mapping['sync_error'] != null)
                      Text(
                        mapping['sync_error'].toString(),
                        style: const TextStyle(fontSize: 11, color: AppColors.error),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: PosStatusBadge(label: syncStatus.toUpperCase(), variant: badgeVariant),
              ),
            );
          },
        ),
      },
    );
  }
}
