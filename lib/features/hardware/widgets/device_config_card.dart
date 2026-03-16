import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/hardware/enums/connection_type.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';
import 'package:thawani_pos/features/hardware/models/hardware_configuration.dart';

class DeviceConfigCard extends StatelessWidget {
  const DeviceConfigCard({super.key, required this.config, this.onTest, this.onRemove});

  final HardwareConfiguration config;
  final VoidCallback? onTest;
  final VoidCallback? onRemove;

  IconData _deviceIcon(HardwareDeviceType type) => switch (type) {
    HardwareDeviceType.receiptPrinter => Icons.print,
    HardwareDeviceType.barcodeScanner => Icons.qr_code_scanner,
    HardwareDeviceType.cashDrawer => Icons.point_of_sale,
    HardwareDeviceType.customerDisplay => Icons.desktop_windows,
    HardwareDeviceType.weighingScale => Icons.scale,
    HardwareDeviceType.labelPrinter => Icons.label,
    HardwareDeviceType.cardTerminal => Icons.credit_card,
    HardwareDeviceType.nfcReader => Icons.nfc,
  };

  IconData _connectionIcon(ConnectionType type) => switch (type) {
    ConnectionType.usb => Icons.usb,
    ConnectionType.network => Icons.wifi,
    ConnectionType.bluetooth => Icons.bluetooth,
    ConnectionType.serial => Icons.cable,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_deviceIcon(config.deviceType), size: 28, color: theme.colorScheme.primary),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.deviceName ?? config.deviceType.value.replaceAll('_', ' ').toUpperCase(),
                        style: theme.textTheme.titleSmall,
                      ),
                      AppSpacing.gapH4,
                      Row(
                        children: [
                          Icon(_connectionIcon(config.connectionType), size: 14, color: theme.hintColor),
                          AppSpacing.gapW4,
                          Text(
                            config.connectionType.value.toUpperCase(),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (config.isActive == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: AppRadius.borderSm),
                    child: Text('Active', style: theme.textTheme.labelSmall?.copyWith(color: Colors.green.shade700)),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: AppRadius.borderSm),
                    child: Text('Inactive', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600)),
                  ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onTest != null)
                  TextButton.icon(
                    onPressed: onTest,
                    icon: const Icon(Icons.play_circle_outline, size: 18),
                    label: const Text('Test'),
                  ),
                if (onRemove != null)
                  TextButton.icon(
                    onPressed: onRemove,
                    icon: Icon(Icons.delete_outline, size: 18, color: theme.colorScheme.error),
                    label: Text('Remove', style: TextStyle(color: theme.colorScheme.error)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
