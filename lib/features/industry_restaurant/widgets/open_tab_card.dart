import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_restaurant/models/open_tab.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class OpenTabCard extends StatelessWidget {

  const OpenTabCard({super.key, required this.tab, this.onTap, this.onClose});
  final OpenTab tab;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOpen = tab.closedAt == null;
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isOpen ? AppColors.success : (AppColors.mutedFor(context))).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isOpen ? Icons.tab : Icons.tab_unselected,
                  size: 20,
                  color: isOpen ? AppColors.success : (AppColors.mutedFor(context)),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tab.customerName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                    if (tab.openedAt != null)
                      Text(
                        'Opened: ${_formatDateTime(tab.openedAt!)}',
                        style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
                      ),
                    if (tab.closedAt != null)
                      Text(
                        'Closed: ${_formatDateTime(tab.closedAt!)}',
                        style: AppTypography.caption.copyWith(color: AppColors.mutedFor(context)),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PosStatusBadge(
                    label: isOpen ? 'Open' : 'Closed',
                    variant: isOpen ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.neutral,
                  ),
                  if (isOpen && onClose != null) ...[
                    AppSpacing.gapH4,
                    GestureDetector(
                      onTap: onClose,
                      child: Text(l10n.restaurantCloseTab, style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
