import 'package:flutter/material.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminAnnouncementListPage extends ConsumerStatefulWidget {
  const AdminAnnouncementListPage({super.key});

  @override
  ConsumerState<AdminAnnouncementListPage> createState() => _AdminAnnouncementListPageState();
}

class _AdminAnnouncementListPageState extends ConsumerState<AdminAnnouncementListPage> {
  final _searchController = TextEditingController();
  String? _selectedType;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(announcementListProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(announcementListProvider.notifier).load(type: _selectedType, storeId: _storeId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _typeColor(String? type) => switch (type) {
    'warning' => AppColors.warning,
    'maintenance' => AppColors.error,
    'update' => AppColors.info,
    _ => AppColors.success,
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
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
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
                        .load(
                          search: _searchController.text.isNotEmpty ? _searchController.text : null,
                          type: _selectedType,
                          storeId: _storeId,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: 'info', label: 'Info'),
                      PosDropdownItem(value: 'warning', label: 'Warning'),
                      PosDropdownItem(value: 'maintenance', label: 'Maintenance'),
                      PosDropdownItem(value: 'update', label: 'Update'),
                    ],
                    selectedValue: _selectedType,
                    onChanged: (v) {
                      setState(() => _selectedType = v);
                      ref.read(announcementListProvider.notifier).load(type: v, storeId: _storeId);
                    },
                    hint: 'Type',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              AnnouncementListInitial() || AnnouncementListLoading() => const Center(child: CircularProgressIndicator()),
              AnnouncementListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
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
