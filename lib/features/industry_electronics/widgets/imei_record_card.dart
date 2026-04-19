import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/device_imei_record.dart';
import '../enums/device_imei_status.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ImeiRecordCard extends StatelessWidget {
  final DeviceImeiRecord record;
  final VoidCallback? onTap;

  const ImeiRecordCard({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderSm),
                child: const Icon(Icons.smartphone, color: AppColors.primary, size: 22),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.imei, style: AppTypography.titleSmall),
                    if (record.serialNumber != null)
                      Text(l10n.electronicsSnWithValue(record.serialNumber!), style: AppTypography.caption),
                    AppSpacing.gapH4,
                    Row(
                      children: [
                        PosStatusBadge(
                          label: l10n.electronicsGradeWithValue(record.conditionGrade?.value ?? ''),
                          variant: PosStatusBadgeVariant.info,
                        ),
                        AppSpacing.gapW8,
                        if (record.status != null) _statusBadge(record.status!),
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
      DeviceImeiStatus.tradedIn => ('Traded In', PosStatusBadgeVariant.info),
      DeviceImeiStatus.returned => ('Returned', PosStatusBadgeVariant.warning),
    };
    return PosStatusBadge(label: label, variant: variant);
  }
}
