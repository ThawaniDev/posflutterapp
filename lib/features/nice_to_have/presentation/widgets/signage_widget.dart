import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import '../nice_to_have_providers.dart';
import '../nice_to_have_state.dart';

class SignageWidget extends ConsumerWidget {
  const SignageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signageProvider);
    return switch (state) {
      SignageInitial() || SignageLoading() => const Center(child: CircularProgressIndicator()),
      SignageError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      SignageLoaded(:final playlists) =>
        playlists.isEmpty
            ? const Center(child: Text('No signage playlists'))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: playlists.length,
                itemBuilder: (_, i) {
                  final p = playlists[i] as Map<String, dynamic>;
                  final slides = (p['slides'] as List?) ?? [];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.slideshow),
                      title: Text(p['name']?.toString() ?? 'Unnamed'),
                      subtitle: Text('${slides.length} slide(s)'),
                      trailing: Icon(
                        p['is_active'] == true ? Icons.check_circle : Icons.pause_circle,
                        color: p['is_active'] == true ? Colors.green : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
