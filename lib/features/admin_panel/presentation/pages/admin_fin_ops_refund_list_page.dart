import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFinOpsRefundListPage extends ConsumerStatefulWidget {
  const AdminFinOpsRefundListPage({super.key});

  @override
  ConsumerState<AdminFinOpsRefundListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsRefundListPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(finOpsRefundsProvider.notifier).load());
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_statusFilter != null && _statusFilter!.isNotEmpty) params['status'] = _statusFilter;
    ref.read(finOpsRefundsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsRefundsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Refunds'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: DropdownButtonFormField<String>(
              value: _statusFilter ?? '',
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: ['', 'pending', 'completed', 'failed']
                  .map(
                    (s) =>
                        DropdownMenuItem(value: s, child: Text(s.isEmpty ? 'All Statuses' : s[0].toUpperCase() + s.substring(1))),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _applyFilter();
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
              FinOpsListLoaded(data: final resp) => _buildList(resp),
              FinOpsListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => const Center(child: Text('Loading refunds...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No refunds found'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final status = (item['status'] ?? '').toString();
          final amount = num.tryParse(item['amount']?.toString() ?? '') ?? 0;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(status).withValues(alpha: 0.15),
                child: Icon(Icons.replay, color: _statusColor(status), size: 20),
              ),
              title: Text('ر.س. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                item['method']?.toString().replaceAll('_', ' ').toUpperCase() ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: _statusChip(status),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String s) => switch (s) {
    'completed' => AppColors.success,
    'pending' => AppColors.warning,
    'failed' => AppColors.error,
    _ => AppColors.textMutedLight,
  };

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _statusColor(status)),
      ),
    );
  }
}
