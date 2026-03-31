import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/features/support/enums/ticket_status.dart';
import 'package:thawani_pos/features/support/models/support_ticket.dart';
import 'package:thawani_pos/features/support/widgets/ticket_priority_badge.dart';
import 'package:thawani_pos/features/support/widgets/ticket_status_badge.dart';
import 'package:intl/intl.dart';

class TicketCardWidget extends StatelessWidget {
  const TicketCardWidget({super.key, required this.ticket, this.onTap});

  final SupportTicket ticket;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = ticket.createdAt != null ? DateFormat.yMMMd().add_jm().format(ticket.createdAt!) : '';

    return PosCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: ticket number + status
          Row(
            children: [
              Text(
                '#${ticket.ticketNumber}',
                style: AppTypography.labelSmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              const Spacer(),
              TicketStatusBadge(status: ticket.status, isSmall: true),
            ],
          ),
          AppSpacing.gapH8,
          // Subject
          Text(
            ticket.subject,
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapH4,
          // Description preview
          Text(
            ticket.description,
            style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapH8,
          // Bottom row: priority + category + date
          Row(
            children: [
              TicketPriorityBadge(priority: ticket.priority, isSmall: true),
              AppSpacing.gapW8,
              Text(
                ticket.category.value.replaceAll('_', ' '),
                style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              const Spacer(),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
            ],
          ),
          // SLA countdown
          if (ticket.slaDeadlineAt != null && ticket.status != TicketStatus.closed && ticket.status != TicketStatus.resolved)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _SlaIndicator(deadline: ticket.slaDeadlineAt!),
            ),
        ],
      ),
    );
  }
}

class _SlaIndicator extends StatelessWidget {
  const _SlaIndicator({required this.deadline});
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = deadline.difference(now);
    final isOverdue = remaining.isNegative;

    final String text;
    final Color color;
    final IconData icon;

    if (isOverdue) {
      final overdue = now.difference(deadline);
      text = 'SLA overdue by ${_formatDuration(overdue)}';
      color = AppColors.error;
      icon = Icons.warning_amber_rounded;
    } else if (remaining.inMinutes < 30) {
      text = 'SLA due in ${_formatDuration(remaining)}';
      color = AppColors.error;
      icon = Icons.access_alarm_rounded;
    } else if (remaining.inHours < 2) {
      text = 'SLA due in ${_formatDuration(remaining)}';
      color = AppColors.warning;
      icon = Icons.access_time_rounded;
    } else {
      text = 'SLA due in ${_formatDuration(remaining)}';
      color = AppColors.success;
      icon = Icons.schedule_rounded;
    }

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        AppSpacing.gapW4,
        Text(
          text,
          style: AppTypography.micro.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours.remainder(24)}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }
}
