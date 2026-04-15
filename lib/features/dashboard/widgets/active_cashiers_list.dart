import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';

class ActiveCashiersList extends StatelessWidget {
  final List<Map<String, dynamic>> cashiers;

  const ActiveCashiersList({super.key, required this.cashiers});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_rounded, color: AppColors.info, size: 20),
              AppSpacing.gapW8,
              Text(l10n.dashboardActiveCashiers, style: AppTypography.headlineSmall),
              const Spacer(),
              if (cashiers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                  child: Text(
                    '${cashiers.length} ${l10n.dashboardOnline}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                  ),
                ),
            ],
          ),
          AppSpacing.gapH12,
          if (cashiers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  l10n.dashboardNoActiveSessions,
                  style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            )
          else
            ...cashiers.map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        _initials(c['cashier_name'] as String? ?? '?'),
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['cashier_name'] as String? ?? 'Unknown',
                            style: AppTypography.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${l10n.dashboardSince} ${c['opened_at'] as String? ?? '-'}',
                            style: AppTypography.micro.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\u0081 ${(c['session_total'] != null ? double.tryParse(c['session_total'].toString()) : null)?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
