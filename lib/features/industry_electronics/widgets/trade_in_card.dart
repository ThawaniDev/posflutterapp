import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade_in_record.dart';

class TradeInCard extends StatelessWidget {
  final TradeInRecord record;
  final VoidCallback? onTap;

  const TradeInCard({super.key, required this.record, this.onTap});

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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.swap_horiz, size: 18, color: AppColors.info),
              ),
              AppSpacing.gapW8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.deviceDescription,
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (record.imei != null)
                      Text('IMEI: ${record.imei}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    Text(
                      'Grade: ${record.conditionGrade}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${record.assessedValue.toStringAsFixed(2)} SAR',
                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
