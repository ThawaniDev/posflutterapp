import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAIDashboardPage extends ConsumerStatefulWidget {
  const AdminWameedAIDashboardPage({super.key});

  @override
  ConsumerState<AdminWameedAIDashboardPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIDashboardPage> {
  String? _from;
  String? _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month - 1, now.day).toIso8601String().substring(0, 10);
    _to = now.toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() {
    ref
        .read(wameedAIAdminDashboardProvider.notifier)
        .load(params: {if (_from != null) 'from': _from!, if (_to != null) 'to': _to!});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wameedAIAdminDashboardProvider);

    return PosListPage(
  title: l10n.adminWameedAIDashboard,
  showSearch: false,
    child: switch (state) {
        WameedAIAdminDashboardLoading() => const Center(child: PosLoading()),
        WameedAIAdminDashboardLoaded(data: final resp) => _buildContent(resp, l10n),
        WameedAIAdminDashboardError(message: final msg) => PosErrorState(message: msg, onRetry: _load),
        _ => Center(child: Text(l10n.loading)),
      },
);
  }

  Widget _buildContent(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final kpis = data['kpis'] as Map<String, dynamic>? ?? {};
    final costByModel = (data['cost_by_model'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final usageByFeature = (data['usage_by_feature'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final usageByStore = (data['usage_by_store'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final topUsers = (data['top_users'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // dailyTrend and chatStats available in resp['data'] if needed

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateFilters(l10n),
            const SizedBox(height: AppSpacing.lg),
            _buildKpiGrid(kpis, l10n),
            const SizedBox(height: AppSpacing.xl),
            _buildNavigationGrid(l10n),
            if (costByModel.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              _sectionTitle(l10n.adminWameedAICostByModel),
              const SizedBox(height: AppSpacing.sm),
              _buildCostByModelTable(costByModel, l10n),
            ],
            if (usageByFeature.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              _sectionTitle(l10n.adminWameedAIUsageByFeature),
              const SizedBox(height: AppSpacing.sm),
              _buildUsageByFeatureTable(usageByFeature, l10n),
            ],
            if (usageByStore.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              _sectionTitle(l10n.adminWameedAIUsageByStore),
              const SizedBox(height: AppSpacing.sm),
              _buildUsageByStoreTable(usageByStore, l10n),
            ],
            if (topUsers.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              _sectionTitle(l10n.adminWameedAITopUsers),
              const SizedBox(height: AppSpacing.sm),
              _buildTopUsersTable(topUsers, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilters(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: PosTextField(label: l10n.from, hint: _from ?? 'YYYY-MM-DD', onChanged: (v) => _from = v),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PosTextField(label: l10n.to, hint: _to ?? 'YYYY-MM-DD', onChanged: (v) => _to = v),
        ),
        const SizedBox(width: AppSpacing.md),
        PosButton(label: l10n.apply, onPressed: _load, size: PosButtonSize.sm),
      ],
    );
  }

  Widget _buildKpiGrid(Map<String, dynamic> kpis, AppLocalizations l10n) {
    final totalReqs = kpis['total_requests'] ?? 0;
    final successReqs = kpis['successful_requests'] ?? 0;
    final failedReqs = kpis['failed_requests'] ?? 0;
    final cachedReqs = kpis['cached_requests'] ?? 0;
    final totalTokens = kpis['total_tokens'] ?? 0;
    final totalCost = kpis['total_cost_usd'] ?? 0;
    final avgLatency = kpis['avg_latency_ms'] ?? 0;
    final uniqueStores = kpis['unique_stores'] ?? 0;

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.0,
      children: [
        PosKpiCard(
          label: l10n.adminWameedAITotalRequests,
          value: _fmtInt(totalReqs),
          subtitle: '${_fmtInt(successReqs)} ${l10n.successful}',
          icon: Icons.api_rounded,
          iconColor: AppColors.primary,
        ),
        PosKpiCard(
          label: l10n.adminWameedAISuccessRate,
          value: totalReqs > 0 ? '${((successReqs / totalReqs) * 100).toStringAsFixed(1)}%' : '0%',
          subtitle: '${_fmtInt(failedReqs)} ${l10n.errors}',
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
        ),
        PosKpiCard(
          label: l10n.adminWameedAITotalTokens,
          value: _fmtLargeNumber(totalTokens),
          subtitle: '${_fmtInt(cachedReqs)} ${l10n.cached}',
          icon: Icons.token_rounded,
          iconColor: AppColors.info,
        ),
        PosKpiCard(
          label: l10n.adminWameedAITotalCost,
          value: '\$${_fmtCost(totalCost)}',
          subtitle: '${l10n.adminWameedAIAvgLatency}: ${_fmtInt(avgLatency)}ms',
          icon: Icons.attach_money_rounded,
          iconColor: AppColors.warning,
        ),
        PosKpiCard(
          label: l10n.adminWameedAIActiveStores,
          value: _fmtInt(uniqueStores),
          subtitle: l10n.adminWameedAIUniqueStoresUsing,
          icon: Icons.store_rounded,
          iconColor: const Color(0xFF6366F1),
        ),
        PosKpiCard(
          label: l10n.adminWameedAITotalChats,
          value: _fmtInt(kpis['total_chats'] ?? 0),
          subtitle: '${_fmtInt(kpis['total_chat_messages'] ?? 0)} ${l10n.messages}',
          icon: Icons.chat_rounded,
          iconColor: const Color(0xFF10B981),
        ),
        PosKpiCard(
          label: l10n.adminWameedAIUniqueUsers,
          value: _fmtInt(kpis['unique_users'] ?? 0),
          subtitle: l10n.adminWameedAIActiveUsers,
          icon: Icons.people_rounded,
          iconColor: const Color(0xFFF59E0B),
        ),
        PosKpiCard(
          label: l10n.adminWameedAIAvgLatency,
          value: '${_fmtInt(avgLatency)}ms',
          subtitle: l10n.adminWameedAIResponseTime,
          icon: Icons.speed_rounded,
          iconColor: const Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildNavigationGrid(AppLocalizations l10n) {
    final items = [
      _NavItem(l10n.adminWameedAIUsageLogs, Icons.list_alt_rounded, Routes.adminWameedAIUsageLogs),
      _NavItem(l10n.adminWameedAIProviders, Icons.cloud_rounded, Routes.adminWameedAIProviders),
      _NavItem(l10n.adminWameedAIFeatures, Icons.auto_awesome_rounded, Routes.adminWameedAIFeatures),
      _NavItem(l10n.adminWameedAILlmModels, Icons.psychology_rounded, Routes.adminWameedAILlmModels),
      _NavItem(l10n.adminWameedAIChats, Icons.chat_bubble_rounded, Routes.adminWameedAIChats),
      _NavItem(l10n.adminWameedAIBilling, Icons.receipt_long_rounded, Routes.adminWameedAIBilling),
    ];

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 6 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.3,
      children: items
          .map(
            (item) => PosCard(
              onTap: () => context.go(item.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 32, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(item.label, textAlign: TextAlign.center, style: AppTypography.labelMedium),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildCostByModelTable(List<Map<String, dynamic>> items, AppLocalizations l10n) {
    return PosCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.model)),
            DataColumn(label: Text(l10n.requests), numeric: true),
            DataColumn(label: Text(l10n.tokens), numeric: true),
            DataColumn(label: Text(l10n.cost), numeric: true),
            DataColumn(label: Text(l10n.adminWameedAIAvgLatency), numeric: true),
          ],
          rows: items
              .map(
                (m) => DataRow(
                  cells: [
                    DataCell(Text(m['model_used']?.toString() ?? '')),
                    DataCell(Text(_fmtInt(m['request_count']))),
                    DataCell(Text(_fmtLargeNumber(m['total_tokens']))),
                    DataCell(Text('\$${_fmtCost(m['total_cost'])}')),
                    DataCell(Text('${_fmtInt(m['avg_latency'])}ms')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildUsageByFeatureTable(List<Map<String, dynamic>> items, AppLocalizations l10n) {
    return PosCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.feature)),
            DataColumn(label: Text(l10n.requests), numeric: true),
            DataColumn(label: Text(l10n.successful), numeric: true),
            DataColumn(label: Text(l10n.errors), numeric: true),
            DataColumn(label: Text(l10n.tokens), numeric: true),
            DataColumn(label: Text(l10n.cost), numeric: true),
          ],
          rows: items
              .map(
                (f) => DataRow(
                  cells: [
                    DataCell(Text(f['feature_slug']?.toString() ?? '')),
                    DataCell(Text(_fmtInt(f['request_count']))),
                    DataCell(Text(_fmtInt(f['success_count']))),
                    DataCell(Text(_fmtInt(f['error_count']))),
                    DataCell(Text(_fmtLargeNumber(f['total_tokens']))),
                    DataCell(Text('\$${_fmtCost(f['total_cost'])}')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildUsageByStoreTable(List<Map<String, dynamic>> items, AppLocalizations l10n) {
    return PosCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.store)),
            DataColumn(label: Text(l10n.requests), numeric: true),
            DataColumn(label: Text(l10n.tokens), numeric: true),
            DataColumn(label: Text(l10n.cost), numeric: true),
            DataColumn(label: Text(l10n.users), numeric: true),
          ],
          rows: items
              .map(
                (s) => DataRow(
                  cells: [
                    DataCell(Text(s['store_name']?.toString() ?? s['store_id']?.toString() ?? '')),
                    DataCell(Text(_fmtInt(s['request_count']))),
                    DataCell(Text(_fmtLargeNumber(s['total_tokens']))),
                    DataCell(Text('\$${_fmtCost(s['total_cost'])}')),
                    DataCell(Text(_fmtInt(s['unique_users']))),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTopUsersTable(List<Map<String, dynamic>> items, AppLocalizations l10n) {
    return PosCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.user)),
            DataColumn(label: Text(l10n.adminWameedAIChats), numeric: true),
            DataColumn(label: Text(l10n.messages), numeric: true),
            DataColumn(label: Text(l10n.tokens), numeric: true),
            DataColumn(label: Text(l10n.cost), numeric: true),
          ],
          rows: items
              .map(
                (u) => DataRow(
                  cells: [
                    DataCell(Text(u['user_name']?.toString() ?? '')),
                    DataCell(Text(_fmtInt(u['chat_count']))),
                    DataCell(Text(_fmtInt(u['total_messages']))),
                    DataCell(Text(_fmtLargeNumber(u['total_tokens']))),
                    DataCell(Text('\$${_fmtCost(u['total_cost'])}')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  String _fmtInt(dynamic v) => ((v as num?)?.toInt() ?? 0).toString();
  String _fmtCost(dynamic v) => ((v as num?)?.toDouble() ?? 0).toStringAsFixed(4);
  String _fmtLargeNumber(dynamic v) {
    final n = (v as num?)?.toInt() ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem(this.label, this.icon, this.route);
}
