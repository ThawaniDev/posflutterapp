import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auto_update/services/update_scheduler_service.dart';

/// Settings page for auto-update configuration:
/// toggle auto-updates, choose maintenance window, select update channel.
class UpdateSettingsPage extends ConsumerStatefulWidget {
  const UpdateSettingsPage({super.key});

  @override
  ConsumerState<UpdateSettingsPage> createState() => _UpdateSettingsPageState();
}

class _UpdateSettingsPageState extends ConsumerState<UpdateSettingsPage> {
  final _scheduler = UpdateSchedulerService();
  bool _autoUpdateEnabled = true;
  int _maintenanceStart = 2;
  int _maintenanceEnd = 4;
  String _updateChannel = 'stable';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _scheduler.getPreferences();
    if (mounted) {
      setState(() {
        _autoUpdateEnabled = prefs['auto_update_enabled'] as bool;
        _maintenanceStart = prefs['maintenance_start'] as int;
        _maintenanceEnd = prefs['maintenance_end'] as int;
        _updateChannel = prefs['update_channel'] as String;
        _loading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    await _scheduler.savePreferences(
      autoUpdateEnabled: _autoUpdateEnabled,
      maintenanceStart: _maintenanceStart,
      maintenanceEnd: _maintenanceEnd,
      updateChannel: _updateChannel,
    );
    if (mounted) {
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.settingsSaved);
    }
  }

  @override
  void dispose() {
    _scheduler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.autoUpdateSettings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.autoUpdateSettings)),
      body: ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // Auto-update toggle
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.system_update),
              title: Text(l10n.autoUpdateEnable),
              subtitle: Text(l10n.autoUpdateEnableDesc),
              value: _autoUpdateEnabled,
              onChanged: (val) {
                setState(() => _autoUpdateEnabled = val);
                _savePreferences();
              },
            ),
          ),
          AppSpacing.gapH16,
          // Maintenance window
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.autoUpdateMaintenanceWindow, style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.autoUpdateWindowStart),
                  trailing: SizedBox(
                    width: 120,
                    child: PosSearchableDropdown<int>(
                      items: List.generate(24, (i) => PosDropdownItem(value: i, label: '${i.toString().padLeft(2, '0')}:00')),
                      selectedValue: _maintenanceStart,
                      onChanged: _autoUpdateEnabled
                          ? (val) {
                              if (val != null) {
                                setState(() => _maintenanceStart = val);
                                _savePreferences();
                              }
                            }
                          : null,
                      showSearch: false,
                      clearable: false,
                      enabled: _autoUpdateEnabled,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.autoUpdateWindowEnd),
                  trailing: SizedBox(
                    width: 120,
                    child: PosSearchableDropdown<int>(
                      items: List.generate(24, (i) => PosDropdownItem(value: i, label: '${i.toString().padLeft(2, '0')}:00')),
                      selectedValue: _maintenanceEnd,
                      onChanged: _autoUpdateEnabled
                          ? (val) {
                              if (val != null) {
                                setState(() => _maintenanceEnd = val);
                                _savePreferences();
                              }
                            }
                          : null,
                      showSearch: false,
                      clearable: false,
                      enabled: _autoUpdateEnabled,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    l10n.autoUpdateWindowDesc,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          // Update channel
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.autoUpdateChannel, style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ...['stable', 'beta', 'alpha'].map(
                  (channel) => RadioListTile<String>(
                    title: Text(channel[0].toUpperCase() + channel.substring(1)),
                    subtitle: Text(_channelDescription(channel, l10n)),
                    value: channel,
                    groupValue: _updateChannel,
                    onChanged: _autoUpdateEnabled
                        ? (val) {
                            if (val != null) {
                              setState(() => _updateChannel = val);
                              _savePreferences();
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _channelDescription(String channel, AppLocalizations l10n) {
    switch (channel) {
      case 'stable':
        return l10n.autoUpdateChannelStable;
      case 'beta':
        return l10n.autoUpdateChannelBeta;
      case 'alpha':
        return l10n.autoUpdateChannelAlpha;
      default:
        return '';
    }
  }
}
