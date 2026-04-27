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
import 'package:wameedpos/features/staff/models/staff_document.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/features/staff/repositories/staff_repository.dart';

class StaffDetailPage extends ConsumerStatefulWidget {

  const StaffDetailPage({super.key, required this.staffId});
  final String staffId;

  @override
  ConsumerState<StaffDetailPage> createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends ConsumerState<StaffDetailPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(staffDetailProvider(widget.staffId).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffDetailProvider(widget.staffId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: state is StaffDetailLoaded ? '${state.staff.firstName} ${state.staff.lastName}' : l10n.staffMemberDetails,
      showSearch: false,
      actions: [
        if (state is StaffDetailLoaded)
          PosButton.icon(
            icon: Icons.edit,
            tooltip: l10n.edit,
            onPressed: () async {
              final result = await context.push<bool>('${Routes.staffMembers}/${widget.staffId}/edit');
              if (result == true && mounted) {
                ref.read(staffDetailProvider(widget.staffId).notifier).load();
              }
            },
            variant: PosButtonVariant.ghost,
          ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.retry,
          onPressed: () => ref.read(staffDetailProvider(widget.staffId).notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
      ],
      isLoading: state is StaffDetailInitial || state is StaffDetailLoading || state is StaffDetailSaving,
      hasError: state is StaffDetailError,
      errorMessage: state is StaffDetailError ? (state).message : null,
      onRetry: () => ref.read(staffDetailProvider(widget.staffId).notifier).load(),
      child: switch (state) {
        StaffDetailLoaded(staff: final staff) => _buildContent(context, staff, isDark, l10n),
        StaffDetailSaved(staff: final staff) => _buildContent(context, staff, isDark, l10n),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildContent(BuildContext context, StaffUser staff, bool isDark, AppLocalizations l10n) {
    return Column(
      children: [
        // Profile header
        _ProfileHeader(staff: staff, isDark: isDark, l10n: l10n),
        // Tab bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.staffOverview),
              PosTabItem(label: l10n.staffBranches),
              PosTabItem(label: l10n.staffAttendanceTab),
              PosTabItem(label: l10n.staffActivity),
              PosTabItem(label: l10n.staffDocuments),
            ],
          ),
        ),
        // Tab views
        Expanded(
          child: IndexedStack(
            index: _currentTab,
            children: [
              _OverviewTab(staff: staff, isDark: isDark, l10n: l10n),
              _BranchAssignmentsTab(staff: staff, isDark: isDark, l10n: l10n),
              _AttendanceTab(staffId: staff.id, isDark: isDark, l10n: l10n),
              _ActivityTab(staffId: staff.id, isDark: isDark, l10n: l10n),
              _DocumentsTab(staffId: staff.id, isDark: isDark, l10n: l10n),
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

  const _ProfileHeader({required this.staff, required this.isDark, required this.l10n});
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: AppSpacing.paddingAll16,
      color: AppColors.surfaceFor(context),
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
                      ).textTheme.labelSmall?.copyWith(color: AppColors.mutedFor(context)),
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

  const _StatusBadge({this.status});
  final StaffStatus? status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      StaffStatus.active => (AppColors.success, 'Active'),
      StaffStatus.inactive => (AppColors.mutedFor(context), 'Inactive'),
      StaffStatus.onLeave => (AppColors.warning, 'On Leave'),
      null => (AppColors.mutedFor(context), 'Unknown'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
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

  const _OverviewTab({required this.staff, required this.isDark, required this.l10n});
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

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
                  style: TextStyle(color: AppColors.mutedFor(context)),
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

  const _BranchAssignmentsTab({required this.staff, required this.isDark, required this.l10n});
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

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
            return PosCard(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              borderRadius: AppRadius.borderMd,

              border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: a.isPrimary ? AppColors.primary10 : (isDark ? AppColors.hoverDark : AppColors.hoverLight),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Icon(
                    Icons.store,
                    color: a.isPrimary ? AppColors.primary : (AppColors.mutedFor(context)),
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
                  style: TextStyle(color: AppColors.mutedFor(context)),
                ),
                trailing: a.isPrimary
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderLg),
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

  const _AttendanceTab({required this.staffId, required this.isDark, required this.l10n});
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;

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
                  return PosCard(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    borderRadius: AppRadius.borderMd,

                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.borderFor(context)),
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
                                        color: AppColors.mutedFor(context),
                                      ),
                                    ),
                                    if (r.clockOutAt != null) ...[
                                      AppSpacing.gapW12,
                                      Text(
                                        'Out: ${timeFormat.format(r.clockOutAt!)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.mutedFor(context),
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
                                borderRadius: AppRadius.borderLg,
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

  const _ActivityTab({required this.staffId, required this.isDark, required this.l10n});
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;

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
        return PosCard(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          borderRadius: AppRadius.borderMd,

          border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
          color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
          child: ListTile(
            leading: Icon(Icons.history, color: AppColors.mutedFor(context)),
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
                    style: TextStyle(color: AppColors.mutedFor(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (createdAt != null)
                  Text(
                    dateTimeFormat.format(createdAt),
                    style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
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

  const _LinkedUserSection({required this.staff, required this.isDark, required this.l10n});
  final StaffUser staff;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  ConsumerState<_LinkedUserSection> createState() => _LinkedUserSectionState();
}

class _LinkedUserSectionState extends ConsumerState<_LinkedUserSection> {
  bool _isLinking = false;

  Future<void> _showLinkDialog() async {
    final repo = ref.read(staffRepositoryProvider);

    // Show loading dialog while fetching linkable users
    if (!mounted) return;
    showDialog(context: context, barrierDismissible: false, useRootNavigator: false, builder: (_) => const PosLoading());

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
              child: PosButton(
                onPressed: _isLinking ? null : _unlinkUser,
                isLoading: _isLinking,
                icon: Icons.link_off,
                variant: PosButtonVariant.danger,
                label: widget.l10n.staffUnlink,
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                Icon(Icons.person_off, size: 40, color: AppColors.mutedFor(context)),
                AppSpacing.gapH8,
                Text(
                  widget.l10n.staffLinkNone,
                  style: TextStyle(color: AppColors.mutedFor(context)),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapH12,
                PosButton(
                  onPressed: _isLinking ? null : _showLinkDialog,
                  isLoading: _isLinking,
                  icon: Icons.link,
                  label: widget.l10n.staffLinkUser,
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

  const _LinkableUsersDialog({required this.users, required this.isDark, required this.l10n});
  final List<Map<String, dynamic>> users;
  final bool isDark;
  final AppLocalizations l10n;

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
            PosTextField(hint: widget.l10n.search, prefixIcon: Icons.search, onChanged: (v) => setState(() => _search = v)),
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
      actions: [
        PosButton(onPressed: () => Navigator.of(context).pop(), variant: PosButtonVariant.ghost, label: widget.l10n.cancel),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Shared Widgets
// ═══════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {

  const _SectionCard({required this.isDark, required this.title, required this.icon, required this.children});
  final bool isDark;
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
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

  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.mutedFor(context)),
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

// ═══════════════════════════════════════════════════════════════
// Documents Tab
// ═══════════════════════════════════════════════════════════════

class _DocumentsTab extends ConsumerStatefulWidget {
  const _DocumentsTab({required this.staffId, required this.isDark, required this.l10n});
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  ConsumerState<_DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends ConsumerState<_DocumentsTab> {
  static const _docTypes = ['national_id', 'contract', 'certificate', 'visa', 'other'];

  String _docTypeLabel(String type) {
    return switch (type) {
      'national_id' => widget.l10n.staffDocumentNationalId,
      'contract' => widget.l10n.staffDocumentContract,
      'certificate' => widget.l10n.staffDocumentCertificate,
      'visa' => widget.l10n.staffDocumentVisa,
      _ => widget.l10n.staffDocumentOther,
    };
  }

  IconData _docTypeIcon(String type) {
    return switch (type) {
      'national_id' => Icons.badge_outlined,
      'contract' => Icons.description_outlined,
      'certificate' => Icons.workspace_premium_outlined,
      'visa' => Icons.flight_outlined,
      _ => Icons.attach_file_outlined,
    };
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    String selectedType = _docTypes.first;
    final urlController = TextEditingController();
    DateTime? expiryDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(widget.l10n.staffAddDocument),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(labelText: widget.l10n.staffDocumentType),
                  items: _docTypes.map((t) => DropdownMenuItem(value: t, child: Text(_docTypeLabel(t)))).toList(),
                  onChanged: (v) => setStateDialog(() => selectedType = v ?? selectedType),
                ),
                AppSpacing.gapH16,
                TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: widget.l10n.staffDocumentUrl, hintText: 'https://...'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? widget.l10n.required : null,
                ),
                AppSpacing.gapH16,
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().add(const Duration(days: 365)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setStateDialog(() => expiryDate = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: widget.l10n.staffDocumentExpiry,
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                    ),
                    child: Text(
                      expiryDate != null ? DateFormat('yyyy-MM-dd').format(expiryDate!) : '—',
                      style: TextStyle(color: expiryDate != null ? null : AppColors.mutedFor(context)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(widget.l10n.cancel)),
            PosButton(
              label: widget.l10n.save,
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(ctx);
                await ref.read(staffDocumentsProvider(widget.staffId).notifier).add(
                  documentType: selectedType,
                  fileUrl: urlController.text.trim(),
                  expiryDate: expiryDate != null ? DateFormat('yyyy-MM-dd').format(expiryDate!) : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(StaffDocument doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.staffDeleteDocumentConfirm),
        content: Text(_docTypeLabel(doc.documentType)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(widget.l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(widget.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(staffDocumentsProvider(widget.staffId).notifier).remove(doc.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffDocumentsProvider(widget.staffId));

    return state.when(
      loading: () => PosLoadingSkeleton.list(),
      error: (e, _) => PosErrorState(
        message: e.toString(),
        onRetry: () => ref.invalidate(staffDocumentsProvider(widget.staffId)),
      ),
      data: (docs) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  widget.l10n.staffDocuments,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                PosButton.outlined(
                  label: widget.l10n.staffAddDocument,
                  icon: Icons.add,
                  onPressed: _showAddDialog,
                  size: PosButtonSize.sm,
                ),
              ],
            ),
          ),
          Expanded(
            child: docs.isEmpty
                ? PosEmptyState(title: widget.l10n.staffNoDocuments, icon: Icons.folder_open_outlined)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => AppSpacing.gapH12,
                    itemBuilder: (ctx, i) {
                      final doc = docs[i];
                      return _DocumentCard(
                        doc: doc,
                        typeLabel: _docTypeLabel(doc.documentType),
                        typeIcon: _docTypeIcon(doc.documentType),
                        isDark: widget.isDark,
                        l10n: widget.l10n,
                        onDelete: () => _confirmDelete(doc),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.doc,
    required this.typeLabel,
    required this.typeIcon,
    required this.isDark,
    required this.l10n,
    required this.onDelete,
  });
  final StaffDocument doc;
  final String typeLabel;
  final IconData typeIcon;
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final expiryColor = doc.isExpired
        ? AppColors.error
        : doc.expiringSoon
            ? AppColors.warning
            : AppColors.success;

    return PosCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(typeIcon, color: AppColors.primary, size: 22),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(typeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (doc.expiryDate != null) ...[
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: expiryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          doc.isExpired
                              ? l10n.staffDocumentExpired
                              : doc.expiringSoon
                                  ? l10n.staffDocumentExpiringSoon
                                  : l10n.staffDocumentDaysLeft(doc.daysUntilExpiry ?? 0),
                          style: TextStyle(fontSize: 11, color: expiryColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                      AppSpacing.gapW8,
                      Text(
                        DateFormat('dd MMM yyyy').format(DateTime.parse(doc.expiryDate!)),
                        style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.open_in_new_outlined, color: AppColors.mutedFor(context)),
            tooltip: 'Open',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: l10n.delete,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
