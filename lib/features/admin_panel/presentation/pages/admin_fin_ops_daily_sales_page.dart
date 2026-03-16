import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFinOpsDailySalesPage extends ConsumerStatefulWidget {
  const AdminFinOpsDailySalesPage({super.key});

  @override
  ConsumerState<AdminFinOpsDailySalesPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsDailySalesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(finOpsDailySalesSummaryProvider.notifier).load();
      ref.read(finOpsProductSalesSummaryProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Reports'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Daily Summary'),
            Tab(text: 'By Product'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_DailySummaryTab(), _ProductSalesTab()]),
    );
  }
}

class _DailySummaryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(finOpsDailySalesSummaryProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildList(resp),
      FinOpsListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No daily sales data'));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final total = num.tryParse(item['total_sales']?.toString() ?? '') ?? 0;
        final orders = item['order_count'] ?? item['total_orders'] ?? 0;
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      Text('$orders orders', style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ر.ع. ${total.toStringAsFixed(3)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                    if (item['avg_order_value'] != null)
                      Text(
                        'Avg: ${num.tryParse(item['avg_order_value'].toString())?.toStringAsFixed(3) ?? ''}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
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
    final state = ref.watch(finOpsProductSalesSummaryProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildList(resp),
      FinOpsListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No product sales data'));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final revenue = num.tryParse(item['total_revenue']?.toString() ?? '') ?? 0;
        final qty = item['total_quantity'] ?? item['quantity_sold'] ?? 0;
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      Text('$qty units sold', style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                    ],
                  ),
                ),
                Text(
                  'ر.ع. ${revenue.toStringAsFixed(3)}',
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
