import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/providers/hardware_state.dart';
import 'package:wameedpos/features/hardware/services/hardware_auto_detector.dart' show DetectedDevice;
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart';
import 'package:wameedpos/features/softpos/providers/softpos_providers.dart';

/// Opens the cashier-facing hardware setup sheet.
///
/// Use [showPosHardwareSetupSheet] to display it from anywhere in the POS flow.
Future<void> showPosHardwareSetupSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _HardwareSetupSheet(),
  );
}

class _HardwareSetupSheet extends ConsumerStatefulWidget {
  const _HardwareSetupSheet();

  @override
  ConsumerState<_HardwareSetupSheet> createState() => _HardwareSetupSheetState();
}

class _HardwareSetupSheetState extends ConsumerState<_HardwareSetupSheet> {
  @override
  void initState() {
    super.initState();
    // Auto-start a scan if one isn't already running.
    Future.microtask(() {
      if (!mounted) return;
      final state = ref.read(networkScanProvider);
      if (state is NetworkScanIdle) {
        ref.read(networkScanProvider.notifier).scan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── Drag handle ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderFor(context), borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // ── Header ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.print_rounded, color: AppColors.primary, size: 20),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.posHardwareSetup, style: AppTypography.titleMedium),
                        Text(
                          l10n.posHardwareSetupSubtitle,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Scrollable body ──────────────────────────────────────
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Active Printer ─────────────────────────────────
                  _ActivePrinterCard(isDark: isDark),
                  AppSpacing.gapH12,

                  // ── Network / BT scan ──────────────────────────────
                  _ScanCard(isDark: isDark),
                  AppSpacing.gapH12,

                  // ── Barcode Scanner ────────────────────────────────
                  _BarcodeScannerCard(isDark: isDark),
                  AppSpacing.gapH12,

                  // ── EdfaPay Device ID ──────────────────────────────
                  _EdfaPayDeviceIdCard(isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Active Printer Card ───────────────────────────────────────────────────

class _ActivePrinterCard extends ConsumerWidget {
  const _ActivePrinterCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final active = ref.watch(activePrinterProvider);
    final scanState = ref.watch(networkScanProvider);

    // Build full list of available printers for the picker.
    final builtIn = ref.watch(builtInPrinterProvider).valueOrNull;
    final detected = switch (scanState) {
      NetworkScanComplete(:final devices) => devices.where((d) => d.type == HardwareDeviceType.receiptPrinter).toList(),
      _ => <DetectedDevice>[],
    };

    final options = <_PrinterItem>[
      if (builtIn != null) _PrinterItem(selection: builtIn, icon: Icons.print_rounded),
      for (final d in detected.where((d) => d.connectionType == 'network'))
        _PrinterItem(
          selection: PrinterSelection(
            label: d.name,
            config: PrinterConfig(connectionType: 'network', ipAddress: d.address, port: d.port ?? 9100),
          ),
          icon: Icons.wifi_rounded,
        ),
      for (final d in detected.where((d) => d.connectionType == 'bluetooth'))
        _PrinterItem(
          selection: PrinterSelection(
            label: d.name,
            config: PrinterConfig(connectionType: 'bluetooth', bluetoothAddress: d.address),
          ),
          icon: Icons.bluetooth_rounded,
        ),
    ];

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
                const Icon(Icons.print_rounded, size: 18, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(l10n.posSelectPrinter, style: AppTypography.titleSmall),
              ],
            ),
            AppSpacing.gapH12,

            if (active == null && options.isEmpty)
              // No printer found at all — prompt to scan
              Row(
                children: [
                  Icon(Icons.print_disabled_outlined, size: 18, color: AppColors.mutedFor(context)),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      l10n.posNoPrinterDetected,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                    ),
                  ),
                ],
              )
            else ...[
              // Auto-select indicator
              _PrinterOptionTile(
                label: 'Auto-select',
                subtitle: active?.label ?? l10n.posNoPrinterDetected,
                icon: Icons.auto_awesome_rounded,
                selected: ref.watch(selectedPrinterProvider) == null,
                isDark: isDark,
                onTap: () => ref.read(selectedPrinterProvider.notifier).state = null,
              ),
              if (options.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.borderFor(context)),
                ),
                ...options.map(
                  (item) => _PrinterOptionTile(
                    label: item.selection.label,
                    subtitle: _connectionLabel(item.selection.config),
                    icon: item.icon,
                    selected: ref.watch(selectedPrinterProvider)?.label == item.selection.label,
                    isDark: isDark,
                    onTap: () => ref.read(selectedPrinterProvider.notifier).state = item.selection,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _connectionLabel(PrinterConfig cfg) {
    if (cfg.connectionType == 'bluetooth') return 'Bluetooth · ${cfg.bluetoothAddress ?? ''}';
    if (cfg.connectionType == 'network') return 'Network · ${cfg.ipAddress ?? ''}:${cfg.port}';
    return 'USB · ${cfg.usbDevicePath ?? ''}';
  }
}

class _PrinterOptionTile extends StatelessWidget {
  const _PrinterOptionTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppColors.primary : AppColors.mutedFor(context)),
            AppSpacing.gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? AppColors.primary : null,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: AppTypography.micro.copyWith(
                        color: isDark ? AppColors.textMutedDark : Colors.grey.shade500,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Scan Card ─────────────────────────────────────────────────────────────

class _ScanCard extends ConsumerWidget {
  const _ScanCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scanState = ref.watch(networkScanProvider);
    final subnet = ref.watch(detectedSubnetProvider).valueOrNull;
    final isRunning = scanState is NetworkScanRunning;

    final allDevices = switch (scanState) {
      NetworkScanComplete(:final devices) => devices,
      _ => <DetectedDevice>[],
    };
    final networkDevices = allDevices.where((d) => d.connectionType == 'network').toList();
    final btDevices = allDevices.where((d) => d.connectionType == 'bluetooth').toList();

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Icon(Icons.radar_rounded, size: 18, color: isDark ? AppColors.textMutedDark : Colors.grey.shade700),
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
                    icon: Icons.refresh_rounded,
                    label: scanState is NetworkScanComplete ? l10n.hardwareRescan : l10n.hardwareScan,
                    size: PosButtonSize.sm,
                  ),
              ],
            ),

            // Progress / results
            if (isRunning) ...[
              AppSpacing.gapH8,
              LinearProgressIndicator(
                value: scanState.total > 0 ? scanState.scanned / scanState.total : null,
                backgroundColor: isDark ? AppColors.borderDark : Colors.grey.shade200,
              ),
              AppSpacing.gapH4,
              Text(
                l10n.hardwareScanningProgress(scanState.scanned.toString(), scanState.total.toString()),
                style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
              ),
            ] else if (scanState is NetworkScanComplete) ...[
              AppSpacing.gapH12,
              // ── Network devices ──
              if (networkDevices.isEmpty)
                _EmptyRow(icon: Icons.wifi_off_rounded, label: l10n.hardwareNoNetworkDevices, isDark: isDark)
              else
                Column(
                  children: networkDevices.map((d) => _DeviceRow(device: d, isDark: isDark)).toList(),
                ),
              // ── Bluetooth devices ──
              AppSpacing.gapH8,
              if (btDevices.isEmpty)
                _EmptyRow(icon: Icons.bluetooth_disabled_rounded, label: l10n.hardwareNoBluetooth, isDark: isDark)
              else
                Column(
                  children: btDevices.map((d) => _DeviceRow(device: d, isDark: isDark)).toList(),
                ),
            ] else if (scanState is NetworkScanError) ...[
              AppSpacing.gapH8,
              Text(scanState.message, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device, required this.isDark});
  final DetectedDevice device;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isBt = device.connectionType == 'bluetooth';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(isBt ? Icons.bluetooth_rounded : Icons.print_rounded, size: 16, color: AppColors.info),
          AppSpacing.gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                if (device.address != null)
                  Text(
                    isBt ? device.address! : '${device.address}:${device.port ?? 9100}',
                    style: AppTypography.micro.copyWith(
                      color: isDark ? AppColors.textMutedDark : Colors.grey.shade500,
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.10), borderRadius: AppRadius.borderSm),
            child: Text(isBt ? 'Bluetooth' : 'Network', style: AppTypography.micro.copyWith(color: AppColors.info)),
          ),
        ],
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.icon, required this.label, required this.isDark});
  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? AppColors.textMutedDark : Colors.grey.shade400),
        AppSpacing.gapW8,
        Expanded(
          child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
        ),
      ],
    );
  }
}

// ─── Barcode Scanner Card ──────────────────────────────────────────────────

class _BarcodeScannerCard extends ConsumerWidget {
  const _BarcodeScannerCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scanner = ref.read(hardwareManagerProvider).barcodeScanner;
    final isListening = scanner.isListening;

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Row(
          children: [
            const Icon(Icons.qr_code_scanner_rounded, size: 20, color: AppColors.info),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hardwareKeyboardWedgeTitle, style: AppTypography.titleSmall),
                  Text(
                    kIsWeb ? l10n.hardwareHidScanner : l10n.hardwareUsbKeyboardWedge,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    isListening ? l10n.hardwareWedgeActiveHint : l10n.hardwareWedgeInactiveHint,
                    style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isListening ? AppColors.info : AppColors.mutedFor(context)).withValues(alpha: 0.12),
                borderRadius: AppRadius.borderSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isListening ? Icons.radio_button_checked : Icons.circle_outlined,
                    size: 10,
                    color: isListening ? AppColors.info : AppColors.mutedFor(context),
                  ),
                  AppSpacing.gapW4,
                  Text(
                    isListening ? l10n.hardwareWedgeReady : l10n.hardwareInactive,
                    style: AppTypography.labelSmall.copyWith(
                      color: isListening ? AppColors.info : AppColors.mutedFor(context),
                      fontWeight: FontWeight.w600,
                    ),
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

// ─── Internal helpers ──────────────────────────────────────────────────────

class _PrinterItem {
  const _PrinterItem({required this.selection, required this.icon});
  final PrinterSelection selection;
  final IconData icon;
}

// ─── EdfaPay Device ID Card ────────────────────────────────────────────────

/// Shows the EdfaPay device ID for this handset so the operator can locate
/// it on the EdfaPay merchant dashboard without sitting at the device.
///
/// The ID is derived from the Android ID:
///   `{androidId[0:8]}-{androidId[8:12]}-{androidId[12:16]}-0000-0000{androidId[8:16]}`
class _EdfaPayDeviceIdCard extends ConsumerWidget {
  const _EdfaPayDeviceIdCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceIdAsync = ref.watch(softPosDeviceIdProvider);

    return PosCard(
      borderRadius: AppRadius.borderMd,
      color: isDark ? AppColors.surfaceDark : null,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Row(
          children: [
            const Icon(Icons.contactless_rounded, size: 20, color: AppColors.primary),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WameedPOS Device ID', style: AppTypography.titleSmall),
                  AppSpacing.gapH4,
                  deviceIdAsync.when(
                    loading: () => const SizedBox(height: 14, width: 14, child: PosLoading(size: 14)),
                    error: (_, __) =>
                        Text('Not available', style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context))),
                    data: (id) => id == null
                        ? Text('Not available', style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)))
                        : SelectableText(
                            id,
                            style: AppTypography.micro.copyWith(
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.textMutedDark : Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
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
