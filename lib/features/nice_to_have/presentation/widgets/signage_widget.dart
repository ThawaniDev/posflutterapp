import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_providers.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class SignageWidget extends ConsumerWidget {
  const SignageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(signageProvider);
    return switch (state) {
      SignageInitial() || SignageLoading() => const Center(child: CircularProgressIndicator()),
      SignageError(:final message) => Center(
        child: Text(l10n.genericError(message), style: const TextStyle(color: AppColors.error)),
      ),
      SignageLoaded(:final playlists) =>
        playlists.isEmpty
            ? Center(child: Text(l10n.noSignagePlaylists))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: playlists.length,
                itemBuilder: (_, i) {
                  final p = playlists[i] as Map<String, dynamic>;
                  final slides = (p['slides'] as List?) ?? [];
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.slideshow),
                      title: Text(p['name']?.toString() ?? 'Unnamed'),
                      subtitle: Text('${slides.length} slide(s)'),
                      trailing: Icon(
                        p['is_active'] == true ? Icons.check_circle : Icons.pause_circle,
                        color: p['is_active'] == true ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
