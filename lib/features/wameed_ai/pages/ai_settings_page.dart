import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

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
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wameedAISettings)),
      body: switch (state) {
        AIFeaturesInitial() || AIFeaturesLoading() => const Center(child: CircularProgressIndicator()),
        AIFeaturesError(:final message) => Center(child: Text(message)),
        AIFeaturesLoaded(:final features) => ListView.builder(
          padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            final isAr = Localizations.localeOf(context).languageCode == 'ar';
            final name = isAr ? (feature.nameAr ?? feature.name) : feature.name;
            final desc = isAr ? (feature.descriptionAr ?? feature.description ?? '') : (feature.description ?? '');
            final isEnabled = feature.storeConfigs?.firstOrNull?.isEnabled ?? true;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.auto_awesome, color: isEnabled ? AppColors.primary : Colors.grey),
                title: Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Switch(
                  value: isEnabled,
                  activeColor: AppColors.primary,
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
