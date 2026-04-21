import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_providers.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class GiftRegistryWidget extends ConsumerWidget {
  const GiftRegistryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(giftRegistryProvider);
    return switch (state) {
      GiftRegistryInitial() || GiftRegistryLoading() => const Center(child: CircularProgressIndicator()),
      GiftRegistryError(:final message) => Center(
        child: Text(l10n.genericError(message), style: const TextStyle(color: AppColors.error)),
      ),
      GiftRegistryLoaded(:final registries) =>
        registries.isEmpty
            ? Center(child: Text(l10n.noGiftRegistries))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: registries.length,
                itemBuilder: (_, i) {
                  final r = registries[i] as Map<String, dynamic>;
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.card_giftcard),
                      title: Text(r['name']?.toString() ?? 'Unnamed'),
                      subtitle: Text('${r['event_type'] ?? '-'} • ${r['event_date'] ?? '-'}'),
                      trailing: Text(
                        r['share_code']?.toString() ?? '',
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
