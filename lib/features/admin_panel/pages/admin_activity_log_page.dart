import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminActivityLogPage extends ConsumerStatefulWidget {
  const AdminActivityLogPage({super.key});

  @override
  ConsumerState<AdminActivityLogPage> createState() => _AdminActivityLogPageState();
}

class _AdminActivityLogPageState extends ConsumerState<AdminActivityLogPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _actionFilter;
  String? _entityTypeFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadLogs();
    });
  }

  void _loadLogs() {
    ref
        .read(activityLogProvider.notifier)
        .load(action: _actionFilter, entityType: _entityTypeFilter, storeId: _storeId, page: _currentPage);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityLogProvider);
    final theme = Theme.of(context);

    final isLoading = state is ActivityLogInitial || state is ActivityLogLoading;
    final hasError = state is ActivityLogError;

    return PosListPage(
      title: l10n.activityLog,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: _loadLogs,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: 'role.created', label: 'Role Created'),
                      PosDropdownItem(value: 'role.updated', label: 'Role Updated'),
                      PosDropdownItem(value: 'role.deleted', label: 'Role Deleted'),
                      PosDropdownItem(value: 'user.created', label: 'User Created'),
                      PosDropdownItem(value: 'user.updated', label: 'User Updated'),
                      PosDropdownItem(value: 'user.deactivated', label: 'User Deactivated'),
                      PosDropdownItem(value: 'user.activated', label: 'User Activated'),
                    ],
                    selectedValue: _actionFilter,
                    onChanged: (val) {
                      setState(() {
                        _actionFilter = val;
                        _currentPage = 1;
                      });
                      _loadLogs();
                    },
                    hint: 'All Actions',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: 'admin_role', label: l10n.roles),
                      PosDropdownItem(value: 'admin_user', label: l10n.users),
                    ],
                    selectedValue: _entityTypeFilter,
                    onChanged: (val) {
                      setState(() {
                        _entityTypeFilter = val;
                        _currentPage = 1;
                      });
                      _loadLogs();
                    },
                    hint: 'All Entities',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
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
                                return PosCard(
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
              _ => const SizedBox.shrink(),
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
