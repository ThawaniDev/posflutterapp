import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';
import 'package:wameedpos/features/support/widgets/ticket_card_widget.dart';

class SupportDashboardPage extends ConsumerStatefulWidget {
  const SupportDashboardPage({super.key});

  @override
  ConsumerState<SupportDashboardPage> createState() => _SupportDashboardPageState();
}

class _SupportDashboardPageState extends ConsumerState<SupportDashboardPage> {
  String? _statusFilter;
  String? _categoryFilter;
  String? _priorityFilter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(supportStatsProvider.notifier).load();
      ref.read(ticketListProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter(String? status) {
    setState(() => _statusFilter = status);
    ref
        .read(ticketListProvider.notifier)
        .load(
          status: status,
          category: _categoryFilter,
          priority: _priorityFilter,
          search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
        );
  }

  void _applyCategory(String? category) {
    setState(() => _categoryFilter = category);
    ref
        .read(ticketListProvider.notifier)
        .load(
          status: _statusFilter,
          category: category,
          priority: _priorityFilter,
          search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
        );
  }

  void _applyPriority(String? priority) {
    setState(() => _priorityFilter = priority);
    ref
        .read(ticketListProvider.notifier)
        .load(
          status: _statusFilter,
          category: _categoryFilter,
          priority: priority,
          search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
        );
  }

  void _onSearch(String query) {
    ref
        .read(ticketListProvider.notifier)
        .load(
          status: _statusFilter,
          category: _categoryFilter,
          priority: _priorityFilter,
          search: query.trim().isNotEmpty ? query.trim() : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(supportStatsProvider);
    final listState = ref.watch(ticketListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
      title: l10n.support,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.menu_book_rounded,
          onPressed: () => context.push('/support/kb'),
          tooltip: l10n.supportKnowledgeBase,
        ),
        PosButton.icon(
          icon: Icons.refresh_rounded,
          onPressed: () {
            ref.read(supportStatsProvider.notifier).load();
            ref
                .read(ticketListProvider.notifier)
                .load(
                  status: _statusFilter,
                  category: _categoryFilter,
                  priority: _priorityFilter,
                  search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
                );
          },
          tooltip: l10n.supportRefresh,
        ),
        PosButton(
          label: l10n.supportNewTicket,
          icon: Icons.add,
          size: PosButtonSize.sm,
          onPressed: () => context.push('/support/create'),
        ),
      ],
      child: Column(
        children: [
          // Stats KPI cards
          _buildStatsSection(statsState, l10n, isDark),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PosSearchField(
              controller: _searchController,
              hint: l10n.supportSearchTickets,
              onChanged: _onSearch,
              onClear: () => _onSearch(''),
            ),
          ),
          // Status + Category + Priority filter pills
          _buildFilterPills(l10n),
          const Divider(height: 1),
          // Ticket list
          Expanded(child: _buildTicketList(listState, l10n)),
          // Pagination bar
          if (listState is TicketListLoaded) _buildPaginationBar(listState, isDark),
        ],
      ),
    );
  }

  Widget _buildStatsSection(SupportStatsState state, AppLocalizations l10n, bool isDark) {
    return switch (state) {
      SupportStatsInitial() || SupportStatsLoading() => const Padding(
        padding: AppSpacing.paddingAll16,
        child: Center(child: PosLoadingSkeleton(height: 100)),
      ),
      SupportStatsError(:final message) => Padding(
        padding: AppSpacing.paddingAll16,
        child: PosErrorState(message: message, onRetry: () => ref.read(supportStatsProvider.notifier).load()),
      ),
      SupportStatsLoaded(:final total, :final open, :final inProgress, :final resolved) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: context.isPhone
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PosKpiCard(
                          label: l10n.supportTotal,
                          value: '$total',
                          icon: Icons.confirmation_number_rounded,
                          iconColor: AppColors.info,
                          iconBgColor: AppColors.info.withValues(alpha: 0.1),
                        ),
                      ),
                      AppSpacing.gapW8,
                      Expanded(
                        child: PosKpiCard(
                          label: l10n.supportOpen,
                          value: '$open',
                          icon: Icons.inbox_rounded,
                          iconColor: AppColors.warning,
                          iconBgColor: AppColors.warning.withValues(alpha: 0.1),
                          onTap: () => _applyFilter('open'),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapH8,
                  Row(
                    children: [
                      Expanded(
                        child: PosKpiCard(
                          label: l10n.supportInProgress,
                          value: '$inProgress',
                          icon: Icons.autorenew_rounded,
                          iconColor: AppColors.primary,
                          iconBgColor: AppColors.primary10,
                          onTap: () => _applyFilter('in_progress'),
                        ),
                      ),
                      AppSpacing.gapW8,
                      Expanded(
                        child: PosKpiCard(
                          label: l10n.supportResolved,
                          value: '$resolved',
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: AppColors.success,
                          iconBgColor: AppColors.success.withValues(alpha: 0.1),
                          onTap: () => _applyFilter('resolved'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: PosKpiCard(
                      label: l10n.supportTotal,
                      value: '$total',
                      icon: Icons.confirmation_number_rounded,
                      iconColor: AppColors.info,
                      iconBgColor: AppColors.info.withValues(alpha: 0.1),
                    ),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: PosKpiCard(
                      label: l10n.supportOpen,
                      value: '$open',
                      icon: Icons.inbox_rounded,
                      iconColor: AppColors.warning,
                      iconBgColor: AppColors.warning.withValues(alpha: 0.1),
                      onTap: () => _applyFilter('open'),
                    ),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: PosKpiCard(
                      label: l10n.supportInProgress,
                      value: '$inProgress',
                      icon: Icons.autorenew_rounded,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primary10,
                      onTap: () => _applyFilter('in_progress'),
                    ),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: PosKpiCard(
                      label: l10n.supportResolved,
                      value: '$resolved',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.success,
                      iconBgColor: AppColors.success.withValues(alpha: 0.1),
                      onTap: () => _applyFilter('resolved'),
                    ),
                  ),
                ],
              ),
      ),
    };
  }

  Widget _buildFilterPills(AppLocalizations l10n) {
    final statusFilters = <String, String>{
      'open': l10n.supportOpen,
      'in_progress': l10n.supportInProgress,
      'resolved': l10n.supportResolved,
      'closed': l10n.supportClosed,
    };

    final categoryFilters = <String, String>{
      'billing': l10n.supportCategoryBilling,
      'technical': l10n.supportCategoryTechnical,
      'zatca': l10n.supportCategoryZatca,
      'feature_request': l10n.supportCategoryFeatureRequest,
      'general': l10n.supportKbGeneral,
      'hardware': l10n.supportCategoryHardware,
    };

    final priorityFilters = <String, String>{
      'low': l10n.supportPriorityLow,
      'medium': l10n.supportPriorityMedium,
      'high': l10n.supportPriorityHigh,
      'critical': l10n.supportCriticalPriority,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status row
        _FilterRow(
          label: null,
          options: statusFilters,
          selected: _statusFilter,
          allLabel: l10n.supportAll,
          onSelect: _applyFilter,
        ),
        // Category row
        _FilterRow(
          label: l10n.supportFilterCategory,
          options: categoryFilters,
          selected: _categoryFilter,
          allLabel: l10n.supportAll,
          onSelect: _applyCategory,
        ),
        // Priority row
        _FilterRow(
          label: l10n.supportFilterPriority,
          options: priorityFilters,
          selected: _priorityFilter,
          allLabel: l10n.supportAll,
          onSelect: _applyPriority,
        ),
      ],
    );
  }

  Widget _buildTicketList(TicketListState state, AppLocalizations l10n) {
    return switch (state) {
      TicketListInitial() || TicketListLoading() => PosLoadingSkeleton.list(),
      TicketListError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(ticketListProvider.notifier).load(status: _statusFilter),
      ),
      TicketListLoaded(:final tickets) =>
        tickets.isEmpty
            ? PosEmptyState(
                title: l10n.supportNoTickets,
                subtitle: l10n.supportTapToCreate,
                icon: Icons.support_agent_rounded,
                actionLabel: l10n.supportNewTicket,
                onAction: () => context.push('/support/create'),
              )
            : RefreshIndicator(
                onRefresh: () => ref
                    .read(ticketListProvider.notifier)
                    .load(
                      status: _statusFilter,
                      category: _categoryFilter,
                      priority: _priorityFilter,
                      search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
                    ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) => TicketCardWidget(
                    ticket: tickets[index],
                    onTap: () => context.push('/support/tickets/${tickets[index].id}'),
                  ),
                ),
              ),
    };
  }

  Widget _buildPaginationBar(TicketListLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${state.total} ${AppLocalizations.of(context)!.supportTicketsCount}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
          ),
          Row(
            children: [
              PosButton(
                label: AppLocalizations.of(context)!.supportPrevious,
                variant: PosButtonVariant.outline,
                size: PosButtonSize.sm,
                icon: Icons.chevron_left_rounded,
                onPressed: state.currentPage > 1 ? () => ref.read(ticketListProvider.notifier).previousPage() : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${state.currentPage} / ${state.lastPage}', style: AppTypography.labelMedium),
              ),
              PosButton(
                label: AppLocalizations.of(context)!.supportNext,
                variant: PosButtonVariant.outline,
                size: PosButtonSize.sm,
                trailingIcon: Icons.chevron_right_rounded,
                onPressed: state.hasMore ? () => ref.read(ticketListProvider.notifier).nextPage() : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Filter Row Widget ────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.options, required this.selected, required this.allLabel, required this.onSelect, this.label});

  final String? label;
  final Map<String, String> options;
  final String? selected;
  final String allLabel;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          if (label != null) ...[
            Text('$label:', style: AppTypography.labelSmall.copyWith(color: AppColors.mutedFor(context))),
            AppSpacing.gapW8,
          ],
          PosButton.pill(label: allLabel, isSelected: selected == null, onPressed: () => onSelect(null)),
          AppSpacing.gapW8,
          ...options.entries.map(
            (e) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: PosButton.pill(
                label: e.value,
                isSelected: selected == e.key,
                onPressed: () => onSelect(selected == e.key ? null : e.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
