import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/enums/shift_schedule_status.dart';
import 'package:wameedpos/features/staff/models/shift_schedule.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class ShiftSchedulePage extends ConsumerStatefulWidget {
  const ShiftSchedulePage({super.key});

  @override
  ConsumerState<ShiftSchedulePage> createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends ConsumerState<ShiftSchedulePage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  DateTimeRange? _dateRange;
  String? _statusFilter;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadShifts());
  }

  void _loadShifts() {
    ref
        .read(shiftProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
          status: _statusFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shiftProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.staffShiftSchedule),
        actions: [
          IconButton(icon: Icon(Icons.date_range), onPressed: _pickDateRange, tooltip: l10n.staffFilterByDate),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadShifts),
        ],
      ),
      floatingActionButton: PosButton(
        onPressed: () => _showCreateShiftDialog(context, state),
        // icon: const Icon(Icons.add),
        label: l10n.staffAddShift,
      ),
      body: Column(
        children: [
          // Status filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: Text(l10n.all, style: TextStyle(fontSize: 12)),
                  selected: _statusFilter == null,
                  onSelected: (_) {
                    setState(() => _statusFilter = null);
                    _loadShifts();
                  },
                  visualDensity: VisualDensity.compact,
                ),
                for (final status in ShiftScheduleStatus.values) ...[
                  AppSpacing.gapW8,
                  FilterChip(
                    label: Text(status.value.toUpperCase(), style: const TextStyle(fontSize: 12)),
                    selected: _statusFilter == status.value,
                    onSelected: (_) {
                      setState(() => _statusFilter = status.value);
                      _loadShifts();
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
          ),
          // Active date filter
          if (_dateRange != null)
            Container(
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
                      _loadShifts();
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          AppSpacing.gapH4,
          // Shift list
          Expanded(
            child: switch (state) {
              ShiftInitial() || ShiftLoading() => PosLoadingSkeleton.list(),
              ShiftError(message: final msg) => PosErrorState(message: msg, onRetry: _loadShifts),
              ShiftLoaded(shifts: final shifts) =>
                shifts.isEmpty
                    ? const PosEmptyState(title: 'No shifts found', icon: Icons.calendar_today)
                    : RefreshIndicator(
                        onRefresh: () async => _loadShifts(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: shifts.length,
                          itemBuilder: (context, index) => _ShiftCard(
                            shift: shifts[index],
                            dateFormat: _dateFormat,
                            onDelete: () => _confirmDeleteShift(context, shifts[index]),
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
      _loadShifts();
    }
  }

  void _showCreateShiftDialog(BuildContext context, ShiftState state) {
    final templates = state is ShiftLoaded ? state.templates : <ShiftTemplate>[];

    showDialog(
      context: context,
      builder: (ctx) => _CreateShiftDialog(
        templates: templates,
        onCreate: (data) async {
          Navigator.pop(ctx);
          try {
            await ref.read(shiftProvider.notifier).createShift(data);
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              showPosSuccessSnackbar(context, l10n.staffShiftCreated);
            }
          } catch (e) {
            if (mounted) {
              showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
            }
          }
        },
      ),
    );
  }

  Future<void> _confirmDeleteShift(BuildContext context, ShiftSchedule shift) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.staffDeleteShift,
      message: l10n.staffDeleteShiftConfirm,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(shiftProvider.notifier).deleteShift(shift.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.staffShiftDeleted);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, l10n.genericError(e.toString()));
        }
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Shift Card
// ═══════════════════════════════════════════════════════════════

class _ShiftCard extends StatelessWidget {
  final ShiftSchedule shift;
  final DateFormat dateFormat;
  final VoidCallback onDelete;

  const _ShiftCard({required this.shift, required this.dateFormat, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (statusColor, statusLabel) = _statusInfo(shift.status);

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            Container(
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text(
                    DateFormat('dd').format(shift.date),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                  ),
                  Text(
                    DateFormat('MMM').format(shift.date),
                    style: TextStyle(fontSize: 12, color: colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            AppSpacing.gapW16,
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Staff: ${shift.staffUserId}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (shift.actualStart != null || shift.actualEnd != null) ...[
                    Text(
                      'Actual: ${shift.actualStart != null ? DateFormat('HH:mm').format(shift.actualStart!) : '—'} - ${shift.actualEnd != null ? DateFormat('HH:mm').format(shift.actualEnd!) : '—'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  Text(
                    'Template: ${shift.shiftTemplateId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Delete
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: onDelete,
              tooltip: 'Delete shift',
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _statusInfo(ShiftScheduleStatus? status) {
    return switch (status) {
      ShiftScheduleStatus.scheduled => (AppColors.info, 'Scheduled'),
      ShiftScheduleStatus.completed => (AppColors.success, 'Completed'),
      ShiftScheduleStatus.missed => (AppColors.error, 'Missed'),
      ShiftScheduleStatus.swapped => (AppColors.warning, 'Swapped'),
      null => (AppColors.textSecondary, 'Unknown'),
    };
  }
}

// ═══════════════════════════════════════════════════════════════
// Create Shift Dialog
// ═══════════════════════════════════════════════════════════════

class _CreateShiftDialog extends ConsumerStatefulWidget {
  final List<ShiftTemplate> templates;
  final void Function(Map<String, dynamic> data) onCreate;

  const _CreateShiftDialog({required this.templates, required this.onCreate});

  @override
  ConsumerState<_CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends ConsumerState<_CreateShiftDialog> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  StaffUser? _selectedStaff;
  ShiftTemplate? _selectedTemplate;
  DateTime _selectedDate = DateTime.now();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final state = ref.read(staffListProvider);
    if (state is! StaffListLoaded) {
      ref.read(staffListProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.staffCreateShift),
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
            PosSearchableDropdown<ShiftTemplate>(
              label: '${l10n.staffShiftTemplate} *',
              items: widget.templates
                  .map((t) => PosDropdownItem(value: t, label: '${t.name} (${t.startTime} - ${t.endTime})'))
                  .toList(),
              selectedValue: _selectedTemplate,
              onChanged: (v) => setState(() => _selectedTemplate = v),
              showSearch: true,
            ),
            AppSpacing.gapH16,
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.txColDate),
              subtitle: Text(_dateFormat.format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _selectedStaff == null || _selectedTemplate == null
              ? null
              : () => widget.onCreate({
                  'store_id': _selectedStaff!.storeId,
                  'staff_user_id': _selectedStaff!.id,
                  'shift_template_id': _selectedTemplate!.id,
                  'date': _dateFormat.format(_selectedDate),
                }),
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
