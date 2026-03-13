import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/features/staff/models/attendance_record.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';
import 'package:thawani_pos/features/staff/providers/staff_providers.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
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
    final colorScheme = Theme.of(context).colorScheme;

    // Listen for clock action results
    ref.listen<ClockActionState>(clockActionProvider, (prev, next) {
      if (next is ClockActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        _loadAttendance();
      } else if (next is ClockActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange, tooltip: 'Filter by date'),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAttendance),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showClockDialog(context),
        icon: const Icon(Icons.access_time),
        label: const Text('Clock In/Out'),
      ),
      body: Column(
        children: [
          // Active filters
          if (_dateRange != null || _selectedStaffId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colorScheme.surfaceContainerHighest,
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
                    const SizedBox(width: 8),
                  ],
                  if (_selectedStaffId != null)
                    Chip(
                      label: const Text('Filtered by staff', style: TextStyle(fontSize: 12)),
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
              AttendanceInitial() || AttendanceLoading() => const Center(child: CircularProgressIndicator()),
              AttendanceError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(msg),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _loadAttendance, child: const Text('Retry')),
                  ],
                ),
              ),
              AttendanceLoaded(records: final records) =>
                records.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time, size: 64, color: colorScheme.outline),
                            const SizedBox(height: 16),
                            const Text('No attendance records found'),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _loadAttendance(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: records.length,
                          itemBuilder: (context, index) => _AttendanceCard(
                            record: records[index],
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
  final DateFormat timeFormat;
  final DateFormat dateTimeFormat;
  final VoidCallback onStartBreak;
  final VoidCallback onEndBreak;

  const _AttendanceCard({
    required this.record,
    required this.timeFormat,
    required this.dateTimeFormat,
    required this.onStartBreak,
    required this.onEndBreak,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOpen = record.clockOutAt == null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isOpen ? Icons.timer : Icons.check_circle, color: isOpen ? Colors.orange : Colors.green, size: 20),
                const SizedBox(width: 8),
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
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.orange),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(icon: Icons.login, label: 'In: ${timeFormat.format(record.clockInAt)}'),
                const SizedBox(width: 12),
                if (record.clockOutAt != null)
                  _InfoChip(icon: Icons.logout, label: 'Out: ${timeFormat.format(record.clockOutAt!)}'),
                if (record.breakMinutes != null && record.breakMinutes! > 0) ...[
                  const SizedBox(width: 12),
                  _InfoChip(icon: Icons.coffee, label: 'Break: ${record.breakMinutes}m'),
                ],
                if (record.overtimeMinutes != null && record.overtimeMinutes! > 0) ...[
                  const SizedBox(width: 12),
                  _InfoChip(icon: Icons.more_time, label: 'OT: ${record.overtimeMinutes}m', color: colorScheme.error),
                ],
              ],
            ),
            if (record.notes != null) ...[
              const SizedBox(height: 8),
              Text(record.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
            ],
            if (isOpen) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onStartBreak,
                    icon: const Icon(Icons.coffee, size: 16),
                    label: const Text('Start Break'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onEndBreak,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('End Break'),
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
        const SizedBox(width: 4),
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

    return AlertDialog(
      title: const Text('Clock In / Out'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<StaffUser>(
              decoration: const InputDecoration(labelText: 'Staff Member *', border: OutlineInputBorder()),
              items: staffList.map((s) => DropdownMenuItem(value: s, child: Text('${s.firstName} ${s.lastName}'))).toList(),
              onChanged: (v) => setState(() => _selectedStaff = v),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Clock In'), icon: Icon(Icons.login)),
                ButtonSegment(value: false, label: Text('Clock Out'), icon: Icon(Icons.logout)),
              ],
              selected: {_isClockIn},
              onSelectionChanged: (v) => setState(() => _isClockIn = v.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
