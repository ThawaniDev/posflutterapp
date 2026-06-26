import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/widgets/connected_devices_panel.dart';

/// Hardware page — local only.
///
/// Shows hardware physically connected to this machine or reachable on its
/// local network range. Deliberately backend-free: no stored configuration,
/// no certified-models list, no event logs — just what is connected right now.
class HardwareDashboardPage extends ConsumerWidget {
  const HardwareDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: l10n.hardwareManagement,
      showSearch: false,
      child: RefreshIndicator(
        onRefresh: () => ref.read(networkScanProvider.notifier).scan(),
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingAll16,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ConnectedDevicesPanel()]),
        ),
      ),
    );
  }
}
