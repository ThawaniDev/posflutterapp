import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminABTestListPage extends ConsumerStatefulWidget {
  const AdminABTestListPage({super.key});

  @override
  ConsumerState<AdminABTestListPage> createState() => _AdminABTestListPageState();
}

class _AdminABTestListPageState extends ConsumerState<AdminABTestListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(abTestListProvider);

    return PosListPage(
  title: l10n.adminABTests,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add, onPressed: () {},
  ),
],
  child: Column(
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
                        Text(l10n.adminPageOf(currentPage.toString(), lastPage.toString())),
                      ],
                    ),
                  ),
                  Expanded(
                    child: tests.isEmpty
                        ? Center(child: Text(l10n.adminNoAbTests))
                        : ListView.builder(
                            itemCount: tests.length,
                            itemBuilder: (context, index) {
                              final test = tests[index];
                              final status = test['status'] as String? ?? 'draft';
                              return PosCard(
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
                    PosButton(onPressed: () => _loadTests(), label: l10n.retry),
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
