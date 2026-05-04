import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_bakery/models/production_schedule.dart';
import 'package:wameedpos/features/industry_bakery/enums/production_schedule_status.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ProductionScheduleCard extends StatelessWidget {

  const ProductionScheduleCard({super.key, required this.schedule, this.onTap});
  final ProductionSchedule schedule;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
                    child: const Icon(Icons.schedule, size: 18, color: AppColors.primary),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      _formatDate(schedule.scheduleDate),
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildStatusBadge(context),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                children: [
                  _metric(context, 'Planned', '${schedule.plannedBatches} batches'),
                  AppSpacing.gapW16,
                  _metric(context, 'Yield', '${schedule.plannedYield}'),
                  if (schedule.actualBatches != null) ...[
                    AppSpacing.gapW16,
                    _metric(context, 'Actual', '${schedule.actualBatches} / ${schedule.actualYield ?? "—"}'),
                  ],
                ],
              ),
              if (schedule.notes != null && schedule.notes!.isNotEmpty) ...[
                AppSpacing.gapH4,
                Text(
                  schedule.notes!,
                  style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
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

  Widget _metric(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context))),
        Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  PosStatusBadge _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = schedule.status ?? ProductionScheduleStatus.planned;
    return switch (status) {
      ProductionScheduleStatus.scheduled => PosStatusBadge(label: l10n.statusScheduled, variant: PosStatusBadgeVariant.info),
      ProductionScheduleStatus.planned => PosStatusBadge(label: l10n.statusPlanned, variant: PosStatusBadgeVariant.neutral),
      ProductionScheduleStatus.inProgress => PosStatusBadge(label: l10n.statusInProgress, variant: PosStatusBadgeVariant.warning),
      ProductionScheduleStatus.completed => PosStatusBadge(label: l10n.ordersCompleted, variant: PosStatusBadgeVariant.success),
      ProductionScheduleStatus.cancelled => PosStatusBadge(label: l10n.ordersCancelled, variant: PosStatusBadgeVariant.error),
    };
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
