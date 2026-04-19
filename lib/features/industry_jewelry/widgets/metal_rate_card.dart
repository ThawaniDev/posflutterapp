import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../enums/metal_type.dart';
import '../models/daily_metal_rate.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class MetalRateCard extends StatelessWidget {
  final DailyMetalRate rate;
  final VoidCallback? onTap;

  const MetalRateCard({super.key, required this.rate, this.onTap});

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _metalColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderSm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.diamond, size: 20, color: _metalColor),
                    if (rate.karat != null)
                      Text(
                        rate.karat!,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _metalColor),
                      ),
                  ],
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${rate.metalType.value.toUpperCase()} ${rate.karat ?? ''}', style: AppTypography.titleSmall),
                    Text(l10n.jewelryEffectiveWithValue(rate.effectiveDate.toString()), style: AppTypography.caption),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${rate.ratePerGram.toStringAsFixed(2)}/g',
                    style: AppTypography.priceSmall.copyWith(color: AppColors.primary),
                  ),
                  if (rate.buybackRatePerGram != null)
                    Text(
                      'Buy: ${rate.buybackRatePerGram!.toStringAsFixed(2)}/g',
                      style: AppTypography.caption.copyWith(color: AppColors.success),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _metalColor {
    return switch (rate.metalType) {
      MetalType.gold => const Color(0xFFD4A017),
      MetalType.silver => const Color(0xFFC0C0C0),
      MetalType.platinum => const Color(0xFFE5E4E2),
    };
  }
}
