import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/hardware/enums/connection_type.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';
import 'package:thawani_pos/features/hardware/models/hardware_configuration.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_providers.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_state.dart';
import 'package:thawani_pos/features/hardware/services/hardware_auto_detector.dart';
import 'package:thawani_pos/features/hardware/services/hardware_manager.dart';

/// Real-time connected devices panel showing all peripherals grouped by connection type.
class ConnectedDevicesPanel extends ConsumerWidget {
  const ConnectedDevicesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final configState = ref.watch(hardwareConfigListProvider);
    final statusAsync = ref.watch(peripheralStatusProvider);
    final networkScanState = ref.watch(networkScanProvider);

    // Get configured devices
    final configs = switch (configState) {
      HardwareConfigListLoaded(:final configs) => configs,
      _ => <HardwareConfiguration>[],
    };

    // Get live statuses
    final statuses = statusAsync.when(
      data: (s) => s,
      loading: () => ref.read(hardwareManagerProvider).statuses,
      error: (_, __) => ref.read(hardwareManagerProvider).statuses,
    );

    // Group configs by connection type
    final byConnection = <ConnectionType, List<_DeviceInfo>>{};
    for (final config in configs) {
      if (config.isActive != true) continue;
      final status = statuses[config.deviceType];
      final info = _DeviceInfo(config: config, status: status);
      byConnection.putIfAbsent(config.connectionType, () => []).add(info);
    }

    // Count totals
    final totalConfigured = configs.where((c) => c.isActive == true).length;
    final totalConnected = statuses.values.where((s) => s.isConnected).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Summary bar ──
        _SummaryBar(totalConfigured: totalConfigured, totalConnected: totalConnected, isDark: isDark),

        AppSpacing.gapH16,

        // ── Connection type groups ──
        if (byConnection.isEmpty)
          _EmptyState(isDark: isDark)
        else ...[
          if (context.isPhone)
            ...byConnection.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ConnectionGroup(connectionType: e.key, devices: e.value, isDark: isDark),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final entries = byConnection.entries.toList();
                final crossCount = constraints.maxWidth > 900 ? 3 : 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: entries
                      .map(
                        (e) => SizedBox(
                          width: (constraints.maxWidth - 12 * (crossCount - 1)) / crossCount,
                          child: _ConnectionGroup(connectionType: e.key, devices: e.value, isDark: isDark),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],

        AppSpacing.gapH12,

        // ── Network Scan ──
        _NetworkScanSection(scanState: networkScanState, ref: ref, isDark: isDark),
      ],
    );
  }
}

// ─── Summary Bar ───────────────────────────────────────────
class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.totalConfigured, required this.totalConnected, required this.isDark});

  final int totalConfigured;
  final int totalConnected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final disconnected = totalConfigured - totalConnected;
    return Row(
      children: [
        _SummaryChip(
          icon: Icons.devices,
          label: '$totalConfigured Configured',
          color: isDark ? AppColors.textSecondary : AppColors.textPrimaryLight,
          isDark: isDark,
        ),
        AppSpacing.gapW12,
        _SummaryChip(icon: Icons.check_circle, label: '$totalConnected Connected', color: AppColors.success, isDark: isDark),
        if (disconnected > 0) ...[
          AppSpacing.gapW12,
          _SummaryChip(icon: Icons.error_outline, label: '$disconnected Offline', color: AppColors.error, isDark: isDark),
        ],
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label, required this.color, required this.isDark});

  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          AppSpacing.gapW4,
          Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Center(
          child: Column(
            children: [
              Icon(Icons.devices_other, size: 48, color: isDark ? AppColors.textSecondary : Colors.grey.shade400),
              AppSpacing.gapH12,
              Text(
                'No active devices',
                style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade600),
              ),
              AppSpacing.gapH4,
              Text(
                'Configure devices above to see their connection status',
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Connection Type Group ─────────────────────────────────
class _ConnectionGroup extends StatelessWidget {
  const _ConnectionGroup({required this.connectionType, required this.devices, required this.isDark});

  final ConnectionType connectionType;
  final List<_DeviceInfo> devices;
  final bool isDark;

  String get _label => switch (connectionType) {
    ConnectionType.usb => 'USB',
    ConnectionType.network => 'WiFi / Network',
    ConnectionType.bluetooth => 'Bluetooth',
    ConnectionType.serial => 'Serial / COM',
  };

  IconData get _icon => switch (connectionType) {
    ConnectionType.usb => Icons.usb,
    ConnectionType.network => Icons.wifi,
    ConnectionType.bluetooth => Icons.bluetooth,
    ConnectionType.serial => Icons.cable,
  };

  Color get _accentColor => switch (connectionType) {
    ConnectionType.usb => const Color(0xFF5C6BC0),
    ConnectionType.network => const Color(0xFF26A69A),
    ConnectionType.bluetooth => const Color(0xFF42A5F5),
    ConnectionType.serial => const Color(0xFFFF7043),
  };

  @override
  Widget build(BuildContext context) {
    final connected = devices.where((d) => d.status?.isConnected == true).length;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      color: isDark ? AppColors.surfaceDark : null,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
              border: Border(bottom: BorderSide(color: _accentColor.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                Icon(_icon, size: 20, color: _accentColor),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(_label, style: AppTypography.titleSmall.copyWith(color: _accentColor)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _accentColor.withValues(alpha: 0.15), borderRadius: AppRadius.borderSm),
                  child: Text(
                    '$connected/${devices.length}',
                    style: AppTypography.micro.copyWith(color: _accentColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Device rows
          ...devices.map((d) => _DeviceRow(device: d, isDark: isDark)),
        ],
      ),
    );
  }
}

// ─── Device Row ────────────────────────────────────────────
class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device, required this.isDark});

  final _DeviceInfo device;
  final bool isDark;

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

  String _deviceLabel(HardwareDeviceType type) => switch (type) {
    HardwareDeviceType.receiptPrinter => 'Receipt Printer',
    HardwareDeviceType.barcodeScanner => 'Barcode Scanner',
    HardwareDeviceType.cashDrawer => 'Cash Drawer',
    HardwareDeviceType.customerDisplay => 'Customer Display',
    HardwareDeviceType.weighingScale => 'Weighing Scale',
    HardwareDeviceType.labelPrinter => 'Label Printer',
    HardwareDeviceType.cardTerminal => 'Card Terminal',
    HardwareDeviceType.nfcReader => 'NFC Reader',
  };

  @override
  Widget build(BuildContext context) {
    final isConnected = device.status?.isConnected ?? false;
    final hasError = device.status?.errorMessage != null && device.status!.errorMessage!.isNotEmpty;
    final name = device.config.deviceName ?? _deviceLabel(device.config.deviceType);

    final statusColor = isConnected ? AppColors.success : (hasError ? AppColors.error : AppColors.textSecondary);
    final statusText = isConnected ? 'Connected' : (hasError ? 'Error' : 'Offline');
    final statusIcon = isConnected ? Icons.circle : (hasError ? Icons.warning_amber_rounded : Icons.circle_outlined);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Icon(_deviceIcon(device.config.deviceType), size: 22, color: isDark ? AppColors.textSecondary : Colors.grey.shade600),
          AppSpacing.gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                if (hasError)
                  Text(
                    device.status!.errorMessage!,
                    style: AppTypography.micro.copyWith(color: AppColors.error),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (device.status?.lastActivity != null && !hasError)
                  Text(
                    _formatLastActivity(device.status!.lastActivity!),
                    style: AppTypography.micro.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade500),
                  ),
              ],
            ),
          ),
          // Status indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: isConnected ? 8 : 12, color: statusColor),
              AppSpacing.gapW4,
              Text(
                statusText,
                style: AppTypography.micro.copyWith(color: statusColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastActivity(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Active just now';
    if (diff.inMinutes < 60) return 'Active ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Active ${diff.inHours}h ago';
    return 'Active ${diff.inDays}d ago';
  }
}

// ─── Network Scan Section ──────────────────────────────────
class _NetworkScanSection extends StatelessWidget {
  const _NetworkScanSection({required this.scanState, required this.ref, required this.isDark});

  final NetworkScanState scanState;
  final WidgetRef ref;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radar, size: 20, color: isDark ? AppColors.textSecondary : Colors.grey.shade700),
                AppSpacing.gapW8,
                Expanded(child: Text('Network Discovery', style: AppTypography.titleSmall)),
                switch (scanState) {
                  NetworkScanIdle() || NetworkScanComplete() || NetworkScanError() => TextButton.icon(
                    onPressed: () => ref.read(networkScanProvider.notifier).scan(),
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('Scan'),
                  ),
                  NetworkScanRunning() => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                },
              ],
            ),

            switch (scanState) {
              NetworkScanIdle() => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Scan your local network to discover printers and displays',
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade600),
                ),
              ),

              NetworkScanRunning(:final scanned, :final total) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: total > 0 ? scanned / total : null,
                      backgroundColor: isDark ? AppColors.borderDark : Colors.grey.shade200,
                    ),
                    AppSpacing.gapH8,
                    Text(
                      'Scanning... $scanned/$total addresses',
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              NetworkScanComplete(:final devices) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: devices.isEmpty
                    ? Text(
                        'No devices found on the network',
                        style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey.shade600),
                      )
                    : Column(
                        children: devices.map((d) => _DetectedDeviceRow(device: d, isDark: isDark)).toList(),
                      ),
              ),

              NetworkScanError(:final message) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(message, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _DetectedDeviceRow extends StatelessWidget {
  const _DetectedDeviceRow({required this.device, required this.isDark});

  final DetectedDevice device;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(device.connectionType == 'network' ? Icons.wifi : Icons.usb, size: 18, color: AppColors.info),
          AppSpacing.gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                if (device.address != null)
                  Text(
                    '${device.address}${device.port != null ? ':${device.port}' : ''}',
                    style: AppTypography.micro.copyWith(
                      color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
            child: Text(device.type.value.replaceAll('_', ' '), style: AppTypography.micro.copyWith(color: AppColors.info)),
          ),
        ],
      ),
    );
  }
}

// ─── Internal data class ───────────────────────────────────
class _DeviceInfo {
  final HardwareConfiguration config;
  final PeripheralStatus? status;

  const _DeviceInfo({required this.config, this.status});
}
