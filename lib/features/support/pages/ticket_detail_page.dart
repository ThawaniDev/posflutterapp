import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/support/enums/ticket_status.dart';
import 'package:wameedpos/features/support/models/support_ticket.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';
import 'package:wameedpos/features/support/widgets/message_bubble.dart';
import 'package:wameedpos/features/support/widgets/ticket_priority_badge.dart';
import 'package:wameedpos/features/support/widgets/ticket_status_badge.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  final String ticketId;
  const TicketDetailPage({super.key, required this.ticketId});

  @override
  ConsumerState<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(ticketDetailProvider.notifier).load(widget.ticketId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(ticketActionProvider.notifier).addMessage(widget.ticketId, message: text);
    _messageController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(ticketDetailProvider);
    final actionState = ref.watch(ticketActionProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<TicketActionState>(ticketActionProvider, (prev, next) {
      if (next is TicketActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(ticketActionProvider.notifier).reset();
        ref.read(ticketDetailProvider.notifier).load(widget.ticketId);
        _scrollToBottom();
      } else if (next is TicketActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.supportTicketDetail,
      showSearch: false,
      actions: [
        if (detailState is TicketDetailLoaded && detailState.ticket.status != TicketStatus.closed)
          PosButton(
            label: l10n.supportCloseTicket,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.sm,
            icon: Icons.check_circle_outline_rounded,
            onPressed: actionState is TicketActionLoading ? null : () => _confirmCloseTicket(l10n),
          ),
        AppSpacing.gapW8,
      ],
      child: switch (detailState) {
        TicketDetailInitial() || TicketDetailLoading() => Center(child: PosLoadingSkeleton.list()),
        TicketDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(ticketDetailProvider.notifier).load(widget.ticketId),
        ),
        TicketDetailLoaded(:final ticket, :final messages) => Column(
          children: [
            // Ticket info header
            _buildHeader(ticket, isDark, l10n),
            const Divider(height: 1),
            // Messages
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Text(
                        l10n.supportNoMessages,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => MessageBubble(message: messages[index]),
                    ),
            ),
            // Message input
            if (ticket.status != TicketStatus.closed) _buildMessageInput(actionState, l10n, isDark),
          ],
        ),
      },
    );
  }

  void _confirmCloseTicket(AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.supportCloseTicket,
      message: l10n.supportCloseConfirmation,
      confirmLabel: l10n.supportClose,
      cancelLabel: l10n.supportCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(ticketActionProvider.notifier).closeTicket(widget.ticketId);
    }
  }

  Widget _buildHeader(SupportTicket ticket, bool isDark, AppLocalizations l10n) {
    final dateStr = ticket.createdAt != null ? DateFormat.yMMMd().add_jm().format(ticket.createdAt!) : '';

    return PosCard(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      border: const Border(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: ticket number + status badge
          Row(
            children: [
              Text(
                '#${ticket.ticketNumber}',
                style: AppTypography.labelMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              const Spacer(),
              TicketStatusBadge(status: ticket.status),
            ],
          ),
          AppSpacing.gapH8,
          // Subject
          Text(ticket.subject, style: AppTypography.titleMedium),
          AppSpacing.gapH4,
          // Description
          Text(
            ticket.description,
            style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapH12,
          // Meta row: priority + category + date
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TicketPriorityBadge(priority: ticket.priority, isSmall: true),
              Text(
                ticket.category.value.replaceAll('_', ' ').toUpperCase(),
                style: AppTypography.micro.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
            ],
          ),
          // SLA info
          if (ticket.slaDeadlineAt != null && ticket.status != TicketStatus.closed && ticket.status != TicketStatus.resolved)
            Padding(padding: const EdgeInsets.only(top: 8), child: _buildSlaRow(ticket.slaDeadlineAt!, l10n)),
        ],
      ),
    );
  }

  Widget _buildSlaRow(DateTime deadline, AppLocalizations l10n) {
    final now = DateTime.now();
    final remaining = deadline.difference(now);
    final isOverdue = remaining.isNegative;

    final Color color;
    final IconData icon;
    final String text;

    if (isOverdue) {
      color = AppColors.error;
      icon = Icons.warning_amber_rounded;
      text = '${l10n.supportSlaOverdue} ${_fmtDuration(now.difference(deadline))}';
    } else if (remaining.inMinutes < 30) {
      color = AppColors.error;
      icon = Icons.access_alarm_rounded;
      text = '${l10n.supportSlaDueIn} ${_fmtDuration(remaining)}';
    } else if (remaining.inHours < 2) {
      color = AppColors.warning;
      icon = Icons.access_time_rounded;
      text = '${l10n.supportSlaDueIn} ${_fmtDuration(remaining)}';
    } else {
      color = AppColors.success;
      icon = Icons.schedule_rounded;
      text = '${l10n.supportSlaDueIn} ${_fmtDuration(remaining)}';
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        AppSpacing.gapW4,
        Text(
          text,
          style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _fmtDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours.remainder(24)}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }

  Widget _buildMessageInput(TicketActionState actionState, AppLocalizations l10n, bool isDark) {
    final isLoading = actionState is TicketActionLoading;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: PosTextField(
              controller: _messageController,
              hint: l10n.supportTypeMessage,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
            ),
          ),
          AppSpacing.gapW8,
          PosButton.icon(
            icon: Icons.send_rounded,
            onPressed: isLoading ? null : _sendMessage,
            variant: PosButtonVariant.primary,
            tooltip: l10n.supportSend,
          ),
        ],
      ),
    );
  }
}
