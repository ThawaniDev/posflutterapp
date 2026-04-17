import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminTeamListPage extends ConsumerStatefulWidget {
  const AdminTeamListPage({super.key});

  @override
  ConsumerState<AdminTeamListPage> createState() => _AdminTeamListPageState();
}

class _AdminTeamListPageState extends ConsumerState<AdminTeamListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _storeId;
  bool? _activeFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadTeam();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTeam() {
    ref
        .read(adminTeamListProvider.notifier)
        .load(
          search: _searchController.text.isEmpty ? null : _searchController.text,
          isActive: _activeFilter,
          storeId: _storeId,
          page: _currentPage,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminTeamListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Team'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Team Member',
            onPressed: () => context.push(Routes.adminTeamUserCreate),
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // ─── Filter Bar ─────────────────────────────
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _searchController,
                    hint: 'Search by name or email...',
                    prefixIcon: Icons.search,
                    onChanged: (_) => _loadTeam(),
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: PosSearchableDropdown<bool>(
                    items: [
                      PosDropdownItem(value: true, label: l10n.active),
                      PosDropdownItem(value: false, label: l10n.inactive),
                    ],
                    selectedValue: _activeFilter,
                    onChanged: (val) {
                      setState(() => _activeFilter = val);
                      _loadTeam();
                    },
                    hint: 'Status',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),

          // ─── Content ────────────────────────────────
          Expanded(
            child: switch (state) {
              AdminTeamListInitial() || AdminTeamListLoading() => const Center(child: CircularProgressIndicator()),
              AdminTeamListError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(msg, style: theme.textTheme.bodyLarge),
                    AppSpacing.gapH16,
                    PosButton(label: l10n.retry, onPressed: _loadTeam),
                  ],
                ),
              ),
              AdminTeamListLoaded(users: final users, total: final total, currentPage: final page, lastPage: final lastPage) =>
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$total team members', style: theme.textTheme.bodySmall),
                    ),
                    Expanded(
                      child: users.isEmpty
                          ? const Center(child: Text('No team members found'))
                          : ListView.separated(
                              padding: AppSpacing.paddingAll16,
                              itemCount: users.length,
                              separatorBuilder: (_, __) => AppSpacing.gapH8,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final isActive = user['is_active'] == true;
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: isActive
                                          ? AppColors.success.withValues(alpha: 0.1)
                                          : AppColors.error.withValues(alpha: 0.1),
                                      child: Icon(Icons.person, color: isActive ? AppColors.success : AppColors.error),
                                    ),
                                    title: Text(user['name'] as String? ?? ''),
                                    subtitle: Text(user['email'] as String? ?? ''),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isActive ? AppColors.success : AppColors.error,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                    onTap: () => context.push('${Routes.adminTeamUserDetail}/${user['id']}'),
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
                                      _loadTeam();
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text('Page $page of $lastPage'),
                            IconButton(
                              onPressed: page < lastPage
                                  ? () {
                                      _currentPage = page + 1;
                                      _loadTeam();
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
}
