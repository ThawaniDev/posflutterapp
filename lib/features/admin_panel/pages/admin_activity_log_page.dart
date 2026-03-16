import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminActivityLogPage extends ConsumerStatefulWidget {
  const AdminActivityLogPage({super.key});

  @override
  ConsumerState<AdminActivityLogPage> createState() => _AdminActivityLogPageState();
}

class _AdminActivityLogPageState extends ConsumerState<AdminActivityLogPage> {
  String? _actionFilter;
  String? _entityTypeFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadLogs());
  }

  void _loadLogs() {
    ref.read(activityLogProvider.notifier).load(action: _actionFilter, entityType: _entityTypeFilter, page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityLogProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Log')),
      body: Column(
        children: [
          // ─── Filters ──────────────────────────────
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String?>(
                    value: _actionFilter,
                    isExpanded: true,
                    hint: const Text('Action'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Actions')),
                      DropdownMenuItem(value: 'role.created', child: Text('Role Created')),
                      DropdownMenuItem(value: 'role.updated', child: Text('Role Updated')),
                      DropdownMenuItem(value: 'role.deleted', child: Text('Role Deleted')),
                      DropdownMenuItem(value: 'user.created', child: Text('User Created')),
                      DropdownMenuItem(value: 'user.updated', child: Text('User Updated')),
                      DropdownMenuItem(value: 'user.deactivated', child: Text('User Deactivated')),
                      DropdownMenuItem(value: 'user.activated', child: Text('User Activated')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _actionFilter = val;
                        _currentPage = 1;
                      });
                      _loadLogs();
                    },
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: DropdownButton<String?>(
                    value: _entityTypeFilter,
                    isExpanded: true,
                    hint: const Text('Entity'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Entities')),
                      DropdownMenuItem(value: 'admin_role', child: Text('Roles')),
                      DropdownMenuItem(value: 'admin_user', child: Text('Users')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _entityTypeFilter = val;
                        _currentPage = 1;
                      });
                      _loadLogs();
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─── Content ──────────────────────────────
          Expanded(
            child: switch (state) {
              ActivityLogInitial() || ActivityLogLoading() => const Center(child: CircularProgressIndicator()),
              ActivityLogError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(msg),
                    AppSpacing.gapH16,
                    PosButton(label: 'Retry', onPressed: _loadLogs),
                  ],
                ),
              ),
              ActivityLogLoaded(logs: final logs, total: final total, currentPage: final page, lastPage: final lastPage) =>
                Column(
                  children: [
                    Padding(
                      padding: AppSpacing.paddingAll8,
                      child: Text('$total log entries', style: theme.textTheme.bodySmall),
                    ),
                    Expanded(
                      child: logs.isEmpty
                          ? const Center(child: Text('No activity logs found'))
                          : ListView.separated(
                              padding: AppSpacing.paddingAll16,
                              itemCount: logs.length,
                              separatorBuilder: (_, __) => AppSpacing.gapH4,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return Card(
                                  child: ListTile(
                                    dense: true,
                                    leading: _actionIcon(log['action'] as String? ?? ''),
                                    title: Text(
                                      log['action'] as String? ?? '',
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      '${log['admin_user_name'] ?? 'Unknown'} - '
                                      '${log['entity_type'] ?? ''} '
                                      '${log['created_at'] ?? ''}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    trailing: log['ip_address'] != null
                                        ? Text(
                                            log['ip_address'] as String,
                                            style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'monospace'),
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                    if (lastPage > 1)
                      Padding(
                        padding: AppSpacing.paddingAll8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: page > 1
                                  ? () {
                                      _currentPage = page - 1;
                                      _loadLogs();
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text('Page $page of $lastPage'),
                            IconButton(
                              onPressed: page < lastPage
                                  ? () {
                                      _currentPage = page + 1;
                                      _loadLogs();
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
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

  Widget _actionIcon(String action) {
    if (action.contains('created')) {
      return Icon(Icons.add_circle_outline, color: AppColors.success, size: 20);
    } else if (action.contains('deleted')) {
      return Icon(Icons.delete_outline, color: AppColors.error, size: 20);
    } else if (action.contains('deactivated')) {
      return Icon(Icons.block, color: AppColors.warning, size: 20);
    } else if (action.contains('activated')) {
      return Icon(Icons.check_circle_outline, color: AppColors.success, size: 20);
    }
    return Icon(Icons.edit_outlined, color: AppColors.primary, size: 20);
  }
}
