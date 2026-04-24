import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/zatca/models/zatca_device.dart';
import 'package:wameedpos/features/zatca/providers/zatca_providers.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

/// ZATCA Phase 2 device management page: provision, activate, and
/// reset tamper for terminal-bound EGS devices.
class ZatcaDeviceActivationPage extends ConsumerStatefulWidget {
  const ZatcaDeviceActivationPage({super.key});

  @override
  ConsumerState<ZatcaDeviceActivationPage> createState() => _ZatcaDeviceActivationPageState();
}

class _ZatcaDeviceActivationPageState extends ConsumerState<ZatcaDeviceActivationPage> {
  final _activationCodeCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zatcaDeviceProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _activationCodeCtrl.dispose();
    _serialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(zatcaDeviceProvider);

    return PosListPage(
      title: l10n.zatcaDeviceActivation,
      showSearch: false,
      child: SingleChildScrollView(
        padding: AppSpacing.paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProvisionSection(context, l10n, state),
            AppSpacing.gapH20,
            _buildActivationForm(l10n),
            AppSpacing.gapH20,
            _buildDeviceList(l10n, state),
          ],
        ),
      ),
    );
  }

  Widget _buildProvisionSection(BuildContext context, AppLocalizations l10n, ZatcaDeviceState state) {
    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.zatcaProvisionDevice, style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.gapH8,
          PosButton(
            label: l10n.zatcaProvisionDevice,
            isFullWidth: true,
            onPressed: state is ZatcaDeviceLoading ? null : () => ref.read(zatcaDeviceProvider.notifier).provision(),
          ),
          if (state is ZatcaDeviceProvisioned) ...[AppSpacing.gapH16, _buildActivationCodeBanner(state)],
        ],
      ),
    );
  }

  Widget _buildActivationCodeBanner(ZatcaDeviceProvisioned state) {
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activation Code', style: Theme.of(context).textTheme.labelLarge),
          AppSpacing.gapH4,
          SelectableText(
            state.activationCode,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          AppSpacing.gapH4,
          Text('Device UUID: ${state.deviceUuid}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildActivationForm(AppLocalizations l10n) {
    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.zatcaActivationCode, style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.gapH8,
          TextField(
            controller: _activationCodeCtrl,
            decoration: InputDecoration(labelText: l10n.zatcaActivationCode, border: const OutlineInputBorder()),
            textCapitalization: TextCapitalization.characters,
          ),
          AppSpacing.gapH8,
          TextField(
            controller: _serialCtrl,
            decoration: const InputDecoration(labelText: 'Hardware Serial (optional)', border: OutlineInputBorder()),
          ),
          AppSpacing.gapH12,
          PosButton(
            label: l10n.zatcaActivateDevice,
            isFullWidth: true,
            onPressed: () {
              ref
                  .read(zatcaDeviceProvider.notifier)
                  .activate(
                    activationCode: _activationCodeCtrl.text.trim(),
                    hardwareSerial: _serialCtrl.text.trim().isEmpty ? null : _serialCtrl.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(AppLocalizations l10n, ZatcaDeviceState state) {
    if (state is ZatcaDeviceListLoaded) {
      if (state.devices.isEmpty) {
        return PosCard(child: Text(l10n.zatcaNoDevices));
      }
      return PosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: state.devices.map((d) => _buildDeviceTile(l10n, d)).toList(growable: false),
        ),
      );
    }
    if (state is ZatcaDeviceLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ZatcaDeviceError) {
      return PosCard(
        child: Text('Error: ${state.message}', style: const TextStyle(color: AppColors.error)),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDeviceTile(AppLocalizations l10n, ZatcaDevice device) {
    final tampered = device.isTampered;
    return ListTile(
      leading: Icon(tampered ? Icons.warning_amber : Icons.verified_user, color: tampered ? AppColors.error : AppColors.success),
      title: Text(device.deviceUuid),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.zatcaIcv}: ${device.currentIcv}'),
          Text('Status: ${device.status.value}'),
          if (device.hardwareSerial != null) Text('Serial: ${device.hardwareSerial}'),
        ],
      ),
      trailing: tampered
          ? TextButton(
              onPressed: () => ref.read(zatcaDeviceProvider.notifier).resetTamper(device.id),
              child: Text(l10n.zatcaResetTamper),
            )
          : null,
    );
  }
}
