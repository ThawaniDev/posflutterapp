import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/security/models/device_registration.dart';

class DeviceListWidget extends StatelessWidget {
  final List<DeviceRegistration> devices;
  final ValueChanged<String>? onDeactivate;
  final ValueChanged<String>? onRemoteWipe;
  final bool isActionLoading;

  const DeviceListWidget({super.key, required this.devices, this.onDeactivate, this.onRemoteWipe, this.isActionLoading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (devices.isEmpty) {
      return Center(child: Text(l10n.securityNoDevices));
    }

    return ListView.builder(
      padding: AppSpacing.paddingAll16,
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return _DeviceTile(
          device: device,
          onDeactivate: onDeactivate,
          onRemoteWipe: onRemoteWipe,
          isActionLoading: isActionLoading,
        );
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final DeviceRegistration device;
  final ValueChanged<String>? onDeactivate;
  final ValueChanged<String>? onRemoteWipe;
  final bool isActionLoading;

  const _DeviceTile({required this.device, this.onDeactivate, this.onRemoteWipe, this.isActionLoading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final statusColor = device.isActive ? AppColors.success : AppColors.textSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(device.isActive ? Icons.devices : Icons.devices_other, color: statusColor),
                AppSpacing.gapW8,
                Expanded(child: Text(device.deviceName, style: theme.textTheme.titleSmall)),
                Container(
                  padding: AppSpacing.paddingH8,
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                  child: Text(
                    device.isActive ? l10n.securityActive : l10n.securityInactive,
                    style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH8,
            Text('${l10n.securityHardware}: ${device.hardwareId}', style: theme.textTheme.bodySmall),
            if (device.osInfo != null) Text('${l10n.securityOS}: ${device.osInfo}', style: theme.textTheme.bodySmall),
            if (device.appVersion != null) Text('${l10n.securityApp}: ${device.appVersion}', style: theme.textTheme.bodySmall),
            if (device.ipAddress != null) Text('${l10n.securityIP}: ${device.ipAddress}', style: theme.textTheme.bodySmall),
            if (device.deviceType != null)
              Text('${l10n.securityDeviceType}: ${device.deviceType}', style: theme.textTheme.bodySmall),
            if (device.remoteWipeRequested)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '⚠ ${l10n.securityRemoteWipeRequested}',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            if (device.isActive) ...[
              AppSpacing.gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isActionLoading ? null : (onDeactivate != null ? () => onDeactivate!(device.id) : null),
                    child: Text(l10n.securityDeactivate),
                  ),
                  AppSpacing.gapW8,
                  TextButton(
                    onPressed: isActionLoading ? null : (onRemoteWipe != null ? () => onRemoteWipe!(device.id) : null),
                    style: TextButton.styleFrom(foregroundColor: AppColors.error),
                    child: Text(l10n.securityRemoteWipe),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
