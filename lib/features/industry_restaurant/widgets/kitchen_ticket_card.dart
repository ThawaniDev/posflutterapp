import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/kitchen_ticket.dart';
import '../enums/kitchen_ticket_status.dart';

class KitchenTicketCard extends StatelessWidget {
  final KitchenTicket ticket;
  final VoidCallback? onTap;
  final ValueChanged<KitchenTicketStatus>? onStatusChange;

  const KitchenTicketCard({super.key, required this.ticket, this.onTap, this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(Icons.receipt_long, size: 18, color: _statusColor),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text('#${ticket.ticketNumber}', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              AppSpacing.gapH8,
              if (ticket.station != null)
                Text('Station: ${ticket.station}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              if (ticket.courseNumber != null)
                Text('Course ${ticket.courseNumber}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              if (ticket.fireAt != null) ...[
                AppSpacing.gapH4,
                Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 14, color: AppColors.warning),
                    AppSpacing.gapW4,
                    Text(
                      'Fire at: ${_formatTime(ticket.fireAt!)}',
                      style: AppTypography.caption.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ],
              if (onStatusChange != null) ...[AppSpacing.gapH8, _buildActionRow()],
            ],
          ),
        ),
      ),
    );
  }

  PosStatusBadge _buildStatusBadge() {
    final status = ticket.status ?? KitchenTicketStatus.pending;
    return switch (status) {
      KitchenTicketStatus.pending => PosStatusBadge(label: 'Pending', variant: PosStatusBadgeVariant.neutral),
      KitchenTicketStatus.preparing => PosStatusBadge(label: 'Preparing', variant: PosStatusBadgeVariant.warning),
      KitchenTicketStatus.ready => PosStatusBadge(label: 'Ready', variant: PosStatusBadgeVariant.success),
      KitchenTicketStatus.served => PosStatusBadge(label: 'Served', variant: PosStatusBadgeVariant.info),
    };
  }

  Color get _statusColor {
    return switch (ticket.status ?? KitchenTicketStatus.pending) {
      KitchenTicketStatus.pending => AppColors.textSecondary,
      KitchenTicketStatus.preparing => AppColors.warning,
      KitchenTicketStatus.ready => AppColors.success,
      KitchenTicketStatus.served => AppColors.info,
    };
  }

  Widget _buildActionRow() {
    final next = _nextStatus;
    if (next == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => onStatusChange?.call(next),
        icon: Icon(_nextStatusIcon, size: 16),
        label: Text(_nextStatusLabel),
        style: OutlinedButton.styleFrom(
          foregroundColor: _nextStatusColor,
          side: BorderSide(color: _nextStatusColor),
          padding: const EdgeInsets.symmetric(vertical: 6),
          textStyle: AppTypography.labelSmall,
        ),
      ),
    );
  }

  KitchenTicketStatus? get _nextStatus {
    return switch (ticket.status ?? KitchenTicketStatus.pending) {
      KitchenTicketStatus.pending => KitchenTicketStatus.preparing,
      KitchenTicketStatus.preparing => KitchenTicketStatus.ready,
      KitchenTicketStatus.ready => KitchenTicketStatus.served,
      KitchenTicketStatus.served => null,
    };
  }

  IconData get _nextStatusIcon {
    return switch (_nextStatus) {
      KitchenTicketStatus.preparing => Icons.pan_tool_alt,
      KitchenTicketStatus.ready => Icons.check_circle,
      KitchenTicketStatus.served => Icons.room_service,
      _ => Icons.arrow_forward,
    };
  }

  String get _nextStatusLabel {
    return switch (_nextStatus) {
      KitchenTicketStatus.preparing => 'Start Preparing',
      KitchenTicketStatus.ready => 'Mark Ready',
      KitchenTicketStatus.served => 'Mark Served',
      _ => '',
    };
  }

  Color get _nextStatusColor {
    return switch (_nextStatus) {
      KitchenTicketStatus.preparing => AppColors.warning,
      KitchenTicketStatus.ready => AppColors.success,
      KitchenTicketStatus.served => AppColors.info,
      _ => AppColors.textSecondary,
    };
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
