import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/hardware/enums/connection_type.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Dialog for adding or editing a hardware device configuration
class DeviceSetupDialog extends StatefulWidget {
  const DeviceSetupDialog({
    super.key,
    this.initialDeviceType,
    this.initialConnectionType,
    this.initialDeviceName,
    this.initialConfigJson,
    this.isEditing = false,
  });

  final HardwareDeviceType? initialDeviceType;
  final ConnectionType? initialConnectionType;
  final String? initialDeviceName;
  final Map<String, dynamic>? initialConfigJson;
  final bool isEditing;

  @override
  State<DeviceSetupDialog> createState() => _DeviceSetupDialogState();
}

class _DeviceSetupDialogState extends State<DeviceSetupDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late HardwareDeviceType _selectedType;
  late ConnectionType _selectedConnection;
  late TextEditingController _nameController;
  late TextEditingController _ipController;
  late TextEditingController _portController;
  late TextEditingController _comPortController;
  late TextEditingController _baudRateController;

  // Receipt printer specific
  int _paperWidth = 80;
  bool _autoCut = true;

  // Scale specific
  String _scaleUnit = 'kg';
  int _decimalPlaces = 3;

  // Card terminal specific
  String _terminalProvider = 'nearpay';
  String _terminalEnvironment = 'sandbox';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialDeviceType ?? HardwareDeviceType.receiptPrinter;
    _selectedConnection = widget.initialConnectionType ?? ConnectionType.network;
    _nameController = TextEditingController(text: widget.initialDeviceName ?? '');

    final json = widget.initialConfigJson ?? {};
    _ipController = TextEditingController(text: json['ip'] as String? ?? '');
    _portController = TextEditingController(text: (json['port'] ?? 9100).toString());
    _comPortController = TextEditingController(text: json['com_port'] as String? ?? 'COM3');
    _baudRateController = TextEditingController(text: (json['baud_rate'] ?? 9600).toString());
    _paperWidth = json['paper_width'] as int? ?? 80;
    _autoCut = json['auto_cut'] as bool? ?? true;
    _scaleUnit = json['unit'] as String? ?? 'kg';
    _decimalPlaces = json['decimal_places'] as int? ?? 3;
    _terminalProvider = json['provider'] as String? ?? 'nearpay';
    _terminalEnvironment = json['environment'] as String? ?? 'sandbox';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _comPortController.dispose();
    _baudRateController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildConfigJson() {
    final config = <String, dynamic>{};
    switch (_selectedType) {
      case HardwareDeviceType.receiptPrinter:
        config['paper_width'] = _paperWidth;
        config['auto_cut'] = _autoCut;
        if (_selectedConnection == ConnectionType.network) {
          config['ip'] = _ipController.text;
          config['port'] = int.tryParse(_portController.text) ?? 9100;
        }
      case HardwareDeviceType.labelPrinter:
        if (_selectedConnection == ConnectionType.network) {
          config['ip'] = _ipController.text;
          config['port'] = int.tryParse(_portController.text) ?? 9100;
        }
        config['language'] = 'zpl';
      case HardwareDeviceType.weighingScale:
        config['com_port'] = _comPortController.text;
        config['baud_rate'] = int.tryParse(_baudRateController.text) ?? 9600;
        config['unit'] = _scaleUnit;
        config['decimal_places'] = _decimalPlaces;
      case HardwareDeviceType.barcodeScanner:
        config['connection_type'] = _selectedConnection.value;
        if (_selectedConnection == ConnectionType.serial) {
          config['com_port'] = _comPortController.text;
        }
      case HardwareDeviceType.cashDrawer:
        config['trigger_method'] = 'printer_kick';
        config['pin'] = 0;
        config['pulse_on'] = 100;
        config['pulse_off'] = 100;
      case HardwareDeviceType.customerDisplay:
        config['display_type'] = _selectedConnection == ConnectionType.serial ? 'pole_display' : 'secondary_screen';
        if (_selectedConnection == ConnectionType.serial) {
          config['com_port'] = _comPortController.text;
          config['baud_rate'] = int.tryParse(_baudRateController.text) ?? 9600;
        }
      case HardwareDeviceType.cardTerminal:
        config['provider'] = _terminalProvider;
        config['environment'] = _terminalEnvironment;
        if (_selectedConnection == ConnectionType.network) {
          config['ip_address'] = _ipController.text;
          config['port'] = int.tryParse(_portController.text) ?? 8443;
        }
      case HardwareDeviceType.nfcReader:
        config['connection_type'] = _selectedConnection.value;
        config['purpose'] = 'staff_badge';
        config['continuous_read'] = true;
    }
    return config;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: AppSpacing.paddingAll16,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.devices_other, color: AppColors.primary),
                  AppSpacing.gapW8,
                  Text(
                    widget.isEditing ? l10n.hardwareEditDevice : l10n.hardwareAddDevice,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),

            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Type
                    if (!widget.isEditing) ...[
                      Text(l10n.hwDeviceType, style: theme.textTheme.labelLarge),
                      AppSpacing.gapH8,
                      PosSearchableDropdown<HardwareDeviceType>(
                        hint: l10n.selectDeviceType,
                        items: HardwareDeviceType.values.map((t) {
                          return PosDropdownItem(value: t, label: _deviceLabel(t));
                        }).toList(),
                        selectedValue: _selectedType,
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedType = v);
                        },
                        showSearch: false,
                        clearable: false,
                      ),
                      AppSpacing.gapH16,
                    ],

                    // Device Name
                    Text(l10n.hwDeviceName, style: theme.textTheme.labelLarge),
                    AppSpacing.gapH8,
                    PosTextField(controller: _nameController, hint: l10n.hwDeviceNameHint),
                    AppSpacing.gapH16,

                    // Connection Type
                    Text(l10n.hwConnection, style: theme.textTheme.labelLarge),
                    AppSpacing.gapH8,
                    Wrap(
                      spacing: 8,
                      children: _allowedConnections(_selectedType).map((c) {
                        return ChoiceChip(
                          label: Text(c.value.toUpperCase()),
                          selected: _selectedConnection == c,
                          onSelected: (_) => setState(() => _selectedConnection = c),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                    AppSpacing.gapH16,

                    // Dynamic config fields
                    ..._buildConfigFields(theme),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: AppSpacing.paddingAll16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PosButton(onPressed: () => Navigator.of(context).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
                  AppSpacing.gapW8,
                  PosButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'device_type': _selectedType.value,
                        'connection_type': _selectedConnection.value,
                        'device_name': _nameController.text.isEmpty ? null : _nameController.text,
                        'config_json': _buildConfigJson(),
                      });
                    },
                    icon: Icons.save,
                    label: widget.isEditing ? l10n.update : l10n.hardwareAddDevice,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConfigFields(ThemeData theme) {
    final fields = <Widget>[];

    // Network fields: IP + Port
    if (_selectedConnection == ConnectionType.network) {
      fields.addAll([
        Text(l10n.hwIpAddress, style: theme.textTheme.labelLarge),
        AppSpacing.gapH8,
        PosTextField(controller: _ipController, hint: l10n.hwIpAddressHint, keyboardType: TextInputType.number),
        AppSpacing.gapH12,
        Text(l10n.hwPort, style: theme.textTheme.labelLarge),
        AppSpacing.gapH8,
        PosTextField(controller: _portController, hint: l10n.hwPortHint, keyboardType: TextInputType.number),
        AppSpacing.gapH16,
      ]);
    }

    // Serial fields: COM Port + Baud Rate
    if (_selectedConnection == ConnectionType.serial) {
      fields.addAll([
        Text(l10n.hwComPort, style: theme.textTheme.labelLarge),
        AppSpacing.gapH8,
        PosTextField(controller: _comPortController, hint: l10n.hwComPortHint),
        AppSpacing.gapH12,
        Text(l10n.hwBaudRate, style: theme.textTheme.labelLarge),
        AppSpacing.gapH8,
        PosSearchableDropdown<int>(
          hint: l10n.selectBaudRate,
          items: [2400, 4800, 9600, 19200, 38400, 57600, 115200].map((b) {
            return PosDropdownItem(value: b, label: '$b');
          }).toList(),
          selectedValue: int.tryParse(_baudRateController.text) ?? 9600,
          onChanged: (v) {
            if (v != null) _baudRateController.text = v.toString();
          },
          showSearch: false,
          clearable: false,
        ),
        AppSpacing.gapH16,
      ]);
    }

    // Type-specific fields
    switch (_selectedType) {
      case HardwareDeviceType.receiptPrinter:
        fields.addAll([
          Text(l10n.hwPaperWidth, style: theme.textTheme.labelLarge),
          AppSpacing.gapH8,
          SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 58, label: Text(l10n.hardware58mm)),
              ButtonSegment(value: 80, label: Text(l10n.hardware80mm)),
            ],
            selected: {_paperWidth},
            onSelectionChanged: (v) => setState(() => _paperWidth = v.first),
          ),
          AppSpacing.gapH12,
          SwitchListTile(
            title: Text(l10n.hwAutoCutAfterPrint),
            value: _autoCut,
            onChanged: (v) => setState(() => _autoCut = v),
            contentPadding: EdgeInsets.zero,
          ),
        ]);
      case HardwareDeviceType.weighingScale:
        fields.addAll([
          Text(l10n.hwWeightUnit, style: theme.textTheme.labelLarge),
          AppSpacing.gapH8,
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'kg', label: Text(l10n.hardwareKg)),
              const ButtonSegment(value: 'g', label: Text('g')),
              ButtonSegment(value: 'lb', label: Text(l10n.hardwareLb)),
            ],
            selected: {_scaleUnit},
            onSelectionChanged: (v) => setState(() => _scaleUnit = v.first),
          ),
          AppSpacing.gapH12,
          Text(l10n.hwDecimalPlaces, style: theme.textTheme.labelLarge),
          AppSpacing.gapH8,
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('1')),
              ButtonSegment(value: 2, label: Text('2')),
              ButtonSegment(value: 3, label: Text('3')),
            ],
            selected: {_decimalPlaces},
            onSelectionChanged: (v) => setState(() => _decimalPlaces = v.first),
          ),
        ]);
      case HardwareDeviceType.cardTerminal:
        fields.addAll([
          Text(l10n.hwProvider, style: theme.textTheme.labelLarge),
          AppSpacing.gapH8,
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'nearpay', label: Text(l10n.hardwareNearPay)),
              ButtonSegment(value: 'nexo', label: Text(l10n.hardwareNexo)),
            ],
            selected: {_terminalProvider},
            onSelectionChanged: (v) => setState(() => _terminalProvider = v.first),
          ),
          AppSpacing.gapH12,
          Text(l10n.hwEnvironment, style: theme.textTheme.labelLarge),
          AppSpacing.gapH8,
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'sandbox', label: Text(l10n.sandbox)),
              ButtonSegment(value: 'production', label: Text(l10n.production)),
            ],
            selected: {_terminalEnvironment},
            onSelectionChanged: (v) => setState(() => _terminalEnvironment = v.first),
          ),
        ]);
      default:
        break;
    }

    return fields;
  }

  List<ConnectionType> _allowedConnections(HardwareDeviceType type) => switch (type) {
    HardwareDeviceType.receiptPrinter => [ConnectionType.usb, ConnectionType.network, ConnectionType.bluetooth],
    HardwareDeviceType.barcodeScanner => [ConnectionType.usb, ConnectionType.bluetooth, ConnectionType.serial],
    HardwareDeviceType.cashDrawer => [ConnectionType.usb],
    HardwareDeviceType.customerDisplay => [ConnectionType.serial, ConnectionType.usb],
    HardwareDeviceType.weighingScale => [ConnectionType.serial, ConnectionType.usb],
    HardwareDeviceType.labelPrinter => [ConnectionType.usb, ConnectionType.network],
    HardwareDeviceType.cardTerminal => [ConnectionType.usb, ConnectionType.network, ConnectionType.bluetooth],
    HardwareDeviceType.nfcReader => [ConnectionType.usb],
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
}
