import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminFinOpsExpenseListPage extends ConsumerStatefulWidget {
  const AdminFinOpsExpenseListPage({super.key});

  @override
  ConsumerState<AdminFinOpsExpenseListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsExpenseListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilter();
      ref.read(finOpsStatsProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilter();
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) params['category'] = _categoryFilter;
    ref.read(finOpsExpensesProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsExpensesProvider);

    return PosListPage(
  title: l10n.expenses,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: finOpsStatsProvider,
            cardBuilder: (data) {
              final e = data['expenses'] as Map<String, dynamic>? ?? {};
              final p = data['payments'] as Map<String, dynamic>? ?? {};
              return [
                kpi('Total Expenses', e['total'] ?? 0, AppColors.primary),
                kpi('Total Amount', e['total_amount'] ?? 0, AppColors.error),
                kpi('Total Payments', p['total'] ?? 0, AppColors.success),
                kpi('Payment Amount', p['total_amount'] ?? 0, AppColors.info),
              ];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'supplies', label: l10n.adminExpenseSupplies),
                PosDropdownItem(value: 'food', label: l10n.adminExpenseFood),
                PosDropdownItem(value: 'transport', label: l10n.adminExpenseTransport),
                PosDropdownItem(value: 'maintenance', label: l10n.maintenance),
                PosDropdownItem(value: 'utility', label: l10n.adminExpenseUtility),
                PosDropdownItem(value: 'other', label: l10n.acquirerOther),
              ],
              selectedValue: _categoryFilter,
              onChanged: (v) {
                setState(() => _categoryFilter = v);
                _applyFilter();
              },
              label: l10n.category,
              hint: l10n.adminAllCategories,
              showSearch: false,
              clearable: true,
            ),
          ),
          Expanded(
            child: switch (state) {
              FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
              FinOpsListLoaded(data: final resp) => _buildList(resp),
              FinOpsListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => Center(child: Text(l10n.adminLoadingExpenses)),
            },
          ),
        ],
      ),
);
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.adminNoExpensesFound));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final category = (item['category'] ?? '').toString();
          final amount = num.tryParse(item['amount']?.toString() ?? '') ?? 0;
          return PosCard(
            borderRadius: BorderRadius.circular(10,),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.error.withValues(alpha: 0.15),
                child: const Icon(Icons.receipt_long, color: AppColors.error, size: 20),
              ),
              title: Text('\u0081. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(category[0].toUpperCase() + category.substring(1), style: const TextStyle(fontSize: 12)),
              trailing: Text(
                item['expense_date']?.toString() ?? item['created_at']?.toString().substring(0, 10) ?? '',
                style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
              ),
            ),
          );
        },
      ),
    );
  }
}
