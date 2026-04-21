import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/settings/models/working_hour.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';

class WorkingHoursPage extends ConsumerStatefulWidget {
  const WorkingHoursPage({super.key});

  @override
  ConsumerState<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends ConsumerState<WorkingHoursPage> {
  String? _storeId;
  bool _saving = false;
  List<WorkingHour>? _localHours;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _storeId = await ref.read(authLocalStorageProvider).getStoreId();
      if (_storeId != null) {
        ref.read(workingHoursProvider.notifier).load(_storeId!);
      }
    });
  }

  void _initLocal(List<WorkingHour> hours) {
    if (_localHours != null) return;
    _localHours = List.of(hours);
  }

  Future<void> _save() async {
    if (_storeId == null || _saving || _localHours == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(workingHoursProvider.notifier).update(_storeId!, _localHours!);
      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.settingsSaved);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final state = ref.watch(workingHoursProvider);

    final isLoading = state is WorkingHoursLoading || state is WorkingHoursInitial;
    final hasError = state is WorkingHoursError;

    final List<WorkingHour>? hours = switch (state) {
      WorkingHoursLoaded(:final hours) => hours,
      WorkingHoursSaved(:final hours) => hours,
      WorkingHoursSaving(:final hours) => hours,
      _ => null,
    };

    return PosFormPage(
      title: l10n.settingsWorkingHours,
      isLoading: isLoading,
      bottomBar: hours == null
          ? null
          : Row(
              children: [
                Expanded(
                  child: PosButton(label: l10n.save, icon: Icons.save, onPressed: _save, isLoading: _saving, isFullWidth: true),
                ),
              ],
            ),
      child: hasError
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message, textAlign: TextAlign.center),
                AppSpacing.gapH12,
                PosButton(
                  label: l10n.retry,
                  onPressed: _storeId == null ? null : () => ref.read(workingHoursProvider.notifier).load(_storeId!),
                ),
              ],
            )
          : hours == null
          ? const SizedBox.shrink()
          : _build(hours, l10n, isAr),
    );
  }

  Widget _build(List<WorkingHour> hours, AppLocalizations l10n, bool isAr) {
    _initLocal(hours);
    return Column(
      children: [
        ..._localHours!.map(
          (day) => _DayCard(
            day: day,
            isAr: isAr,
            onChanged: (updated) {
              setState(() {
                final idx = _localHours!.indexWhere((d) => d.dayOfWeek == updated.dayOfWeek);
                if (idx >= 0) _localHours![idx] = updated;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {

  const _DayCard({required this.day, required this.isAr, required this.onChanged});
  final WorkingHour day;
  final bool isAr;
  final ValueChanged<WorkingHour> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = isAr ? day.dayNameAr : day.dayName;

    return PosCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: Theme.of(context).textTheme.titleSmall)),
                Switch.adaptive(
                  value: day.isOpen,
                  onChanged: (v) => onChanged(day.copyWith(isOpen: v)),
                ),
              ],
            ),
            if (day.isOpen) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TimePicker(
                      label: l10n.settingsWorkingOpen,
                      value: day.openTime,
                      onChanged: (t) => onChanged(day.copyWith(openTime: t)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimePicker(
                      label: l10n.settingsWorkingClose,
                      value: day.closeTime,
                      onChanged: (t) => onChanged(day.copyWith(closeTime: t)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TimePicker(
                      label: l10n.settingsWorkingBreakStart,
                      value: day.breakStart,
                      onChanged: (t) => onChanged(day.copyWith(breakStart: t)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimePicker(
                      label: l10n.settingsWorkingBreakEnd,
                      value: day.breakEnd,
                      onChanged: (t) => onChanged(day.copyWith(breakEnd: t)),
                    ),
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

class _TimePicker extends StatelessWidget {

  const _TimePicker({required this.label, this.value, required this.onChanged});
  final String label;
  final String? value; // "HH:mm:ss" or "HH:mm"
  final ValueChanged<String> onChanged;

  TimeOfDay? _parseTime() {
    if (value == null || value!.isEmpty) return null;
    final parts = value!.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final tod = _parseTime();
    final text = tod != null ? tod.format(context) : '—';

    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: tod ?? const TimeOfDay(hour: 9, minute: 0));
        if (picked != null) {
          onChanged('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00');
        }
      },
      borderRadius: AppRadius.borderMd,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, isDense: true, border: const OutlineInputBorder()),
        child: Text(text),
      ),
    );
  }
}
