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
  const TicketDetailPage({super.key, required this.ticketId});
  final String ticketId;

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
            // Rating banner for resolved/closed unrated tickets
            if ((ticket.status == TicketStatus.resolved || ticket.status == TicketStatus.closed) && !ticket.isRated)
              _RatingBanner(ticketId: widget.ticketId, actionState: actionState, l10n: l10n, isDark: isDark),
            // Already-rated satisfaction display
            if (ticket.isRated) _SatisfactionDisplay(ticket: ticket, l10n: l10n),
            // Messages
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Text(
                        l10n.supportNoMessages,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
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
              Text('#${ticket.ticketNumber}', style: AppTypography.labelMedium.copyWith(color: AppColors.mutedFor(context))),
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
                style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context), fontWeight: FontWeight.w600),
              ),
              if (dateStr.isNotEmpty) Text(dateStr, style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context))),
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
        color: isDark ? AppColors.cardDark : AppColors.surfaceFor(context),
        border: Border(top: BorderSide(color: AppColors.borderFor(context))),
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

// ─── Rating Banner Widget ────────────────────────────────────────────────────

class _RatingBanner extends ConsumerStatefulWidget {
  const _RatingBanner({required this.ticketId, required this.actionState, required this.l10n, required this.isDark});

  final String ticketId;
  final TicketActionState actionState;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  ConsumerState<_RatingBanner> createState() => _RatingBannerState();
}

class _RatingBannerState extends ConsumerState<_RatingBanner> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();
  bool _expanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedRating == 0) return;
    ref
        .read(ticketActionProvider.notifier)
        .rateTicket(
          widget.ticketId,
          rating: _selectedRating,
          comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.actionState is TicketActionLoading;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : AppColors.primaryLight.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Header row — always visible
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      widget.l10n.supportRateTicket,
                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.mutedFor(context)),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.l10n.supportRateTicketHint,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                  ),
                  AppSpacing.gapH12,
                  // Star row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedRating = star),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            star <= _selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: AppColors.warning,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  AppSpacing.gapH12,
                  // Optional comment
                  PosTextField(controller: _commentController, hint: widget.l10n.supportRateTicketHint, maxLines: 3, minLines: 1),
                  AppSpacing.gapH12,
                  SizedBox(
                    width: double.infinity,
                    child: PosButton(
                      label: widget.l10n.supportRateSubmit,
                      onPressed: (isLoading || _selectedRating == 0) ? null : _submit,
                      variant: PosButtonVariant.primary,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Satisfaction Display Widget ─────────────────────────────────────────────

class _SatisfactionDisplay extends StatelessWidget {
  const _SatisfactionDisplay({required this.ticket, required this.l10n});

  final SupportTicket ticket;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rating = ticket.satisfactionRating ?? 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
              AppSpacing.gapW8,
              Text(
                l10n.supportTicketRated,
                style: AppTypography.labelMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(i < rating ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.warning, size: 18),
                ),
              ),
            ],
          ),
          if (ticket.satisfactionComment != null && ticket.satisfactionComment!.isNotEmpty) ...[
            AppSpacing.gapH4,
            Text(ticket.satisfactionComment!, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
          ],
        ],
      ),
    );
  }
}
