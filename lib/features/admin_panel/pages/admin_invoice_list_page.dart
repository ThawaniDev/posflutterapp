import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminInvoiceListPage extends ConsumerStatefulWidget {
  const AdminInvoiceListPage({super.key});

  @override
  ConsumerState<AdminInvoiceListPage> createState() => _AdminInvoiceListPageState();
}

class _AdminInvoiceListPageState extends ConsumerState<AdminInvoiceListPage> {
  String? _storeId;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(invoiceListProvider.notifier).loadInvoices(storeId: _storeId);
    });
  }

  void _onFilterChanged(String? status) {
    setState(() => _statusFilter = status);
    ref.read(invoiceListProvider.notifier).loadInvoices(status: status, storeId: _storeId);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(invoiceListProvider.notifier).loadInvoices(status: _statusFilter, storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', selected: _statusFilter == null, onSelected: () => _onFilterChanged(null)),
                  for (final s in ['pending', 'paid', 'overdue', 'cancelled'])
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: s[0].toUpperCase() + s.substring(1),
                        selected: _statusFilter == s,
                        onSelected: () => _onFilterChanged(s),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (state) {
              InvoiceListLoading() => const Center(child: CircularProgressIndicator()),
              InvoiceListError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, style: const TextStyle(color: AppColors.error)),
                    AppSpacing.gapH16,
                    PosButton(
                      label: 'Retry',
                      variant: PosButtonVariant.outline,
                      onPressed: () =>
                          ref.read(invoiceListProvider.notifier).loadInvoices(status: _statusFilter, storeId: _storeId),
                    ),
                  ],
                ),
              ),
              InvoiceListLoaded(:final invoices) =>
                invoices.isEmpty
                    ? const Center(child: Text('No invoices found'))
                    : ListView.builder(
                        padding: AppSpacing.paddingAll16,
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return _InvoiceCard(invoice: invoice);
                        },
                      ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Map<String, dynamic> invoice;
  const _InvoiceCard({required this.invoice});

  Color _statusColor(String status) {
    return switch (status) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'overdue' => AppColors.error,
      'cancelled' => AppColors.textSecondary,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final status = invoice['status'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: AppColors.primary),
        title: Text(invoice['invoice_number'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Due: ${invoice['due_date']?.toString().substring(0, 10) ?? 'N/A'}',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\u0081${invoice['total'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(color: _statusColor(status), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
