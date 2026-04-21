import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/branches/providers/branch_providers.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';
import 'package:wameedpos/features/staff/enums/employment_type.dart';
import 'package:wameedpos/features/staff/enums/staff_status.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class StaffListPage extends ConsumerStatefulWidget {
  const StaffListPage({super.key});

  @override
  ConsumerState<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends ConsumerState<StaffListPage> {
  final _searchController = TextEditingController();
  String? _statusFilter;
  String? _employmentTypeFilter;
  String? _selectedStoreId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(branchListProvider.notifier).load();
      _loadStaff();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStaff() {
    ref
        .read(staffListProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          status: _statusFilter,
          employmentType: _employmentTypeFilter,
          storeId: _selectedStoreId,
        );
  }

  PosBadgeVariant _statusVariant(StaffStatus? status) {
    switch (status) {
      case StaffStatus.active:
        return PosBadgeVariant.success;
      case StaffStatus.onLeave:
        return PosBadgeVariant.warning;
      case StaffStatus.inactive:
      case null:
        return PosBadgeVariant.neutral;
    }
  }

  String _statusLabel(StaffStatus? status, AppLocalizations l10n) {
    switch (status) {
      case StaffStatus.active:
        return l10n.branchesActive;
      case StaffStatus.inactive:
        return l10n.branchesInactive;
      case StaffStatus.onLeave:
        return 'On Leave';
      case null:
        return '-';
    }
  }

  Future<void> _confirmDelete(StaffUser staff) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.staffDeleteTitle,
      message: l10n.staffDeleteStaffConfirm(l10n.staffDeleteConfirm, staff.firstName, staff.lastName),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(staffListProvider.notifier).deleteStaff(staff.id);
        if (mounted) {
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.staffDeleted);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(staffListProvider);
    final branchState = ref.watch(branchListProvider);

    final isLoading = state is StaffListInitial || state is StaffListLoading;
    final hasError = state is StaffListError;
    final errorMessage = state is StaffListError ? state.message : null;
    final staff = state is StaffListLoaded ? state.staff : const <StaffUser>[];

    final stores = branchState is BranchListLoaded ? branchState.branches : const [];

    // Status filter options
    final statusOptions = <PosDropdownItem<String?>>[
      PosDropdownItem<String?>(value: null, label: l10n.allStatus),
      for (final s in StaffStatus.values)
        PosDropdownItem<String?>(value: s.value, label: s.value.replaceAll('_', ' ').toUpperCase()),
    ];

    // Employment type filter options
    final typeOptions = <PosDropdownItem<String?>>[
      PosDropdownItem<String?>(value: null, label: l10n.txAllTypes),
      for (final t in EmploymentType.values)
        PosDropdownItem<String?>(value: t.value, label: t.value.replaceAll('_', ' ').toUpperCase()),
    ];

    // Store filter options
    final storeOptions = <PosDropdownItem<String?>>[
      PosDropdownItem<String?>(value: null, label: l10n.staffSelectStore),
      for (final s in stores) PosDropdownItem<String?>(value: s.id, label: s.name),
    ];

    return PosListPage(
      title: l10n.staffMembers,
      searchController: _searchController,
      searchHint: l10n.staffSearchHint,
      onSearchSubmitted: (_) => _loadStaff(),
      onSearchClear: () {
        _searchController.clear();
        _loadStaff();
      },
      filters: [
        SizedBox(
          width: 180,
          child: PosSearchableDropdown<String?>(
            hint: l10n.commonAllBranches,
            items: storeOptions,
            selectedValue: _selectedStoreId,
            onChanged: (v) {
              setState(() => _selectedStoreId = v);
              _loadStaff();
            },
            showSearch: true,
            clearable: true,
          ),
        ),
        SizedBox(
          width: 160,
          child: PosSearchableDropdown<String?>(
            hint: l10n.allStatuses,
            items: statusOptions,
            selectedValue: _statusFilter,
            onChanged: (v) {
              setState(() => _statusFilter = v);
              _loadStaff();
            },
            showSearch: false,
            clearable: true,
          ),
        ),
        SizedBox(
          width: 160,
          child: PosSearchableDropdown<String?>(
            hint: l10n.allTypes,
            items: typeOptions,
            selectedValue: _employmentTypeFilter,
            onChanged: (v) {
              setState(() => _employmentTypeFilter = v);
              _loadStaff();
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
          onPressed: () => showStaffListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(icon: Icons.refresh, onPressed: _loadStaff, variant: PosButtonVariant.ghost),
        PosButton(label: l10n.staffAddMember, icon: Icons.person_add, onPressed: () => context.push(Routes.staffMembersCreate)),
      ],
      child: PosDataTable<StaffUser>(
        items: staff,
        isLoading: isLoading,
        error: errorMessage,
        onRetry: hasError ? _loadStaff : null,
        emptyConfig: PosTableEmptyConfig(
          icon: Icons.people_outline,
          title: l10n.staffNoMembers,
          action: () => context.push(Routes.staffMembersCreate),
          actionLabel: l10n.staffAddMember,
        ),
        onRowTap: (s) => context.push('${Routes.staffMembers}/${s.id}'),
        columns: [
          PosTableColumn(title: l10n.staffMembers),
          PosTableColumn(title: l10n.staffRoleOrType),
          PosTableColumn(title: l10n.allStatus),
          PosTableColumn(title: l10n.staffContact),
          PosTableColumn(title: l10n.staffHireDate),
        ],
        cellBuilder: (s, colIndex, col) {
          switch (colIndex) {
            case 0:
              return _StaffNameCell(staff: s);
            case 1:
              return Text(s.employmentType.value.replaceAll('_', ' ').toUpperCase(), style: AppTypography.tableCell);
            case 2:
              return PosBadge(label: _statusLabel(s.status, l10n), variant: _statusVariant(s.status));
            case 3:
              return Text(s.email ?? s.phone ?? '-', style: AppTypography.tableCell);
            case 4:
              return Text(
                '${s.hireDate.year}-${s.hireDate.month.toString().padLeft(2, '0')}-${s.hireDate.day.toString().padLeft(2, '0')}',
                style: AppTypography.tableCell,
              );
            default:
              return const SizedBox.shrink();
          }
        },
        actions: [
          PosTableRowAction<StaffUser>(
            label: l10n.edit,
            icon: Icons.edit_outlined,
            onTap: (s) => context.push('${Routes.staffMembers}/${s.id}'),
          ),
          PosTableRowAction<StaffUser>(
            label: l10n.delete,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: _confirmDelete,
          ),
        ],
      ),
    );
  }
}

class _StaffNameCell extends StatelessWidget {
  const _StaffNameCell({required this.staff});
  final StaffUser staff;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PosAvatar(imageUrl: staff.photoUrl, name: '${staff.firstName} ${staff.lastName}'.trim(), radius: 16),
          AppSpacing.gapW12,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${staff.firstName} ${staff.lastName}',
                  style: AppTypography.tableCellBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (staff.email != null)
                  Text(
                    staff.email!,
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
