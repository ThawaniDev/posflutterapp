import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/sync/providers/sync_providers.dart';
import 'package:wameedpos/features/sync/providers/sync_state.dart';

class SyncLogsPage extends ConsumerStatefulWidget {
  const SyncLogsPage({super.key});

  @override
  ConsumerState<SyncLogsPage> createState() => _SyncLogsPageState();
}

class _SyncLogsPageState extends ConsumerState<SyncLogsPage> {
  String? _directionFilter;
  String? _statusFilter;

  static const _directions = ['push', 'pull', 'full'];
  static const _statuses = ['success', 'partial', 'failed'];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  void _load({int page = 1}) {
    ref.read(syncLogsProvider.notifier).load(direction: _directionFilter, status: _statusFilter, page: page);
  }

  Color _statusColor(String status) => switch (status) {
    'success' => AppColors.success,
    'partial' => AppColors.warning,
    'failed' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  IconData _directionIcon(String direction) => switch (direction) {
    'push' => Icons.cloud_upload_outlined,
    'pull' => Icons.cloud_download_outlined,
    'full' => Icons.sync,
    _ => Icons.sync,
  };

  Color _directionColor(String direction) => switch (direction) {
    'push' => AppColors.primary,
    'pull' => AppColors.info,
    'full' => AppColors.success,
    _ => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final logsState = ref.watch(syncLogsProvider);

    return PosListPage(
      title: l10n.syncLogsTitle,
      showSearch: false,
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load, tooltip: l10n.retry)],
      child: Column(
        children: [
          _buildFilters(l10n),
          Expanded(
            child: switch (logsState) {
              SyncLogsInitial() || SyncLogsLoading() => const Center(child: PosLoading()),
              SyncLogsError(:final message) => Center(
                child: _ErrorCard(message: message, onRetry: _load),
              ),
              SyncLogsLoaded(:final logs, :final currentPage, :final lastPage, :final total) =>
                logs.isEmpty
                    ? Center(child: _EmptyState(l10n: l10n))
                    : Column(
                        children: [
                          Expanded(child: _buildLogsTable(logs, l10n)),
                          _buildPagination(currentPage, lastPage, total, l10n),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: PosDropdown<String?>(
              label: l10n.syncLogsFilterDirection,
              value: _directionFilter,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.syncAll)),
                ..._directions.map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Row(
                      children: [
                        Icon(_directionIcon(d), size: 16, color: _directionColor(d)),
                        AppSpacing.gapW8,
                        Text(d.toUpperCase()),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() => _directionFilter = v);
                _load();
              },
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: PosDropdown<String?>(
              label: l10n.syncLogsFilterStatus,
              value: _statusFilter,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.syncAll)),
                ..._statuses.map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: _statusColor(s), shape: BoxShape.circle),
                        ),
                        AppSpacing.gapW8,
                        Text(s[0].toUpperCase() + s.substring(1)),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _load();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTable(List<Map<String, dynamic>> logs, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return PosDataTable<Map<String, dynamic>>(
      columns: [
        PosTableColumn(title: l10n.syncLogsFilterDirection, flex: 1),
        PosTableColumn(title: l10n.syncLogsFilterStatus, flex: 1),
        PosTableColumn(title: l10n.syncLogsRecordsCount(0).replaceAll('0', '#'), flex: 1, numeric: true),
        PosTableColumn(title: l10n.syncLogsTerminal, flex: 2),
        PosTableColumn(title: l10n.syncLogsDuration(0).replaceAll('0', 'ms'), flex: 1, numeric: true),
        PosTableColumn(title: l10n.cashSessionOpenedAt, flex: 2),
      ],
      items: logs,
      cellBuilder: (log, colIndex, column) {
        final direction = log['direction'] as String? ?? '';
        final status = log['status'] as String? ?? '';
        final records = log['records_count'] as int? ?? 0;
        final durationMs = log['duration_ms'] as int? ?? 0;
        final terminalId = log['terminal_id'] as String? ?? '';
        final startedAt = log['started_at'] as String?;
        final errorMessage = log['error_message'] as String?;
        final shortTerminal = terminalId.length > 8 ? '${terminalId.substring(0, 8)}…' : terminalId;

        return switch (colIndex) {
          0 => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_directionIcon(direction), size: 14, color: _directionColor(direction)),
              AppSpacing.gapW4,
              Text(direction.toUpperCase(), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          1 => Tooltip(
            message: errorMessage ?? '',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.15), borderRadius: AppRadius.borderFull),
              child: Text(
                status.isEmpty ? '—' : status[0].toUpperCase() + status.substring(1),
                style: theme.textTheme.labelSmall?.copyWith(color: _statusColor(status), fontWeight: FontWeight.w600),
              ),
            ),
          ),
          2 => Text(records.toString()),
          3 => Tooltip(
            message: terminalId,
            child: Text(shortTerminal, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
          ),
          4 => Text('${durationMs}ms'),
          _ => Text(
            startedAt != null ? DateTime.tryParse(startedAt)?.toLocal().toString().substring(0, 16) ?? startedAt : '—',
            style: theme.textTheme.bodySmall,
          ),
        };
      },
    );
  }

  Widget _buildPagination(int currentPage, int lastPage, int total, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${(currentPage - 1) * 25 + 1}–${(currentPage * 25).clamp(0, total)} of $total',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1 ? () => _load(page: currentPage - 1) : null,
              ),
              Text('$currentPage / $lastPage'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < lastPage ? () => _load(page: currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            AppSpacing.gapH12,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapH16,
            PosButton(onPressed: onRetry, label: AppLocalizations.of(context)!.retry, icon: Icons.refresh),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.history, size: 56, color: AppColors.textSecondary),
        AppSpacing.gapH12,
        Text(l10n.syncLogsEmpty, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
