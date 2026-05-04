import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_jewelry/models/buyback_transaction.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BuybackCard extends StatelessWidget {

  const BuybackCard({super.key, required this.buyback, this.onTap});
  final BuybackTransaction buyback;
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _metalColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.currency_exchange, size: 20, color: _metalColor),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${buyback.metalType.value.toUpperCase()} ${buyback.karat}',
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${buyback.weightG}g @ ${buyback.ratePerGram.toStringAsFixed(2)}/g',
                      style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    PosStatusBadge(label: buyback.paymentMethod.value.replaceAll('_', ' '), variant: PosStatusBadgeVariant.info),
                  ],
                ),
              ),
              Text(
                '${buyback.totalAmount.toStringAsFixed(2)} \u0081',
                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _metalColor {
    return switch (buyback.metalType) {
      MetalType.gold => const Color(0xFFD4A017),
      MetalType.silver => const Color(0xFF9CA3AF),
      MetalType.platinum => const Color(0xFF6B7280),
    };
  }
}
