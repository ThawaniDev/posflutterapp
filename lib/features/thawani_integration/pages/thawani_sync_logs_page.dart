import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ThawaniSyncLogsPage extends ConsumerStatefulWidget {
  const ThawaniSyncLogsPage({super.key});

  @override
  ConsumerState<ThawaniSyncLogsPage> createState() => _ThawaniSyncLogsPageState();
}

class _ThawaniSyncLogsPageState extends ConsumerState<ThawaniSyncLogsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _entityTypeFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(thawaniSyncLogsProvider.notifier).load();
    });
  }

  void _applyFilters() {
    ref.read(thawaniSyncLogsProvider.notifier).load(entityType: _entityTypeFilter, status: _statusFilter, perPage: 50);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(thawaniSyncLogsProvider);

    return PosListPage(
      title: l10n.syncLogs,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.refresh, onPressed: _applyFilters)],
      child: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: PosDropdown<String?>(
                    value: _entityTypeFilter,
                    label: l10n.genericEntityType,
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      DropdownMenuItem(value: 'product', child: Text(l10n.wameedAIProduct)),
                      DropdownMenuItem(value: 'category', child: Text(l10n.category)),
                      DropdownMenuItem(value: 'connection', child: Text(l10n.hwConnection)),
                    ],
                    onChanged: (v) {
                      setState(() => _entityTypeFilter = v);
                      _applyFilters();
                    },
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosDropdown<String?>(
                    value: _statusFilter,
                    label: l10n.status,
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      DropdownMenuItem(value: 'success', child: Text(l10n.success)),
                      DropdownMenuItem(value: 'failed', child: Text(l10n.deliveryFailed)),
                      DropdownMenuItem(value: 'pending', child: Text(l10n.pending)),
                    ],
                    onChanged: (v) {
                      setState(() => _statusFilter = v);
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Log list
          Expanded(
            child: switch (state) {
              ThawaniSyncLogsInitial() || ThawaniSyncLogsLoading() => Center(child: PosLoadingSkeleton.list()),
              ThawaniSyncLogsError(:final message) => PosErrorState(message: message, onRetry: _applyFilters),
              ThawaniSyncLogsLoaded(:final logs) when logs.isEmpty => PosEmptyState(
                title: l10n.thawaniNoSyncLogs,
                icon: Icons.history,
              ),
              ThawaniSyncLogsLoaded(:final logs, :final pagination) => Column(
                children: [
                  if (pagination != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        l10n.genericPaginationInfo(
                          pagination['current_page'] as int? ?? 1,
                          pagination['last_page'] as int? ?? 1,
                          pagination['total'] as int? ?? 0,
                        ),
                        style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context)),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: logs.length,
                      itemBuilder: (context, index) => _buildLogItem(logs[index] as Map<String, dynamic>),
                    ),
                  ),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    final status = log['status'] as String? ?? '';
    final (statusColor, badgeVariant) = switch (status) {
      'success' => (AppColors.success, PosStatusBadgeVariant.success),
      'failed' => (AppColors.error, PosStatusBadgeVariant.error),
      'pending' => (AppColors.warning, PosStatusBadgeVariant.warning),
      _ => (Colors.grey, PosStatusBadgeVariant.neutral),
    };
    final entityType = log['entity_type'] as String? ?? '';
    final entityIcon = switch (entityType) {
      'product' => Icons.inventory,
      'category' => Icons.category,
      'connection' => Icons.link,
      _ => Icons.sync,
    };
    final direction = log['direction'] as String? ?? '';
    final directionIcon = direction == 'outgoing' ? Icons.arrow_upward : Icons.arrow_downward;
    final createdAt = log['created_at']?.toString() ?? '';
    final mutedColor = AppColors.mutedFor(context);

    return PosCard(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 6),
      borderRadius: AppRadius.borderSm,
      border: Border.fromBorderSide(BorderSide(color: statusColor.withValues(alpha: 0.3))),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: statusColor.withValues(alpha: 0.1),
          child: Icon(entityIcon, color: statusColor, size: 16),
        ),
        title: Row(
          children: [
            Text(
              (log['action'] as String? ?? '').toUpperCase(),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
            ),
            AppSpacing.gapW8,
            Icon(directionIcon, size: 14, color: mutedColor),
            AppSpacing.gapW4,
            Text(direction, style: TextStyle(fontSize: 11, color: mutedColor)),
          ],
        ),
        subtitle: Text(
          createdAt.length >= 19 ? createdAt.substring(0, 19).replaceFirst('T', ' ') : createdAt,
          style: TextStyle(fontSize: 11, color: mutedColor),
        ),
        trailing: PosStatusBadge(label: status.toUpperCase(), variant: badgeVariant),
        children: [
          if (log['error_message'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, size: 14, color: AppColors.error),
                  AppSpacing.gapW4,
                  Expanded(
                    child: Text(log['error_message'].toString(), style: const TextStyle(fontSize: 12, color: AppColors.error)),
                  ),
                ],
              ),
            ),
          if (log['http_status_code'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Text(
                l10n.thawaniHttpStatus(log['http_status_code'].toString()),
                style: TextStyle(fontSize: 11, color: mutedColor),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
