import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_providers.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_state.dart';
import 'package:thawani_pos/features/hardware/widgets/certified_hardware_list.dart';
import 'package:thawani_pos/features/hardware/widgets/device_config_card.dart';
import 'package:thawani_pos/features/hardware/widgets/event_log_list.dart';

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
    final theme = Theme.of(context);
    final configState = ref.watch(hardwareConfigListProvider);
    final modelsState = ref.watch(supportedModelsProvider);
    final logsState = ref.watch(eventLogListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hardware Management')),
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
              // ── Configured Devices ──
              Text('Configured Devices', style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              _buildConfigList(configState),

              AppSpacing.gapH24,

              // ── Device Test ──
              _buildTestSection(),

              AppSpacing.gapH24,

              // ── Certified Hardware ──
              Text('Supported Hardware', style: theme.textTheme.titleMedium),
              AppSpacing.gapH12,
              _buildSupportedModels(modelsState),

              AppSpacing.gapH24,

              // ── Event Logs ──
              Text('Recent Events', style: theme.textTheme.titleMedium),
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
                      'No devices configured',
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
              const Expanded(child: Text('Select a device above to test')),
            ],
          ),
          DeviceTestRunning() => const Row(
            children: [
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 8),
              Text('Testing device...'),
            ],
          ),
          DeviceTestSuccess(:final success, :final message) => Row(
            children: [
              Icon(success ? Icons.check_circle : Icons.cancel, color: success ? Colors.green : Colors.red),
              AppSpacing.gapW8,
              Expanded(child: Text(message)),
            ],
          ),
          DeviceTestError(:final message) => Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
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
      color: Colors.red.shade50,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            AppSpacing.gapW8,
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
