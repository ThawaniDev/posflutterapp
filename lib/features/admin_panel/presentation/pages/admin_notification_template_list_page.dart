import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminNotificationTemplateListPage extends ConsumerStatefulWidget {
  const AdminNotificationTemplateListPage({super.key});

  @override
  ConsumerState<AdminNotificationTemplateListPage> createState() => _AdminNotificationTemplateListPageState();
}

class _AdminNotificationTemplateListPageState extends ConsumerState<AdminNotificationTemplateListPage> {
  final _searchController = TextEditingController();
  String? _selectedChannel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationTemplateListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(notificationTemplateListProvider.notifier)
        .load(search: _searchController.text.isNotEmpty ? _searchController.text : null, channel: _selectedChannel);
  }

  Color _channelColor(String? channel) => switch (channel) {
    'push' => Colors.blue,
    'email' => Colors.purple,
    'sms' => Colors.green,
    'whatsapp' => Colors.teal,
    'in_app' => Colors.orange,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationTemplateListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Templates'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search templates...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String?>(
                  value: _selectedChannel,
                  hint: const Text('Channel'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'push', child: Text('Push')),
                    DropdownMenuItem(value: 'email', child: Text('Email')),
                    DropdownMenuItem(value: 'sms', child: Text('SMS')),
                    DropdownMenuItem(value: 'in_app', child: Text('In-App')),
                    DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedChannel = v);
                    _search();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              NotificationTemplateListInitial() ||
              NotificationTemplateListLoading() => const Center(child: CircularProgressIndicator()),
              NotificationTemplateListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
              ),
              NotificationTemplateListLoaded(:final templates) =>
                templates.isEmpty
                    ? const Center(child: Text('No templates found'))
                    : ListView.builder(
                        itemCount: templates.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final tpl = templates[index];
                          final channel = tpl['channel'] as String?;
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _channelColor(channel).withValues(alpha: 0.2),
                                child: Text(
                                  (channel ?? '?').substring(0, 1).toUpperCase(),
                                  style: TextStyle(color: _channelColor(channel), fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(tpl['event_key'] ?? ''),
                              subtitle: Text('${channel ?? ''} • ${tpl['title'] ?? 'No title'}'),
                              trailing: Switch(value: tpl['is_active'] == true, onChanged: null),
                            ),
                          );
                        },
                      ),
            },
          ),
        ],
      ),
    );
  }
}
