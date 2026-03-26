import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryPlatformCard extends StatelessWidget {
  final Map<String, dynamic> config;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onTestConnection;

  const DeliveryPlatformCard({
    super.key,
    required this.config,
    this.onToggle,
    this.onTap,
    this.onTestConnection,
  });

  @override
  Widget build(BuildContext context) {
    final platformSlug = config['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final isEnabled = config['is_enabled'] == true;
    final autoAccept = config['auto_accept'] == true;
    final dailyCount = config['daily_order_count'] as int? ?? 0;
    final status = config['status'] as String? ?? 'inactive';
    final lastOrderAt = config['last_order_received_at'] as String?;

    final platformColor = platform?.color ?? AppColors.textSecondary;
    final platformIcon = platform?.icon ?? Icons.delivery_dining;
    final platformName = platform?.label ?? platformSlug;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: isEnabled ? platformColor.withValues(alpha: 0.3) : Theme.of(context).dividerColor,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                              isEnabled ? status : 'Disabled',
                              style: TextStyle(
                                fontSize: 12,
                                color: isEnabled ? AppColors.success : AppColors.textSecondary,
                              ),
                            ),
                            if (autoAccept && isEnabled) ...[
                              AppSpacing.gapW8,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  'Auto-accept',
                                  style: TextStyle(fontSize: 10, color: AppColors.info),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: onToggle != null ? (_) => onToggle!() : null,
                    activeColor: platformColor,
                  ),
                ],
              ),
              if (isEnabled) ...[
                AppSpacing.gapH12,
                Divider(height: 1, color: Theme.of(context).dividerColor),
                AppSpacing.gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoChip(label: 'Today', value: '$dailyCount orders'),
                    if (lastOrderAt != null)
                      _InfoChip(label: 'Last order', value: _formatTimeAgo(lastOrderAt)),
                    if (onTestConnection != null)
                      TextButton.icon(
                        onPressed: onTestConnection,
                        icon: const Icon(Icons.wifi_tethering, size: 16),
                        label: const Text('Test', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return dateString;
    }
  }
}

class _StatusDot extends StatelessWidget {
  final bool isActive;
  const _StatusDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.success : AppColors.textSecondary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
