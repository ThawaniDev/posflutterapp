import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_state.dart';

class AdminNotificationLogListPage extends ConsumerStatefulWidget {
  const AdminNotificationLogListPage({super.key});

  @override
  ConsumerState<AdminNotificationLogListPage> createState() => _AdminNotificationLogListPageState();
}

class _AdminNotificationLogListPageState extends ConsumerState<AdminNotificationLogListPage> {
  final _searchController = TextEditingController();
  String? _channelFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationLogListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_channelFilter != null) params['channel'] = _channelFilter;
    if (_statusFilter != null) params['status'] = _statusFilter;
    ref.read(notificationLogListProvider.notifier).load(params: params);
  }

  Color _channelColor(String? channel) => switch (channel) {
    'push' => Colors.blue,
    'email' => Colors.teal,
    'sms' => Colors.purple,
    'whatsapp' => Colors.green,
    'in_app' => AppColors.primary,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationLogListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Logs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search notification logs...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _channelFilter,
                  hint: const Text('Channel'),
                  items: const [
                    DropdownMenuItem(value: 'push', child: Text('Push')),
                    DropdownMenuItem(value: 'email', child: Text('Email')),
                    DropdownMenuItem(value: 'sms', child: Text('SMS')),
                    DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                    DropdownMenuItem(value: 'in_app', child: Text('In-App')),
                  ],
                  onChanged: (v) {
                    setState(() => _channelFilter = v);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _statusFilter,
                  hint: const Text('Status'),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'sent', child: Text('Sent')),
                    DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                  ],
                  onChanged: (v) {
                    setState(() => _statusFilter = v);
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              NotificationLogListInitial() || NotificationLogListLoading() => const Center(child: CircularProgressIndicator()),
              NotificationLogListLoaded(data: final data) => _buildList(data),
              NotificationLogListError(message: final msg) => Center(
                child: Text(msg, style: const TextStyle(color: Colors.red)),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data']?['data'] as List?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No notification logs found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final log = items[index] as Map<String, dynamic>;
        final channel = log['channel']?.toString();
        final status = log['status']?.toString() ?? 'pending';
        final isFailed = status == 'failed';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _channelColor(channel).withValues(alpha: 0.15),
              child: Icon(Icons.notifications_outlined, color: _channelColor(channel)),
            ),
            title: Text(
              '${channel?.replaceAll('_', ' ').toUpperCase() ?? 'UNKNOWN'} • $status',
              style: TextStyle(fontWeight: FontWeight.w600, color: isFailed ? Colors.red : null),
            ),
            subtitle: isFailed
                ? Text(log['error_message']?.toString() ?? '', style: const TextStyle(color: Colors.red))
                : Text('Sent: ${log['sent_at'] ?? 'N/A'}'),
          ),
        );
      },
    );
  }
}
