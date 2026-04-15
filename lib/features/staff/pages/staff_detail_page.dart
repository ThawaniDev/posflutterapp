import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/enums/staff_status.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/features/staff/repositories/staff_repository.dart';

class StaffDetailPage extends ConsumerStatefulWidget {
  final String staffId;

  const StaffDetailPage({super.key, required this.staffId});

  @override
  ConsumerState<StaffDetailPage> createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends ConsumerState<StaffDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() => ref.read(staffDetailProvider(widget.staffId).notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffDetailProvider(widget.staffId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(state is StaffDetailLoaded ? '${state.staff.firstName} ${state.staff.lastName}' : l10n.staffMemberDetails),
        actions: [
          if (state is StaffDetailLoaded)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: l10n.edit,
              onPressed: () async {
                final result = await context.push<bool>('${Routes.staffMembers}/${widget.staffId}/edit');
                if (result == true && mounted) {
                  ref.read(staffDetailProvider(widget.staffId).notifier).load();
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.retry,
            onPressed: () => ref.read(staffDetailProvider(widget.staffId).notifier).load(),
          ),
        ],
      ),
      body: switch (state) {
        StaffDetailInitial() || StaffDetailLoading() || StaffDetailSaving() => PosLoadingSkeleton.list(),
        StaffDetailError(message: final msg) => PosErrorState(
          message: msg,
          onRetry: () => ref.read(staffDetailProvider(widget.staffId).notifier).load(),
        ),
        StaffDetailLoaded(staff: final staff) => _buildContent(context, staff, isDark, l10n),
        StaffDetailSaved(staff: final staff) => _buildContent(context, staff, isDark, l10n),
      },
    );
  }

  Widget _buildContent(BuildContext context, StaffUser staff, bool isDark, AppLocalizations l10n) {
    return Column(
      children: [
        // Profile header
        _ProfileHeader(staff: staff, isDark: isDark, l10n: l10n),
        // Tab bar
        Container(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: l10n.staffOverview),
              Tab(text: l10n.staffBranches),
              Tab(text: l10n.staffAttendanceTab),
              Tab(text: l10n.staffActivity),
            ],
          ),
        ),
        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(staff: staff, isDark: isDark, l10n: l10n),
              _BranchAssignmentsTab(staff: staff, isDark: isDark, l10n: l10n),
              _AttendanceTab(staffId: staff.id, isDark: isDark, l10n: l10n),
              _ActivityTab(staffId: staff.id, isDark: isDark, l10n: l10n),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Profile Header
// ═══════════════════════════════════════════════════════════════

class _ProfileHeader extends StatelessWidget {
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  const _ProfileHeader({required this.staff, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: AppSpacing.paddingAll16,
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: staff.photoUrl != null ? NetworkImage(staff.photoUrl!) : null,
            child: staff.photoUrl == null
                ? Text(
                    '${staff.firstName[0]}${staff.lastName[0]}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                AppSpacing.gapH4,
                Row(
                  children: [
                    _StatusBadge(status: staff.status),
                    AppSpacing.gapW8,
                    Text(
                      staff.employmentType.value.replaceAll('_', ' ').toUpperCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
                AppSpacing.gapH4,
                Text(
                  '${l10n.staffHiredOn} ${dateFormat.format(staff.hireDate)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
        ],
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

// ═══════════════════════════════════════════════════════════════
// Overview Tab
// ═══════════════════════════════════════════════════════════════

class _OverviewTab extends StatelessWidget {
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  const _OverviewTab({required this.staff, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        // Contact Info
        _SectionCard(
          isDark: isDark,
          title: l10n.staffContactInfo,
          icon: Icons.contact_phone,
          children: [
            if (staff.email != null) _InfoRow(icon: Icons.email_outlined, label: l10n.email, value: staff.email!),
            if (staff.phone != null) _InfoRow(icon: Icons.phone_outlined, label: l10n.staffPhone, value: staff.phone!),
            if (staff.nationalId != null)
              _InfoRow(icon: Icons.badge_outlined, label: l10n.staffNationalId, value: staff.nationalId!),
            if (staff.email == null && staff.phone == null && staff.nationalId == null)
              Padding(
                padding: AppSpacing.paddingAll16,
                child: Text(
                  l10n.staffNoContactInfo,
                  style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
          ],
        ),
        AppSpacing.gapH16,
        // Employment Details
        _SectionCard(
          isDark: isDark,
          title: l10n.staffEmploymentDetails,
          icon: Icons.work_outline,
          children: [
            _InfoRow(
              icon: Icons.business_center,
              label: l10n.staffEmploymentType,
              value: staff.employmentType.value.replaceAll('_', ' ').toUpperCase(),
            ),
            _InfoRow(
              icon: Icons.attach_money,
              label: l10n.staffSalaryType,
              value: staff.salaryType.value.replaceAll('_', ' ').toUpperCase(),
            ),
            if (staff.hourlyRate != null)
              _InfoRow(icon: Icons.access_time, label: l10n.staffHourlyRate, value: staff.hourlyRate!.toStringAsFixed(2)),
            _InfoRow(
              icon: Icons.calendar_today,
              label: l10n.staffHireDate,
              value: DateFormat('MMM d, yyyy').format(staff.hireDate),
            ),
            if (staff.terminationDate != null)
              _InfoRow(
                icon: Icons.event_busy,
                label: l10n.staffTerminationDate,
                value: DateFormat('MMM d, yyyy').format(staff.terminationDate!),
              ),
          ],
        ),
        AppSpacing.gapH16,
        // Security
        _SectionCard(
          isDark: isDark,
          title: l10n.staffSecurity,
          icon: Icons.security,
          children: [
            _InfoRow(
              icon: Icons.pin,
              label: l10n.staffPin,
              value: staff.pinHash != null ? l10n.staffPinSet : l10n.staffPinNotSet,
            ),
            _InfoRow(icon: Icons.nfc, label: l10n.staffNfc, value: staff.nfcBadgeUid ?? l10n.staffNotRegistered),
            _InfoRow(
              icon: Icons.fingerprint,
              label: l10n.staffBiometric,
              value: staff.biometricEnabled == true ? l10n.staffEnabled : l10n.staffDisabled,
            ),
          ],
        ),
        AppSpacing.gapH16,
        // Linked User Account
        _LinkedUserSection(staff: staff, isDark: isDark, l10n: l10n),
        AppSpacing.gapH16,
        // Language preference
        if (staff.languagePreference != null)
          _SectionCard(
            isDark: isDark,
            title: l10n.staffPreferences,
            icon: Icons.settings,
            children: [_InfoRow(icon: Icons.language, label: l10n.staffLanguage, value: staff.languagePreference!.toUpperCase())],
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Branch Assignments Tab
// ═══════════════════════════════════════════════════════════════

class _BranchAssignmentsTab extends ConsumerWidget {
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  const _BranchAssignmentsTab({required this.staff, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(branchAssignmentsProvider(staff.id));

    return assignmentsAsync.when(
      loading: () => PosLoadingSkeleton.list(),
      error: (err, _) =>
          PosErrorState(message: err.toString(), onRetry: () => ref.invalidate(branchAssignmentsProvider(staff.id))),
      data: (assignments) {
        if (assignments.isEmpty) {
          return PosEmptyState(title: l10n.staffNoBranches, icon: Icons.store_outlined);
        }
        return ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final a = assignments[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: a.isPrimary ? AppColors.primary10 : (isDark ? AppColors.hoverDark : AppColors.hoverLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.store,
                    color: a.isPrimary ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    size: 20,
                  ),
                ),
                title: Text(
                  a.branchName ?? a.branchId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                subtitle: Text(
                  a.roleName ?? l10n.staffNoRole,
                  style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
                trailing: a.isPrimary
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          l10n.staffPrimary,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Attendance Tab (Summary)
// ═══════════════════════════════════════════════════════════════

class _AttendanceTab extends ConsumerStatefulWidget {
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;

  const _AttendanceTab({required this.staffId, required this.isDark, required this.l10n});

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(attendanceProvider.notifier).load(staffUserId: widget.staffId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceProvider);
    final timeFormat = DateFormat('HH:mm');
    final dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');

    return switch (state) {
      AttendanceInitial() || AttendanceLoading() => PosLoadingSkeleton.list(),
      AttendanceError(message: final msg) => PosErrorState(
        message: msg,
        onRetry: () => ref.read(attendanceProvider.notifier).load(staffUserId: widget.staffId),
      ),
      AttendanceLoaded(records: final records) =>
        records.isEmpty
            ? PosEmptyState(title: widget.l10n.staffNoAttendance, icon: Icons.access_time)
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final r = records[index];
                  final isOpen = r.clockOutAt == null;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(color: widget.isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
                    child: Padding(
                      padding: AppSpacing.paddingAll16,
                      child: Row(
                        children: [
                          Icon(
                            isOpen ? Icons.timer : Icons.check_circle,
                            color: isOpen ? AppColors.warning : AppColors.success,
                            size: 20,
                          ),
                          AppSpacing.gapW12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateTimeFormat.format(r.clockInAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                AppSpacing.gapH4,
                                Row(
                                  children: [
                                    Text(
                                      'In: ${timeFormat.format(r.clockInAt)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ),
                                    if (r.clockOutAt != null) ...[
                                      AppSpacing.gapW12,
                                      Text(
                                        'Out: ${timeFormat.format(r.clockOutAt!)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isOpen)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.l10n.staffActive,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    };
  }
}

// ═══════════════════════════════════════════════════════════════
// Activity Tab
// ═══════════════════════════════════════════════════════════════

class _ActivityTab extends ConsumerStatefulWidget {
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;

  const _ActivityTab({required this.staffId, required this.isDark, required this.l10n});

  @override
  ConsumerState<_ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends ConsumerState<_ActivityTab> {
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await ref.read(staffRepositoryProvider).getActivityLog(widget.staffId);
      if (mounted) {
        setState(() {
          _activities = result.items.map((a) => {'action': a.action, 'details': a.details, 'created_at': a.createdAt}).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return PosLoadingSkeleton.list();
    if (_error != null) return PosErrorState(message: _error!, onRetry: _loadActivities);
    if (_activities.isEmpty) {
      return PosEmptyState(title: widget.l10n.staffNoActivity, icon: Icons.history);
    }

    final dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');

    return ListView.builder(
      padding: AppSpacing.paddingAll16,
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final a = _activities[index];
        final createdAt = a['created_at'] as DateTime?;
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: BorderSide(color: widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
          child: ListTile(
            leading: Icon(Icons.history, color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            title: Text(
              a['action'] as String? ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (a['details'] != null)
                  Text(
                    a['details'].toString(),
                    style: TextStyle(color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (createdAt != null)
                  Text(
                    dateTimeFormat.format(createdAt),
                    style: TextStyle(fontSize: 11, color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Linked User Account Section
// ═══════════════════════════════════════════════════════════════

class _LinkedUserSection extends ConsumerStatefulWidget {
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  const _LinkedUserSection({required this.staff, required this.isDark, required this.l10n});

  @override
  ConsumerState<_LinkedUserSection> createState() => _LinkedUserSectionState();
}

class _LinkedUserSectionState extends ConsumerState<_LinkedUserSection> {
  bool _isLinking = false;

  Future<void> _showLinkDialog() async {
    final repo = ref.read(staffRepositoryProvider);

    // Show loading dialog while fetching linkable users
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    List<Map<String, dynamic>> users;
    try {
      users = await repo.getLinkableUsers();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // dismiss loading
        showPosErrorSnackbar(context, e.toString());
      }
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss loading

    if (users.isEmpty) {
      showPosWarningSnackbar(context, widget.l10n.staffLinkNoUsers);
      return;
    }

    // Show user selection dialog
    final selectedUserId = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => _LinkableUsersDialog(users: users, isDark: widget.isDark, l10n: widget.l10n),
    );

    if (selectedUserId == null || !mounted) return;

    setState(() => _isLinking = true);
    try {
      await repo.linkUser(widget.staff.id, selectedUserId);
      if (mounted) {
        ref.read(staffDetailProvider(widget.staff.id).notifier).load();
        showPosSuccessSnackbar(context, widget.l10n.staffLinkSuccess);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLinking = false);
    }
  }

  Future<void> _unlinkUser() async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: widget.l10n.staffUnlinkTitle,
      message: widget.l10n.staffUnlinkConfirm,
      confirmLabel: widget.l10n.staffUnlink,
      cancelLabel: widget.l10n.cancel,
      isDanger: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLinking = true);
    try {
      await ref.read(staffRepositoryProvider).unlinkUser(widget.staff.id);
      if (mounted) {
        ref.read(staffDetailProvider(widget.staff.id).notifier).load();
        showPosSuccessSnackbar(context, widget.l10n.staffUnlinkSuccess);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLinking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final linked = widget.staff.linkedUser;
    final hasLink = linked != null;

    return _SectionCard(
      isDark: widget.isDark,
      title: widget.l10n.staffLinkedAccount,
      icon: Icons.link,
      children: [
        if (hasLink) ...[
          _InfoRow(icon: Icons.person, label: widget.l10n.staffLinkName, value: linked.name),
          _InfoRow(icon: Icons.email_outlined, label: widget.l10n.email, value: linked.email),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLinking ? null : _unlinkUser,
                icon: _isLinking
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.link_off, size: 18),
                label: Text(widget.l10n.staffUnlink),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                Icon(Icons.person_off, size: 40, color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                AppSpacing.gapH8,
                Text(
                  widget.l10n.staffLinkNone,
                  style: TextStyle(color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapH12,
                FilledButton.icon(
                  onPressed: _isLinking ? null : _showLinkDialog,
                  icon: _isLinking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.link, size: 18),
                  label: Text(widget.l10n.staffLinkUser),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Linkable Users Selection Dialog
// ═══════════════════════════════════════════════════════════════

class _LinkableUsersDialog extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final bool isDark;
  final AppLocalizations l10n;

  const _LinkableUsersDialog({required this.users, required this.isDark, required this.l10n});

  @override
  State<_LinkableUsersDialog> createState() => _LinkableUsersDialogState();
}

class _LinkableUsersDialogState extends State<_LinkableUsersDialog> {
  String _search = '';

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return widget.users;
    final q = _search.toLowerCase();
    return widget.users.where((u) {
      final name = (u['name'] as String? ?? '').toLowerCase();
      final email = (u['email'] as String? ?? '').toLowerCase();
      return name.contains(q) || email.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.staffLinkSelectUser),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: widget.l10n.search,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            AppSpacing.gapH12,
            Expanded(
              child: _filtered.isEmpty
                  ? Center(child: Text(widget.l10n.staffLinkNoUsers))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) {
                        final u = _filtered[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary10,
                            child: Text(
                              (u['name'] as String? ?? '?')[0].toUpperCase(),
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(u['name'] as String? ?? ''),
                          subtitle: Text(u['email'] as String? ?? ''),
                          onTap: () => Navigator.of(ctx).pop(u['id'] as String),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(widget.l10n.cancel))],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Shared Widgets
// ═══════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.isDark, required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          AppSpacing.gapW12,
          Text(label, style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
