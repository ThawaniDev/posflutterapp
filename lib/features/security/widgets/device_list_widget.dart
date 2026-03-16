import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/security/models/device_registration.dart';

class DeviceListWidget extends StatelessWidget {
  final List<DeviceRegistration> devices;
  final ValueChanged<String>? onDeactivate;
  final ValueChanged<String>? onRemoteWipe;

  const DeviceListWidget({super.key, required this.devices, this.onDeactivate, this.onRemoteWipe});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Center(child: Text('No devices registered.'));
    }

    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return _DeviceTile(device: device, onDeactivate: onDeactivate, onRemoteWipe: onRemoteWipe);
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final DeviceRegistration device;
  final ValueChanged<String>? onDeactivate;
  final ValueChanged<String>? onRemoteWipe;

  const _DeviceTile({required this.device, this.onDeactivate, this.onRemoteWipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = device.isActive ? Colors.green : Colors.grey;

    return Card(
      margin: AppSpacing.paddingV4,
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
                    device.isActive ? 'Active' : 'Inactive',
                    style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH8,
            Text('Hardware: ${device.hardwareId}', style: theme.textTheme.bodySmall),
            if (device.osInfo != null) Text('OS: ${device.osInfo}', style: theme.textTheme.bodySmall),
            if (device.appVersion != null) Text('App: ${device.appVersion}', style: theme.textTheme.bodySmall),
            if (device.remoteWipeRequested)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('⚠ Remote wipe requested', style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
              ),
            if (device.isActive) ...[
              AppSpacing.gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onDeactivate != null ? () => onDeactivate!(device.id) : null,
                    child: const Text('Deactivate'),
                  ),
                  AppSpacing.gapW8,
                  TextButton(
                    onPressed: onRemoteWipe != null ? () => onRemoteWipe!(device.id) : null,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Remote Wipe'),
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
