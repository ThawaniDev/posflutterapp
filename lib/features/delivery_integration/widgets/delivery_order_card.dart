import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_status_badge.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTap;
  final void Function(String status)? onStatusAction;

  const DeliveryOrderCard({super.key, required this.order, this.onTap, this.onStatusAction});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusString = order['delivery_status'] as String? ?? 'pending';
    final status = DeliveryOrderStatus.tryFromValue(statusString) ?? DeliveryOrderStatus.pending;
    final platformSlug = order['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final externalId = order['external_order_id'] as String? ?? order['platform_order_id'] as String? ?? 'Order';
    final customerName = order['customer_name'] as String?;
    final totalAmount = (order['total_amount'] != null ? double.tryParse(order['total_amount'].toString()) : null);
    final itemsCount = order['items_count'] as int?;
    final createdAt = order['created_at'] as String?;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: status.isActionable ? status.color.withValues(alpha: 0.3) : Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: status.color.withValues(alpha: 0.12),
                    child: Icon(status.icon, color: status.color, size: 18),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('#$externalId', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        if (platform != null) Text(platform.label, style: TextStyle(fontSize: 12, color: platform.color)),
                      ],
                    ),
                  ),
                  PosStatusBadge(label: status.label, variant: _statusToVariant(status)),
                ],
              ),

              // Customer & details
              if (customerName != null || totalAmount != null || itemsCount != null) ...[
                AppSpacing.gapH12,
                Divider(height: 1, color: Theme.of(context).dividerColor),
                AppSpacing.gapH12,
                Row(
                  children: [
                    if (customerName != null) ...[
                      Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                      AppSpacing.gapW4,
                      Expanded(
                        child: Text(
                          customerName,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (itemsCount != null) ...[
                      AppSpacing.gapW12,
                      Text(
                        l10n.deliveryItemsCountValue(itemsCount),
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                    if (totalAmount != null) ...[
                      const Spacer(),
                      Text(
                        '${totalAmount.toStringAsFixed(2)} \u0081',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ],

              // Action buttons
              if (status.isActionable && onStatusAction != null) ...[AppSpacing.gapH12, _buildActionButtons(status)],

              // Timestamp
              if (createdAt != null) ...[
                AppSpacing.gapH8,
                Text(_formatTime(context, createdAt), style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(DeliveryOrderStatus status) {
    final transitions = status.allowedTransitions;
    if (transitions.isEmpty) return const SizedBox.shrink();

    return Row(
      children: transitions.map((next) {
        final isPrimary =
            next == transitions.first && next != DeliveryOrderStatus.rejected && next != DeliveryOrderStatus.cancelled;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: next == transitions.first ? 0 : 8),
            child: isPrimary
                ? FilledButton.icon(
                    onPressed: () => onStatusAction?.call(next.value),
                    icon: Icon(next.icon, size: 16),
                    label: Text(next.label, style: const TextStyle(fontSize: 12)),
                    style: FilledButton.styleFrom(backgroundColor: next.color, padding: const EdgeInsets.symmetric(vertical: 8)),
                  )
                : OutlinedButton.icon(
                    onPressed: () => onStatusAction?.call(next.value),
                    icon: Icon(next.icon, size: 16, color: next.color),
                    label: Text(next.label, style: TextStyle(fontSize: 12, color: next.color)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: next.color),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  PosStatusBadgeVariant _statusToVariant(DeliveryOrderStatus status) => switch (status) {
    DeliveryOrderStatus.delivered => PosStatusBadgeVariant.success,
    DeliveryOrderStatus.pending => PosStatusBadgeVariant.warning,
    DeliveryOrderStatus.preparing || DeliveryOrderStatus.accepted => PosStatusBadgeVariant.info,
    DeliveryOrderStatus.rejected || DeliveryOrderStatus.cancelled || DeliveryOrderStatus.failed => PosStatusBadgeVariant.error,
    _ => PosStatusBadgeVariant.neutral,
  };

  String _formatTime(BuildContext context, String dateString) {
    final l10n = AppLocalizations.of(context)!;
    try {
      final date = DateTime.parse(dateString);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return l10n.deliveryMinutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return l10n.deliveryHoursAgo(diff.inHours);
      return l10n.deliveryDaysAgo(diff.inDays);
    } catch (_) {
      return dateString;
    }
  }
}
