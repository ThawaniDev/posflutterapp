import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/device_imei_record.dart';
import '../enums/device_imei_status.dart';

class ImeiRecordCard extends StatelessWidget {
  final DeviceImeiRecord record;
  final VoidCallback? onTap;

  const ImeiRecordCard({super.key, required this.record, this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.smartphone, color: AppColors.primary, size: 22),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.imei, style: AppTypography.titleSmall),
                    if (record.serialNumber != null)
                      Text('S/N: ${record.serialNumber}', style: AppTypography.caption),
                    AppSpacing.gapH4,
                    Row(
                      children: [
                        PosStatusBadge(
                          label: 'Grade: ${record.conditionGrade}',
                          variant: PosStatusBadgeVariant.info,
                        ),
                        AppSpacing.gapW8,
                        _statusBadge(record.status),
                      ],
                    ),
                  ],
                ),
              ),
              if (record.purchasePrice != null)
                Text(
                  '${record.purchasePrice!.toStringAsFixed(2)}',
                  style: AppTypography.priceSmall.copyWith(color: AppColors.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(DeviceImeiStatus status) {
    final (label, variant) = switch (status) {
      DeviceImeiStatus.inStock => ('In Stock', PosStatusBadgeVariant.success),
      DeviceImeiStatus.sold => ('Sold', PosStatusBadgeVariant.neutral),
      DeviceImeiStatus.returned => ('Returned', PosStatusBadgeVariant.warning),
      DeviceImeiStatus.defective => ('Defective', PosStatusBadgeVariant.error),
      DeviceImeiStatus.inRepair => ('In Repair', PosStatusBadgeVariant.info),
    };
    return PosStatusBadge(label: label, variant: variant);
  }
}
