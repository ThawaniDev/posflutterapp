import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_pharmacy/models/prescription.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PrescriptionCard extends StatelessWidget {

  const PrescriptionCard({super.key, required this.prescription, this.onTap});
  final Prescription prescription;
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
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
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
                    PosStatusBadge(
                      label: l10n.pharmacyInsured,
                      variant: PosStatusBadgeVariant.success,
                      icon: Icons.verified_outlined,
                    ),
                ],
              ),
              AppSpacing.gapH8,
              Row(
                children: [
                  Icon(Icons.local_hospital, size: 14, color: AppColors.mutedFor(context)),
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
                  'Claim: ${prescription.insuranceClaimAmount!.toStringAsFixed(2)} \u0081',
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
