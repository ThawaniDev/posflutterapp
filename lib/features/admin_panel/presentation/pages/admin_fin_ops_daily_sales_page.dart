import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminFinOpsDailySalesPage extends ConsumerStatefulWidget {
  const AdminFinOpsDailySalesPage({super.key});

  @override
  ConsumerState<AdminFinOpsDailySalesPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsDailySalesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(finOpsDailySalesSummaryProvider.notifier).load(params: params);
    ref.read(finOpsProductSalesSummaryProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.adminFinOpsSalesReports,
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.dailySummary),
              PosTabItem(label: l10n.adminFinOpsByProduct),
            ],
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: [_DailySummaryTab(), _ProductSalesTab()]),
          ),
        ],
      ),
    );
  }
}

class _DailySummaryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsDailySalesSummaryProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildList(context, resp),
      FinOpsListError(message: final msg) => Center(
        child: Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildList(BuildContext context, Map<String, dynamic> resp) {
    final l10n = AppLocalizations.of(context)!;
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.adminNoDailySales));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final total = num.tryParse(item['total_sales']?.toString() ?? '') ?? 0;
        final orders = item['order_count'] ?? item['total_orders'] ?? 0;
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['date']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('$orders orders', style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\u0081. ${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                    if (item['avg_order_value'] != null)
                      Text(
                        'Avg: ${num.tryParse(item['avg_order_value'].toString())?.toStringAsFixed(2) ?? ''}',
                        style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductSalesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsProductSalesSummaryProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildList(context, resp),
      FinOpsListError(message: final msg) => Center(
        child: Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildList(BuildContext context, Map<String, dynamic> resp) {
    final l10n = AppLocalizations.of(context)!;
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.adminNoProductSales));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final revenue = num.tryParse(item['total_revenue']?.toString() ?? '') ?? 0;
        final qty = item['total_quantity'] ?? item['quantity_sold'] ?? 0;
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  child: const Icon(Icons.inventory_2, color: Color(0xFF7C3AED), size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['product_name']?.toString() ?? 'Product #${item['product_id'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$qty units sold', style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
                    ],
                  ),
                ),
                Text(
                  '\u0081. ${revenue.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
