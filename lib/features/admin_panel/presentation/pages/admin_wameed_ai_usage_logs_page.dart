import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAIUsageLogsPage extends ConsumerStatefulWidget {
  const AdminWameedAIUsageLogsPage({super.key});

  @override
  ConsumerState<AdminWameedAIUsageLogsPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIUsageLogsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _from;
  String? _to;
  String? _feature;
  String? _model;
  String? _status;
  String? _search;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month - 1, now.day).toIso8601String().substring(0, 10);
    _to = now.toIso8601String().substring(0, 10);
    Future.microtask(() {
      _loadStats();
      _loadLogs();
    });
  }

  Map<String, dynamic> get _filterParams => {
    if (_from != null && _from!.isNotEmpty) 'from': _from!,
    if (_to != null && _to!.isNotEmpty) 'to': _to!,
    if (_feature != null && _feature!.isNotEmpty) 'feature': _feature!,
    if (_model != null && _model!.isNotEmpty) 'model': _model!,
    if (_status != null && _status!.isNotEmpty) 'status': _status!,
    if (_search != null && _search!.isNotEmpty) 'search': _search!,
    'page': _page,
    'per_page': 25,
  };

  void _loadStats() {
    ref
        .read(wameedAIAdminLogStatsProvider.notifier)
        .load(params: {if (_from != null && _from!.isNotEmpty) 'from': _from!, if (_to != null && _to!.isNotEmpty) 'to': _to!});
  }

  void _loadLogs() {
    ref.read(wameedAIAdminLogsProvider.notifier).load(params: _filterParams);
  }

  void _applyFilters() {
    _page = 1;
    _loadStats();
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statsState = ref.watch(wameedAIAdminLogStatsProvider);
    final logsState = ref.watch(wameedAIAdminLogsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminWameedAIUsageLogs), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          // ── Stats Cards ──
          if (statsState is WameedAIAdminDashboardLoaded) _buildStatsCards(statsState.data, l10n),
          // ── Filters ──
          _buildFilters(l10n),
          const Divider(height: 1),
          // ── Logs Table ──
          Expanded(
            child: switch (logsState) {
              WameedAIAdminListLoading() => const Center(child: PosLoading()),
              WameedAIAdminListLoaded(data: final resp) => _buildLogsTable(resp, l10n),
              WameedAIAdminListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadLogs),
              _ => Center(child: Text(l10n.loading)),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 2.2,
        children: [
          PosKpiCard(
            label: l10n.adminWameedAITotalRequests,
            value: '${data['total_requests'] ?? 0}',
            subtitle: '${l10n.adminWameedAISuccessRate}: ${data['success_rate'] ?? 0}%',
            icon: Icons.api_rounded,
            iconColor: AppColors.primary,
          ),
          PosKpiCard(
            label: l10n.adminWameedAISuccessRate,
            value: '${data['success_requests'] ?? 0}',
            subtitle: '${data['error_requests'] ?? 0} ${l10n.errors}',
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.success,
          ),
          PosKpiCard(
            label: l10n.adminWameedAITotalTokens,
            value: _fmtLargeNumber(data['total_tokens']),
            subtitle: '${data['cached_requests'] ?? 0} ${l10n.cached}',
            icon: Icons.token_rounded,
            iconColor: AppColors.info,
          ),
          PosKpiCard(
            label: l10n.adminWameedAITotalCost,
            value: '\$${_fmtCost(data['total_cost_usd'])}',
            subtitle: '${l10n.adminWameedAIAvgLatency}: ${data['avg_latency_ms'] ?? 0}ms',
            icon: Icons.attach_money_rounded,
            iconColor: AppColors.warning,
          ),
          PosKpiCard(
            label: l10n.adminWameedAIActiveStores,
            value: '${data['unique_stores'] ?? 0}',
            subtitle: l10n.adminWameedAIUniqueStoresUsing,
            icon: Icons.store_rounded,
            iconColor: const Color(0xFF6366F1),
          ),
          PosKpiCard(
            label: l10n.adminWameedAICacheHitRate,
            value: '${data['cache_hit_rate'] ?? 0}%',
            subtitle: '${data['cached_requests'] ?? 0} ${l10n.cached}',
            icon: Icons.cached_rounded,
            iconColor: const Color(0xFF10B981),
          ),
          PosKpiCard(
            label: l10n.adminWameedAITopFeature,
            value: _truncate(data['top_feature']?.toString() ?? '-', 20),
            subtitle: '${data['top_feature_count'] ?? 0} ${l10n.requests}',
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF59E0B),
          ),
          PosKpiCard(
            label: l10n.adminWameedAITopModel,
            value: _truncate(data['top_model']?.toString() ?? '-', 22),
            subtitle: '\$${_fmtCost(data['top_model_cost'])} ${l10n.cost}',
            icon: Icons.psychology_rounded,
            iconColor: const Color(0xFFEC4899),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          SizedBox(
            width: 140,
            child: PosTextField(label: l10n.from, hint: _from ?? 'YYYY-MM-DD', onChanged: (v) => _from = v),
          ),
          SizedBox(
            width: 140,
            child: PosTextField(label: l10n.to, hint: _to ?? 'YYYY-MM-DD', onChanged: (v) => _to = v),
          ),
          SizedBox(
            width: 160,
            child: PosTextField(label: l10n.feature, hint: l10n.allFeatures, onChanged: (v) => _feature = v),
          ),
          SizedBox(
            width: 160,
            child: PosTextField(label: l10n.model, hint: l10n.allModels, onChanged: (v) => _model = v),
          ),
          SizedBox(
            width: 120,
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'success', label: l10n.successful),
                PosDropdownItem(value: 'error', label: l10n.error),
                PosDropdownItem(value: 'rate_limited', label: l10n.rateLimited),
              ],
              selectedValue: _status,
              onChanged: (v) => setState(() => _status = v),
              label: l10n.status,
              hint: l10n.allStatuses,
              showSearch: false,
              clearable: true,
            ),
          ),
          SizedBox(
            width: 200,
            child: PosSearchField(hint: l10n.searchLogs, onChanged: (v) => _search = v),
          ),
          PosButton(label: l10n.apply, onPressed: _applyFilters, size: PosButtonSize.sm),
        ],
      ),
    );
  }

  Widget _buildLogsTable(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final total = data['total'] as int? ?? 0;
    final currentPage = data['current_page'] as int? ?? 1;
    final lastPage = data['last_page'] as int? ?? 1;

    if (items.isEmpty) {
      return PosEmptyState(title: l10n.noLogsFound, subtitle: l10n.adjustFilters, icon: Icons.list_alt_rounded);
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: AppSpacing.lg,
                columns: [
                  DataColumn(label: Text(l10n.store)),
                  DataColumn(label: Text(l10n.user)),
                  DataColumn(label: Text(l10n.feature)),
                  DataColumn(label: Text(l10n.model)),
                  DataColumn(label: Text(l10n.status)),
                  DataColumn(label: Text(l10n.tokens), numeric: true),
                  DataColumn(label: Text(l10n.cost), numeric: true),
                  DataColumn(label: Text(l10n.latency), numeric: true),
                  DataColumn(label: Text(l10n.cached)),
                  DataColumn(label: Text(l10n.txColDate)),
                ],
                rows: items.map((log) {
                  final status = log['status']?.toString() ?? '';
                  return DataRow(
                    cells: [
                      DataCell(Text(log['store_name']?.toString() ?? log['store_id']?.toString() ?? '')),
                      DataCell(Text(log['user_name']?.toString() ?? log['user_id']?.toString() ?? '-')),
                      DataCell(Text(log['feature_slug']?.toString() ?? '')),
                      DataCell(Text(_truncate(log['model_used']?.toString() ?? '', 20))),
                      DataCell(
                        PosBadge(
                          label: status,
                          customColor: status == 'success'
                              ? AppColors.success
                              : (status == 'error' ? AppColors.error : AppColors.warning),
                        ),
                      ),
                      DataCell(Text('${log['total_tokens'] ?? 0}')),
                      DataCell(Text('\$${_fmtCost(log['estimated_cost_usd'])}')),
                      DataCell(Text('${log['latency_ms'] ?? 0}ms')),
                      DataCell(
                        Icon(
                          log['response_cached'] == true ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: log['response_cached'] == true ? AppColors.success : AppColors.textMutedLight,
                        ),
                      ),
                      DataCell(Text(_fmtDate(log['created_at']))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // ── Pagination ──
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.showing} ${items.length} ${l10n.of_} $total', style: AppTypography.bodySmall),
              Row(
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () {
                            _page = currentPage - 1;
                            _loadLogs();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('$currentPage / $lastPage', style: AppTypography.bodySmall),
                  IconButton(
                    onPressed: currentPage < lastPage
                        ? () {
                            _page = currentPage + 1;
                            _loadLogs();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _fmtCost(dynamic v) => ((v as num?)?.toDouble() ?? 0).toStringAsFixed(4);
  String _fmtLargeNumber(dynamic v) {
    final n = (v as num?)?.toInt() ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _truncate(String s, int max) => s.length > max ? '${s.substring(0, max)}...' : s;
  String _fmtDate(dynamic v) {
    if (v == null) return '';
    final s = v.toString();
    return s.length >= 16 ? s.substring(0, 16).replaceAll('T', ' ') : s;
  }
}
