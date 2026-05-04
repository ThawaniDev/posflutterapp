import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accounting/providers/accounting_providers.dart';
import 'package:wameedpos/features/accounting/providers/accounting_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AutoExportSettingsPage extends ConsumerStatefulWidget {
  const AutoExportSettingsPage({super.key});

  @override
  ConsumerState<AutoExportSettingsPage> createState() => _AutoExportSettingsPageState();
}

class _AutoExportSettingsPageState extends ConsumerState<AutoExportSettingsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _enabled = false;
  String _frequency = 'daily';
  int _dayOfWeek = 0;
  int _dayOfMonth = 1;
  TimeOfDay _time = const TimeOfDay(hour: 23, minute: 0);
  final _emailController = TextEditingController();
  bool _retryOnFailure = true;
  final Set<String> _selectedExportTypes = {};
  bool _hasChanges = false;

  static const _allExportTypes = [
    'daily_summary',
    'payment_breakdown',
    'category_breakdown',
    'expense_entries',
    'payroll_summary',
    'full_reconciliation',
  ];

  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(autoExportConfigProvider.notifier).loadConfig();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _populateFromState(AutoExportConfigLoaded state) {
    _enabled = state.enabled;
    _frequency = state.frequency;
    _dayOfWeek = state.dayOfWeek ?? 0;
    _dayOfMonth = state.dayOfMonth ?? 1;
    _emailController.text = state.notifyEmail ?? '';
    _retryOnFailure = state.retryOnFailure;

    // Parse time "HH:mm"
    final timeParts = state.time.split(':');
    if (timeParts.length == 2) {
      _time = TimeOfDay(hour: int.tryParse(timeParts[0]) ?? 23, minute: int.tryParse(timeParts[1]) ?? 0);
    }

    _selectedExportTypes.clear();
    for (final t in state.exportTypes) {
      if (t is String) _selectedExportTypes.add(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configState = ref.watch(autoExportConfigProvider);

    // Populate form from loaded state once
    ref.listen<AutoExportConfigState>(autoExportConfigProvider, (prev, next) {
      if (next is AutoExportConfigLoaded && prev is! AutoExportConfigLoaded) {
        setState(() {
          _populateFromState(next);
          _hasChanges = false;
        });
      }
    });

    return PosFormPage(
      title: l10n.autoExportSettings,
      isLoading: configState is AutoExportConfigInitial || configState is AutoExportConfigLoading,
      actions: [
        if (_hasChanges && configState is AutoExportConfigLoaded)
          PosButton(label: l10n.save, icon: Icons.save, onPressed: _saveConfig),
      ],
      child: switch (configState) {
        AutoExportConfigError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(autoExportConfigProvider.notifier).loadConfig(),
        ),
        AutoExportConfigLoaded() => _buildForm(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Enable toggle
        PosCard(
          elevation: 0,
          borderRadius: AppRadius.borderMd,
          border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
          child: SwitchListTile(
            title: Text(l10n.acctEnableAutoExport, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_enabled ? 'Exports will run automatically on schedule' : 'Auto export is disabled'),
            value: _enabled,
            onChanged: (val) => setState(() {
              _enabled = val;
              _hasChanges = true;
            }),
          ),
        ),
        AppSpacing.gapH12,

        // Frequency
        PosCard(
          elevation: 0,
          borderRadius: AppRadius.borderMd,
          border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.floristFrequency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                AppSpacing.gapH12,
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'daily', label: Text(l10n.gamificationDaily)),
                    ButtonSegment(value: 'weekly', label: Text(l10n.notificationsDigestWeekly)),
                    ButtonSegment(value: 'monthly', label: Text(l10n.subscriptionMonthly)),
                  ],
                  selected: {_frequency},
                  onSelectionChanged: (val) => setState(() {
                    _frequency = val.first;
                    _hasChanges = true;
                  }),
                ),
                AppSpacing.gapH16,

                // Day selection
                if (_frequency == 'weekly') ...[
                  Text(l10n.dayOfWeek),
                  AppSpacing.gapH8,
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (i) {
                      return ChoiceChip(
                        label: Text(_weekDays[i]),
                        selected: _dayOfWeek == i,
                        onSelected: (_) => setState(() {
                          _dayOfWeek = i;
                          _hasChanges = true;
                        }),
                      );
                    }),
                  ),
                ],
                if (_frequency == 'monthly') ...[
                  Text(l10n.dayOfMonth),
                  AppSpacing.gapH8,
                  PosSearchableDropdown<int>(
                    hint: l10n.selectDay,
                    label: l10n.dayOfMonth,
                    items: List.generate(28, (i) => PosDropdownItem(value: i + 1, label: '${i + 1}')),
                    selectedValue: _dayOfMonth.clamp(1, 28),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _dayOfMonth = val;
                          _hasChanges = true;
                        });
                      }
                    },
                    showSearch: false,
                    clearable: false,
                  ),
                ],

                // Time
                AppSpacing.gapH16,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: Text(l10n.exportTime),
                  trailing: Text(_time.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: _time);
                    if (picked != null) {
                      setState(() {
                        _time = picked;
                        _hasChanges = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapH12,

        // Export types
        PosCard(
          elevation: 0,
          borderRadius: AppRadius.borderMd,
          border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.acctExportTypes, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                AppSpacing.gapH8,
                ..._allExportTypes.map(
                  (t) => CheckboxListTile(
                    title: Text(_formatExportType(t)),
                    value: _selectedExportTypes.contains(t),
                    dense: true,
                    onChanged: (val) => setState(() {
                      if (val == true) {
                        _selectedExportTypes.add(t);
                      } else {
                        _selectedExportTypes.remove(t);
                      }
                      _hasChanges = true;
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapH12,

        // Notification & retry
        PosCard(
          elevation: 0,
          borderRadius: AppRadius.borderMd,
          border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.notifications, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                AppSpacing.gapH12,
                TextField(
                  controller: _emailController,
                  onChanged: (_) => setState(() => _hasChanges = true),
                  decoration: InputDecoration(
                    labelText: l10n.accountingNotificationEmail,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                AppSpacing.gapH12,
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.retryOnFailure),
                  subtitle: Text(l10n.automaticallyRetryFailedExports),
                  value: _retryOnFailure,
                  onChanged: (val) => setState(() {
                    _retryOnFailure = val;
                    _hasChanges = true;
                  }),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapH16,

        // Last/Next run info
        if (ref.read(autoExportConfigProvider) case AutoExportConfigLoaded(:final lastRunAt, :final nextRunAt))
          PosCard(
            elevation: 0,
            borderRadius: AppRadius.borderMd,
            border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
            color: AppColors.primary5,
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.acctScheduleInfo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  AppSpacing.gapH8,
                  if (lastRunAt != null) _buildInfoRow('Last Run', _formatDate(lastRunAt)),
                  if (nextRunAt != null) _buildInfoRow('Next Run', _formatDate(nextRunAt)),
                  if (lastRunAt == null && nextRunAt == null)
                    Text(l10n.acctNoRunsScheduled, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _saveConfig() {
    final data = <String, dynamic>{
      'enabled': _enabled,
      'frequency': _frequency,
      'time': '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
      'retry_on_failure': _retryOnFailure,
    };

    if (_frequency == 'weekly') {
      data['day_of_week'] = _dayOfWeek;
    }
    if (_frequency == 'monthly') {
      data['day_of_month'] = _dayOfMonth;
    }
    if (_selectedExportTypes.isNotEmpty) {
      data['export_types'] = _selectedExportTypes.toList();
    }
    if (_emailController.text.trim().isNotEmpty) {
      data['notify_email'] = _emailController.text.trim();
    }

    ref.read(autoExportConfigProvider.notifier).updateConfig(data);
    setState(() => _hasChanges = false);
  }

  String _formatExportType(String type) {
    return type.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
