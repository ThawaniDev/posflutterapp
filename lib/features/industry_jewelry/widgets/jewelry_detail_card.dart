import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class JewelryDetailCard extends StatelessWidget {

  const JewelryDetailCard({super.key, required this.detail, this.onTap});
  final JewelryProductDetail detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      color: _metalColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(Icons.diamond, size: 18, color: _metalColor),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail.metalType.value.toUpperCase()} ${detail.karat ?? ""}',
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Gross: ${detail.grossWeightG}g • Net: ${detail.netWeightG}g',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.mutedFor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH8,
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _chip('Making: ${detail.makingChargesValue}'),
                  if (detail.stoneType != null) _chip('${detail.stoneType} (${detail.stoneCount ?? 0}pcs)'),
                  if (detail.certificateNumber != null) _chip('Cert: ${detail.certificateNumber}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.borderSubtleLight, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(text, style: AppTypography.caption),
    );
  }

  Color get _metalColor {
    return switch (detail.metalType) {
      MetalType.gold => const Color(0xFFD4A017),
      MetalType.silver => const Color(0xFF9CA3AF),
      MetalType.platinum => const Color(0xFF6B7280),
    };
  }
}
