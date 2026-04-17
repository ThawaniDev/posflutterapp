import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.settings,
      showSearch: false,
      child: ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          _SettingsSection(
            title: l10n.settingsGeneral,
            items: [
              _SettingsItem(
                icon: Icons.language,
                title: l10n.settingsLocalization,
                subtitle: l10n.settingsLocalizationDesc,
                onTap: () => context.go(Routes.localization),
              ),
              _SettingsItem(
                icon: Icons.store,
                title: l10n.settingsStoreProfile,
                subtitle: l10n.settingsStoreProfileDesc,
                onTap: () => context.go(Routes.settingsStoreProfile),
              ),
              _SettingsItem(
                icon: Icons.schedule,
                title: l10n.settingsWorkingHours,
                subtitle: l10n.settingsWorkingHoursDesc,
                onTap: () => context.go(Routes.settingsWorkingHours),
              ),
            ],
          ),
          AppSpacing.gapH16,
          _SettingsSection(
            title: l10n.settingsBusiness,
            items: [
              _SettingsItem(
                icon: Icons.receipt_long,
                title: l10n.settingsTax,
                subtitle: l10n.settingsTaxDesc,
                onTap: () => context.go(Routes.settingsTax),
              ),
              _SettingsItem(
                icon: Icons.print,
                title: l10n.settingsReceipt,
                subtitle: l10n.settingsReceiptDesc,
                onTap: () => context.go(Routes.settingsReceipt),
              ),
              _SettingsItem(
                icon: Icons.tune,
                title: l10n.settingsPosBehavior,
                subtitle: l10n.settingsPosBehaviorDesc,
                onTap: () => context.go(Routes.settingsPosBehavior),
              ),
              _SettingsItem(
                icon: Icons.payment,
                title: l10n.settingsPaymentMethods,
                subtitle: l10n.settingsPaymentMethodsDesc,
                onTap: () {},
              ),
            ],
          ),
          AppSpacing.gapH16,
          _SettingsSection(
            title: l10n.settingsSystem,
            items: [
              _SettingsItem(
                icon: Icons.notifications,
                title: l10n.settingsNotifications,
                subtitle: l10n.settingsNotificationsDesc,
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.security,
                title: l10n.settingsSecurity,
                subtitle: l10n.settingsSecurityDesc,
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.info_outline,
                title: l10n.settingsAbout,
                subtitle: l10n.settingsAboutDesc,
                onTap: () => context.go(Routes.settingsAbout),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        PosCard(
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(children: [entry.value, if (!isLast) const Divider(height: 1, indent: 56)]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
