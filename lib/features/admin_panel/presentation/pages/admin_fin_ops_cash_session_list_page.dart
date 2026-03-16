import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFinOpsCashSessionListPage extends ConsumerStatefulWidget {
  const AdminFinOpsCashSessionListPage({super.key});

  @override
  ConsumerState<AdminFinOpsCashSessionListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsCashSessionListPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(finOpsCashSessionsProvider.notifier).load());
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_statusFilter != null && _statusFilter!.isNotEmpty) params['status'] = _statusFilter;
    ref.read(finOpsCashSessionsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsCashSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Sessions'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
              items: ['', 'open', 'closed']
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
              _ => const Center(child: Text('Loading cash sessions...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No cash sessions found'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final status = (item['status'] ?? '').toString();
          final variance = num.tryParse(item['variance']?.toString() ?? '') ?? 0;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: status == 'open'
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.textMutedLight.withValues(alpha: 0.15),
                child: Icon(
                  Icons.point_of_sale,
                  color: status == 'open' ? AppColors.success : AppColors.textMutedLight,
                  size: 20,
                ),
              ),
              title: Text(
                'Session #${(item['id'] ?? '').toString().substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Float: ر.ع. ${_fmt(item['opening_float'])}', style: const TextStyle(fontSize: 12)),
                  if (variance != 0)
                    Text(
                      'Variance: ر.ع. ${variance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: variance < 0 ? AppColors.error : AppColors.success),
                    ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (status == 'open' ? AppColors.success : AppColors.textMutedLight).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: status == 'open' ? AppColors.success : AppColors.textMutedLight,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmt(dynamic v) {
    if (v == null) return '0.00';
    final n = v is num ? v : num.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(2);
  }
}
