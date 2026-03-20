import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/support/providers/support_providers.dart';
import 'package:thawani_pos/features/support/providers/support_state.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  final String ticketId;
  const TicketDetailPage({super.key, required this.ticketId});

  @override
  ConsumerState<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(ticketDetailProvider.notifier).load(widget.ticketId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(ticketActionProvider.notifier).addMessage(widget.ticketId, message: text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(ticketDetailProvider);
    final actionState = ref.watch(ticketActionProvider);

    ref.listen<TicketActionState>(ticketActionProvider, (prev, next) {
      if (next is TicketActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(ticketActionProvider.notifier).reset();
        ref.read(ticketDetailProvider.notifier).load(widget.ticketId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.supportTicketDetail),
        actions: [
          if (detailState is TicketDetailLoaded && detailState.ticket['status'] != 'closed')
            TextButton.icon(
              onPressed: actionState is TicketActionLoading
                  ? null
                  : () => ref.read(ticketActionProvider.notifier).closeTicket(widget.ticketId),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(AppLocalizations.of(context)!.supportClose),
            ),
        ],
      ),
      body: switch (detailState) {
        TicketDetailInitial() || TicketDetailLoading() => const Center(child: CircularProgressIndicator()),
        TicketDetailError(:final message) => Center(
          child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
        ),
        TicketDetailLoaded(:final ticket) => Column(
          children: [
            // Ticket info header
            _buildHeader(ticket),
            const Divider(height: 1),
            // Messages
            Expanded(child: _buildMessages(ticket)),
            // Message input
            if (ticket['status'] != 'closed') _buildMessageInput(actionState),
          ],
        ),
      },
    );
  }

  Widget _buildHeader(Map<String, dynamic> ticket) {
    final status = ticket['status'] as String? ?? 'open';
    final statusColor = switch (status) {
      'open' => Colors.orange,
      'in_progress' => Colors.amber,
      'resolved' => Colors.green,
      'closed' => Colors.grey,
      _ => Colors.blue,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(ticket['ticket_number'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket['subject'] as String? ?? '', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            ticket['description'] as String? ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chipInfo('Category', ticket['category'] as String? ?? ''),
              const SizedBox(width: 8),
              _chipInfo('Priority', ticket['priority'] as String? ?? ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipInfo(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('$label: ${value.replaceAll('_', ' ')}', style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildMessages(Map<String, dynamic> ticket) {
    final messages = (ticket['messages'] as List<dynamic>?) ?? [];

    if (messages.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.supportNoMessages, style: const TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index] as Map<String, dynamic>;
        final isProvider = msg['sender_type'] == 'provider';
        return Align(
          alignment: isProvider ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isProvider
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg['message_text'] as String? ?? ''),
                const SizedBox(height: 4),
                Text(msg['sent_at'] as String? ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(TicketActionState actionState) {
    final isLoading = actionState is TicketActionLoading;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.supportTypeMessage,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isLoading ? null : _sendMessage,
            icon: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
