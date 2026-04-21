import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  DateTimeRange? _dateRange;
  String? _selectedStaffId;
  String? _statusFilter;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm');
  final _dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadAttendance();
      _loadSummary();
      final staffState = ref.read(staffListProvider);
      if (staffState is! StaffListLoaded) {
        ref.read(staffListProvider.notifier).load();
      }
    });
  }

  void _loadAttendance() {
    ref
        .read(attendanceProvider.notifier)
        .load(
          staffUserId: _selectedStaffId,
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
        );
  }

  void _loadSummary() {
    ref
        .read(attendanceSummaryProvider.notifier)
        .load(
          staffUserId: _selectedStaffId,
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
        );
  }

  void _refreshAll() {
    _loadAttendance();
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceProvider);
    final clockState = ref.watch(clockActionProvider);
    final summaryState = ref.watch(attendanceSummaryProvider);
    final staffState = ref.watch(staffListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];

    ref.listen<ClockActionState>(clockActionProvider, (prev, next) {
      if (next is ClockActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        _refreshAll();
      } else if (next is ClockActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.staffAttendance,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.date_range,
          tooltip: l10n.staffFilterByDate,
          onPressed: _pickDateRange,
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(icon: Icons.refresh, tooltip: l10n.commonRefresh, onPressed: _refreshAll, variant: PosButtonVariant.ghost),
        PosButton(label: l10n.staffClockInOut, icon: Icons.access_time, onPressed: () => _showClockDialog(context)),
      ],
      isLoading: state is AttendanceInitial || state is AttendanceLoading,
      hasError: state is AttendanceError,
      errorMessage: state is AttendanceError ? (state).message : null,
      onRetry: _refreshAll,
      isEmpty: state is AttendanceLoaded && (state).records.isEmpty,
      emptyTitle: l10n.staffNoAttendance,
      emptyIcon: Icons.access_time,
      child: Column(
        children: [
          // ─── Summary Stats ────────────────────────
          if (summaryState is AttendanceSummaryLoaded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: PosKpiGrid(
                cards: [
                  PosKpiCard(
                    label: l10n.staffTotalHours,
                    value: summaryState.summary.totalWorkHours.toStringAsFixed(1),
                    icon: Icons.schedule,
                    iconColor: AppColors.info,
                  ),
                  PosKpiCard(
                    label: l10n.staffAvgHours,
                    value: summaryState.summary.avgWorkHours.toStringAsFixed(1),
                    icon: Icons.analytics,
                    iconColor: colorScheme.primary,
                  ),
                  PosKpiCard(
                    label: l10n.staffClockedIn,
                    value: summaryState.summary.currentlyClockedIn.toString(),
                    icon: Icons.person,
                    iconColor: AppColors.success,
                  ),
                  PosKpiCard(
                    label: l10n.staffLateArrivals,
                    value: summaryState.summary.lateCount.toString(),
                    icon: Icons.warning_amber,
                    iconColor: AppColors.warning,
                  ),
                  PosKpiCard(
                    label: l10n.staffOnTimeRate,
                    value: summaryState.summary.totalRecords > 0
                        ? '${((summaryState.summary.onTimeCount / summaryState.summary.totalRecords) * 100).round()}%'
                        : '—',
                    icon: Icons.check_circle,
                    iconColor: AppColors.success,
                  ),
                  PosKpiCard(
                    label: l10n.staffOvertimeHours,
                    value: summaryState.summary.totalOvertimeHours.toStringAsFixed(1),
                    icon: Icons.more_time,
                    iconColor: AppColors.error,
                  ),
                ],
                desktopCols: 6,
                tabletCols: 3,
                mobileCols: 2,
              ),
            ),
          ],

          // ─── Filters ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: PosSearchableDropdown<StaffUser?>(
                    hint: l10n.selectStaffMember,
                    items: [
                      PosDropdownItem<StaffUser?>(value: null, label: l10n.all),
                      ...staffList.map(
                        (s) => PosDropdownItem<StaffUser?>(value: s, label: l10n.staffFullNameLabel(s.firstName, s.lastName)),
                      ),
                    ],
                    selectedValue: staffList.where((s) => s.id == _selectedStaffId).firstOrNull,
                    onChanged: (v) {
                      setState(() => _selectedStaffId = v?.id);
                      _refreshAll();
                    },
                    showSearch: true,
                  ),
                ),
              ],
            ),
          ),
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.all, style: const TextStyle(fontSize: 12)),
                  selected: _statusFilter == null,
                  onSelected: (_) => setState(() => _statusFilter = null),
                  visualDensity: VisualDensity.compact,
                ),
                AppSpacing.gapW8,
                FilterChip(
                  label: Text(l10n.staffOnTime, style: const TextStyle(fontSize: 12)),
                  selected: _statusFilter == 'on_time',
                  onSelected: (_) => setState(() => _statusFilter = 'on_time'),
                  visualDensity: VisualDensity.compact,
                ),
                AppSpacing.gapW4,
                FilterChip(
                  label: Text(l10n.staffLate, style: const TextStyle(fontSize: 12)),
                  selected: _statusFilter == 'late',
                  onSelected: (_) => setState(() => _statusFilter = 'late'),
                  visualDensity: VisualDensity.compact,
                ),
                AppSpacing.gapW4,
                FilterChip(
                  label: Text(l10n.staffEarlyDeparture, style: const TextStyle(fontSize: 12)),
                  selected: _statusFilter == 'early_departure',
                  onSelected: (_) => setState(() => _statusFilter = 'early_departure'),
                  visualDensity: VisualDensity.compact,
                ),
                AppSpacing.gapW4,
                FilterChip(
                  label: Text(l10n.staffActiveSession, style: const TextStyle(fontSize: 12)),
                  selected: _statusFilter == 'active',
                  onSelected: (_) => setState(() => _statusFilter = 'active'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          // Active date filter chip
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      '${_dateFormat.format(_dateRange!.start)} – ${_dateFormat.format(_dateRange!.end)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onDeleted: () {
                      setState(() => _dateRange = null);
                      _refreshAll();
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

          // Loading indicator for clock actions
          if (clockState is ClockActionLoading) const LinearProgressIndicator(),

          AppSpacing.gapH4,

          // ─── Attendance Records List ──────────────
          Expanded(
            child: switch (state) {
              AttendanceLoaded(records: final records) => RefreshIndicator(
                onRefresh: () async => _refreshAll(),
                child: Builder(
                  builder: (context) {
                    final filtered = _filterRecords(records);
                    if (filtered.isEmpty) {
                      return Center(
                        child: PosEmptyState(icon: Icons.access_time, title: l10n.staffNoAttendance),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => _AttendanceCard(
                        record: filtered[index],
                        staffList: staffList,
                        isDark: isDark,
                        timeFormat: _timeFormat,
                        dateTimeFormat: _dateTimeFormat,
                        onStartBreak: () => _startBreak(filtered[index]),
                        onEndBreak: () => _endBreak(filtered[index]),
                      ),
                    );
                  },
                ),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  List<AttendanceRecord> _filterRecords(List<AttendanceRecord> records) {
    if (_statusFilter == null) return records;
    return records.where((r) {
      if (_statusFilter == 'active') return r.isOpen;
      return r.status == _statusFilter;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final range = await showPosDateRangePicker(
      context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _refreshAll();
    }
  }

  void _showClockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ClockDialog(
        onClock: (staffId, storeId, isClockIn, notes) {
          Navigator.pop(ctx);
          if (isClockIn) {
            ref.read(clockActionProvider.notifier).clockIn(staffUserId: staffId, storeId: storeId, notes: notes);
          } else {
            ref.read(clockActionProvider.notifier).clockOut(staffUserId: staffId, storeId: storeId, notes: notes);
          }
        },
      ),
    );
  }

  void _startBreak(AttendanceRecord record) {
    ref.read(clockActionProvider.notifier).startBreak(attendanceRecordId: record.id);
  }

  void _endBreak(AttendanceRecord record) {
    ref.read(clockActionProvider.notifier).endBreak(attendanceRecordId: record.id);
  }
}

// ═══════════════════════════════════════════════════════════════
// Attendance Card
// ═══════════════════════════════════════════════════════════════

class _AttendanceCard extends StatefulWidget {

  const _AttendanceCard({
    required this.record,
    required this.staffList,
    required this.isDark,
    required this.timeFormat,
    required this.dateTimeFormat,
    required this.onStartBreak,
    required this.onEndBreak,
  });
  final AttendanceRecord record;
  final List<StaffUser> staffList;
  final bool isDark;
  final DateFormat timeFormat;
  final DateFormat dateTimeFormat;
  final VoidCallback onStartBreak;
  final VoidCallback onEndBreak;

  @override
  State<_AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<_AttendanceCard> {
  bool _breakExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final record = widget.record;
    final isOpen = record.isOpen;
    final isOnBreak = record.isOnBreak;

    // Resolve staff name
    final staffName =
        record.staffUser?.fullName ??
        widget.staffList.where((s) => s.id == record.staffUserId).map((s) => '${s.firstName} ${s.lastName}'.trim()).firstOrNull ??
        l10n.staffUnknown;

    // Status info
    final (statusColor, statusLabel) = _statusInfo(l10n, record);

    return PosCard(
      elevation: 0,
      color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(
        BorderSide(color: isOpen ? AppColors.warning.withValues(alpha: 0.5) : AppColors.borderFor(context)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Row ─────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isOpen ? AppColors.warning.withValues(alpha: 0.15) : colorScheme.primaryContainer,
                  child: Text(
                    staffName.isNotEmpty ? staffName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isOpen ? AppColors.warning : colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staffName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat('EEE, MMM d').format(record.clockInAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                      ),
                    ],
                  ),
                ),
                // Status badges
                if (isOpen) ...[
                  if (isOnBreak)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.coffee, size: 12, color: AppColors.info),
                          const SizedBox(width: 3),
                          Text(
                            l10n.staffOnBreak,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.info),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                    child: Text(
                      l10n.staffActiveSession,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
                    ),
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                    child: Text(
                      statusLabel,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                    ),
                  ),
              ],
            ),

            AppSpacing.gapH12,

            // ─── Time Details ───────────────────────
            Row(
              children: [
                _InfoChip(icon: Icons.login, label: l10n.staffAttInLabel(widget.timeFormat.format(record.clockInAt))),
                AppSpacing.gapW12,
                if (record.clockOutAt != null)
                  _InfoChip(icon: Icons.logout, label: l10n.staffAttOutLabel(widget.timeFormat.format(record.clockOutAt!))),
                if (record.breakMinutes != null && record.breakMinutes! > 0) ...[
                  AppSpacing.gapW12,
                  _InfoChip(icon: Icons.coffee, label: l10n.staffAttBreakLabel(record.breakMinutes.toString())),
                ],
                if (record.overtimeMinutes != null && record.overtimeMinutes! > 0) ...[
                  AppSpacing.gapW12,
                  _InfoChip(
                    icon: Icons.more_time,
                    label: l10n.staffAttOTLabel(record.overtimeMinutes.toString()),
                    color: AppColors.error,
                  ),
                ],
              ],
            ),

            // ─── Worked Duration ────────────────────
            AppSpacing.gapH8,
            Row(
              children: [
                Icon(Icons.timelapse, size: 14, color: colorScheme.outline),
                AppSpacing.gapW4,
                Text(
                  _formatDuration(record.workedDuration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (record.netWorkedDuration != record.workedDuration) ...[
                  AppSpacing.gapW8,
                  Text(
                    '(${l10n.staffNetWorked}: ${_formatDuration(record.netWorkedDuration)})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                  ),
                ],
              ],
            ),

            // ─── Notes ──────────────────────────────
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              AppSpacing.gapH8,
              Text(
                record.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // ─── Break Records (expandable) ─────────
            if (record.breakRecords.isNotEmpty) ...[
              AppSpacing.gapH8,
              InkWell(
                onTap: () => setState(() => _breakExpanded = !_breakExpanded),
                borderRadius: AppRadius.borderSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.coffee, size: 14, color: colorScheme.outline),
                      AppSpacing.gapW4,
                      Text(
                        l10n.staffBreakDetails,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                      ),
                      AppSpacing.gapW4,
                      Text(
                        '(${record.breakRecords.length})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                      ),
                      const Spacer(),
                      Icon(_breakExpanded ? Icons.expand_less : Icons.expand_more, size: 18, color: colorScheme.outline),
                    ],
                  ),
                ),
              ),
              if (_breakExpanded)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: Column(
                    children: record.breakRecords.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final br = entry.value;
                      final isActive = br.breakEnd == null;
                      return Padding(
                        padding: EdgeInsets.only(bottom: idx < record.breakRecords.length - 1 ? 4 : 0),
                        child: Row(
                          children: [
                            Icon(
                              isActive ? Icons.timer : Icons.check_circle_outline,
                              size: 14,
                              color: isActive ? AppColors.warning : AppColors.success,
                            ),
                            AppSpacing.gapW8,
                            Text(widget.timeFormat.format(br.breakStart), style: Theme.of(context).textTheme.bodySmall),
                            Text(' – ', style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              br.breakEnd != null ? widget.timeFormat.format(br.breakEnd!) : l10n.staffOngoing,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isActive ? AppColors.warning : null,
                                fontWeight: isActive ? FontWeight.w600 : null,
                              ),
                            ),
                            if (br.breakEnd != null) ...[
                              AppSpacing.gapW8,
                              Text(
                                _formatDuration(br.breakEnd!.difference(br.breakStart)),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],

            // ─── Action Buttons (active sessions) ───
            if (isOpen) ...[
              AppSpacing.gapH12,
              Row(
                children: [
                  if (!isOnBreak)
                    PosButton(
                      onPressed: widget.onStartBreak,
                      variant: PosButtonVariant.outline,
                      icon: Icons.coffee,
                      label: l10n.staffStartBreak,
                      size: PosButtonSize.sm,
                    )
                  else
                    PosButton(
                      onPressed: widget.onEndBreak,
                      variant: PosButtonVariant.outline,
                      icon: Icons.play_arrow,
                      label: l10n.staffEndBreak,
                      size: PosButtonSize.sm,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  (Color, String) _statusInfo(AppLocalizations l10n, AttendanceRecord record) {
    return switch (record.status) {
      'on_time' => (AppColors.success, l10n.staffOnTime),
      'late' => (AppColors.warning, l10n.staffLate),
      'early_departure' => (AppColors.error, l10n.staffEarlyDeparture),
      'absent' => (AppColors.error, l10n.staffAbsent),
      _ =>
        record.clockOutAt != null
            ? (AppColors.success, l10n.staffCompleted)
            : (AppColors.mutedFor(context), l10n.staffStatusUnknown),
    };
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

// ═══════════════════════════════════════════════════════════════
// Info Chip
// ═══════════════════════════════════════════════════════════════

class _InfoChip extends StatelessWidget {

  const _InfoChip({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        AppSpacing.gapW4,
        Text(label, style: TextStyle(fontSize: 12, color: c)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Clock In/Out Dialog
// ═══════════════════════════════════════════════════════════════

class _ClockDialog extends ConsumerStatefulWidget {

  const _ClockDialog({required this.onClock});
  final void Function(String staffId, String storeId, bool isClockIn, String? notes) onClock;

  @override
  ConsumerState<_ClockDialog> createState() => _ClockDialogState();
}

class _ClockDialogState extends ConsumerState<_ClockDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  StaffUser? _selectedStaff;
  bool _isClockIn = true;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(staffListProvider);
    if (state is! StaffListLoaded) {
      ref.read(staffListProvider.notifier).load();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.staffClockInOut),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosSearchableDropdown<StaffUser>(
              hint: l10n.selectStaffMember,
              label: l10n.staffMemberRequired(l10n.staffMember),
              items: staffList
                  .map((s) => PosDropdownItem(value: s, label: l10n.staffFullNameLabel(s.firstName, s.lastName)))
                  .toList(),
              selectedValue: _selectedStaff,
              onChanged: (v) => setState(() => _selectedStaff = v),
              showSearch: true,
            ),
            AppSpacing.gapH16,
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(l10n.staffClockIn), icon: const Icon(Icons.login)),
                ButtonSegment(value: false, label: Text(l10n.staffClockOut), icon: const Icon(Icons.logout)),
              ],
              selected: {_isClockIn},
              onSelectionChanged: (v) => setState(() => _isClockIn = v.first),
            ),
            AppSpacing.gapH16,
            PosTextField(controller: _notesController, label: l10n.staffNotesOptional, maxLines: 2),
          ],
        ),
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context), variant: PosButtonVariant.ghost, label: l10n.cancel),
        PosButton(
          onPressed: _selectedStaff == null
              ? null
              : () => widget.onClock(
                  _selectedStaff!.id,
                  _selectedStaff!.storeId,
                  _isClockIn,
                  _notesController.text.isNotEmpty ? _notesController.text : null,
                ),
          label: _isClockIn ? l10n.staffClockIn : l10n.staffClockOut,
        ),
      ],
    );
  }
}
