import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/onboarding/models/store_working_hour.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_providers.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_state.dart';

/// Working hours editor — toggles and time pickers for each day of the week.
class WorkingHoursPage extends ConsumerStatefulWidget {
  final String storeId;

  const WorkingHoursPage({super.key, required this.storeId});

  @override
  ConsumerState<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends ConsumerState<WorkingHoursPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _isSaving = false;

  // Local editable copy: 7 days (0=Sunday to 6=Saturday)
  final List<_DayEntry> _days = List.generate(
    7,
    (i) => _DayEntry(
      dayOfWeek: i,
      isOpen: i != 5, // Friday off by default
      openTime: i != 5 ? const TimeOfDay(hour: 9, minute: 0) : null,
      closeTime: i != 5 ? const TimeOfDay(hour: 22, minute: 0) : null,
    ),
  );

  bool _populated = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(workingHoursProvider(widget.storeId).notifier).load());
  }

  void _populateFromServer(List<StoreWorkingHour> hours) {
    if (_populated) return;
    _populated = true;
    for (final h in hours) {
      if (h.dayOfWeek >= 0 && h.dayOfWeek < 7) {
        _days[h.dayOfWeek] = _DayEntry(
          dayOfWeek: h.dayOfWeek,
          isOpen: h.isOpen,
          openTime: _parseTime(h.openTime),
          closeTime: _parseTime(h.closeTime),
          breakStart: _parseTime(h.breakStart),
          breakEnd: _parseTime(h.breakEnd),
        );
      }
    }
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final days = _days
          .map(
            (d) => <String, dynamic>{
              'day_of_week': d.dayOfWeek,
              'is_open': d.isOpen,
              'open_time': d.isOpen ? _formatTime(d.openTime) : null,
              'close_time': d.isOpen ? _formatTime(d.closeTime) : null,
              'break_start': d.breakStart != null ? _formatTime(d.breakStart) : null,
              'break_end': d.breakEnd != null ? _formatTime(d.breakEnd) : null,
            },
          )
          .toList();

      await ref.read(workingHoursProvider(widget.storeId).notifier).update(days);

      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.workingHoursSaved);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickTime(int dayIndex, bool isOpen) async {
    final day = _days[dayIndex];
    final initial = isOpen
        ? (day.openTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (day.closeTime ?? const TimeOfDay(hour: 22, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) {
        return MediaQuery(data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true), child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        if (isOpen) {
          _days[dayIndex] = day.copyWith(openTime: picked);
        } else {
          _days[dayIndex] = day.copyWith(closeTime: picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hoursState = ref.watch(workingHoursProvider(widget.storeId));

    if (hoursState is WorkingHoursLoaded) {
      _populateFromServer(hoursState.hours);
    }

    final isLoading = hoursState is WorkingHoursLoading;
    final hasError = hoursState is WorkingHoursError;

    return PosFormPage(
      title: l10n.branchesWorkingHours,
      isLoading: isLoading,
      bottomBar: PosButton(label: l10n.save, isLoading: _isSaving, onPressed: _isSaving ? null : _save, isFullWidth: true),
      child: hasError
          ? Center(child: Text(l10n.genericError(hoursState.message)))
          : Column(
              children: List.generate(
                7,
                (i) => Padding(
                  padding: EdgeInsets.only(bottom: i < 6 ? AppSpacing.md : 0),
                  child: _buildDayCard(i),
                ),
              ),
            ),
    );
  }

  Widget _buildDayCard(int index) {
    final day = _days[index];
    final dayLabel = StoreWorkingHour.dayNames[index];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: day.isOpen ? AppColors.primary20 : AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Day header with toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: day.isOpen ? AppColors.primary10 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Center(
                    child: Text(
                      dayLabel.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: day.isOpen ? AppColors.primary : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    dayLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: day.isOpen ? null : AppColors.textMutedLight,
                    ),
                  ),
                ),
                Switch(
                  value: day.isOpen,
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    setState(() {
                      _days[index] = day.copyWith(
                        isOpen: v,
                        openTime: v ? (day.openTime ?? const TimeOfDay(hour: 9, minute: 0)) : day.openTime,
                        closeTime: v ? (day.closeTime ?? const TimeOfDay(hour: 22, minute: 0)) : day.closeTime,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          // Time pickers (when open)
          if (day.isOpen) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(child: _timeButton('Open', day.openTime, () => _pickTime(index, true))),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.textMutedLight),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _timeButton('Close', day.closeTime, () => _pickTime(index, false))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _timeButton(String label, TimeOfDay? time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              time != null ? _formatTime(time) : '--:--',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal editable model for a single day of the week.
class _DayEntry {
  final int dayOfWeek;
  final bool isOpen;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;

  const _DayEntry({required this.dayOfWeek, this.isOpen = true, this.openTime, this.closeTime, this.breakStart, this.breakEnd});

  _DayEntry copyWith({
    int? dayOfWeek,
    bool? isOpen,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    TimeOfDay? breakStart,
    TimeOfDay? breakEnd,
  }) {
    return _DayEntry(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }
}
