import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/branches/models/branch_stats.dart';
import 'package:thawani_pos/features/branches/providers/branch_providers.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';

class BranchListPage extends ConsumerStatefulWidget {
  const BranchListPage({super.key});

  @override
  ConsumerState<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends ConsumerState<BranchListPage> {
  final _searchController = TextEditingController();
  String? _selectedCity;
  bool? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(branchListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    ref
        .read(branchListProvider.notifier)
        .setFilters(search: value.isEmpty ? null : value, city: _selectedCity, isActive: _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(branchListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.branches),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(branchListProvider.notifier).load())],
      ),
      floatingActionButton: PosButton(
        onPressed: () => context.push('${Routes.branches}/create'),
        label: l10n.branchesCreateBranch,
      ),
      body: switch (state) {
        BranchListInitial() || BranchListLoading() => Center(child: PosLoadingSkeleton.list()),
        BranchListError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(branchListProvider.notifier).load(),
        ),
        BranchListLoaded(:final branches, :final stats) => _buildContent(branches, stats),
      },
    );
  }

  Widget _buildContent(List<Store> branches, BranchStats? stats) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => ref.read(branchListProvider.notifier).load(),
      child: CustomScrollView(
        slivers: [
          // Stats row
          if (stats != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.base, AppSpacing.base, 0),
                child: context.isPhone
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _statChipFixed(Icons.store, '${stats.totalBranches}', l10n.branchesTotalBranches),
                            AppSpacing.gapW8,
                            _statChipFixed(
                              Icons.check_circle_outline,
                              '${stats.activeBranches}',
                              l10n.branchesActiveBranches,
                              color: AppColors.success,
                            ),
                            AppSpacing.gapW8,
                            _statChipFixed(
                              Icons.pause_circle_outline,
                              '${stats.inactiveBranches}',
                              l10n.branchesInactiveBranches,
                              color: AppColors.error,
                            ),
                            if (stats.warehouses > 0) ...[
                              AppSpacing.gapW8,
                              _statChipFixed(
                                Icons.warehouse_outlined,
                                '${stats.warehouses}',
                                l10n.branchesWarehouses,
                                color: AppColors.info,
                              ),
                            ],
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          _statChip(Icons.store, '${stats.totalBranches}', l10n.branchesTotalBranches),
                          AppSpacing.gapW8,
                          _statChip(
                            Icons.check_circle_outline,
                            '${stats.activeBranches}',
                            l10n.branchesActiveBranches,
                            color: AppColors.success,
                          ),
                          AppSpacing.gapW8,
                          _statChip(
                            Icons.pause_circle_outline,
                            '${stats.inactiveBranches}',
                            l10n.branchesInactiveBranches,
                            color: AppColors.error,
                          ),
                          if (stats.warehouses > 0) ...[
                            AppSpacing.gapW8,
                            _statChip(
                              Icons.warehouse_outlined,
                              '${stats.warehouses}',
                              l10n.branchesWarehouses,
                              color: AppColors.info,
                            ),
                          ],
                        ],
                      ),
              ),
            ),

          // Search bar + filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Row(
                children: [
                  Expanded(
                    child: PosSearchField(controller: _searchController, hint: l10n.branchesSearch, onChanged: _onSearch),
                  ),
                  AppSpacing.gapW8,
                  PopupMenuButton<bool?>(
                    icon: Icon(
                      Icons.filter_list,
                      color: _selectedStatus != null
                          ? AppColors.primary
                          : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    onSelected: (value) {
                      setState(() => _selectedStatus = value);
                      ref
                          .read(branchListProvider.notifier)
                          .setFilters(
                            search: _searchController.text.isEmpty ? null : _searchController.text,
                            city: _selectedCity,
                            isActive: value,
                          );
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: null, child: Text(l10n.branchesAllBranches)),
                      PopupMenuItem(value: true, child: Text(l10n.branchesActive)),
                      PopupMenuItem(value: false, child: Text(l10n.branchesInactive)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Branch list
          if (branches.isEmpty)
            SliverFillRemaining(
              child: PosEmptyState(
                title: l10n.branchesNoBranches,
                icon: Icons.store_outlined,
                actionLabel: l10n.branchesCreateBranch,
                onAction: () => context.push('${Routes.branches}/create'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _branchCard(branches[index]),
                  childCount: branches.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color ?? AppColors.primary),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color ?? AppColors.primary),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: color ?? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChipFixed(IconData icon, String value, String label, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.primary),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color ?? AppColors.primary),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 8, color: color ?? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _branchCard(Store branch) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(
          color: branch.isMainBranch ? AppColors.primary20 : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        onTap: () => context.push('${Routes.branches}/${branch.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              CircleAvatar(
                radius: 22,
                backgroundColor: branch.isActive
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.textSecondary.withValues(alpha: 0.12),
                child: Icon(
                  branch.isWarehouse ? Icons.warehouse : (branch.isMainBranch ? Icons.store : Icons.storefront),
                  color: branch.isActive ? AppColors.success : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              AppSpacing.gapW12,
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            branch.name,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (branch.isMainBranch) PosStatusBadge(label: l10n.branchesMain, variant: PosStatusBadgeVariant.info),
                        if (branch.isWarehouse) ...[
                          const SizedBox(width: 4),
                          PosStatusBadge(label: l10n.branchesWarehouse, variant: PosStatusBadgeVariant.neutral),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (branch.city != null || branch.address != null)
                      Text(
                        [branch.city, branch.address].whereType<String>().join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: branch.isActive ? AppColors.success : AppColors.error),
                        const SizedBox(width: 4),
                        Text(
                          branch.isActive ? l10n.branchesActive : l10n.branchesInactive,
                          style: TextStyle(fontSize: 11, color: branch.isActive ? AppColors.success : AppColors.error),
                        ),
                        if (branch.branchCode != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            l10n.branchesCode(branch.branchCode!),
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                        if (branch.staffCount != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.people_outline,
                            size: 12,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${branch.staffCount}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ],
          ),
        ),
      ),
    );
  }
}
