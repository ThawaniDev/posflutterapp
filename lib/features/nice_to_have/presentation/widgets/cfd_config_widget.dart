import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import '../nice_to_have_providers.dart';
import '../nice_to_have_state.dart';

class CfdConfigWidget extends ConsumerWidget {
  const CfdConfigWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cfdConfigProvider);
    return switch (state) {
      CfdConfigInitial() || CfdConfigLoading() => const Center(child: CircularProgressIndicator()),
      CfdConfigError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
      ),
      CfdConfigLoaded(:final config) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(title: const Text('CFD Enabled'), value: config['is_enabled'] == true, onChanged: null),
            AppSpacing.gapH12,
            ListTile(title: const Text('Target Monitor'), subtitle: Text(config['target_monitor']?.toString() ?? 'secondary')),
            ListTile(
              title: const Text('Idle Rotation (seconds)'),
              subtitle: Text(config['idle_rotation_seconds']?.toString() ?? '10'),
            ),
          ],
        ),
      ),
    };
  }
}
