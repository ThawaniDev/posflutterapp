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

class AdminFinOpsThawaniSettlementListPage extends ConsumerStatefulWidget {
  const AdminFinOpsThawaniSettlementListPage({super.key});

  @override
  ConsumerState<AdminFinOpsThawaniSettlementListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsThawaniSettlementListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
      ref.read(finOpsStatsProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(finOpsThawaniSettlementsProvider.notifier).load(params: params);
    ref.read(finOpsThawaniOrdersProvider.notifier).load(params: params);
    ref.read(finOpsThawaniStoreConfigsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    return PosListPage(
      title: l10n.thawaniIntegration,
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.thawaniSettlements),
              PosTabItem(label: l10n.orders),
              PosTabItem(label: l10n.adminConfigs),
            ],
          ),
          AdminStatsKpiSection(
            provider: finOpsStatsProvider,
            cardBuilder: (data) {
              final t = data['thawani_settlements'] as Map<String, dynamic>? ?? {};
              final ae = data['accounting_exports'] as Map<String, dynamic>? ?? {};
              return [
                kpi('Settlements', t['total'] ?? 0, AppColors.primary),
                kpi('Gross Amount', t['total_gross'] ?? 0, AppColors.success),
                kpi('Net Amount', t['total_net'] ?? 0, AppColors.info),
                kpi('Exports', ae['total'] ?? 0, AppColors.warning, '${ae['pending'] ?? 0} pending'),
              ];
            },
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: [_SettlementsTab(), _OrdersTab(), _StoreConfigsTab()]),
          ),
        ],
      ),
    );
  }
}

class _SettlementsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsThawaniSettlementsProvider);
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
    if (items.isEmpty) return Center(child: Text(l10n.noSettlements));
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final amount = num.tryParse(item['total_amount']?.toString() ?? '') ?? 0;
          final status = (item['status'] ?? '').toString();
          return PosCard(
            borderRadius: BorderRadius.circular(10,),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
                child: const Icon(Icons.account_balance, color: Color(0xFF059669), size: 20),
              ),
              title: Text('\u0081. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Date: ${item['settlement_date'] ?? item['created_at'] ?? ''}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: _statusChip(status),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      'settled' || 'completed' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.error,
      _ => AppColors.textMutedLight,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _OrdersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsThawaniOrdersProvider);
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
    if (items.isEmpty) return Center(child: Text(l10n.adminNoThawaniOrders));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final amount = num.tryParse(item['amount']?.toString() ?? '') ?? 0;
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.1),
              child: const Icon(Icons.receipt_long, color: Color(0xFF2563EB), size: 20),
            ),
            title: Text('\u0081. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Ref: ${item['thawani_reference'] ?? item['reference_id'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              item['status']?.toString().toUpperCase() ?? '',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

class _StoreConfigsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsThawaniStoreConfigsProvider);
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
    if (items.isEmpty) return Center(child: Text(l10n.adminNoStoreConfigs));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        return PosCard(
          borderRadius: BorderRadius.circular(10,),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              child: const Icon(Icons.store, color: Color(0xFFF59E0B), size: 20),
            ),
            title: Text(
              item['store_name']?.toString() ?? 'Store #${item['store_id'] ?? item['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Key: ${item['api_key'] != null ? '****${item['api_key'].toString().substring(item['api_key'].toString().length > 4 ? item['api_key'].toString().length - 4 : 0)}' : 'Not set'}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Icon(
              item['is_active'] == true ? Icons.check_circle : Icons.cancel,
              color: item['is_active'] == true ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
