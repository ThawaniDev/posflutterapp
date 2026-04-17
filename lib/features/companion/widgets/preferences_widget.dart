import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PreferencesWidget extends ConsumerWidget {
  const PreferencesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(preferencesProvider);
    final theme = Theme.of(context);

    return switch (state) {
      PreferencesInitial() || PreferencesLoading() => const Center(child: CircularProgressIndicator()),
      PreferencesError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      final PreferencesLoaded s => _buildContent(
        context,
        ref,
        s.theme,
        s.language,
        s.compactMode,
        s.notificationsEnabled,
        s.biometricLock,
        s.defaultPage,
        s.currencyDisplay,
      ),
    };
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    String themeMode,
    String language,
    bool compactMode,
    bool notificationsEnabled,
    bool biometricLock,
    String defaultPage,
    String currencyDisplay,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.companionAppPreferences, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          AppSpacing.gapH16,
          Card(
            child: Column(
              children: [
                _buildTile(icon: Icons.palette, title: l10n.appBarTheme, subtitle: themeMode.toUpperCase()),
                const Divider(height: 1),
                _buildTile(icon: Icons.language, title: l10n.staffLanguage, subtitle: language == 'ar' ? 'العربية' : 'English'),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.view_compact,
                  title: l10n.companionCompactMode,
                  value: compactMode,
                  onChanged: (v) => ref.read(preferencesProvider.notifier).update({'compact_mode': v}),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: l10n.notifications,
                  value: notificationsEnabled,
                  onChanged: (v) => ref.read(preferencesProvider.notifier).update({'notifications_enabled': v}),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: l10n.companionBiometricLock,
                  value: biometricLock,
                  onChanged: (v) => ref.read(preferencesProvider.notifier).update({'biometric_lock': v}),
                ),
                const Divider(height: 1),
                _buildTile(icon: Icons.home, title: l10n.companionDefaultPage, subtitle: defaultPage),
                const Divider(height: 1),
                _buildTile(icon: Icons.attach_money, title: l10n.companionCurrencyDisplay, subtitle: currencyDisplay),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(subtitle));
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(secondary: Icon(icon), title: Text(title), value: value, onChanged: onChanged);
  }
}
