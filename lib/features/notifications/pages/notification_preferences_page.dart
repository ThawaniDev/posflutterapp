import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

class NotificationPreferencesPage extends ConsumerStatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  ConsumerState<NotificationPreferencesPage> createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends ConsumerState<NotificationPreferencesPage> {
  TimeOfDay? _quietStart;
  TimeOfDay? _quietEnd;
  Map<String, dynamic> _preferences = {};
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationPreferencesProvider.notifier).load();
    });
  }

  void _initFromState(NotificationPreferencesLoaded state) {
    if (!_hasChanges) {
      _preferences = Map<String, dynamic>.from(state.preferences);
      _quietStart = _parseTime(state.quietHoursStart);
      _quietEnd = _parseTime(state.quietHoursEnd);
    }
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _save() {
    ref
        .read(notificationPreferencesProvider.notifier)
        .update(preferences: _preferences, quietHoursStart: _formatTime(_quietStart), quietHoursEnd: _formatTime(_quietEnd));
    _hasChanges = false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationPreferencesProvider);

    if (state is NotificationPreferencesLoaded) {
      _initFromState(state);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _save,
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: switch (state) {
        NotificationPreferencesInitial() || NotificationPreferencesLoading() => const Center(child: CircularProgressIndicator()),
        NotificationPreferencesError(:final message) => Center(
          child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
        ),
        NotificationPreferencesLoaded() => _buildPreferences(),
      },
    );
  }

  Widget _buildPreferences() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─── Notification Categories ──────────────
        const Text('Notification Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCategorySection('order_updates', 'Order Updates', 'New orders, status changes, cancellations', Icons.receipt_long),
        _buildCategorySection('promotions', 'Promotions', 'Deals, special offers, campaign alerts', Icons.local_offer),
        _buildCategorySection('inventory_alerts', 'Inventory Alerts', 'Low stock warnings, reorder reminders', Icons.inventory_2),
        _buildCategorySection('system_updates', 'System Updates', 'App updates, maintenance notices', Icons.settings),

        const SizedBox(height: 24),

        // ─── Quiet Hours ──────────────────────────
        const Text('Quiet Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Mute push notifications during these hours', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker(
                label: 'Start',
                value: _quietStart,
                onChanged: (t) => setState(() {
                  _quietStart = t;
                  _hasChanges = true;
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.arrow_forward, color: Colors.grey),
            ),
            Expanded(
              child: _buildTimePicker(
                label: 'End',
                value: _quietEnd,
                onChanged: (t) => setState(() {
                  _quietEnd = t;
                  _hasChanges = true;
                }),
              ),
            ),
          ],
        ),
        if (_quietStart != null || _quietEnd != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => setState(() {
              _quietStart = null;
              _quietEnd = null;
              _hasChanges = true;
            }),
            icon: const Icon(Icons.clear, size: 18),
            label: const Text('Clear quiet hours'),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySection(String key, String title, String subtitle, IconData icon) {
    final catPrefs = (_preferences[key] as Map<String, dynamic>?) ?? {};
    final inApp = catPrefs['in_app'] as bool? ?? true;
    final push = catPrefs['push'] as bool? ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChannelToggle('In-App', inApp, (v) {
                  _updateCategoryPref(key, 'in_app', v);
                }),
                const SizedBox(width: 16),
                _buildChannelToggle('Push', push, (v) {
                  _updateCategoryPref(key, 'push', v);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  void _updateCategoryPref(String category, String channel, bool value) {
    setState(() {
      final catPrefs = Map<String, dynamic>.from((_preferences[category] as Map<String, dynamic>?) ?? {});
      catPrefs[channel] = value;
      _preferences[category] = catPrefs;
      _hasChanges = true;
    });
  }

  Widget _buildTimePicker({required String label, required TimeOfDay? value, required ValueChanged<TimeOfDay> onChanged}) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: value ?? const TimeOfDay(hour: 22, minute: 0));
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          value != null ? value.format(context) : 'Not set',
          style: TextStyle(color: value != null ? null : Colors.grey),
        ),
      ),
    );
  }
}
