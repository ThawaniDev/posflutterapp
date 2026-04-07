import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminFinOpsGiftCardListPage extends ConsumerStatefulWidget {
  const AdminFinOpsGiftCardListPage({super.key});

  @override
  ConsumerState<AdminFinOpsGiftCardListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsGiftCardListPage> {
  String? _storeId;
  String? _statusFilter;

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
    if (_statusFilter != null && _statusFilter!.isNotEmpty) params['status'] = _statusFilter;
    ref.read(finOpsGiftCardsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsGiftCardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gift Cards'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
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
              items: ['', 'active', 'redeemed', 'expired', 'deactivated']
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
              _ => const Center(child: Text('Loading gift cards...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No gift cards found'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final status = (item['status'] ?? '').toString();
          final balance = num.tryParse(item['balance']?.toString() ?? '') ?? 0;
          final initial = num.tryParse(item['initial_amount']?.toString() ?? '') ?? 0;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                child: const Icon(Icons.card_giftcard, color: Color(0xFFF59E0B), size: 20),
              ),
              title: Text(
                item['code']?.toString() ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
              subtitle: Text(
                'Balance: \u0081. ${balance.toStringAsFixed(2)} / ${initial.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: _statusChip(status),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      'active' => AppColors.success,
      'redeemed' => AppColors.info,
      'expired' => AppColors.warning,
      'deactivated' => AppColors.error,
      _ => AppColors.textMutedLight,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
