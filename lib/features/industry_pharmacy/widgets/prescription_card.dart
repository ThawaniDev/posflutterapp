import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/prescription.dart';

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback? onTap;

  const PrescriptionCard({super.key, required this.prescription, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
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
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.receipt_long, color: AppColors.success, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prescription.prescriptionNumber, style: AppTypography.titleSmall),
                        Text(prescription.patientName, style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  if (prescription.insuranceProvider != null)
                    const PosStatusBadge(label: 'Insured', variant: PosStatusBadgeVariant.success, icon: Icons.verified_outlined),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                children: [
                  const Icon(Icons.local_hospital, size: 14, color: Colors.grey),
                  AppSpacing.gapW4,
                  Expanded(
                    child: Text(
                      'Dr. ${prescription.doctorName} · ${prescription.doctorLicense}',
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (prescription.insuranceClaimAmount != null) ...[
                AppSpacing.gapH4,
                Text(
                  'Claim: ${prescription.insuranceClaimAmount!.toStringAsFixed(2)} OMR',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
