import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_providers.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class UpdateStatusWidget extends ConsumerWidget {
  const UpdateStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(updateCheckProvider);
    final theme = Theme.of(context);

    return switch (state) {
      UpdateCheckInitial() => Center(child: Text(l10n.auTapToCheck)),
      UpdateCheckLoading() => const PosLoading(),
      UpdateCheckError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      final UpdateCheckLoaded s => PosCard(
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
                Chip(label: Text(l10n.autoUpdateRequired), backgroundColor: theme.colorScheme.errorContainer),
              ],
              if (s.releaseNotes != null) ...[AppSpacing.gapH12, Text(s.releaseNotes!, style: theme.textTheme.bodyMedium)],
              if (s.updateAvailable) ...[
                AppSpacing.gapH16,
                SizedBox(
                  width: double.infinity,
                  child: PosButton(
                    onPressed: () => _openStore(s.storeUrl ?? s.downloadUrl),
                    icon: Icons.download,
                    label: s.isForceUpdate ? 'Update Now (Required)' : 'Update Now',
                    isFullWidth: true,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    };
  }

  Future<void> _openStore(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
