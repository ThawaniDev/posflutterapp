import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      SupportStatsError(:final message) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      SupportStatsLoaded(:final total, :final open, :final inProgress, :final resolved) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _statCard(AppLocalizations.of(context)!.supportTotal, total, Colors.blue),
            _statCard(AppLocalizations.of(context)!.supportOpen, open, Colors.orange),
            _statCard(AppLocalizations.of(context)!.supportInProgress, inProgress, Colors.amber),
            _statCard(AppLocalizations.of(context)!.supportResolved, resolved, Colors.green),
          ],
        ),
      ),
    };
  }

  Widget _statCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                '$value',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
          const SizedBox(width: 8),
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
      TicketListInitial() || TicketListLoading() => const Center(child: CircularProgressIndicator()),
      TicketListError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      TicketListLoaded(:final tickets) =>
        tickets.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.support_agent, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.supportNoTickets,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.supportTapToCreate, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
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
      'open' => Colors.orange,
      'in_progress' => Colors.amber,
      'resolved' => Colors.green,
      'closed' => Colors.grey,
      _ => Colors.blue,
    };
    final priorityColor = switch (priority) {
      'critical' => Colors.red,
      'high' => Colors.deepOrange,
      'medium' => Colors.amber,
      'low' => Colors.green,
      _ => Colors.grey,
    };

    return Card(
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
            const SizedBox(width: 8),
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
