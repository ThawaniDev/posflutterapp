import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import '../nice_to_have_providers.dart';
import '../nice_to_have_state.dart';

class GamificationWidget extends ConsumerWidget {
  const GamificationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gamificationProvider);
    return switch (state) {
      GamificationInitial() || GamificationLoading() => const Center(child: CircularProgressIndicator()),
      GamificationError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      GamificationLoaded(:final challenges, :final badges, :final tiers) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Challenges (${challenges.length})', style: Theme.of(context).textTheme.titleMedium),
            AppSpacing.gapH8,
            ...challenges.map((c) {
              final ch = c as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text(ch['name_en']?.toString() ?? 'Challenge'),
                  subtitle: Text('Type: ${ch['challenge_type'] ?? '-'} • Target: ${ch['target_value'] ?? 0}'),
                ),
              );
            }),
            AppSpacing.gapH16,
            Text('Badges (${badges.length})', style: Theme.of(context).textTheme.titleMedium),
            AppSpacing.gapH8,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badges.map((b) {
                final badge = b as Map<String, dynamic>;
                return Chip(
                  avatar: const Icon(Icons.military_tech, size: 18),
                  label: Text(badge['name_en']?.toString() ?? 'Badge'),
                );
              }).toList(),
            ),
            AppSpacing.gapH16,
            Text('Tiers (${tiers.length})', style: Theme.of(context).textTheme.titleMedium),
            AppSpacing.gapH8,
            ...tiers.map((t) {
              final tier = t as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(tier['tier_name_en']?.toString() ?? 'Tier'),
                  subtitle: Text('Min points: ${tier['min_points'] ?? 0}'),
                ),
              );
            }),
          ],
        ),
      ),
    };
  }
}
