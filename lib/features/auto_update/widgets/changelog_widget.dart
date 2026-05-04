import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_providers.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ChangelogWidget extends ConsumerWidget {
  const ChangelogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(changelogProvider);
    final theme = Theme.of(context);

    return switch (state) {
      ChangelogInitial() => Center(child: Text(l10n.auLoadingChangelog)),
      ChangelogLoading() => const PosLoading(),
      ChangelogError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      ChangelogLoaded(:final releases) =>
        releases.isEmpty
            ? Center(child: Text(l10n.auNoReleasesFound))
            : ListView.separated(
                padding: AppSpacing.paddingAll16,
                itemCount: releases.length,
                separatorBuilder: (_, __) => AppSpacing.gapH8,
                itemBuilder: (context, index) {
                  final r = releases[index];
                  return PosCard(
                    child: ListTile(
                      leading: const Icon(Icons.new_releases_outlined),
                      title: Text('v${r['version_number'] ?? r['version'] ?? '?'}', style: theme.textTheme.titleSmall),
                      subtitle: Text(
                        r['release_notes']?.toString() ?? l10n.changelogNoNotes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: r['is_force_update'] == true
                          ? Chip(label: Text(l10n.staffRequired), backgroundColor: theme.colorScheme.errorContainer)
                          : null,
                    ),
                  );
                },
              ),
    };
  }
}
