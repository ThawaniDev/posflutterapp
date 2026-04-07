import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminActivityLogListPage extends ConsumerStatefulWidget {
  const AdminActivityLogListPage({super.key});

  @override
  ConsumerState<AdminActivityLogListPage> createState() => _AdminActivityLogListPageState();
}

class _AdminActivityLogListPageState extends ConsumerState<AdminActivityLogListPage> {
  final _searchController = TextEditingController();
  String? _actionFilter;
  String? _entityTypeFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_actionFilter != null) params['action'] = _actionFilter;
    if (_entityTypeFilter != null) params['entity_type'] = _entityTypeFilter;
    ref.read(activityLogListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityLogListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Logs')),
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
                    decoration: InputDecoration(
                      hintText: 'Search logs...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _actionFilter,
                  hint: const Text('Action'),
                  items: const [
                    DropdownMenuItem(value: 'login', child: Text('Login')),
                    DropdownMenuItem(value: 'create', child: Text('Create')),
                    DropdownMenuItem(value: 'update', child: Text('Update')),
                    DropdownMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onChanged: (v) {
                    setState(() => _actionFilter = v);
                    _applyFilters();
                  },
                ),
                if (_actionFilter != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() => _actionFilter = null);
                      _applyFilters();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              ActivityLogListInitial() || ActivityLogListLoading() => const Center(child: CircularProgressIndicator()),
              ActivityLogListLoaded(data: final data) => _buildList(data),
              ActivityLogListError(message: final msg) => Center(
                child: Text(msg, style: const TextStyle(color: AppColors.error)),
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
      return const Center(child: Text('No activity logs found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final log = items[index] as Map<String, dynamic>;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.history, color: AppColors.primary),
            ),
            title: Text(log['action']?.toString() ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${log['entity_type'] ?? ''} • ${log['ip_address'] ?? ''}\n${log['created_at'] ?? ''}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
