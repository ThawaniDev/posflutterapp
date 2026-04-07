import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminMarketplaceSettlementListPage extends ConsumerStatefulWidget {
  const AdminMarketplaceSettlementListPage({super.key});

  @override
  ConsumerState<AdminMarketplaceSettlementListPage> createState() => _AdminMarketplaceSettlementListPageState();
}

class _AdminMarketplaceSettlementListPageState extends ConsumerState<AdminMarketplaceSettlementListPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(marketplaceSettlementListProvider.notifier).load(params: params.isEmpty ? null : params);
    ref.read(marketplaceSettlementSummaryProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(marketplaceSettlementListProvider);
    final summaryState = ref.watch(marketplaceSettlementSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settlements'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // Summary card
          switch (summaryState) {
            MarketplaceSettlementSummaryLoaded(:final data) => _buildSummary(data),
            MarketplaceSettlementSummaryLoading() => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: LinearProgressIndicator(),
            ),
            _ => const SizedBox.shrink(),
          },
          // List
          Expanded(
            child: switch (listState) {
              MarketplaceSettlementListLoading() => const Center(child: CircularProgressIndicator()),
              MarketplaceSettlementListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: AppColors.error)),
              ),
              MarketplaceSettlementListLoaded(:final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(Map<String, dynamic> data) {
    final summary = data['data'] as Map<String, dynamic>? ?? data;
    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Builder(
          builder: (context) {
            if (context.isPhone) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem('Gross', summary['total_gross']?.toString() ?? '0'),
                      _summaryItem('Commission', summary['total_commission']?.toString() ?? '0'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem('Net', summary['total_net']?.toString() ?? '0'),
                      _summaryItem('Orders', summary['total_orders']?.toString() ?? '0'),
                    ],
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Gross', summary['total_gross']?.toString() ?? '0'),
                _summaryItem('Commission', summary['total_commission']?.toString() ?? '0'),
                _summaryItem('Net', summary['total_net']?.toString() ?? '0'),
                _summaryItem('Orders', summary['total_orders']?.toString() ?? '0'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final settlements = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (settlements.isEmpty) {
      return const Center(child: Text('No settlements found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: settlements.length,
      itemBuilder: (context, index) {
        final s = settlements[index];
        final store = s['store'] as Map<String, dynamic>?;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
            title: Text(store?['name']?.toString() ?? 'Unknown'),
            subtitle: Text('${s['settlement_date']} • ${s['order_count']} orders'),
            trailing: Text(
              '${s['net_amount']} \u0081',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
            ),
          ),
        );
      },
    );
  }
}
