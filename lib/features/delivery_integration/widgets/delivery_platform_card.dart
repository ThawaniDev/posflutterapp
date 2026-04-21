import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class DeliveryPlatformCard extends StatelessWidget {

  const DeliveryPlatformCard({super.key, required this.config, this.onToggle, this.onTap, this.onTestConnection});
  final Map<String, dynamic> config;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onTestConnection;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final platformSlug = config['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final isEnabled = config['is_enabled'] == true;
    final autoAccept = config['auto_accept'] == true;
    final dailyCount = config['daily_order_count'] as int? ?? 0;
    final status = config['status'] as String? ?? 'inactive';
    final lastOrderAt = config['last_order_received_at'] as String?;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = AppColors.mutedFor(context);

    final platformColor = platform?.color ?? mutedColor;
    final platformIcon = platform?.icon ?? Icons.delivery_dining;
    final platformName = platform?.label ?? platformSlug;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(
        BorderSide(color: isEnabled ? platformColor.withValues(alpha: 0.3) : Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: platformColor.withValues(alpha: 0.12),
                    child: Icon(platformIcon, color: platformColor, size: 20),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(platformName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        AppSpacing.gapH2,
                        Row(
                          children: [
                            _StatusDot(isActive: isEnabled),
                            AppSpacing.gapW4,
                            Text(
                              isEnabled ? status : l10n.deliveryDisabled,
                              style: TextStyle(fontSize: 12, color: isEnabled ? AppColors.success : mutedColor),
                            ),
                            if (autoAccept && isEnabled) ...[
                              AppSpacing.gapW8,
                              PosStatusBadge(label: l10n.deliveryAutoAccept, variant: PosStatusBadgeVariant.info),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Switch(value: isEnabled, onChanged: onToggle != null ? (_) => onToggle!() : null, activeThumbColor: platformColor),
                ],
              ),
              if (isEnabled) ...[
                AppSpacing.gapH12,
                Divider(height: 1, color: Theme.of(context).dividerColor),
                AppSpacing.gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoChip(label: l10n.deliveryToday, value: l10n.deliveryOrdersCount(dailyCount)),
                    if (lastOrderAt != null)
                      _InfoChip(label: l10n.deliveryLastOrder, value: _formatTimeAgo(context, lastOrderAt)),
                    if (onTestConnection != null)
                      PosButton(
                        onPressed: onTestConnection,
                        icon: Icons.wifi_tethering,
                        label: l10n.deliveryTestConnection,
                        size: PosButtonSize.sm,
                        variant: PosButtonVariant.ghost,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(BuildContext context, String dateString) {
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

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = AppColors.mutedFor(context);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: isActive ? AppColors.success : mutedColor, shape: BoxShape.circle),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = AppColors.mutedFor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: mutedColor)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
