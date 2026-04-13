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
import 'package:thawani_pos/features/branches/providers/branch_providers.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';
import 'package:thawani_pos/features/staff/enums/employment_type.dart';
import 'package:thawani_pos/features/staff/enums/staff_status.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';
import 'package:thawani_pos/features/staff/providers/staff_providers.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isPhone;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.staffMembers),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.featureInfoTooltip,
            onPressed: () => showStaffListInfo(context),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStaff),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.staffMembersCreate),
        icon: const Icon(Icons.person_add),
        label: Text(isMobile ? '' : l10n.staffAddMember),
        isExtended: !isMobile,
      ),
      body: Column(
        children: [
          // Store selector
          _buildStoreSelector(context, isDark, l10n),
          // Search bar
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.staffSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadStaff();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: isMobile,
              ),
              onSubmitted: (_) => _loadStaff(),
            ),
          ),
          // Filter chips
          SizedBox(
            height: isMobile ? 40 : 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
              children: [
                _buildFilterChip(
                  label: 'All Status',
                  selected: _statusFilter == null,
                  onSelected: () {
                    setState(() => _statusFilter = null);
                    _loadStaff();
                  },
                ),
                for (final status in StaffStatus.values) ...[
                  AppSpacing.gapW8,
                  _buildFilterChip(
                    label: status.value.replaceAll('_', ' ').toUpperCase(),
                    selected: _statusFilter == status.value,
                    onSelected: () {
                      setState(() => _statusFilter = status.value);
                      _loadStaff();
                    },
                  ),
                ],
                AppSpacing.gapW16,
                const VerticalDivider(),
                AppSpacing.gapW8,
                _buildFilterChip(
                  label: 'All Types',
                  selected: _employmentTypeFilter == null,
                  onSelected: () {
                    setState(() => _employmentTypeFilter = null);
                    _loadStaff();
                  },
                ),
                for (final type in EmploymentType.values) ...[
                  AppSpacing.gapW8,
                  _buildFilterChip(
                    label: type.value.replaceAll('_', ' ').toUpperCase(),
                    selected: _employmentTypeFilter == type.value,
                    onSelected: () {
                      setState(() => _employmentTypeFilter = type.value);
                      _loadStaff();
                    },
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.gapH8,
          // Staff list
          Expanded(
            child: switch (state) {
              StaffListInitial() || StaffListLoading() => PosLoadingSkeleton.list(),
              StaffListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadStaff),
              StaffListLoaded(staff: final staff) =>
                staff.isEmpty
                    ? PosEmptyState(title: l10n.staffNoMembers, icon: Icons.people_outline)
                    : RefreshIndicator(
                        onRefresh: () async => _loadStaff(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: staff.length,
                          itemBuilder: (context, index) => _StaffCard(
                            staff: staff[index],
                            onTap: () => context.push('${Routes.staffMembers}/${staff[index].id}'),
                            onDelete: () => _confirmDelete(context, staff[index]),
                          ),
                        ),
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSelector(BuildContext context, bool isDark, AppLocalizations l10n) {
    final branchState = ref.watch(branchListProvider);
    final stores = branchState is BranchListLoaded ? branchState.branches : <Store>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: PosSearchableDropdown<String>(
        label: l10n.staffSelectStore,
        items: stores.map((s) => PosDropdownItem<String>(value: s.id, label: s.name)).toList(),
        selectedValue: _selectedStoreId,
        onChanged: (value) {
          setState(() => _selectedStoreId = value);
          _loadStaff();
        },
        showSearch: true,
        clearable: true,
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool selected, required VoidCallback onSelected}) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onSelected(),
      visualDensity: VisualDensity.compact,
    );
  }

  Future<void> _confirmDelete(BuildContext context, StaffUser staff) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.staffDeleteTitle,
      message: '${l10n.staffDeleteConfirm} ${staff.firstName} ${staff.lastName}?',
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
}

// ═══════════════════════════════════════════════════════════════
// Staff Card Widget
// ═══════════════════════════════════════════════════════════════

class _StaffCard extends StatelessWidget {
  final StaffUser staff;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StaffCard({required this.staff, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet ? 12 : 16,
        vertical: MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet ? 3 : 4,
      ),
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: staff.photoUrl != null ? NetworkImage(staff.photoUrl!) : null,
                child: staff.photoUrl == null
                    ? Text(
                        '${staff.firstName[0]}${staff.lastName[0]}',
                        style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${staff.firstName} ${staff.lastName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    AppSpacing.gapH4,
                    Row(
                      children: [
                        _StatusBadge(status: staff.status),
                        AppSpacing.gapW8,
                        Text(
                          staff.employmentType.value.replaceAll('_', ' ').toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                        ),
                      ],
                    ),
                    if (staff.email != null) ...[
                      AppSpacing.gapH2,
                      Text(staff.email!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onTap();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'), dense: true),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: AppColors.error),
                      title: Text('Delete', style: TextStyle(color: AppColors.error)),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StaffStatus? status;

  const _StatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      StaffStatus.active => (AppColors.success, 'Active'),
      StaffStatus.inactive => (AppColors.textSecondary, 'Inactive'),
      StaffStatus.onLeave => (AppColors.warning, 'On Leave'),
      null => (AppColors.textSecondary, 'Unknown'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
