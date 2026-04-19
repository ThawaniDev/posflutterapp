import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/hardware/enums/connection_type.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/features/hardware/models/hardware_configuration.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return PosCard(
      borderRadius: AppRadius.borderMd,
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
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                    child: Text(l10n.active, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.successDark)),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.textMutedDark : AppColors.textMutedLight).withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: Text(
                      l10n.inactive,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onTest != null)
                  PosButton(
                    onPressed: onTest,
                    variant: PosButtonVariant.ghost,
                    icon: Icons.play_circle_outline,
                    label: l10n.testConnection,
                  ),
                if (onRemove != null)
                  PosButton(
                    onPressed: onRemove,
                    variant: PosButtonVariant.danger,
                    icon: Icons.delete_outline,
                    label: l10n.remove,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
