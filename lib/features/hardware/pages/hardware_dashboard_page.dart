import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/providers/hardware_state.dart';
import 'package:wameedpos/features/hardware/widgets/certified_hardware_list.dart';
import 'package:wameedpos/features/hardware/widgets/connected_devices_panel.dart';
import 'package:wameedpos/features/hardware/widgets/device_config_card.dart';
import 'package:wameedpos/features/hardware/widgets/event_log_list.dart';

class HardwareDashboardPage extends ConsumerStatefulWidget {
  const HardwareDashboardPage({super.key});

  @override
  ConsumerState<HardwareDashboardPage> createState() => _HardwareDashboardPageState();
}

class _HardwareDashboardPageState extends ConsumerState<HardwareDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(hardwareConfigListProvider.notifier).load();
      ref.read(supportedModelsProvider.notifier).load();
      ref.read(eventLogListProvider.notifier).load(perPage: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final configState = ref.watch(hardwareConfigListProvider);
    final modelsState = ref.watch(supportedModelsProvider);
    final logsState = ref.watch(eventLogListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.hardwareManagement)),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(hardwareConfigListProvider.notifier).load();
          await ref.read(eventLogListProvider.notifier).load(perPage: 10);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Connected Devices ──
              Text(l10n.hardwareConnected, style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              const ConnectedDevicesPanel(),

              AppSpacing.gapH24,

              // ── Configured Devices ──
              Text(l10n.hardwareConfiguredDevices, style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              _buildConfigList(configState),

              AppSpacing.gapH24,

              // ── Device Test ──
              _buildTestSection(),

              AppSpacing.gapH24,

              // ── Certified Hardware ──
              Text(l10n.hardwareSupportedHardware, style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              _buildSupportedModels(modelsState),

              AppSpacing.gapH24,

              // ── Event Logs ──
              Text(l10n.hardwareRecentEvents, style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              _buildEventLogs(logsState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigList(HardwareConfigListState state) {
    return switch (state) {
      HardwareConfigListInitial() || HardwareConfigListLoading() => const Center(child: CircularProgressIndicator()),
      HardwareConfigListLoaded(:final configs) =>
        configs.isEmpty
            ? Card(
                child: Padding(
                  padding: AppSpacing.paddingAll24,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.hardwareNoDevicesConfigured,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              )
            : Column(
                children: configs
                    .map(
                      (c) => DeviceConfigCard(
                        config: c,
                        onTest: () => ref
                            .read(deviceTestProvider.notifier)
                            .test(
                              terminalId: c.terminalId,
                              deviceType: c.deviceType.value,
                              connectionType: c.connectionType.value,
                            ),
                        onRemove: () => ref.read(hardwareConfigListProvider.notifier).remove(c.id),
                      ),
                    )
                    .toList(),
              ),
      HardwareConfigListError(:final message) => _errorCard(message),
    };
  }

  Widget _buildTestSection() {
    final testState = ref.watch(deviceTestProvider);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: switch (testState) {
          DeviceTestIdle() => Row(
            children: [
              const Icon(Icons.science, size: 20),
              AppSpacing.gapW8,
              Expanded(child: Text(AppLocalizations.of(context)!.hardwareSelectDeviceToTest)),
            ],
          ),
          DeviceTestRunning() => Row(
            children: [
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.hardwareTestingDevice),
            ],
          ),
          DeviceTestSuccess(:final success, :final message) => Row(
            children: [
              Icon(success ? Icons.check_circle : Icons.cancel, color: success ? AppColors.success : AppColors.error),
              AppSpacing.gapW8,
              Expanded(child: Text(message)),
            ],
          ),
          DeviceTestError(:final message) => Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              AppSpacing.gapW8,
              Expanded(
                child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        },
      ),
    );
  }

  Widget _buildSupportedModels(SupportedModelsState state) {
    return switch (state) {
      SupportedModelsInitial() || SupportedModelsLoading() => const Center(child: CircularProgressIndicator()),
      SupportedModelsLoaded(:final models) => CertifiedHardwareList(models: models),
      SupportedModelsError(:final message) => _errorCard(message),
    };
  }

  Widget _buildEventLogs(EventLogListState state) {
    return switch (state) {
      EventLogListInitial() || EventLogListLoading() => const Center(child: CircularProgressIndicator()),
      EventLogListLoaded(:final logs) => EventLogList(logs: logs),
      EventLogListError(:final message) => _errorCard(message),
    };
  }

  Widget _errorCard(String message) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.08),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            AppSpacing.gapW8,
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
