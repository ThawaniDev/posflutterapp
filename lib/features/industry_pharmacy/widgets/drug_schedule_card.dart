import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/drug_schedule.dart';
import '../enums/drug_schedule_type.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class DrugScheduleCard extends StatelessWidget {
  final DrugSchedule drug;
  final VoidCallback? onTap;

  const DrugScheduleCard({super.key, required this.drug, this.onTap});

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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.medication, size: 18, color: _typeColor),
              ),
              AppSpacing.gapW8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (drug.activeIngredient != null)
                      Text(drug.activeIngredient!, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        if (drug.dosageForm != null)
                          Text(drug.dosageForm!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                        if (drug.strength != null) ...[
                          AppSpacing.gapW4,
                          Text('• ${drug.strength}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                    if (drug.manufacturer != null)
                      Text(drug.manufacturer!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTypeBadge(),
                  if (drug.requiresPrescription == true) ...[
                    AppSpacing.gapH4,
                    const Icon(Icons.assignment, size: 14, color: AppColors.warning),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PosStatusBadge _buildTypeBadge() {
    return switch (drug.scheduleType) {
      DrugScheduleType.otc => PosStatusBadge(label: 'OTC', variant: PosStatusBadgeVariant.success),
      DrugScheduleType.prescriptionOnly => PosStatusBadge(label: 'Rx Only', variant: PosStatusBadgeVariant.warning),
      DrugScheduleType.controlled => PosStatusBadge(label: 'Controlled', variant: PosStatusBadgeVariant.error),
    };
  }

  Color get _typeColor {
    return switch (drug.scheduleType) {
      DrugScheduleType.otc => AppColors.success,
      DrugScheduleType.prescriptionOnly => AppColors.warning,
      DrugScheduleType.controlled => AppColors.error,
    };
  }
}
