import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/widgets/invoice_tile.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Page showing invoice/billing history with filtering and pagination.
class BillingHistoryPage extends ConsumerStatefulWidget {
  const BillingHistoryPage({super.key});

  @override
  ConsumerState<BillingHistoryPage> createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends ConsumerState<BillingHistoryPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _statusFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoicesProvider.notifier).loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoicesState = ref.watch(invoicesProvider);

    return PosListPage(
      title: l10n.subscriptionBillingHistory,
      showSearch: false,
      child: Column(
        children: [
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(l10n.subFilterAll, null),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.subFilterPaid, 'paid'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.subFilterPending, 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.subFilterOverdue, 'overdue'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.subFilterCancelled, 'cancelled'),
              ],
            ),
          ),
          Expanded(child: _buildBody(invoicesState)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _statusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary20,
      checkmarkColor: AppColors.primary,
      onSelected: (_) {
        setState(() {
          _statusFilter = value;
          _currentPage = 1;
        });
        ref.read(invoicesProvider.notifier).loadInvoices(page: 1);
      },
    );
  }

  Widget _buildBody(InvoicesState state) {
    if (state is InvoicesLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (state is InvoicesError) {
      return PosErrorState(message: state.message, onRetry: () => ref.read(invoicesProvider.notifier).loadInvoices());
    }

    if (state is InvoicesLoaded) {
      var invoices = state.invoices;

      // Client-side status filter
      if (_statusFilter != null) {
        invoices = invoices.where((inv) => inv.status?.name.toLowerCase() == _statusFilter).toList();
      }

      if (invoices.isEmpty) {
        return PosEmptyState(title: l10n.noInvoicesFound, icon: Icons.receipt_long);
      }

      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.read(invoicesProvider.notifier).loadInvoices(page: _currentPage);
              },
              child: ListView.separated(
                padding: AppSpacing.paddingAllMd,
                itemCount: invoices.length,
                separatorBuilder: (_, __) => AppSpacing.verticalSm,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => context.go('${Routes.invoiceDetail}/${invoices[index].id}'),
                    borderRadius: AppRadius.borderLg,
                    child: InvoiceTile(invoice: invoices[index]),
                  );
                },
              ),
            ),
          ),
          // Pagination
          if (state.lastPage > 1)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() => _currentPage--);
                            ref.read(invoicesProvider.notifier).loadInvoices(page: _currentPage);
                          }
                        : null,
                  ),
                  Text(l10n.subPageOfLast(_currentPage.toString(), state.lastPage.toString())),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < state.lastPage
                        ? () {
                            setState(() => _currentPage++);
                            ref.read(invoicesProvider.notifier).loadInvoices(page: _currentPage);
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
