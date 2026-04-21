import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/sync/providers/sync_providers.dart';
import 'package:wameedpos/features/sync/providers/sync_state.dart';

class ConflictResolutionPage extends ConsumerStatefulWidget {
  const ConflictResolutionPage({super.key});

  @override
  ConsumerState<ConflictResolutionPage> createState() => _ConflictResolutionPageState();
}

class _ConflictResolutionPageState extends ConsumerState<ConflictResolutionPage> {
  String _filter = 'unresolved';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(syncConflictListProvider.notifier).load(status: _filter));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(syncConflictListProvider);

    final isLoading = state is SyncConflictListInitial || state is SyncConflictListLoading;
    final hasError = state is SyncConflictListError;
    final isEmpty = state is SyncConflictListLoaded && state.conflicts.isEmpty;

    return PosListPage(
      title: l10n.syncConflictResolution,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(syncConflictListProvider.notifier).load(status: _filter == 'all' ? null : _filter),
      isEmpty: isEmpty,
      emptyIcon: Icons.check_circle_outline,
      emptyTitle: l10n.syncNoConflicts,
      filters: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'unresolved', label: Text(l10n.syncOpen)),
            ButtonSegment(value: 'resolved', label: Text(l10n.syncResolved)),
            ButtonSegment(value: 'all', label: Text(l10n.syncAll)),
          ],
          selected: {_filter},
          onSelectionChanged: (v) {
            setState(() => _filter = v.first);
            ref.read(syncConflictListProvider.notifier).load(status: _filter == 'all' ? null : _filter);
          },
        ),
      ],
      child: switch (state) {
        SyncConflictListLoaded(:final conflicts) => ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: conflicts.length,
          itemBuilder: (context, index) {
            final conflict = conflicts[index];
            final isResolved = conflict.resolution != null;

            return PosCard(
              borderRadius: AppRadius.borderLg,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          isResolved ? Icons.check_circle : Icons.warning_amber,
                          color: isResolved ? AppColors.success : AppColors.warning,
                          size: 20,
                        ),
                        AppSpacing.gapW8,
                        Expanded(child: Text('${conflict.tableName} — ${conflict.recordId}', style: theme.textTheme.titleSmall)),
                        if (isResolved)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderSm,
                            ),
                            child: Text(
                              conflict.resolution!.value,
                              style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        if (conflict.detectedAt != null) ...[
                          AppSpacing.gapW8,
                          Text(
                            _formatTime(conflict.detectedAt!),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.gapH16,

                    // Side-by-side comparison
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DataPanel(title: l10n.syncLocalData, data: conflict.localData, color: AppColors.info),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: _DataPanel(title: l10n.syncCloudData, data: conflict.cloudData, color: AppColors.primary),
                        ),
                      ],
                    ),

                    // Resolution buttons
                    if (!isResolved) ...[
                      AppSpacing.gapH16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PosButton(
                            onPressed: () {
                              ref
                                  .read(syncConflictListProvider.notifier)
                                  .resolveConflict(conflictId: conflict.id, resolution: 'local_wins');
                            },
                            variant: PosButtonVariant.outline,
                            label: l10n.syncUseLocal,
                          ),
                          AppSpacing.gapW8,
                          PosButton(
                            onPressed: () {
                              ref
                                  .read(syncConflictListProvider.notifier)
                                  .resolveConflict(conflictId: conflict.id, resolution: 'cloud_wins');
                            },
                            variant: PosButtonVariant.soft,
                            label: l10n.syncUseCloud,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _DataPanel extends StatelessWidget {

  const _DataPanel({required this.title, required this.data, required this.color});
  final String title;
  final Map<String, dynamic> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppSpacing.paddingAll12,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH8,
          ...data.entries
              .take(8)
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.hintColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${entry.value}',
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (data.length > 8)
            Text(
              AppLocalizations.of(context)!.conflictMoreFields(data.length - 8),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 10),
            ),
        ],
      ),
    );
  }
}
