import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/models/branch_stats.dart';
import 'package:wameedpos/features/branches/providers/branch_providers.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';

class BranchListPage extends ConsumerStatefulWidget {
  const BranchListPage({super.key});

  @override
  ConsumerState<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends ConsumerState<BranchListPage> {
  final _searchController = TextEditingController();
  final String? _selectedCity = null;
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
    final state = ref.watch(branchListProvider);

    final isLoading = state is BranchListInitial || state is BranchListLoading;
    final hasError = state is BranchListError;
    final errorMessage = state is BranchListError ? state.message : null;
    final branches = state is BranchListLoaded ? state.branches : const <Store>[];
    final stats = state is BranchListLoaded ? state.stats : null;

    final statusOptions = <PosDropdownItem<bool?>>[
      PosDropdownItem<bool?>(value: null, label: l10n.branchesAllBranches),
      PosDropdownItem<bool?>(value: true, label: l10n.branchesActive),
      PosDropdownItem<bool?>(value: false, label: l10n.branchesInactive),
    ];

    return PosListPage(
      title: l10n.branches,
      searchController: _searchController,
      searchHint: l10n.branchesSearch,
      onSearchChanged: _onSearch,
      filters: [
        SizedBox(
          width: 180,
          child: PosSearchableDropdown<bool?>(
            hint: l10n.allStatuses,
            items: statusOptions,
            selectedValue: _selectedStatus,
            onChanged: (v) {
              setState(() => _selectedStatus = v);
              ref
                  .read(branchListProvider.notifier)
                  .setFilters(
                    search: _searchController.text.isEmpty ? null : _searchController.text,
                    city: _selectedCity,
                    isActive: v,
                  );
            },
            showSearch: false,
            clearable: true,
          ),
        ),
      ],
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showBranchListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          onPressed: () => ref.read(branchListProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.branchesCreateBranch, icon: Icons.add, onPressed: () => context.push('${Routes.branches}/create')),
      ],
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: errorMessage,
      onRetry: () => ref.read(branchListProvider.notifier).load(),
      child: Column(
        children: [
          if (stats != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.md, AppSpacing.xxxl, AppSpacing.sm),
              child: _BranchStatsRow(stats: stats),
            ),
          Expanded(
            child: PosDataTable<Store>(
              items: branches,
              onRowTap: (b) => context.push('${Routes.branches}/${b.id}'),
              emptyConfig: PosTableEmptyConfig(
                icon: Icons.store_outlined,
                title: l10n.branchesNoBranches,
                action: () => context.push('${Routes.branches}/create'),
                actionLabel: l10n.branchesCreateBranch,
              ),
              columns: [
                PosTableColumn(title: l10n.branches),
                PosTableColumn(title: l10n.branchesType),
                PosTableColumn(title: l10n.branchesLocation),
                PosTableColumn(title: l10n.allStatus),
                PosTableColumn(title: l10n.branchesStaffColumn, numeric: true),
              ],
              cellBuilder: (b, colIndex, col) {
                switch (colIndex) {
                  case 0:
                    return _BranchNameCell(branch: b);
                  case 1:
                    return _BranchTypeCell(branch: b, l10n: l10n);
                  case 2:
                    return Text(
                      [b.city, b.address].whereType<String>().join(' · '),
                      style: AppTypography.tableCell,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  case 3:
                    return PosBadge(
                      label: b.isActive ? l10n.branchesActive : l10n.branchesInactive,
                      variant: b.isActive ? PosBadgeVariant.success : PosBadgeVariant.error,
                    );
                  case 4:
                    return Text(b.staffCount?.toString() ?? '-', style: AppTypography.tableCell);
                  default:
                    return const SizedBox.shrink();
                }
              },
              actions: [
                PosTableRowAction<Store>(
                  label: l10n.edit,
                  icon: Icons.edit_outlined,
                  onTap: (b) => context.push('${Routes.branches}/${b.id}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Stats row — uses PosKpiCard style
// ═══════════════════════════════════════════════════════════════

class _BranchStatsRow extends StatelessWidget {
  const _BranchStatsRow({required this.stats});
  final BranchStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet;

    final chips = <Widget>[
      _StatChip(icon: Icons.store_rounded, value: '${stats.totalBranches}', label: l10n.branchesTotalBranches),
      _StatChip(
        icon: Icons.check_circle_outline_rounded,
        value: '${stats.activeBranches}',
        label: l10n.branchesActiveBranches,
        color: AppColors.success,
      ),
      _StatChip(
        icon: Icons.pause_circle_outline_rounded,
        value: '${stats.inactiveBranches}',
        label: l10n.branchesInactiveBranches,
        color: AppColors.error,
      ),
      if (stats.warehouses > 0)
        _StatChip(
          icon: Icons.warehouse_outlined,
          value: '${stats.warehouses}',
          label: l10n.branchesWarehouses,
          color: AppColors.info,
        ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < chips.length; i++) ...[if (i > 0) AppSpacing.gapW8, SizedBox(width: 140, child: chips[i])],
          ],
        ),
      );
    }

    return Row(
      children: [
        for (int i = 0; i < chips.length; i++) ...[if (i > 0) AppSpacing.gapW12, Expanded(child: chips[i])],
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, required this.label, this.color});

  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
            child: Icon(icon, size: 18, color: accent),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.headlineSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Table cells
// ═══════════════════════════════════════════════════════════════

class _BranchNameCell extends StatelessWidget {
  const _BranchNameCell({required this.branch});
  final Store branch;

  @override
  Widget build(BuildContext context) {
    final accent = branch.isActive ? AppColors.success : AppColors.mutedFor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
            child: Icon(
              branch.isWarehouse
                  ? Icons.warehouse_outlined
                  : (branch.isMainBranch ? Icons.store_rounded : Icons.storefront_outlined),
              size: 18,
              color: accent,
            ),
          ),
          AppSpacing.gapW12,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(branch.name, style: AppTypography.tableCellBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (branch.branchCode != null)
                  Text(
                    branch.branchCode!,
                    style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchTypeCell extends StatelessWidget {
  const _BranchTypeCell({required this.branch, required this.l10n});
  final Store branch;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (branch.isMainBranch) {
      return PosBadge(label: l10n.branchesMain, variant: PosBadgeVariant.info);
    }
    if (branch.isWarehouse) {
      return PosBadge(label: l10n.branchesWarehouse, variant: PosBadgeVariant.neutral);
    }
    return PosBadge(label: l10n.branchesBranchLabel, variant: PosBadgeVariant.neutral);
  }
}
