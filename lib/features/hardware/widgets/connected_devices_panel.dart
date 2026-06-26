import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/providers/hardware_state.dart';
import 'package:wameedpos/features/hardware/services/hardware_auto_detector.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Local-only hardware panel.
///
/// Shows peripherals connected to THIS machine or discoverable on its local
/// network range. Intentionally backend-free: no account, no stored
/// configuration, no remote APIs — only what is physically reachable now.
class ConnectedDevicesPanel extends ConsumerStatefulWidget {
  const ConnectedDevicesPanel({super.key});

  @override
  ConsumerState<ConnectedDevicesPanel> createState() => _ConnectedDevicesPanelState();
}

class _ConnectedDevicesPanelState extends ConsumerState<ConnectedDevicesPanel> {
  @override
  void initState() {
    super.initState();
    // Auto-discover on first open. Only start a scan when idle so we don't
    // restart one already running or re-run after returning to the page.
    Future.microtask(() {
      if (!mounted) return;
      if (ref.read(networkScanProvider) is NetworkScanIdle) {
        ref.read(networkScanProvider.notifier).scan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scanState = ref.watch(networkScanProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Intro: explains this is a local-only view ──
        _IntroBanner(isDark: isDark),

        AppSpacing.gapH16,

        // ── Local input device: keyboard-wedge / HID barcode scanner ──
        _KeyboardWedgeScannerCard(isDark: isDark),

        AppSpacing.gapH12,

        // ── Devices reachable on this machine's local network ──
        _NetworkDevicesCard(scanState: scanState, isDark: isDark),

        AppSpacing.gapH12,

        // ── Bluetooth-paired peripherals ──
        _BluetoothDevicesCard(scanState: scanState, isDark: isDark),
      ],
    );
  }
}

// ─── Local & Network Devices ───────────────────────────────────────────
class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: AppColors.info.withValues(alpha: isDark ? 0.12 : 0.06),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lan_outlined, size: 20, color: AppColors.info),
            AppSpacing.gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hardwareLocalDevicesTitle, style: AppTypography.titleSmall),
                  AppSpacing.gapH4,
                  Text(
                    l10n.hardwareLocalDevicesHint,
                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Network Devices ──────────────────────────────────
class _NetworkDevicesCard extends ConsumerWidget {
  const _NetworkDevicesCard({required this.scanState, required this.isDark});

  final NetworkScanState scanState;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subnet = ref.watch(detectedSubnetProvider).valueOrNull;
    final isRunning = scanState is NetworkScanRunning;

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radar, size: 20, color: isDark ? AppColors.textMutedDark : Colors.grey.shade700),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.networkDiscovery, style: AppTypography.titleSmall),
                      if (subnet != null)
                        Text(
                          l10n.hardwareScanningRange(subnet),
                          style: AppTypography.micro.copyWith(
                            color: isDark ? AppColors.textMutedDark : Colors.grey.shade500,
                            fontFamily: 'monospace',
                          ),
                        ),
                    ],
                  ),
                ),
                if (isRunning)
                  const SizedBox(width: 20, height: 20, child: PosLoading(size: 20))
                else
                  PosButton(
                    onPressed: () => ref.read(networkScanProvider.notifier).scan(),
                    variant: PosButtonVariant.ghost,
                    icon: Icons.refresh,
                    label: scanState is NetworkScanComplete ? l10n.hardwareRescan : l10n.hardwareScan,
                  ),
              ],
            ),

            switch (scanState) {
              NetworkScanIdle() => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.hardwareNetworkScanHint,
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade600),
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
                      l10n.hardwareScanningProgress(scanned.toString(), total.toString()),
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              NetworkScanComplete(:final devices) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: devices.isEmpty
                    ? Row(
                        children: [
                          Icon(Icons.search_off, size: 18, color: isDark ? AppColors.textMutedDark : Colors.grey.shade500),
                          AppSpacing.gapW8,
                          Expanded(
                            child: Text(
                              l10n.hardwareNoNetworkDevices,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
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
                      color: isDark ? AppColors.textMutedDark : Colors.grey.shade500,
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

// ─── Keyboard-wedge Barcode Scanner Card ───────────────────
class _KeyboardWedgeScannerCard extends ConsumerWidget {
  const _KeyboardWedgeScannerCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scanner = ref.read(hardwareManagerProvider).barcodeScanner;
    final isListening = scanner.isListening;
    // A keyboard-wedge listener being active is an app *input capability*, not a
    // connected hardware device, so present it with a neutral/informational
    // indicator rather than a green "connected" style.
    const activeColor = AppColors.info;

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF5C6BC0).withValues(alpha: isDark ? 0.15 : 0.08),
              border: Border(bottom: BorderSide(color: const Color(0xFF5C6BC0).withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner, size: 20, color: Color(0xFF5C6BC0)),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    l10n.hardwareKeyboardWedgeTitle,
                    style: AppTypography.titleSmall.copyWith(color: const Color(0xFF5C6BC0)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.keyboard, size: 22, color: isDark ? AppColors.textMutedDark : Colors.grey.shade600),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kIsWeb ? l10n.hardwareHidScanner : l10n.hardwareUsbKeyboardWedge,
                        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        isListening ? l10n.hardwareWedgeActiveHint : l10n.hardwareWedgeInactiveHint,
                        style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isListening ? Icons.radio_button_checked : Icons.circle_outlined,
                      size: 12,
                      color: isListening ? activeColor : (AppColors.mutedFor(context)),
                    ),
                    AppSpacing.gapW4,
                    Text(
                      isListening ? l10n.hardwareWedgeReady : l10n.hardwareInactive,
                      style: AppTypography.micro.copyWith(
                        color: isListening ? activeColor : (AppColors.mutedFor(context)),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// (Removed config-based device list — this panel is local-discovery only.)

// ─── Bluetooth Devices Card ──────────────────────────────

class _BluetoothDevicesCard extends StatelessWidget {
  const _BluetoothDevicesCard({required this.scanState, required this.isDark});

  final NetworkScanState scanState;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Only extract BT devices when a scan has finished.
    final btDevices = switch (scanState) {
      NetworkScanComplete(:final devices) => devices.where((d) => d.connectionType == 'bluetooth').toList(),
      _ => <DetectedDevice>[],
    };

    // Show nothing during idle/running (BT appears as soon as scan completes).
    if (scanState is NetworkScanIdle || scanState is NetworkScanRunning) {
      return const SizedBox.shrink();
    }

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bluetooth, size: 20, color: isDark ? AppColors.textMutedDark : Colors.grey.shade700),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.hardwareBluetoothDevices, style: AppTypography.titleSmall),
                      Text(
                        l10n.hardwareBluetoothHint,
                        style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (btDevices.isEmpty)
              Row(
                children: [
                  Icon(Icons.bluetooth_disabled, size: 18, color: isDark ? AppColors.textMutedDark : Colors.grey.shade500),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      l10n.hardwareNoBluetooth,
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : Colors.grey.shade600),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: btDevices.map((d) => _DetectedDeviceRow(device: d, isDark: isDark)).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
