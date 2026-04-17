import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAIBillingPage extends ConsumerStatefulWidget {
  const AdminWameedAIBillingPage({super.key});

  @override
  ConsumerState<AdminWameedAIBillingPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIBillingPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wameedAIAdminBillingDashboardProvider.notifier).load();
      ref.read(wameedAIAdminBillingInvoicesProvider.notifier).load();
      ref.read(wameedAIAdminBillingStoresProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.listen(wameedAIAdminActionProvider, (_, next) {
      if (next is WameedAIAdminActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success), backgroundColor: AppColors.success));
        ref.read(wameedAIAdminActionProvider.notifier).reset();
        _refreshAll();
      } else if (next is WameedAIAdminActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
        ref.read(wameedAIAdminActionProvider.notifier).reset();
      }
    });

    return PosListPage(
      title: l10n.adminWameedAIBilling,
      showSearch: false,
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.overview),
              PosTabItem(label: l10n.invoices),
              PosTabItem(label: l10n.stores),
            ],
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: [_overviewTab(l10n), _invoicesTab(l10n), _storesTab(l10n)]),
          ),
        ],
      ),
    );
  }

  void _refreshAll() {
    ref.read(wameedAIAdminBillingDashboardProvider.notifier).load();
    ref.read(wameedAIAdminBillingInvoicesProvider.notifier).load();
    ref.read(wameedAIAdminBillingStoresProvider.notifier).load();
  }

  // ── OVERVIEW TAB ──
  Widget _overviewTab(AppLocalizations l10n) {
    final state = ref.watch(wameedAIAdminBillingDashboardProvider);
    return switch (state) {
      WameedAIAdminDashboardLoading() => const Center(child: PosLoading()),
      WameedAIAdminDashboardLoaded(data: final resp) => _buildOverview(resp, l10n),
      WameedAIAdminDashboardError(message: final msg) => PosErrorState(
        message: msg,
        onRetry: () => ref.read(wameedAIAdminBillingDashboardProvider.notifier).load(),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildOverview(Map<String, dynamic> resp, AppLocalizations l10n) {
    final d = resp['data'] as Map<String, dynamic>? ?? resp;
    final invoiceStats = d['invoice_stats'] as Map<String, dynamic>? ?? {};
    final storeStats = d['store_stats'] as Map<String, dynamic>? ?? {};
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 2.5,
          children: [
            PosKpiCard(
              label: l10n.adminWameedAITotalRevenue,
              value: '\$${_fmt(invoiceStats['total_billed_usd'] ?? invoiceStats['total_collected_usd'])}',
              subtitle: l10n.adminWameedAIAllTime,
              icon: Icons.attach_money_rounded,
              iconColor: AppColors.success,
            ),
            PosKpiCard(
              label: l10n.adminWameedAIOutstanding,
              value:
                  '\$${_fmt((invoiceStats['total_billed_usd'] as num? ?? 0).toDouble() - (invoiceStats['total_collected_usd'] as num? ?? 0).toDouble())}',
              subtitle: '${invoiceStats['pending_count'] ?? 0} ${l10n.invoices}',
              icon: Icons.pending_actions_rounded,
              iconColor: AppColors.warning,
            ),
            PosKpiCard(
              label: l10n.adminWameedAIOverdue,
              value: '${invoiceStats['overdue_count'] ?? 0}',
              subtitle: '${invoiceStats['total_invoices'] ?? 0} ${l10n.invoices}',
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.error,
            ),
            PosKpiCard(
              label: l10n.adminWameedAIBillingStores,
              value: '${storeStats['enabled_stores'] ?? storeStats['total_stores'] ?? 0}',
              subtitle: '${storeStats['total_stores'] ?? 0} ${l10n.stores}',
              icon: Icons.store_rounded,
              iconColor: AppColors.info,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Generate invoices action
        Row(
          children: [
            PosButton(
              label: l10n.adminWameedAIGenerateInvoices,
              onPressed: () => _confirmGenerate(l10n),
              variant: PosButtonVariant.primary,
              icon: Icons.receipt_long_rounded,
            ),
          ],
        ),
      ],
    );
  }

  void _confirmGenerate(AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.adminWameedAIGenerateInvoices,
      message: l10n.adminWameedAIGenerateInvoicesConfirm,
      confirmLabel: l10n.generate,
      cancelLabel: l10n.cancel,
    );
    if (confirmed == true) {
      ref.read(wameedAIAdminActionProvider.notifier).generateInvoices();
    }
  }

  // ── INVOICES TAB ──
  Widget _invoicesTab(AppLocalizations l10n) {
    final state = ref.watch(wameedAIAdminBillingInvoicesProvider);
    return switch (state) {
      WameedAIAdminListLoading() => const Center(child: PosLoading()),
      WameedAIAdminListLoaded(data: final resp) => _buildInvoices(resp, l10n),
      WameedAIAdminListError(message: final msg) => PosErrorState(
        message: msg,
        onRetry: () => ref.read(wameedAIAdminBillingInvoicesProvider.notifier).load(),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildInvoices(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final invoices =
        (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? (data['invoices'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Column(
      children: [
        Expanded(
          child: invoices.isEmpty
              ? PosEmptyState(
                  title: l10n.noInvoicesFound,
                  subtitle: l10n.adminWameedAIGenerateInvoicesHint,
                  icon: Icons.receipt_long_rounded,
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.backgroundLight),
                    columns: [
                      DataColumn(label: Text(l10n.store, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.invoiceNumber, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.period, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.debitsAmount, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.status, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.dueDate, style: AppTypography.labelSmall)),
                      DataColumn(label: Text(l10n.actions, style: AppTypography.labelSmall)),
                    ],
                    rows: invoices.map((inv) {
                      final storeName = inv['store_name'] ?? inv['store']?['name'] ?? 'Store #${inv['store_id'] ?? ''}';
                      final status = inv['status']?.toString() ?? '';
                      final isPaid = status == 'paid';
                      final isOverdue = status == 'overdue';
                      return DataRow(
                        cells: [
                          DataCell(Text(storeName.toString(), style: AppTypography.bodySmall)),
                          DataCell(Text(inv['invoice_number']?.toString() ?? '-', style: AppTypography.bodySmall)),
                          DataCell(
                            Text(
                              inv['period_start'] != null
                                  ? '${_fmtDate(inv['period_start']?.toString() ?? '')} — ${_fmtDate(inv['period_end']?.toString() ?? '')}'
                                  : '${inv['year'] ?? ''}/${inv['month']?.toString().padLeft(2, '0') ?? ''}',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                          DataCell(
                            Text(
                              '\$${_fmt(inv['billed_amount_usd'] ?? inv['total_amount'] ?? inv['amount'])}',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                          DataCell(
                            PosBadge(
                              label: status.toUpperCase(),
                              customColor: isPaid
                                  ? AppColors.success
                                  : isOverdue
                                  ? AppColors.error
                                  : AppColors.warning,
                            ),
                          ),
                          DataCell(Text(_fmtDate(inv['due_date']?.toString() ?? ''), style: AppTypography.bodySmall)),
                          DataCell(
                            isPaid
                                ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                                : PosButton(
                                    label: l10n.markPaid,
                                    onPressed: () => ref
                                        .read(wameedAIAdminActionProvider.notifier)
                                        .markInvoicePaid(inv['id']?.toString() ?? '', {}),
                                    size: PosButtonSize.sm,
                                    variant: PosButtonVariant.primary,
                                  ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  // ── STORES TAB ──
  Widget _storesTab(AppLocalizations l10n) {
    final state = ref.watch(wameedAIAdminBillingStoresProvider);
    return switch (state) {
      WameedAIAdminListLoading() => const Center(child: PosLoading()),
      WameedAIAdminListLoaded(data: final resp) => _buildStores(resp, l10n),
      WameedAIAdminListError(message: final msg) => PosErrorState(
        message: msg,
        onRetry: () => ref.read(wameedAIAdminBillingStoresProvider.notifier).load(),
      ),
      _ => Center(child: Text(l10n.loading)),
    };
  }

  Widget _buildStores(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final stores =
        (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? (data['stores'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return stores.isEmpty
        ? PosEmptyState(title: l10n.noStoresFound, subtitle: l10n.adminWameedAINoStoresMessage, icon: Icons.store_rounded)
        : ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: stores.length,
            itemBuilder: (_, i) {
              final store = stores[i];
              final name = store['store_name'] ?? store['name'] ?? 'Store #${store['store_id'] ?? store['id']}';
              final aiEnabled = store['is_ai_enabled'] == true || store['ai_enabled'] == true || store['is_active'] == true;
              final totalUsage = store['total_cost_usd'] ?? store['usage_amount'] ?? 0;
              final requestCount = store['request_count'] ?? store['total_requests'] ?? 0;

              return PosCard(
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (aiEnabled ? AppColors.success : AppColors.textMutedLight).withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Icon(Icons.store_rounded, color: aiEnabled ? AppColors.success : AppColors.textMutedLight),
                  ),
                  title: Text(name.toString(), style: AppTypography.titleSmall),
                  subtitle: Text(
                    '$requestCount ${l10n.requests} • \$${_fmt(totalUsage)}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
                  ),
                  trailing: Switch(
                    value: aiEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (v) => ref
                        .read(wameedAIAdminActionProvider.notifier)
                        .toggleStoreAI(store['store_id']?.toString() ?? store['id']?.toString() ?? ''),
                  ),
                ),
              );
            },
          );
  }

  String _fmt(dynamic v) => (v as num?)?.toDouble().toStringAsFixed(2) ?? '0.00';
  String _fmtDate(String v) => v.length >= 10 ? v.substring(0, 10) : v;
}
