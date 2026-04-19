import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/sync/providers/sync_providers.dart';
import 'package:wameedpos/features/sync/providers/sync_state.dart';
import 'package:wameedpos/features/sync/widgets/conflict_card.dart';
import 'package:wameedpos/features/sync/widgets/sync_log_list.dart';
import 'package:wameedpos/features/sync/widgets/sync_status_bar.dart';

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

    return PosListPage(
      title: AppLocalizations.of(context)!.syncTitle,
      showSearch: false,
      child: RefreshIndicator(
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
      SyncStatusInitial() || SyncStatusLoading() => const PosLoading(),
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
    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.syncFullSync,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH12,
            if (state is SyncOperationRunning)
              LinearProgressIndicator(semanticsLabel: AppLocalizations.of(context)!.syncSyncProgress(state.operation)),
            if (state is SyncOperationSuccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppLocalizations.of(context)!.syncRecordsSynced(state.recordsSynced),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success),
                ),
              ),
            if (state is SyncOperationError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(state.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error)),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                PosButton(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).push(terminalId: 'local', changes: []),
                  icon: Icons.cloud_upload,
                  label: AppLocalizations.of(context)!.syncPush,
                ),
                PosButton(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).pull(terminalId: 'local'),
                  variant: PosButtonVariant.outline,
                  icon: Icons.cloud_download,
                  label: AppLocalizations.of(context)!.syncPull,
                ),
                PosButton(
                  onPressed: state is SyncOperationRunning
                      ? null
                      : () => ref.read(syncOperationProvider.notifier).fullSync(terminalId: 'local'),
                  variant: PosButtonVariant.outline,
                  icon: Icons.sync,
                  label: AppLocalizations.of(context)!.syncFullSync,
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
      SyncConflictListInitial() || SyncConflictListLoading() => const PosLoading(),
      SyncConflictListLoaded(:final conflicts, :final total) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.syncUnresolvedConflicts(total),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH8,
          if (conflicts.isEmpty)
            PosCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(AppLocalizations.of(context)!.syncNoUnresolvedConflicts),
              ),
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
    return PosCard(
      color: AppColors.error.withValues(alpha: 0.08),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            Text(message, style: const TextStyle(color: AppColors.error)),
            AppSpacing.gapH8,
            PosButton(onPressed: onRetry, variant: PosButtonVariant.ghost, label: AppLocalizations.of(context)!.commonRetry),
          ],
        ),
      ),
    );
  }
}
