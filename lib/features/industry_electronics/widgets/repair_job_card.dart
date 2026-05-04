import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_electronics/models/repair_job.dart';
import 'package:wameedpos/features/industry_electronics/enums/repair_job_status.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class RepairJobCard extends StatelessWidget {

  const RepairJobCard({super.key, required this.job, this.onTap});
  final RepairJob job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: const Icon(Icons.build, color: AppColors.info, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.deviceDescription,
                          style: AppTypography.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (job.imei != null) Text(l10n.electronicsImeiWithValue(job.imei!), style: AppTypography.caption),
                      ],
                    ),
                  ),
                  if (job.status != null) _statusBadge(job.status!),
                ],
              ),
              AppSpacing.gapH8,
              Text(job.issueDescription, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (job.estimatedCost != null || job.finalCost != null) ...[
                AppSpacing.gapH8,
                Row(
                  children: [
                    if (job.estimatedCost != null)
                      Text(l10n.electronicsEstCostWithValue(job.estimatedCost!.toStringAsFixed(2)), style: AppTypography.bodySmall),
                    if (job.finalCost != null) ...[
                      AppSpacing.gapW16,
                      Text(
                        'Final: ${job.finalCost!.toStringAsFixed(2)} \u0081',
                        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(RepairJobStatus status) {
    final (label, variant) = switch (status) {
      RepairJobStatus.received => ('Received', PosStatusBadgeVariant.neutral),
      RepairJobStatus.diagnosing => ('Diagnosing', PosStatusBadgeVariant.info),
      RepairJobStatus.inProgress => ('In Progress', PosStatusBadgeVariant.warning),
      RepairJobStatus.repairing => ('Repairing', PosStatusBadgeVariant.warning),
      RepairJobStatus.testing => ('Testing', PosStatusBadgeVariant.info),
      RepairJobStatus.ready => ('Ready', PosStatusBadgeVariant.success),
      RepairJobStatus.collected => ('Collected', PosStatusBadgeVariant.neutral),
      RepairJobStatus.cancelled => ('Cancelled', PosStatusBadgeVariant.error),
    };
    return PosStatusBadge(label: label, variant: variant);
  }
}
