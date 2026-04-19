import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(adminTeamListProvider);
    final theme = Theme.of(context);
    final isLoading = state is AdminTeamListInitial || state is AdminTeamListLoading;
    final hasError = state is AdminTeamListError;
    final isEmpty = state is AdminTeamListLoaded && state.users.isEmpty;

    return PosListPage(
      title: l10n.adminTeam,
      searchController: _searchController,
      onSearchChanged: (_) => _loadTeam(),
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: _loadTeam,
      isEmpty: isEmpty,
      emptyTitle: 'No team members found',
      emptyIcon: Icons.people_outline,
      actions: [
        PosButton(label: l10n.adminAddTeamMember, icon: Icons.person_add, onPressed: () => context.push(Routes.adminTeamUserCreate)),
      ],
      filters: [
        SizedBox(
          width: 220,
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
            hint: l10n.commonStatus,
            showSearch: false,
            clearable: true,
          ),
        ),
      ],
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AdminTeamListLoaded(users: final users, total: final total, currentPage: final page, lastPage: final lastPage) =>
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: Text('$total team members', style: theme.textTheme.bodySmall),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: AppSpacing.paddingAll16,
                        itemCount: users.length,
                        separatorBuilder: (_, __) => AppSpacing.gapH8,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isActive = user['is_active'] == true;
                          return PosCard(
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
                                  AppSpacing.gapW8,
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
                            Text(l10n.adminPageOf(page.toString(), lastPage.toString())),
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
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}
