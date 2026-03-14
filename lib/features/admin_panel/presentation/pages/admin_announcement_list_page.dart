import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminAnnouncementListPage extends ConsumerStatefulWidget {
  const AdminAnnouncementListPage({super.key});

  @override
  ConsumerState<AdminAnnouncementListPage> createState() => _AdminAnnouncementListPageState();
}

class _AdminAnnouncementListPageState extends ConsumerState<AdminAnnouncementListPage> {
  final _searchController = TextEditingController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(announcementListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _typeColor(String? type) => switch (type) {
    'warning' => Colors.orange,
    'maintenance' => Colors.red,
    'update' => Colors.blue,
    _ => Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Announcements'),
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
                      hintText: 'Search announcements...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => ref
                        .read(announcementListProvider.notifier)
                        .load(search: _searchController.text.isNotEmpty ? _searchController.text : null, type: _selectedType),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String?>(
                  value: _selectedType,
                  hint: const Text('Type'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                    DropdownMenuItem(value: 'warning', child: Text('Warning')),
                    DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                    DropdownMenuItem(value: 'update', child: Text('Update')),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedType = v);
                    ref.read(announcementListProvider.notifier).load(type: v);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              AnnouncementListInitial() || AnnouncementListLoading() => const Center(child: CircularProgressIndicator()),
              AnnouncementListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
              ),
              AnnouncementListLoaded(:final announcements, :final total, :final currentPage, :final lastPage) =>
                announcements.isEmpty
                    ? const Center(child: Text('No announcements found'))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: announcements.length,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final ann = announcements[index];
                                final type = ann['type'] as String?;
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: _typeColor(type).withValues(alpha: 0.2),
                                      child: Icon(
                                        type == 'warning'
                                            ? Icons.warning
                                            : type == 'maintenance'
                                            ? Icons.build
                                            : type == 'update'
                                            ? Icons.system_update
                                            : Icons.info,
                                        color: _typeColor(type),
                                      ),
                                    ),
                                    title: Text(ann['title'] ?? ''),
                                    subtitle: Text(
                                      '${type ?? 'info'} • ${ann['is_banner'] == true ? 'Banner' : ''} ${ann['send_push'] == true ? '• Push' : ''}'
                                          .trim(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('Page $currentPage of $lastPage ($total total)'),
                          ),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }
}
