import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminBillingInvoiceListPage extends ConsumerStatefulWidget {
  const AdminBillingInvoiceListPage({super.key});

  @override
  ConsumerState<AdminBillingInvoiceListPage> createState() => _AdminBillingInvoiceListPageState();
}

class _AdminBillingInvoiceListPageState extends ConsumerState<AdminBillingInvoiceListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _storeId;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(billingInvoiceListProvider.notifier).loadInvoices(storeId: _storeId);
      ref.read(billingStatsProvider.notifier).load(storeId: _storeId);
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(billingInvoiceListProvider);

    return PosListPage(
  title: l10n.invoices,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add, onPressed: () {
              // Navigate to create invoice
            }, tooltip: l10n.adminCreateManualInvoice,
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: billingStatsProvider,
            cardBuilder: (data) => [
              kpi('Total Invoices', data['total_invoices'] ?? 0, AppColors.primary),
              kpi('Paid', data['paid_invoices'] ?? 0, AppColors.success),
              kpi('Failed', data['failed_invoices'] ?? 0, AppColors.error),
              kpi('MRR', data['mrr'] ?? 0, AppColors.info),
            ],
          ),
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
                    ? Center(child: Text(l10n.noInvoicesFound))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final inv = invoices[index];
                          final status = inv['status'] as String? ?? 'unknown';
                          return PosCard(
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
                                  borderRadius: AppRadius.borderLg,
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
              BillingInvoiceListError(message: final msg) => Center(child: Text(l10n.genericError(msg))),
              _ => Center(child: Text(l10n.adminSearchInvoices)),
            },
          ),
        ],
      ),
);
  }
}
