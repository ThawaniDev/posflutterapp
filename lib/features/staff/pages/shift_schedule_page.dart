import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
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

class _ShiftSchedulePageState extends ConsumerState<ShiftSchedulePage> with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late TabController _tabController;
  DateTimeRange? _dateRange;
  String? _statusFilter;
  String? _selectedStaffId;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      _loadShifts();
      ref.read(shiftTemplateProvider.notifier).load();
      final staffState = ref.read(staffListProvider);
      if (staffState is! StaffListLoaded) {
        ref.read(staffListProvider.notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadShifts() {
    ref
        .read(shiftProvider.notifier)
        .load(
          staffUserId: _selectedStaffId,
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
          status: _statusFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shiftProvider);
    final templateState = ref.watch(shiftTemplateProvider);
    final staffState = ref.watch(staffListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    final templates = templateState is ShiftTemplateLoaded ? templateState.templates : <ShiftTemplate>[];

    return PosListPage(
      title: l10n.staffShiftSchedule,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.date_range,
          tooltip: l10n.staffFilterByDate,
          onPressed: _pickDateRange,
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(icon: Icons.refresh, tooltip: l10n.commonRefresh, onPressed: _loadShifts, variant: PosButtonVariant.ghost),
        PosButton(
          label: l10n.staffAddShift,
          icon: Icons.add,
          onPressed: () => _showCreateShiftDialog(context, templates, staffList),
        ),
      ],
      isLoading: state is ShiftInitial || state is ShiftLoading,
      hasError: state is ShiftError,
      errorMessage: state is ShiftError ? (state).message : null,
      onRetry: _loadShifts,
      isEmpty: state is ShiftLoaded && state.shifts.isEmpty && _tabController.index == 0,
      emptyTitle: l10n.staffNoShifts,
      emptyIcon: Icons.calendar_today,
      child: Column(
        children: [
          // ─── Tab Bar ──────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.staffShiftsTab),
                Tab(text: l10n.staffTemplatesTab),
              ],
              onTap: (_) => setState(() {}),
            ),
          ),

          // ─── Filters (shifts tab only) ────────────
          if (_tabController.index == 0) ...[
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
                        _loadShifts();
                      },
                      showSearch: true,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l10n.all, style: const TextStyle(fontSize: 12)),
                    selected: _statusFilter == null,
                    onSelected: (_) {
                      setState(() => _statusFilter = null);
                      _loadShifts();
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                  AppSpacing.gapW8,
                  for (final status in ShiftScheduleStatus.values) ...[
                    FilterChip(
                      label: Text(_statusLabel(l10n, status), style: const TextStyle(fontSize: 12)),
                      selected: _statusFilter == status.value,
                      onSelected: (_) {
                        setState(() => _statusFilter = status.value);
                        _loadShifts();
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    AppSpacing.gapW4,
                  ],
                ],
              ),
            ),
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
                        _loadShifts();
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
          ],

          AppSpacing.gapH4,

          // ─── Tab Content ──────────────────────────
          Expanded(
            child: _tabController.index == 0
                ? _buildShiftsList(state, isDark, colorScheme, templates, staffList)
                : _buildTemplatesList(templateState, isDark, colorScheme),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Shifts List Tab
  // ═══════════════════════════════════════════════════════════

  Widget _buildShiftsList(
    ShiftState state,
    bool isDark,
    ColorScheme colorScheme,
    List<ShiftTemplate> templates,
    List<StaffUser> staffList,
  ) {
    if (state is! ShiftLoaded) return const SizedBox.shrink();
    final shifts = state.shifts;

    return RefreshIndicator(
      onRefresh: () async => _loadShifts(),
      child: shifts.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: shifts.length,
              itemBuilder: (context, index) {
                final shift = shifts[index];
                return _ShiftCard(
                  shift: shift,
                  templates: templates,
                  staffList: staffList,
                  isDark: isDark,
                  onEdit: () => _showEditShiftDialog(context, shift, templates, staffList),
                  onDelete: () => _confirmDeleteShift(context, shift),
                  onStatusChange: (newStatus) => _updateShiftStatus(shift, newStatus),
                );
              },
            ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Templates List Tab
  // ═══════════════════════════════════════════════════════════

  Widget _buildTemplatesList(ShiftTemplateState state, bool isDark, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.staffShiftTemplates,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PosButton(
                label: l10n.staffCreateTemplate,
                icon: Icons.add,
                onPressed: () => _showTemplateDialog(context),
                size: PosButtonSize.sm,
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (state) {
            ShiftTemplateLoading() => const Center(child: CircularProgressIndicator()),
            ShiftTemplateError(message: final msg) => Center(child: Text(msg)),
            ShiftTemplateLoaded(templates: final templates) =>
              templates.isEmpty
                  ? PosEmptyState(icon: Icons.schedule, title: l10n.staffNoTemplates)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: templates.length,
                      itemBuilder: (context, index) => _TemplateCard(
                        template: templates[index],
                        isDark: isDark,
                        onEdit: () => _showTemplateDialog(context, template: templates[index]),
                        onDelete: () => _confirmDeleteTemplate(context, templates[index]),
                      ),
                    ),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Actions
  // ═══════════════════════════════════════════════════════════

  Future<void> _pickDateRange() async {
    final range = await showPosDateRangePicker(
      context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _loadShifts();
    }
  }

  void _showCreateShiftDialog(BuildContext context, List<ShiftTemplate> templates, List<StaffUser> staffList) {
    showDialog(
      context: context,
      builder: (ctx) => _CreateShiftDialog(
        templates: templates,
        staffList: staffList,
        onCreate: (data) async {
          Navigator.pop(ctx);
          try {
            final staffUserIds = data.remove('staff_user_ids') as List<String>?;
            if (staffUserIds != null && staffUserIds.length > 1) {
              // Bulk: assign same period to multiple staff
              await ref.read(shiftProvider.notifier).bulkCreateShifts({...data, 'staff_user_ids': staffUserIds});
            } else {
              // Single staff
              await ref.read(shiftProvider.notifier).createShift({
                ...data,
                'staff_user_id': staffUserIds?.first ?? data['staff_user_id'],
              });
            }
            if (mounted) showPosSuccessSnackbar(context, l10n.staffShiftCreated);
          } catch (e) {
            if (mounted) showPosErrorSnackbar(context, _userError(e));
          }
        },
      ),
    );
  }

  void _showEditShiftDialog(BuildContext context, ShiftSchedule shift, List<ShiftTemplate> templates, List<StaffUser> staffList) {
    showDialog(
      context: context,
      builder: (ctx) => _EditShiftDialog(
        shift: shift,
        templates: templates,
        staffList: staffList,
        onSave: (data) async {
          Navigator.pop(ctx);
          try {
            await ref.read(shiftProvider.notifier).updateShift(shift.id, data);
            if (mounted) showPosSuccessSnackbar(context, l10n.staffShiftUpdated);
          } catch (e) {
            if (mounted) showPosErrorSnackbar(context, _userError(e));
          }
        },
      ),
    );
  }

  Future<void> _updateShiftStatus(ShiftSchedule shift, String newStatus) async {
    try {
      await ref.read(shiftProvider.notifier).updateShift(shift.id, {'status': newStatus});
      if (mounted) showPosSuccessSnackbar(context, l10n.staffShiftUpdated);
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, _userError(e));
    }
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
        if (mounted) showPosSuccessSnackbar(context, l10n.staffShiftDeleted);
      } catch (e) {
        if (mounted) showPosErrorSnackbar(context, _userError(e));
      }
    }
  }

  void _showTemplateDialog(BuildContext context, {ShiftTemplate? template}) {
    showDialog(
      context: context,
      builder: (ctx) => _ShiftTemplateDialog(
        template: template,
        onSave: (data) async {
          Navigator.pop(ctx);
          try {
            if (template != null) {
              await ref.read(shiftTemplateProvider.notifier).update(template.id, data);
            } else {
              await ref.read(shiftTemplateProvider.notifier).create(data);
            }
            if (mounted) {
              showPosSuccessSnackbar(context, template != null ? l10n.staffTemplateUpdated : l10n.staffTemplateCreated);
            }
          } catch (e) {
            if (mounted) showPosErrorSnackbar(context, _userError(e));
          }
        },
      ),
    );
  }

  Future<void> _confirmDeleteTemplate(BuildContext context, ShiftTemplate template) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.staffDeleteTemplate,
      message: l10n.staffDeleteTemplateConfirm,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(shiftTemplateProvider.notifier).delete(template.id);
        if (mounted) showPosSuccessSnackbar(context, l10n.staffTemplateDeleted);
      } catch (e) {
        if (mounted) showPosErrorSnackbar(context, _userError(e));
      }
    }
  }

  String _statusLabel(AppLocalizations l10n, ShiftScheduleStatus status) {
    return switch (status) {
      ShiftScheduleStatus.scheduled => l10n.staffStatusScheduled,
      ShiftScheduleStatus.completed => l10n.staffStatusCompleted,
      ShiftScheduleStatus.missed => l10n.staffStatusMissed,
      ShiftScheduleStatus.swapped => l10n.staffStatusSwapped,
    };
  }

  String _userError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) return data['message'] as String;
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
        }
      }
    }
    return e.toString();
  }
}

// ═══════════════════════════════════════════════════════════════
// Shift Card
// ═══════════════════════════════════════════════════════════════

class _ShiftCard extends StatelessWidget {

  const _ShiftCard({
    required this.shift,
    required this.templates,
    required this.staffList,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });
  final ShiftSchedule shift;
  final List<ShiftTemplate> templates;
  final List<StaffUser> staffList;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(String newStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final (statusColor, statusLabel) = _statusInfo(context, shift.status);

    final staffName =
        shift.staffUser?.fullName ??
        staffList.where((s) => s.id == shift.staffUserId).map((s) => '${s.firstName} ${s.lastName}'.trim()).firstOrNull ??
        l10n.staffUnknown;

    final template = shift.shiftTemplate ?? templates.where((t) => t.id == shift.shiftTemplateId).firstOrNull;
    final templateName = template?.name ?? '';
    final templateTime = template != null ? '${template.startTime} - ${template.endTime}' : '';
    final templateColor = template?.color != null ? _parseColor(template!.color!) : colorScheme.primary;
    final dateLabel = shift.startDate == shift.endDate
        ? DateFormat('MMM d, yyyy').format(shift.startDate)
        : '${DateFormat('MMM d').format(shift.startDate)} – ${DateFormat('MMM d, yyyy').format(shift.endDate)}';

    return PosCard(
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: InkWell(
        onTap: onEdit,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(color: templateColor, borderRadius: BorderRadius.circular(2)),
              ),
              AppSpacing.gapW12,
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  staffName.isNotEmpty ? staffName[0].toUpperCase() : '?',
                  style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            staffName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                    const SizedBox(height: 2),
                    if (templateName.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: colorScheme.outline),
                          AppSpacing.gapW4,
                          Text(
                            '$templateName  •  $templateTime',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                          ),
                        ],
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.date_range, size: 14, color: colorScheme.outline),
                        AppSpacing.gapW4,
                        Text(dateLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                      ],
                    ),
                    if (shift.actualStart != null || shift.actualEnd != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, size: 14, color: AppColors.success),
                          AppSpacing.gapW4,
                          Text(
                            '${l10n.staffActual}: ${shift.actualStart != null ? DateFormat('HH:mm').format(shift.actualStart!) : '—'} - ${shift.actualEnd != null ? DateFormat('HH:mm').format(shift.actualEnd!) : '—'}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                    if (shift.notes != null && shift.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        shift.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 20, color: colorScheme.outline),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [const Icon(Icons.edit, size: 18), AppSpacing.gapW8, Text(l10n.edit)]),
                  ),
                  if (shift.status != ShiftScheduleStatus.completed)
                    PopupMenuItem(
                      value: 'complete',
                      child: Row(
                        children: [const Icon(Icons.check_circle, size: 18), AppSpacing.gapW8, Text(l10n.staffMarkComplete)],
                      ),
                    ),
                  if (shift.status != ShiftScheduleStatus.missed)
                    PopupMenuItem(
                      value: 'missed',
                      child: Row(
                        children: [
                          const Icon(Icons.cancel, size: 18, color: AppColors.error),
                          AppSpacing.gapW8,
                          Text(l10n.staffMarkMissed, style: const TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 18, color: AppColors.error),
                        AppSpacing.gapW8,
                        Text(l10n.delete, style: const TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (action) {
                  switch (action) {
                    case 'edit':
                      onEdit();
                    case 'complete':
                      onStatusChange('completed');
                    case 'missed':
                      onStatusChange('missed');
                    case 'delete':
                      onDelete();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, String) _statusInfo(BuildContext context, ShiftScheduleStatus? status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      ShiftScheduleStatus.scheduled => (AppColors.info, l10n.staffStatusScheduled),
      ShiftScheduleStatus.completed => (AppColors.success, l10n.staffStatusCompleted),
      ShiftScheduleStatus.missed => (AppColors.error, l10n.staffStatusMissed),
      ShiftScheduleStatus.swapped => (AppColors.warning, l10n.staffStatusSwapped),
      null => (AppColors.mutedFor(context), l10n.staffStatusUnknown),
    };
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Template Card
// ═══════════════════════════════════════════════════════════════

class _TemplateCard extends StatelessWidget {

  const _TemplateCard({required this.template, required this.isDark, required this.onEdit, required this.onDelete});
  final ShiftTemplate template;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final templateColor = template.color != null ? _parseColor(template.color!) : colorScheme.primary;

    return PosCard(
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onEdit,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: templateColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: templateColor, width: 2),
                ),
                child: Icon(Icons.schedule, color: templateColor, size: 20),
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(template.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        if (!template.isActive) ...[
                          AppSpacing.gapW8,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              borderRadius: AppRadius.borderLg,
                            ),
                            child: Text(
                              l10n.inactive,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.error),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: colorScheme.outline),
                        AppSpacing.gapW4,
                        Text(
                          '${template.startTime} - ${template.endTime}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                        ),
                        if (template.breakDurationMinutes > 0) ...[
                          AppSpacing.gapW12,
                          Icon(Icons.coffee, size: 14, color: colorScheme.outline),
                          AppSpacing.gapW4,
                          Text(
                            l10n.staffBreakMinutes(template.breakDurationMinutes),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.outline),
                onPressed: onEdit,
                tooltip: l10n.edit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                onPressed: onDelete,
                tooltip: l10n.delete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Create Shift Dialog (Single + Bulk)
// ═══════════════════════════════════════════════════════════════

class _CreateShiftDialog extends ConsumerStatefulWidget {

  const _CreateShiftDialog({required this.templates, required this.staffList, required this.onCreate});
  final List<ShiftTemplate> templates;
  final List<StaffUser> staffList;
  final void Function(Map<String, dynamic> data) onCreate;

  @override
  ConsumerState<_CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends ConsumerState<_CreateShiftDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final Set<StaffUser> _selectedStaff = {};
  ShiftTemplate? _selectedTemplate;
  DateTimeRange _selectedRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final _notesController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSingleDay = _selectedRange.start == _selectedRange.end;
    final rangeLabel = isSingleDay
        ? _dateFormat.format(_selectedRange.start)
        : '${_dateFormat.format(_selectedRange.start)} – ${_dateFormat.format(_selectedRange.end)}';

    return AlertDialog(
      title: Text(l10n.staffCreateShift),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.staffSelectMembers, style: Theme.of(context).textTheme.labelMedium),
              AppSpacing.gapH8,
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: widget.staffList.map((staff) {
                  final isSelected = _selectedStaff.contains(staff);
                  return FilterChip(
                    label: Text(l10n.staffFullNameLabel(staff.firstName, staff.lastName)),
                    selected: isSelected,
                    onSelected: (v) => setState(() => v ? _selectedStaff.add(staff) : _selectedStaff.remove(staff)),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),

              AppSpacing.gapH16,
              PosSearchableDropdown<ShiftTemplate>(
                hint: l10n.selectTemplate,
                label: l10n.staffMemberRequired(l10n.staffShiftTemplate),
                items: widget.templates
                    .where((t) => t.isActive)
                    .map((t) => PosDropdownItem(value: t, label: l10n.staffShiftLabel(t.name, t.startTime, t.endTime)))
                    .toList(),
                selectedValue: _selectedTemplate,
                onChanged: (v) => setState(() => _selectedTemplate = v),
                showSearch: true,
              ),

              AppSpacing.gapH16,
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.staffPeriod),
                subtitle: Text(rangeLabel),
                trailing: const Icon(Icons.date_range),
                onTap: () async {
                  final range = await showPosDateRangePicker(
                    context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                    initialDateRange: _selectedRange,
                  );
                  if (range != null) setState(() => _selectedRange = range);
                },
              ),

              AppSpacing.gapH16,
              PosTextField(controller: _notesController, label: l10n.staffNotesOptional, maxLines: 2),
            ],
          ),
        ),
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context), variant: PosButtonVariant.ghost, label: l10n.cancel),
        PosButton(
          onPressed: _canSubmit
              ? () {
                  widget.onCreate({
                    'store_id': _selectedStaff.first.storeId,
                    'staff_user_ids': _selectedStaff.map((s) => s.id).toList(),
                    'shift_template_id': _selectedTemplate!.id,
                    'start_date': _dateFormat.format(_selectedRange.start),
                    'end_date': _dateFormat.format(_selectedRange.end),
                    if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
                  });
                }
              : null,
          label: l10n.save,
        ),
      ],
    );
  }

  bool get _canSubmit {
    return _selectedStaff.isNotEmpty && _selectedTemplate != null;
  }
}

// ═══════════════════════════════════════════════════════════════
// Edit Shift Dialog
// ═══════════════════════════════════════════════════════════════

class _EditShiftDialog extends StatefulWidget {

  const _EditShiftDialog({required this.shift, required this.templates, required this.staffList, required this.onSave});
  final ShiftSchedule shift;
  final List<ShiftTemplate> templates;
  final List<StaffUser> staffList;
  final void Function(Map<String, dynamic> data) onSave;

  @override
  State<_EditShiftDialog> createState() => _EditShiftDialogState();
}

class _EditShiftDialogState extends State<_EditShiftDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late ShiftTemplate? _selectedTemplate;
  late DateTimeRange _selectedRange;
  late ShiftScheduleStatus? _selectedStatus;
  final _notesController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.templates.where((t) => t.id == widget.shift.shiftTemplateId).firstOrNull;
    _selectedRange = DateTimeRange(start: widget.shift.startDate, end: widget.shift.endDate);
    _selectedStatus = widget.shift.status;
    _notesController.text = widget.shift.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final staffName =
        widget.shift.staffUser?.fullName ??
        widget.staffList
            .where((s) => s.id == widget.shift.staffUserId)
            .map((s) => '${s.firstName} ${s.lastName}'.trim())
            .firstOrNull ??
        '';

    return AlertDialog(
      title: Text(l10n.staffEditShift),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosTextField(label: l10n.staffMember, initialValue: staffName, readOnly: true),
              AppSpacing.gapH16,
              PosSearchableDropdown<ShiftTemplate>(
                hint: l10n.selectTemplate,
                label: l10n.staffShiftTemplate,
                items: widget.templates
                    .map((t) => PosDropdownItem(value: t, label: l10n.staffShiftLabel(t.name, t.startTime, t.endTime)))
                    .toList(),
                selectedValue: _selectedTemplate,
                onChanged: (v) => setState(() => _selectedTemplate = v),
                showSearch: true,
              ),
              AppSpacing.gapH16,
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.staffPeriod),
                subtitle: Text(
                  _selectedRange.start == _selectedRange.end
                      ? _dateFormat.format(_selectedRange.start)
                      : '${_dateFormat.format(_selectedRange.start)} – ${_dateFormat.format(_selectedRange.end)}',
                ),
                trailing: const Icon(Icons.date_range),
                onTap: () async {
                  final range = await showPosDateRangePicker(
                    context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                    initialDateRange: _selectedRange,
                  );
                  if (range != null) setState(() => _selectedRange = range);
                },
              ),
              AppSpacing.gapH16,
              PosSearchableDropdown<ShiftScheduleStatus>(
                hint: l10n.selectStatus,
                label: l10n.status,
                items: ShiftScheduleStatus.values.map((s) => PosDropdownItem(value: s, label: s.value)).toList(),
                selectedValue: _selectedStatus,
                onChanged: (v) => setState(() => _selectedStatus = v),
              ),
              AppSpacing.gapH16,
              PosTextField(controller: _notesController, label: l10n.staffNotesOptional, maxLines: 2),
            ],
          ),
        ),
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context), variant: PosButtonVariant.ghost, label: l10n.cancel),
        PosButton(
          onPressed: () {
            widget.onSave({
              if (_selectedTemplate != null) 'shift_template_id': _selectedTemplate!.id,
              'start_date': _dateFormat.format(_selectedRange.start),
              'end_date': _dateFormat.format(_selectedRange.end),
              if (_selectedStatus != null) 'status': _selectedStatus!.value,
              if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
            });
          },
          label: l10n.save,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Shift Template Dialog (Create / Edit)
// ═══════════════════════════════════════════════════════════════

class _ShiftTemplateDialog extends ConsumerStatefulWidget {

  const _ShiftTemplateDialog({this.template, required this.onSave});
  final ShiftTemplate? template;
  final void Function(Map<String, dynamic> data) onSave;

  @override
  ConsumerState<_ShiftTemplateDialog> createState() => _ShiftTemplateDialogState();
}

class _ShiftTemplateDialogState extends ConsumerState<_ShiftTemplateDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _nameController = TextEditingController();
  final _breakController = TextEditingController();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  String _selectedColor = '#2196F3';
  bool _isActive = true;

  static const _colorOptions = [
    '#2196F3',
    '#4CAF50',
    '#FF9800',
    '#E91E63',
    '#9C27B0',
    '#00BCD4',
    '#795548',
    '#607D8B',
    '#F44336',
    '#3F51B5',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _nameController.text = widget.template!.name;
      _breakController.text = widget.template!.breakDurationMinutes > 0 ? widget.template!.breakDurationMinutes.toString() : '';
      _startTime = _parseTime(widget.template!.startTime);
      _endTime = _parseTime(widget.template!.endTime);
      _selectedColor = widget.template!.color ?? '#2196F3';
      _isActive = widget.template!.isActive;
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _nameController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.template != null;

    return AlertDialog(
      title: Text(isEdit ? l10n.staffEditTemplate : l10n.staffCreateTemplate),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosTextField(controller: _nameController, label: l10n.name),
              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.staffStartTime),
                      subtitle: Text(_formatTime(_startTime)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _startTime);
                        if (time != null) setState(() => _startTime = time);
                      },
                    ),
                  ),
                  AppSpacing.gapW16,
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.staffEndTime),
                      subtitle: Text(_formatTime(_endTime)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _endTime);
                        if (time != null) setState(() => _endTime = time);
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              PosTextField(
                controller: _breakController,
                label: '${l10n.staffBreakDuration} (${l10n.staffMinutes})',
                keyboardType: TextInputType.number,
              ),
              AppSpacing.gapH16,
              Text(l10n.color, style: Theme.of(context).textTheme.labelMedium),
              AppSpacing.gapH8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colorOptions.map((color) {
                  final isSelected = _selectedColor == color;
                  final parsedColor = Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: parsedColor,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3) : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
              AppSpacing.gapH16,
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.active),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context), variant: PosButtonVariant.ghost, label: l10n.cancel),
        PosButton(
          onPressed: _nameController.text.isEmpty
              ? null
              : () {
                  final data = <String, dynamic>{
                    'name': _nameController.text,
                    'start_time': _formatTime(_startTime),
                    'end_time': _formatTime(_endTime),
                    'break_duration_minutes': int.tryParse(_breakController.text) ?? 0,
                    'color': _selectedColor,
                    'is_active': _isActive,
                  };
                  if (!isEdit) {
                    data['store_id'] = ref.read(staffListProvider) is StaffListLoaded
                        ? (ref.read(staffListProvider) as StaffListLoaded).staff.firstOrNull?.storeId ?? ''
                        : '';
                  }
                  widget.onSave(data);
                },
          label: l10n.save,
        ),
      ],
    );
  }
}
