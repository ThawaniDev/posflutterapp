import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AdminSupportTicketListPage extends ConsumerStatefulWidget {
  const AdminSupportTicketListPage({super.key});

  @override
  ConsumerState<AdminSupportTicketListPage> createState() => _AdminSupportTicketListPageState();
}

class _AdminSupportTicketListPageState extends ConsumerState<AdminSupportTicketListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _statusFilter;
  String? _priorityFilter;
  String? _categoryFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
      ref.read(supportStatsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_statusFilter != null) params['status'] = _statusFilter;
    if (_priorityFilter != null) params['priority'] = _priorityFilter;
    if (_categoryFilter != null) params['category'] = _categoryFilter;
    ref.read(ticketListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _statusColor(String status) => switch (status) {
    'open' => AppColors.info,
    'in_progress' => AppColors.warning,
    'resolved' => AppColors.success,
    'closed' => AppColors.textSecondary,
    _ => AppColors.textSecondary,
  };

  Color _priorityColor(String priority) => switch (priority) {
    'low' => AppColors.textSecondary,
    'medium' => AppColors.info,
    'high' => AppColors.warning,
    'critical' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  IconData _priorityIcon(String priority) => switch (priority) {
    'critical' => Icons.error,
    'high' => Icons.arrow_upward,
    'medium' => Icons.remove,
    'low' => Icons.arrow_downward,
    _ => Icons.remove,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ticketListProvider);

    return PosListPage(
      title: l10n.adminSupportTickets,
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: supportStatsProvider,
            cardBuilder: (data) => [
              kpi('Total Tickets', data['total'] ?? 0, AppColors.primary),
              kpi('Open', data['open'] ?? 0, AppColors.info),
              kpi('In Progress', data['in_progress'] ?? 0, AppColors.warning),
              kpi('SLA Breached', data['sla_breached'] ?? 0, AppColors.error),
              kpi('Unresolved', data['unresolved'] ?? 0, const Color(0xFFF59E0B)),
              kpi('Resolved Today', data['resolved_today'] ?? 0, AppColors.success),
            ],
          ),
          // ── Filters ──
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.supportSearchTickets,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Builder(
                  builder: (context) {
                    final statusDropdown = PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'open', label: l10n.open),
                        PosDropdownItem(value: 'in_progress', label: l10n.statusInProgress),
                        PosDropdownItem(value: 'resolved', label: l10n.resolved),
                        PosDropdownItem(value: 'closed', label: l10n.posClosed),
                      ],
                      selectedValue: _statusFilter,
                      onChanged: (v) {
                        setState(() => _statusFilter = v);
                        _applyFilters();
                      },
                      label: l10n.status,
                      hint: 'All',
                      showSearch: false,
                      clearable: true,
                    );
                    final priorityDropdown = PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'low', label: l10n.notifPriorityLow),
                        PosDropdownItem(value: 'medium', label: l10n.supportPriorityMedium),
                        PosDropdownItem(value: 'high', label: l10n.notifPriorityHigh),
                        PosDropdownItem(value: 'critical', label: l10n.supportPriorityCritical),
                      ],
                      selectedValue: _priorityFilter,
                      onChanged: (v) {
                        setState(() => _priorityFilter = v);
                        _applyFilters();
                      },
                      label: l10n.supportPriority,
                      hint: 'All',
                      showSearch: false,
                      clearable: true,
                    );
                    final categoryDropdown = PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'billing', label: l10n.supportKbBilling),
                        PosDropdownItem(value: 'technical', label: l10n.supportCategoryTechnical),
                        PosDropdownItem(value: 'zatca', label: l10n.sidebarZatca),
                        PosDropdownItem(value: 'feature_request', label: l10n.feature),
                        PosDropdownItem(value: 'general', label: l10n.settingsGeneral),
                      ],
                      selectedValue: _categoryFilter,
                      onChanged: (v) {
                        setState(() => _categoryFilter = v);
                        _applyFilters();
                      },
                      label: l10n.category,
                      hint: 'All',
                      showSearch: false,
                      clearable: true,
                    );
                    return ResponsiveRowWrap(children: [statusDropdown, priorityDropdown, categoryDropdown]);
                  },
                ),
              ],
            ),
          ),
          // ── List ──
          Expanded(
            child: switch (state) {
              TicketListLoading() => const Center(child: CircularProgressIndicator()),
              TicketListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: AppColors.error)),
              ),
              TicketListLoaded(:final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final tickets = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        final status = t['status']?.toString() ?? '';
        final priority = t['priority']?.toString() ?? '';
        return PosCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(_priorityIcon(priority), color: _priorityColor(priority)),
            title: Text(t['subject']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${t['ticket_number'] ?? ''} • ${t['category'] ?? ''}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
              child: Text(
                status.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
