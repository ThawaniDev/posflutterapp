import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/cashier_gamification/models/cashier_badge.dart';

class BadgeCard extends StatelessWidget {
  final CashierBadge badge;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const BadgeCard({super.key, required this.badge, this.onTap, this.onEdit, this.onDelete, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isPhone;
    final locale = Localizations.localeOf(context).languageCode;
    final name = locale == 'ar' ? badge.nameAr : badge.nameEn;
    final description = locale == 'ar' ? (badge.descriptionAr ?? '') : (badge.descriptionEn ?? '');

    Color badgeColor;
    try {
      final hex = badge.color.replaceFirst('#', '');
      badgeColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      badgeColor = Colors.orange;
    }

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isMobile ? 40 : 48,
                    height: isMobile ? 40 : 48,
                    decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Text(badge.icon, style: TextStyle(fontSize: isMobile ? 20 : 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${badge.triggerType} ≥ ${badge.triggerThreshold.toStringAsFixed(1)} (${badge.period})',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!badge.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Inactive', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ),
                  if (showActions) ...[
                    if (onEdit != null)
                      IconButton(icon: const Icon(Icons.edit_rounded, size: 18), onPressed: onEdit, tooltip: 'Edit'),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete_rounded, size: 18, color: theme.colorScheme.error),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                      ),
                  ],
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(description, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
