import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminFeatureFlagDetailPage extends ConsumerStatefulWidget {
  final String flagId;
  const AdminFeatureFlagDetailPage({super.key, required this.flagId});

  @override
  ConsumerState<AdminFeatureFlagDetailPage> createState() => _AdminFeatureFlagDetailPageState();
}

class _AdminFeatureFlagDetailPageState extends ConsumerState<AdminFeatureFlagDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(featureFlagDetailProvider.notifier).loadFlag(widget.flagId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureFlagDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Feature Flag Detail')),
      body: switch (state) {
        FeatureFlagDetailInitial() || FeatureFlagDetailLoading() => const Center(child: CircularProgressIndicator()),
        FeatureFlagDetailLoaded(:final flag, :final abTests) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flag['flag_key'] as String? ?? '', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(flag['description'] as String? ?? 'No description'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(label: Text(flag['is_enabled'] == true ? 'Enabled' : 'Disabled')),
                          const SizedBox(width: 8),
                          Chip(label: Text('${flag['rollout_percentage'] ?? 100}% rollout')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Linked A/B Tests (${abTests.length})', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (abTests.isEmpty)
                const Text('No A/B tests linked to this flag')
              else
                ...abTests.map(
                  (test) => Card(
                    child: ListTile(
                      title: Text(test['name'] as String? ?? ''),
                      subtitle: Text('Status: ${test['status'] ?? 'draft'}'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
            ],
          ),
        ),
        FeatureFlagDetailError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              Text(message),
            ],
          ),
        ),
      },
    );
  }
}
