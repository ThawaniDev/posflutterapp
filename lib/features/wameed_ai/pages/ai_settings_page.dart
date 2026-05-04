import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';

class AISettingsPage extends ConsumerStatefulWidget {
  const AISettingsPage({super.key});

  @override
  ConsumerState<AISettingsPage> createState() => _AISettingsPageState();
}

class _AISettingsPageState extends ConsumerState<AISettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiFeaturesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeaturesProvider);

    return PosListPage(
  title: l10n.wameedAISettings,
  showSearch: false,
    child: switch (state) {
        AIFeaturesInitial() || AIFeaturesLoading() => const PosLoading(),
        AIFeaturesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(aiFeaturesProvider.notifier).load(),
        ),
        AIFeaturesLoaded(:final features) => ListView.builder(
          padding: context.responsivePagePadding,
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            final isAr = Localizations.localeOf(context).languageCode == 'ar';
            final name = isAr ? (feature.nameAr ?? feature.name) : feature.name;
            final desc = isAr ? (feature.descriptionAr ?? feature.description ?? '') : (feature.description ?? '');
            final isEnabled = feature.storeConfigs?.firstOrNull?.isEnabled ?? true;

            return PosCard(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.auto_awesome, color: isEnabled ? AppColors.primary : AppColors.textSecondary),
                title: Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Switch(
                  value: isEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    ref.read(aiFeaturesProvider.notifier).updateFeatureConfig(feature.id, isEnabled: value);
                  },
                ),
              ),
            );
          },
        ),
      },
);
  }
}
