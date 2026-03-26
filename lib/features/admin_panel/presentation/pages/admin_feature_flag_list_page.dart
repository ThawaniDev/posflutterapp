import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFeatureFlagListPage extends ConsumerStatefulWidget {
  const AdminFeatureFlagListPage({super.key});

  @override
  ConsumerState<AdminFeatureFlagListPage> createState() => _AdminFeatureFlagListPageState();
}

class _AdminFeatureFlagListPageState extends ConsumerState<AdminFeatureFlagListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(featureFlagListProvider.notifier).loadFlags());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureFlagListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: switch (state) {
        FeatureFlagListInitial() || FeatureFlagListLoading() => const Center(child: CircularProgressIndicator()),
        FeatureFlagListLoaded(:final flags, :final total) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$total feature flags', style: Theme.of(context).textTheme.titleMedium),
            ),
            Expanded(
              child: flags.isEmpty
                  ? const Center(child: Text('No feature flags configured'))
                  : ListView.builder(
                      itemCount: flags.length,
                      itemBuilder: (context, index) {
                        final flag = flags[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(flag['flag_key'] as String? ?? ''),
                            subtitle: Text(flag['description'] as String? ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${flag['rollout_percentage'] ?? 100}%'),
                                const SizedBox(width: 8),
                                Switch(value: flag['is_enabled'] as bool? ?? false, onChanged: (_) {}),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        FeatureFlagListError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              Text(message),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(featureFlagListProvider.notifier).loadFlags(), child: const Text('Retry')),
            ],
          ),
        ),
      },
    );
  }
}
