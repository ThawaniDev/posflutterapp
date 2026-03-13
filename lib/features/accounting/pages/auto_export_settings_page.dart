import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_providers.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_state.dart';

class AutoExportSettingsPage extends ConsumerStatefulWidget {
  const AutoExportSettingsPage({super.key});

  @override
  ConsumerState<AutoExportSettingsPage> createState() => _AutoExportSettingsPageState();
}

class _AutoExportSettingsPageState extends ConsumerState<AutoExportSettingsPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Export Settings'),
        actions: [
          if (_hasChanges)
            TextButton.icon(
              onPressed: _saveConfig,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: switch (configState) {
        AutoExportConfigInitial() || AutoExportConfigLoading() => const Center(child: CircularProgressIndicator()),
        AutoExportConfigError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 12),
              Text('Error: $message', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(autoExportConfigProvider.notifier).loadConfig(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        AutoExportConfigLoaded() => _buildForm(),
      },
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Enable toggle
          Card(
            child: SwitchListTile(
              title: const Text('Enable Auto Export', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_enabled ? 'Exports will run automatically on schedule' : 'Auto export is disabled'),
              value: _enabled,
              onChanged: (val) => setState(() {
                _enabled = val;
                _hasChanges = true;
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Frequency
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Frequency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'daily', label: Text('Daily')),
                      ButtonSegment(value: 'weekly', label: Text('Weekly')),
                      ButtonSegment(value: 'monthly', label: Text('Monthly')),
                    ],
                    selected: {_frequency},
                    onSelectionChanged: (val) => setState(() {
                      _frequency = val.first;
                      _hasChanges = true;
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Day selection
                  if (_frequency == 'weekly') ...[
                    const Text('Day of Week'),
                    const SizedBox(height: 8),
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
                    const Text('Day of Month'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _dayOfMonth.clamp(1, 28),
                      decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      items: List.generate(28, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _dayOfMonth = val;
                            _hasChanges = true;
                          });
                        }
                      },
                    ),
                  ],

                  // Time
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: const Text('Export Time'),
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
          const SizedBox(height: 12),

          // Export types
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Export Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
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
          const SizedBox(height: 12),

          // Notification & retry
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    onChanged: (_) => setState(() => _hasChanges = true),
                    decoration: const InputDecoration(
                      labelText: 'Notification Email (optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Retry on Failure'),
                    subtitle: const Text('Automatically retry failed exports'),
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
          const SizedBox(height: 16),

          // Last/Next run info
          if (ref.read(autoExportConfigProvider) case AutoExportConfigLoaded(:final lastRunAt, :final nextRunAt))
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Schedule Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (lastRunAt != null) _buildInfoRow('Last Run', _formatDate(lastRunAt)),
                    if (nextRunAt != null) _buildInfoRow('Next Run', _formatDate(nextRunAt)),
                    if (lastRunAt == null && nextRunAt == null)
                      Text('No runs scheduled yet', style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
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
