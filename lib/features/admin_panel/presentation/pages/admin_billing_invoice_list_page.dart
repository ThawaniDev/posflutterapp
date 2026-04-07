import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminBillingInvoiceListPage extends ConsumerStatefulWidget {
  const AdminBillingInvoiceListPage({super.key});

  @override
  ConsumerState<AdminBillingInvoiceListPage> createState() => _AdminBillingInvoiceListPageState();
}

class _AdminBillingInvoiceListPageState extends ConsumerState<AdminBillingInvoiceListPage> {
  final _searchController = TextEditingController();
  String? _storeId;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(billingInvoiceListProvider.notifier).loadInvoices(storeId: _storeId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    ref
        .read(billingInvoiceListProvider.notifier)
        .loadInvoices(search: _searchController.text, status: _selectedStatus, storeId: _storeId);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _onSearch();
  }

  Color _statusColor(String status) {
    return switch (status) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.error,
      'refunded' => AppColors.purple,
      'draft' => AppColors.textSecondary,
      _ => AppColors.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billingInvoiceListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Manual Invoice',
            onPressed: () {
              // Navigate to create invoice
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by invoice number...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final status in [null, 'paid', 'pending', 'failed', 'refunded'])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(status?.toUpperCase() ?? 'ALL'),
                            selected: _selectedStatus == status,
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            onSelected: (_) {
                              setState(() => _selectedStatus = status);
                              _onSearch();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              BillingInvoiceListLoading() => const Center(child: CircularProgressIndicator()),
              BillingInvoiceListLoaded(invoices: final invoices) =>
                invoices.isEmpty
                    ? const Center(child: Text('No invoices found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final inv = invoices[index];
                          final status = inv['status'] as String? ?? 'unknown';
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _statusColor(status).withValues(alpha: 0.1),
                                child: Icon(Icons.receipt_long, color: _statusColor(status)),
                              ),
                              title: Text(inv['invoice_number'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Total: ${inv['total']} \u0081 · Due: ${inv['due_date'] ?? 'N/A'}'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                // Navigate to invoice detail
                              },
                            ),
                          );
                        },
                      ),
              BillingInvoiceListError(message: final msg) => Center(child: Text('Error: $msg')),
              _ => const Center(child: Text('Search for invoices')),
            },
          ),
        ],
      ),
    );
  }
}
