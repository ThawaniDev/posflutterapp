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

class AdminFinOpsCashSessionListPage extends ConsumerStatefulWidget {
  const AdminFinOpsCashSessionListPage({super.key});

  @override
  ConsumerState<AdminFinOpsCashSessionListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsCashSessionListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _statusFilter;

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
    if (_statusFilter != null && _statusFilter!.isNotEmpty) params['status'] = _statusFilter;
    ref.read(finOpsCashSessionsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsCashSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminFinOpsCashSessions), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: finOpsStatsProvider,
            cardBuilder: (data) {
              final cs = data['cash_sessions'] as Map<String, dynamic>? ?? {};
              final exp = data['expenses'] as Map<String, dynamic>? ?? {};
              return [
                kpi('Total Sessions', cs['total'] ?? 0, AppColors.primary),
                kpi('Open', cs['open'] ?? 0, AppColors.warning),
                kpi('Closed', (cs['total'] ?? 0) - (cs['open'] ?? 0), AppColors.success),
                kpi('Expenses', exp['total'] ?? 0, AppColors.info),
              ];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'open', label: l10n.open),
                PosDropdownItem(value: 'closed', label: l10n.posClosed),
              ],
              selectedValue: _statusFilter,
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _applyFilter();
              },
              label: l10n.status,
              hint: 'All Statuses',
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
              _ => const Center(child: Text('Loading cash sessions...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return Center(child: Text(l10n.noCashSessionsFound));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final status = (item['status'] ?? '').toString();
          final variance = num.tryParse(item['variance']?.toString() ?? '') ?? 0;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: status == 'open'
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.textMutedLight.withValues(alpha: 0.15),
                child: Icon(
                  Icons.point_of_sale,
                  color: status == 'open' ? AppColors.success : AppColors.textMutedLight,
                  size: 20,
                ),
              ),
              title: Text(
                'Session #${(item['id'] ?? '').toString().substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Float: \u0081. ${_fmt(item['opening_float'])}', style: const TextStyle(fontSize: 12)),
                  if (variance != 0)
                    Text(
                      'Variance: \u0081. ${variance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: variance < 0 ? AppColors.error : AppColors.success),
                    ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (status == 'open' ? AppColors.success : AppColors.textMutedLight).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: status == 'open' ? AppColors.success : AppColors.textMutedLight,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmt(dynamic v) {
    if (v == null) return '0.00';
    final n = v is num ? v : num.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(2);
  }
}
