import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminPlatformEventListPage extends ConsumerStatefulWidget {
  const AdminPlatformEventListPage({super.key});

  @override
  ConsumerState<AdminPlatformEventListPage> createState() => _AdminPlatformEventListPageState();
}

class _AdminPlatformEventListPageState extends ConsumerState<AdminPlatformEventListPage> {
  final _searchController = TextEditingController();
  String? _levelFilter;
  String? _eventTypeFilter;
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
    if (_levelFilter != null) params['level'] = _levelFilter;
    if (_eventTypeFilter != null) params['event_type'] = _eventTypeFilter;
    ref.read(platformEventListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _levelColor(String? level) => switch (level) {
    'critical' => AppColors.errorDark,
    'error' => AppColors.error,
    'warning' => AppColors.warning,
    'info' => AppColors.info,
    'debug' => AppColors.textSecondary,
    _ => AppColors.textSecondary,
  };

  IconData _levelIcon(String? level) => switch (level) {
    'critical' => Icons.dangerous,
    'error' => Icons.error_outline,
    'warning' => Icons.warning_amber,
    'info' => Icons.info_outline,
    'debug' => Icons.bug_report_outlined,
    _ => Icons.article_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(platformEventListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Platform Events')),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                final searchField = TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                );
                final levelDropdown = DropdownButton<String>(
                  value: _levelFilter,
                  hint: const Text('Level'),
                  isExpanded: context.isPhone,
                  items: const [
                    DropdownMenuItem(value: 'debug', child: Text('Debug')),
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                    DropdownMenuItem(value: 'warning', child: Text('Warning')),
                    DropdownMenuItem(value: 'error', child: Text('Error')),
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                  ],
                  onChanged: (v) {
                    setState(() => _levelFilter = v);
                    _applyFilters();
                  },
                );
                final typeDropdown = DropdownButton<String>(
                  value: _eventTypeFilter,
                  hint: const Text('Type'),
                  isExpanded: context.isPhone,
                  items: const [
                    DropdownMenuItem(value: 'deployment', child: Text('Deployment')),
                    DropdownMenuItem(value: 'config_change', child: Text('Config Change')),
                    DropdownMenuItem(value: 'cron_job', child: Text('Cron Job')),
                    DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                    DropdownMenuItem(value: 'error', child: Text('Error')),
                  ],
                  onChanged: (v) {
                    setState(() => _eventTypeFilter = v);
                    _applyFilters();
                  },
                );
                if (context.isPhone) {
                  return Column(
                    children: [
                      searchField,
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: levelDropdown),
                          const SizedBox(width: 8),
                          Expanded(child: typeDropdown),
                        ],
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    levelDropdown,
                    const SizedBox(width: 8),
                    typeDropdown,
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              PlatformEventListInitial() || PlatformEventListLoading() => const Center(child: CircularProgressIndicator()),
              PlatformEventListLoaded(data: final data) => _buildList(data),
              PlatformEventListError(message: final msg) => Center(
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
      return const Center(child: Text('No platform events found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final event = items[index] as Map<String, dynamic>;
        final level = event['level']?.toString();
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _levelColor(level).withValues(alpha: 0.15),
              child: Icon(_levelIcon(level), color: _levelColor(level)),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    event['message']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _levelColor(level).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    level?.toUpperCase() ?? '',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _levelColor(level)),
                  ),
                ),
              ],
            ),
            subtitle: Text('${event['event_type'] ?? ''} • ${event['source'] ?? 'system'}\n${event['created_at'] ?? ''}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
