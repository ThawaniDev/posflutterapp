import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/support/providers/support_providers.dart';
import 'package:thawani_pos/features/support/providers/support_state.dart';

class SupportDashboardPage extends ConsumerStatefulWidget {
  const SupportDashboardPage({super.key});

  @override
  ConsumerState<SupportDashboardPage> createState() => _SupportDashboardPageState();
}

class _SupportDashboardPageState extends ConsumerState<SupportDashboardPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(supportStatsProvider.notifier).load();
      ref.read(ticketListProvider.notifier).load();
    });
  }

  void _applyFilter(String? status) {
    setState(() => _statusFilter = status);
    ref.read(ticketListProvider.notifier).load(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(supportStatsProvider);
    final listState = ref.watch(ticketListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.support),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(supportStatsProvider.notifier).load();
              ref.read(ticketListProvider.notifier).load(status: _statusFilter);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/support/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.supportNewTicket),
      ),
      body: Column(
        children: [
          // Stats cards
          _buildStatsSection(statsState),
          const Divider(height: 1),
          // Status filter
          _buildFilterChips(),
          const Divider(height: 1),
          // Ticket list
          Expanded(child: _buildTicketList(listState)),
        ],
      ),
    );
  }

  Widget _buildStatsSection(SupportStatsState state) {
    return switch (state) {
      SupportStatsInitial() || SupportStatsLoading() => const Padding(
        padding: AppSpacing.paddingAll16,
        child: Center(child: PosLoadingSkeleton(height: 120)),
      ),
      SupportStatsError(:final message) => Padding(
        padding: AppSpacing.paddingAll16,
        child: Text('Error: $message', style: TextStyle(color: AppColors.error)),
      ),
      SupportStatsLoaded(:final total, :final open, :final inProgress, :final resolved) => Padding(
        padding: AppSpacing.paddingAll12,
        child: Row(
          children: [
            _statCard(AppLocalizations.of(context)!.supportTotal, total, AppColors.info),
            _statCard(AppLocalizations.of(context)!.supportOpen, open, AppColors.warning),
            _statCard(AppLocalizations.of(context)!.supportInProgress, inProgress, AppColors.primary),
            _statCard(AppLocalizations.of(context)!.supportResolved, resolved, AppColors.success),
          ],
        ),
      ),
    };
  }

  Widget _statCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                '$value',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              AppSpacing.gapH4,
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    const statuses = ['open', 'in_progress', 'resolved', 'closed'];
    final labels = {
      'open': AppLocalizations.of(context)!.supportOpen,
      'in_progress': AppLocalizations.of(context)!.supportInProgress,
      'resolved': AppLocalizations.of(context)!.supportResolved,
      'closed': AppLocalizations.of(context)!.supportClosed,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(AppLocalizations.of(context)!.supportAll),
            selected: _statusFilter == null,
            onSelected: (_) => _applyFilter(null),
          ),
          AppSpacing.gapW8,
          ...statuses.map(
            (s) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(label: Text(labels[s] ?? s), selected: _statusFilter == s, onSelected: (_) => _applyFilter(s)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList(TicketListState state) {
    return switch (state) {
      TicketListInitial() || TicketListLoading() => PosLoadingSkeleton.list(),
      TicketListError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(ticketListProvider.notifier).load(status: _statusFilter),
      ),
      TicketListLoaded(:final tickets) =>
        tickets.isEmpty
            ? PosEmptyState(title: AppLocalizations.of(context)!.supportNoTickets, icon: Icons.support_agent)
            : RefreshIndicator(
                onRefresh: () => ref.read(ticketListProvider.notifier).load(status: _statusFilter),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) => _ticketCard(tickets[index]),
                ),
              ),
    };
  }

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final status = ticket['status'] as String? ?? 'open';
    final priority = ticket['priority'] as String? ?? 'medium';
    final statusColor = switch (status) {
      'open' => AppColors.warning,
      'in_progress' => AppColors.primary,
      'resolved' => AppColors.success,
      'closed' => AppColors.textSecondary,
      _ => AppColors.info,
    };
    final priorityColor = switch (priority) {
      'critical' => AppColors.error,
      'high' => AppColors.errorDark,
      'medium' => AppColors.warning,
      'low' => AppColors.success,
      _ => AppColors.textSecondary,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.15),
          child: Icon(Icons.confirmation_number, color: statusColor, size: 20),
        ),
        title: Text(ticket['subject'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            Text(ticket['ticket_number'] as String? ?? '', style: const TextStyle(fontSize: 12)),
            AppSpacing.gapW8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(
                priority.toUpperCase(),
                style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: Text(status.replaceAll('_', ' '), style: TextStyle(fontSize: 11, color: statusColor)),
        ),
        onTap: () {
          final id = ticket['id'] as String? ?? '';
          if (id.isNotEmpty) context.push('/support/tickets/$id');
        },
      ),
    );
  }
}
