import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_state.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_providers.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class PosSettingsWidget extends ConsumerWidget {
  const PosSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customizationSettingsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      SettingsInitial() || SettingsLoading() => const Center(child: CircularProgressIndicator()),
      SettingsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      final SettingsLoaded s => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: PosCard(
          child: Column(
            children: [
              _tile(Icons.palette, l10n.pcTheme, s.theme.toUpperCase()),
              const Divider(height: 1),
              _colorTile(l10n.pcPrimaryColor, s.primaryColor),
              const Divider(height: 1),
              _colorTile(l10n.pcSecondaryColor, s.secondaryColor),
              const Divider(height: 1),
              _colorTile(l10n.pcAccentColor, s.accentColor),
              const Divider(height: 1),
              _tile(Icons.text_fields, l10n.pcFontScale, s.fontScale.toStringAsFixed(2)),
              const Divider(height: 1),
              _tile(Icons.pan_tool, l10n.pcHandedness, s.handedness),
              const Divider(height: 1),
              _tile(Icons.grid_view, l10n.pcGridColumns, '${s.gridColumns}'),
              const Divider(height: 1),
              _boolTile(context, l10n.pcShowProductImages, s.showProductImages),
              const Divider(height: 1),
              _boolTile(context, l10n.pcShowPriceOnGrid, s.showPriceOnGrid),
              const Divider(height: 1),
              _tile(Icons.view_list, l10n.pcCartMode, s.cartDisplayMode),
              const Divider(height: 1),
              _tile(Icons.swap_horiz, l10n.pcLayoutDirection, s.layoutDirection),
            ],
          ),
        ),
      ),
    };
  }

  Widget _tile(IconData icon, String title, String subtitle) {
    return ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(subtitle));
  }

  Widget _colorTile(String title, String hex) {
    Color color;
    try {
      color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      color = AppColors.textSecondary;
    }
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 14),
      title: Text(title),
      subtitle: Text(hex),
    );
  }

  Widget _boolTile(BuildContext context, String title, bool value) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(value ? Icons.check_circle : Icons.cancel, color: value ? AppColors.success : AppColors.error),
      title: Text(title),
      subtitle: Text(value ? l10n.yes : l10n.no),
    );
  }
}
