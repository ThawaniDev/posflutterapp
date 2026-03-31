import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/sync/providers/sync_providers.dart';
import 'package:thawani_pos/features/sync/providers/sync_state.dart';

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
    final theme = Theme.of(context);
    final state = ref.watch(syncConflictListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conflict Resolution'),
        actions: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'unresolved', label: Text('Open')),
              ButtonSegment(value: 'resolved', label: Text('Resolved')),
              ButtonSegment(value: 'all', label: Text('All')),
            ],
            selected: {_filter},
            onSelectionChanged: (v) {
              setState(() => _filter = v.first);
              ref.read(syncConflictListProvider.notifier).load(status: _filter == 'all' ? null : _filter);
            },
          ),
          AppSpacing.gapW16,
        ],
      ),
      body: switch (state) {
        SyncConflictListInitial() || SyncConflictListLoading() => const Center(child: CircularProgressIndicator()),
        SyncConflictListError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.gapH12,
              Text(message),
              AppSpacing.gapH12,
              FilledButton(
                onPressed: () => ref.read(syncConflictListProvider.notifier).load(status: _filter),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        SyncConflictListLoaded(:final conflicts) =>
          conflicts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
                      AppSpacing.gapH12,
                      Text('No conflicts', style: theme.textTheme.titleSmall),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: conflicts.length,
                  itemBuilder: (context, index) {
                    final conflict = conflicts[index];
                    final isResolved = conflict.resolution != null;

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
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
                                Expanded(
                                  child: Text('${conflict.tableName} — ${conflict.recordId}', style: theme.textTheme.titleSmall),
                                ),
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
                                  child: _DataPanel(title: 'Local Data', data: conflict.localData, color: AppColors.info),
                                ),
                                AppSpacing.gapW12,
                                Expanded(
                                  child: _DataPanel(title: 'Cloud Data', data: conflict.cloudData, color: AppColors.primary),
                                ),
                              ],
                            ),

                            // Resolution buttons
                            if (!isResolved) ...[
                              AppSpacing.gapH16,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      ref
                                          .read(syncConflictListProvider.notifier)
                                          .resolveConflict(conflictId: conflict.id, resolution: 'local_wins');
                                    },
                                    child: const Text('Use Local'),
                                  ),
                                  AppSpacing.gapW8,
                                  FilledButton(
                                    onPressed: () {
                                      ref
                                          .read(syncConflictListProvider.notifier)
                                          .resolveConflict(conflictId: conflict.id, resolution: 'cloud_wins');
                                    },
                                    child: const Text('Use Cloud'),
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
      },
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _DataPanel extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final Color color;

  const _DataPanel({required this.title, required this.data, required this.color});

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
              '+ ${data.length - 8} more fields',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 10),
            ),
        ],
      ),
    );
  }
}
