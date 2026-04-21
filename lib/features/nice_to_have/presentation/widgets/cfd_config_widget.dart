import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_providers.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_state.dart';

class CfdConfigWidget extends ConsumerWidget {
  const CfdConfigWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cfdConfigProvider);
    return switch (state) {
      CfdConfigInitial() || CfdConfigLoading() => const Center(child: CircularProgressIndicator()),
      CfdConfigError(:final message) => Center(
        child: Text(AppLocalizations.of(context)!.genericError(message), style: const TextStyle(color: AppColors.error)),
      ),
      CfdConfigLoaded(:final config) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.cfdEnabled),
              value: config['is_enabled'] == true,
              onChanged: null,
            ),
            AppSpacing.gapH12,
            ListTile(
              title: Text(AppLocalizations.of(context)!.cfdTargetMonitor),
              subtitle: Text(config['target_monitor']?.toString() ?? 'secondary'),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.cfdIdleRotation),
              subtitle: Text(config['idle_rotation_seconds']?.toString() ?? '10'),
            ),
          ],
        ),
      ),
    };
  }
}
