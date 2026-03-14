import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminABTestListPage extends ConsumerStatefulWidget {
  const AdminABTestListPage({super.key});

  @override
  ConsumerState<AdminABTestListPage> createState() => _AdminABTestListPageState();
}

class _AdminABTestListPageState extends ConsumerState<AdminABTestListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(abTestListProvider.notifier).loadTests());
  }

  Color _statusColor(String status) => switch (status) {
    'running' => Colors.green,
    'completed' => Colors.blue,
    'cancelled' => Colors.red,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abTestListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('A/B Tests'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: switch (state) {
        ABTestListInitial() || ABTestListLoading() => const Center(child: CircularProgressIndicator()),
        ABTestListLoaded(:final tests, :final total, :final currentPage, :final lastPage) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$total tests', style: Theme.of(context).textTheme.titleMedium),
                  Text('Page $currentPage of $lastPage'),
                ],
              ),
            ),
            Expanded(
              child: tests.isEmpty
                  ? const Center(child: Text('No A/B tests found'))
                  : ListView.builder(
                      itemCount: tests.length,
                      itemBuilder: (context, index) {
                        final test = tests[index];
                        final status = test['status'] as String? ?? 'draft';
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(test['name'] as String? ?? ''),
                            subtitle: Text(test['description'] as String? ?? ''),
                            trailing: Chip(
                              label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 11)),
                              backgroundColor: _statusColor(status).withValues(alpha: 0.15),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        ABTestListError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(message),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(abTestListProvider.notifier).loadTests(), child: const Text('Retry')),
            ],
          ),
        ),
      },
    );
  }
}
