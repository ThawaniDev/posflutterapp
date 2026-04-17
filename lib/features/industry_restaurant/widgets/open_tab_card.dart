import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/open_tab.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class OpenTabCard extends StatelessWidget {
  final OpenTab tab;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const OpenTabCard({super.key, required this.tab, this.onTap, this.onClose});

  @override
  Widget build(BuildContext context) {
    final isOpen = tab.closedAt == null;

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
                  color: (isOpen ? AppColors.success : AppColors.textSecondary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isOpen ? Icons.tab : Icons.tab_unselected,
                  size: 20,
                  color: isOpen ? AppColors.success : AppColors.textSecondary,
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
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    if (tab.closedAt != null)
                      Text(
                        'Closed: ${_formatDateTime(tab.closedAt!)}',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
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
                      child: Text('Close Tab', style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
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
