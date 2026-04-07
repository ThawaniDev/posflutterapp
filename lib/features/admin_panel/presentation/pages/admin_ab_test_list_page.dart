import 'package:flutter/material.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminABTestListPage extends ConsumerStatefulWidget {
  const AdminABTestListPage({super.key});

  @override
  ConsumerState<AdminABTestListPage> createState() => _AdminABTestListPageState();
}

class _AdminABTestListPageState extends ConsumerState<AdminABTestListPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadTests();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadTests();
  }

  void _loadTests() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(abTestListProvider.notifier).loadTests(params: params.isEmpty ? null : params);
  }

  Color _statusColor(String status) => switch (status) {
    'running' => AppColors.success,
    'completed' => AppColors.info,
    'cancelled' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abTestListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('A/B Tests'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
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
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 8),
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => _loadTests(), child: const Text('Retry')),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
