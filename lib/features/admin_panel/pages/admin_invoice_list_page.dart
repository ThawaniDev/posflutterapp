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

class AdminInvoiceListPage extends ConsumerStatefulWidget {
  const AdminInvoiceListPage({super.key});

  @override
  ConsumerState<AdminInvoiceListPage> createState() => _AdminInvoiceListPageState();
}

class _AdminInvoiceListPageState extends ConsumerState<AdminInvoiceListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final isLoading = state is InvoiceListLoading;
    final hasError = state is InvoiceListError;
    final isEmpty = state is InvoiceListLoaded && state.invoices.isEmpty;

    return PosListPage(
      title: l10n.invoices,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(invoiceListProvider.notifier).loadInvoices(status: _statusFilter, storeId: _storeId),
      isEmpty: isEmpty,
      emptyTitle: l10n.noInvoicesFound,
      emptyIcon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: l10n.all, selected: _statusFilter == null, onSelected: () => _onFilterChanged(null)),
                  for (final s in ['pending', 'paid', 'overdue', 'cancelled'])
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
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
              InvoiceListLoaded(:final invoices) => ListView.builder(
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

  const _FilterChip({required this.label, required this.selected, required this.onSelected});
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.mutedFor(context),
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});
  final Map<String, dynamic> invoice;

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

    return PosCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: AppColors.primary),
        title: Text(invoice['invoice_number'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Due: ${invoice['due_date']?.toString().substring(0, 10) ?? 'N/A'}',
          style: TextStyle(color: AppColors.mutedFor(context), fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\u0081${invoice['total'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
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
