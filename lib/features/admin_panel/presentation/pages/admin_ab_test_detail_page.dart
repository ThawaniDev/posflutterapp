import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminABTestDetailPage extends ConsumerStatefulWidget {
  final String testId;
  const AdminABTestDetailPage({super.key, required this.testId});

  @override
  ConsumerState<AdminABTestDetailPage> createState() => _AdminABTestDetailPageState();
}

class _AdminABTestDetailPageState extends ConsumerState<AdminABTestDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(abTestDetailProvider.notifier).loadTest(widget.testId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abTestDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('A/B Test Detail')),
      body: switch (state) {
        ABTestDetailInitial() || ABTestDetailLoading() => const Center(child: CircularProgressIndicator()),
        ABTestDetailLoaded(:final test, :final variants) => SingleChildScrollView(
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
                      Text(test['name'] as String? ?? '', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(test['description'] as String? ?? 'No description'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(label: Text((test['status'] as String? ?? 'draft').toUpperCase())),
                          const SizedBox(width: 8),
                          Chip(label: Text('${test['traffic_percentage'] ?? 100}% traffic')),
                        ],
                      ),
                      if (test['metric_key'] != null) ...[const SizedBox(height: 8), Text('Metric: ${test['metric_key']}')],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Variants (${variants.length})', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (variants.isEmpty)
                const Text('No variants added yet')
              else
                ...variants.map(
                  (v) => Card(
                    child: ListTile(
                      leading: v['is_control'] == true
                          ? const Icon(Icons.science, color: Colors.blue)
                          : const Icon(Icons.science_outlined),
                      title: Text(v['variant_key'] as String? ?? ''),
                      subtitle: Text(v['variant_label'] as String? ?? ''),
                      trailing: Text('${v['weight'] ?? 50}%'),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (test['status'] == 'draft')
                    ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('Start')),
                  if (test['status'] == 'running')
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.bar_chart), label: const Text('View Results')),
                ],
              ),
            ],
          ),
        ),
        ABTestDetailError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(message),
            ],
          ),
        ),
      },
    );
  }
}
