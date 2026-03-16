import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_app_bar.dart';
import 'package:thawani_pos/features/sync/providers/sync_providers.dart';
import 'package:thawani_pos/features/sync/providers/sync_state.dart';
import 'package:thawani_pos/features/sync/widgets/conflict_card.dart';
import 'package:thawani_pos/features/sync/widgets/sync_log_list.dart';
import 'package:thawani_pos/features/sync/widgets/sync_status_bar.dart';

class SyncDashboardPage extends ConsumerStatefulWidget {
  const SyncDashboardPage({super.key});

  @override
  ConsumerState<SyncDashboardPage> createState() => _SyncDashboardPageState();
}

class _SyncDashboardPageState extends ConsumerState<SyncDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(syncStatusProvider.notifier).load();
      ref.read(syncConflictListProvider.notifier).load(status: 'unresolved');
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusState = ref.watch(syncStatusProvider);
    final conflictState = ref.watch(syncConflictListProvider);
    final operationState = ref.watch(syncOperationProvider);

    return Scaffold(
      appBar: const PosAppBar(title: 'Sync Dashboard'),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(syncStatusProvider.notifier).load();
          ref.read(syncConflictListProvider.notifier).load(status: 'unresolved');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusSection(statusState),
              AppSpacing.gapH16,
              _buildOperationSection(operationState),
              AppSpacing.gapH16,
              _buildConflictSection(conflictState),
              AppSpacing.gapH16,
              _buildLogSection(statusState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(SyncStatusState state) {
    return switch (state) {
      SyncStatusInitial() || SyncStatusLoading() => const Center(child: CircularProgressIndicator()),
      SyncStatusLoaded() => SyncStatusBar(
        serverOnline: state.serverOnline,
        pendingConflicts: state.pendingConflicts,
        failedSyncs: state.failedSyncs24h,
        lastSync: state.lastSync,
      ),
      SyncStatusError(:final message) => _ErrorCard(
        message: message,
        onRetry: () => ref.read(syncStatusProvider.notifier).load(),
      ),
    };
  }

  Widget _buildOperationSection(SyncOperationState state) {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            AppSpacing.gapH12,
            if (state is SyncOperationRunning) LinearProgressIndicator(semanticsLabel: 'Sync ${state.operation} in progress'),
            if (state is SyncOperationSuccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${state.recordsSynced} records synced',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
              ),
            if (state is SyncOperationError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(state.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red)),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).push(terminalId: 'local', changes: []),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Push'),
                ),
                OutlinedButton.icon(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).pull(terminalId: 'local'),
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Pull'),
                ),
                OutlinedButton.icon(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).fullSync(terminalId: 'local'),
                  icon: const Icon(Icons.sync),
                  label: const Text('Full Sync'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictSection(SyncConflictListState state) {
    return switch (state) {
      SyncConflictListInitial() || SyncConflictListLoading() => const Center(child: CircularProgressIndicator()),
      SyncConflictListLoaded(:final conflicts, :final total) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unresolved Conflicts ($total)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH8,
          if (conflicts.isEmpty)
            const Card(
              child: Padding(padding: EdgeInsets.all(16), child: Text('No unresolved conflicts')),
            )
          else
            ...conflicts.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ConflictCard(
                  conflict: c,
                  onResolve: (resolution) {
                    ref.read(syncConflictListProvider.notifier).resolveConflict(conflictId: c.id, resolution: resolution);
                  },
                ),
              ),
            ),
        ],
      ),
      SyncConflictListError(:final message) => _ErrorCard(
        message: message,
        onRetry: () => ref.read(syncConflictListProvider.notifier).load(status: 'unresolved'),
      ),
    };
  }

  Widget _buildLogSection(SyncStatusState state) {
    if (state is SyncStatusLoaded) {
      return SyncLogList(logs: state.recentLogs);
    }
    return const SizedBox.shrink();
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            Text(message, style: const TextStyle(color: Colors.red)),
            AppSpacing.gapH8,
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
