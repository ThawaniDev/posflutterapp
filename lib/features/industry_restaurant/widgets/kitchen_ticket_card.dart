import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/kitchen_ticket.dart';
import '../enums/kitchen_ticket_status.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class KitchenTicketCard extends StatelessWidget {
  final KitchenTicket ticket;
  final VoidCallback? onTap;
  final ValueChanged<KitchenTicketStatus>? onStatusChange;

  const KitchenTicketCard({super.key, required this.ticket, this.onTap, this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
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
                    child: Text(
                      l10n.restaurantTicketNumberSign(ticket.ticketNumber.toString()),
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildStatusBadge(context),
                ],
              ),
              AppSpacing.gapH8,
              if (ticket.station != null)
                Text(
                  l10n.restaurantStation(ticket.station ?? ''),
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              if (ticket.courseNumber != null)
                Text(
                  l10n.restaurantCourse(ticket.courseNumber.toString()),
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
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

  PosStatusBadge _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = ticket.status ?? KitchenTicketStatus.pending;
    return switch (status) {
      KitchenTicketStatus.pending => PosStatusBadge(label: l10n.pending, variant: PosStatusBadgeVariant.neutral),
      KitchenTicketStatus.inProgress => PosStatusBadge(label: l10n.statusInProgress, variant: PosStatusBadgeVariant.warning),
      KitchenTicketStatus.preparing => PosStatusBadge(label: l10n.ordersPreparing, variant: PosStatusBadgeVariant.warning),
      KitchenTicketStatus.ready => PosStatusBadge(label: l10n.ordersReady, variant: PosStatusBadgeVariant.success),
      KitchenTicketStatus.served => PosStatusBadge(label: l10n.restaurantServed, variant: PosStatusBadgeVariant.info),
      KitchenTicketStatus.cancelled => PosStatusBadge(label: l10n.ordersCancelled, variant: PosStatusBadgeVariant.error),
    };
  }

  Color get _statusColor {
    return switch (ticket.status ?? KitchenTicketStatus.pending) {
      KitchenTicketStatus.pending => AppColors.textMutedLight,
      KitchenTicketStatus.inProgress => AppColors.warning,
      KitchenTicketStatus.preparing => AppColors.warning,
      KitchenTicketStatus.ready => AppColors.success,
      KitchenTicketStatus.served => AppColors.info,
      KitchenTicketStatus.cancelled => AppColors.error,
    };
  }

  Widget _buildActionRow() {
    final next = _nextStatus;
    if (next == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: PosButton(
        onPressed: () => onStatusChange?.call(next),
        variant: PosButtonVariant.outline,
        icon: _nextStatusIcon,
        label: _nextStatusLabel,
        size: PosButtonSize.sm,
      ),
    );
  }

  KitchenTicketStatus? get _nextStatus {
    return switch (ticket.status ?? KitchenTicketStatus.pending) {
      KitchenTicketStatus.pending => KitchenTicketStatus.preparing,
      KitchenTicketStatus.inProgress => KitchenTicketStatus.ready,
      KitchenTicketStatus.preparing => KitchenTicketStatus.ready,
      KitchenTicketStatus.ready => KitchenTicketStatus.served,
      KitchenTicketStatus.served => null,
      KitchenTicketStatus.cancelled => null,
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

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
