import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadStaff());
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
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.staffMembers),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStaff)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.staffMembersCreate),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.staffAddMember),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: AppSpacing.paddingAll16,
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
              ),
              onSubmitted: (_) => _loadStaff(),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildFilterChip({required String label, required bool selected, required VoidCallback onSelected}) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onSelected(),
      visualDensity: VisualDensity.compact,
    );
  }

  Future<void> _confirmDelete(BuildContext context, StaffUser staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.staffDeleteTitle),
          content: Text('${l10n.staffDeleteConfirm} ${staff.firstName} ${staff.lastName}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(staffListProvider.notifier).deleteStaff(staff.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.staffDeleted)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
