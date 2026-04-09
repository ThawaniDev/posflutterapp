import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminInfraFailedJobsPage extends ConsumerStatefulWidget {
  const AdminInfraFailedJobsPage({super.key});

  @override
  ConsumerState<AdminInfraFailedJobsPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraFailedJobsPage> {
  String? _storeId;
  String? _queueFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilter();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilter();
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_queueFilter != null && _queueFilter!.isNotEmpty) params['queue'] = _queueFilter;
    ref.read(infraFailedJobsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infraFailedJobsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Failed Jobs'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'default', label: 'default'),
                PosDropdownItem(value: 'high', label: 'high'),
                PosDropdownItem(value: 'notifications', label: 'notifications'),
                PosDropdownItem(value: 'billing', label: 'billing'),
                PosDropdownItem(value: 'sync', label: 'sync'),
                PosDropdownItem(value: 'reports', label: 'reports'),
              ],
              selectedValue: _queueFilter,
              onChanged: (v) {
                setState(() => _queueFilter = v);
                _applyFilter();
              },
              label: 'Queue',
              hint: 'All Queues',
              showSearch: false,
              clearable: true,
            ),
          ),
          Expanded(
            child: switch (state) {
              InfraListLoading() => const Center(child: CircularProgressIndicator()),
              InfraListLoaded(data: final resp) => _buildList(resp),
              InfraListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => const Center(child: Text('Loading...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No failed jobs'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final exception = (item['exception'] ?? '').toString();
          final truncated = exception.length > 100 ? '${exception.substring(0, 100)}...' : exception;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEE2E2),
                child: Icon(Icons.error_outline, color: AppColors.error, size: 20),
              ),
              title: Text('Queue: ${item['queue'] ?? 'unknown'}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                truncated,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
              trailing: Text(item['failed_at']?.toString().substring(0, 10) ?? '', style: const TextStyle(fontSize: 10)),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
