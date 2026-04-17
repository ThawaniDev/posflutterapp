import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/table_reservation.dart';
import '../enums/table_reservation_status.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ReservationCard extends StatelessWidget {
  final TableReservation reservation;
  final VoidCallback? onTap;

  const ReservationCard({super.key, required this.reservation, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.event_seat, size: 18, color: AppColors.primary),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reservation.customerName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                        if (reservation.customerPhone != null)
                          Text(reservation.customerPhone!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  _buildStatusBadge(context),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                children: [
                  _infoChip(Icons.calendar_today, _formatDate(reservation.reservationDate)),
                  AppSpacing.gapW8,
                  _infoChip(Icons.access_time, reservation.reservationTime),
                  AppSpacing.gapW8,
                  _infoChip(Icons.group, '${reservation.partySize}'),
                ],
              ),
              if (reservation.durationMinutes != null) ...[
                AppSpacing.gapH4,
                Text('${reservation.durationMinutes} min', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
              if (reservation.notes != null && reservation.notes!.isNotEmpty) ...[
                AppSpacing.gapH4,
                Text(
                  reservation.notes!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(text, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  PosStatusBadge _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = reservation.status ?? TableReservationStatus.confirmed;
    return switch (status) {
      TableReservationStatus.confirmed => PosStatusBadge(label: l10n.ordersConfirmed, variant: PosStatusBadgeVariant.info),
      TableReservationStatus.seated => PosStatusBadge(label: 'Seated', variant: PosStatusBadgeVariant.success),
      TableReservationStatus.completed => PosStatusBadge(label: l10n.ordersCompleted, variant: PosStatusBadgeVariant.neutral),
      TableReservationStatus.cancelled => PosStatusBadge(label: l10n.ordersCancelled, variant: PosStatusBadgeVariant.error),
      TableReservationStatus.noShow => PosStatusBadge(label: 'No Show', variant: PosStatusBadgeVariant.warning),
    };
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
