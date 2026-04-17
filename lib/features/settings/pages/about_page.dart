import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// About page — version info, legal text, and support links.
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PosFormPage(
      title: l10n.settingsAbout,
      child: Column(
        children: [
          AppSpacing.gapH24,
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderXxl,
            ),
            child: Icon(Icons.point_of_sale, size: 40, color: theme.colorScheme.primary),
          ),
          AppSpacing.gapH16,
          Text(l10n.appTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          AppSpacing.gapH4,
          Text(l10n.settingsAboutVersion('1.0.0'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
          AppSpacing.gapH24,
          PosCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.settingsAboutTerms),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.settingsAboutPrivacy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(l10n.settingsAboutLicenses),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showLicensePage(context: context, applicationName: 'Wameed POS', applicationVersion: '1.0.0'),
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          PosCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: Text(l10n.settingsAboutSupport),
                  subtitle: Text(l10n.settingsAboutSupportDesc),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          AppSpacing.gapH24,
          Text(
            l10n.settingsAboutCopyright(DateTime.now().year.toString()),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
