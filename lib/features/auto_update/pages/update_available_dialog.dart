import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Dialog shown when a new update is available.
/// Offers: Install Now, Schedule, or Remind Later.
class UpdateAvailableDialog extends StatelessWidget {
  const UpdateAvailableDialog({
    super.key,
    required this.version,
    this.releaseNotes,
    this.releaseNotesAr,
    this.isForceUpdate = false,
    required this.onInstallNow,
    required this.onSchedule,
    required this.onRemindLater,
  });

  final String version;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool isForceUpdate;
  final VoidCallback onInstallNow;
  final VoidCallback onSchedule;
  final VoidCallback onRemindLater;

  static Future<void> show(
    BuildContext context, {
    required String version,
    String? releaseNotes,
    String? releaseNotesAr,
    bool isForceUpdate = false,
    required VoidCallback onInstallNow,
    required VoidCallback onSchedule,
    required VoidCallback onRemindLater,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (_) => UpdateAvailableDialog(
        version: version,
        releaseNotes: releaseNotes,
        releaseNotesAr: releaseNotesAr,
        isForceUpdate: isForceUpdate,
        onInstallNow: onInstallNow,
        onSchedule: onSchedule,
        onRemindLater: onRemindLater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final notes = isArabic && releaseNotesAr != null ? releaseNotesAr! : releaseNotes;

    return AlertDialog(
      icon: Icon(
        isForceUpdate ? Icons.warning_amber_rounded : Icons.system_update,
        color: isForceUpdate ? AppColors.error : theme.colorScheme.primary,
        size: 48,
      ),
      title: Text(isForceUpdate ? l10n.autoUpdateRequired : l10n.autoUpdateAvailable, textAlign: TextAlign.center),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('v$version', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ),
            if (isForceUpdate) ...[
              AppSpacing.gapH12,
              Container(
                padding: AppSpacing.paddingAll8,
                decoration: BoxDecoration(color: AppColors.error.withAlpha(20), borderRadius: AppRadius.borderMd),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.error, size: 16),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(l10n.autoUpdateForceDesc, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
            ],
            if (notes != null) ...[
              AppSpacing.gapH16,
              Text(l10n.autoUpdateWhatsNew, style: theme.textTheme.titleSmall),
              AppSpacing.gapH8,
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(child: Text(notes, style: theme.textTheme.bodyMedium)),
              ),
            ],
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (!isForceUpdate)
          PosButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRemindLater();
            },
            variant: PosButtonVariant.ghost,
            label: l10n.autoUpdateRemindLater,
          ),
        if (!isForceUpdate)
          PosButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSchedule();
            },
            variant: PosButtonVariant.outline,
            label: l10n.autoUpdateSchedule,
          ),
        PosButton(
          icon: Icons.download,
          label: l10n.autoUpdateInstallNow,
          onPressed: () {
            Navigator.of(context).pop();
            onInstallNow();
          },
        ),
      ],
    );
  }
}
