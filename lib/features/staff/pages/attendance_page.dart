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
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm');
  final _dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAttendance());
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceProvider);
    final clockState = ref.watch(clockActionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Listen for clock action results
    ref.listen<ClockActionState>(clockActionProvider, (prev, next) {
      if (next is ClockActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        _loadAttendance();
      } else if (next is ClockActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.staffAttendance),
        actions: [
          IconButton(icon: Icon(Icons.date_range), onPressed: _pickDateRange, tooltip: l10n.staffFilterByDate),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAttendance),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showClockDialog(context),
        icon: const Icon(Icons.access_time),
        label: Text(l10n.staffClockInOut),
      ),
      body: Column(
        children: [
          // Active filters
          if (_dateRange != null || _selectedStaffId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              child: Row(
                children: [
                  if (_dateRange != null) ...[
                    Chip(
                      label: Text(
                        '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onDeleted: () {
                        setState(() => _dateRange = null);
                        _loadAttendance();
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    AppSpacing.gapW8,
                  ],
                  if (_selectedStaffId != null)
                    Chip(
                      label: Text(l10n.staffFilteredByStaff, style: TextStyle(fontSize: 12)),
                      onDeleted: () {
                        setState(() => _selectedStaffId = null);
                        _loadAttendance();
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          // Loading indicator for clock actions
          if (clockState is ClockActionLoading) const LinearProgressIndicator(),
          // Attendance list
          Expanded(
            child: switch (state) {
              AttendanceInitial() || AttendanceLoading() => PosLoadingSkeleton.list(),
              AttendanceError(message: final msg) => PosErrorState(message: msg, onRetry: _loadAttendance),
              AttendanceLoaded(records: final records) =>
                records.isEmpty
                    ? PosEmptyState(title: l10n.staffNoAttendance, icon: Icons.access_time)
                    : RefreshIndicator(
                        onRefresh: () async => _loadAttendance(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: records.length,
                          itemBuilder: (context, index) => _AttendanceCard(
                            record: records[index],
                            isDark: isDark,
                            l10n: l10n,
                            timeFormat: _timeFormat,
                            dateTimeFormat: _dateTimeFormat,
                            onStartBreak: () => _startBreak(records[index]),
                            onEndBreak: () => _endBreak(records[index]),
                          ),
                        ),
                      ),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _loadAttendance();
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

class _AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;
  final bool isDark;
  final AppLocalizations l10n;
  final DateFormat timeFormat;
  final DateFormat dateTimeFormat;
  final VoidCallback onStartBreak;
  final VoidCallback onEndBreak;

  const _AttendanceCard({
    required this.record,
    required this.isDark,
    required this.l10n,
    required this.timeFormat,
    required this.dateTimeFormat,
    required this.onStartBreak,
    required this.onEndBreak,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOpen = record.clockOutAt == null;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isOpen ? Icons.timer : Icons.check_circle, color: isOpen ? AppColors.warning : AppColors.success, size: 20),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    dateTimeFormat.format(record.clockInAt),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(l10n.active,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
                    ),
                  ),
              ],
            ),
            AppSpacing.gapH8,
            Row(
              children: [
                _InfoChip(icon: Icons.login, label: 'In: ${timeFormat.format(record.clockInAt)}'),
                AppSpacing.gapW12,
                if (record.clockOutAt != null)
                  _InfoChip(icon: Icons.logout, label: 'Out: ${timeFormat.format(record.clockOutAt!)}'),
                if (record.breakMinutes != null && record.breakMinutes! > 0) ...[
                  AppSpacing.gapW12,
                  _InfoChip(icon: Icons.coffee, label: 'Break: ${record.breakMinutes}m'),
                ],
                if (record.overtimeMinutes != null && record.overtimeMinutes! > 0) ...[
                  AppSpacing.gapW12,
                  _InfoChip(icon: Icons.more_time, label: 'OT: ${record.overtimeMinutes}m', color: AppColors.error),
                ],
              ],
            ),
            if (record.notes != null) ...[
              AppSpacing.gapH8,
              Text(
                record.notes!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ],
            if (isOpen) ...[
              AppSpacing.gapH12,
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onStartBreak,
                    icon: const Icon(Icons.coffee, size: 16),
                    label: Text(l10n.staffStartBreak),
                  ),
                  AppSpacing.gapW8,
                  OutlinedButton.icon(
                    onPressed: onEndBreak,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: Text(l10n.staffEndBreak),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

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
// Clock Dialog
// ═══════════════════════════════════════════════════════════════

class _ClockDialog extends ConsumerStatefulWidget {
  final void Function(String staffId, String storeId, bool isClockIn, String? notes) onClock;

  const _ClockDialog({required this.onClock});

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
    // Ensure staff list is loaded
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
              label: '${l10n.staffMember} *',
              items: staffList.map((s) => PosDropdownItem(value: s, label: '${s.firstName} ${s.lastName}')).toList(),
              selectedValue: _selectedStaff,
              onChanged: (v) => setState(() => _selectedStaff = v),
              showSearch: true,
            ),
            AppSpacing.gapH16,
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(l10n.staffClockIn), icon: Icon(Icons.login)),
                ButtonSegment(value: false, label: Text(l10n.staffClockOut), icon: Icon(Icons.logout)),
              ],
              selected: {_isClockIn},
              onSelectionChanged: (v) => setState(() => _isClockIn = v.first),
            ),
            AppSpacing.gapH16,
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.staffNotesOptional, border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _selectedStaff == null
              ? null
              : () => widget.onClock(
                  _selectedStaff!.id,
                  _selectedStaff!.storeId,
                  _isClockIn,
                  _notesController.text.isNotEmpty ? _notesController.text : null,
                ),
          child: Text(_isClockIn ? 'Clock In' : 'Clock Out'),
        ),
      ],
    );
  }
}
