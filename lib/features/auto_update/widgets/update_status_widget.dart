import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_providers.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';

class UpdateStatusWidget extends ConsumerWidget {
  const UpdateStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateCheckProvider);
    final theme = Theme.of(context);

    return switch (state) {
      UpdateCheckInitial() => const Center(child: Text('Tap to check for updates')),
      UpdateCheckLoading() => const Center(child: CircularProgressIndicator()),
      UpdateCheckError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      final UpdateCheckLoaded s => Card(
        margin: AppSpacing.paddingAll16,
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    s.updateAvailable ? Icons.system_update : Icons.check_circle,
                    color: s.updateAvailable ? theme.colorScheme.primary : AppColors.success,
                    size: 32,
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(
                      s.updateAvailable ? 'Update Available: v${s.latestVersion}' : 'Up to date',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              if (s.isForceUpdate) ...[
                AppSpacing.gapH8,
                Chip(label: const Text('Required Update'), backgroundColor: theme.colorScheme.errorContainer),
              ],
              if (s.releaseNotes != null) ...[AppSpacing.gapH12, Text(s.releaseNotes!, style: theme.textTheme.bodyMedium)],
            ],
          ),
        ),
      ),
    };
  }
}
