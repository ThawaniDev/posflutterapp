import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/branches/providers/branch_providers.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';

class BranchListPage extends ConsumerStatefulWidget {
  const BranchListPage({super.key});

  @override
  ConsumerState<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends ConsumerState<BranchListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(branchListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(branchListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.branches),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(branchListProvider.notifier).load())],
      ),
      body: switch (state) {
        BranchListInitial() || BranchListLoading() => const Center(child: CircularProgressIndicator()),
        BranchListError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error: $message', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.read(branchListProvider.notifier).load(),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
        BranchListLoaded(:final branches) =>
          branches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.branchesNoBranches,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(branchListProvider.notifier).load(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: branches.length,
                    itemBuilder: (context, index) => _branchCard(branches[index]),
                  ),
                ),
      },
    );
  }

  Widget _branchCard(Map<String, dynamic> branch) {
    final isActive = branch['is_active'] == true;
    final isMain = branch['is_main_branch'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
          child: Icon(isMain ? Icons.store : Icons.storefront, color: isActive ? Colors.green : Colors.grey),
        ),
        title: Row(
          children: [
            Expanded(child: Text(branch['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (isMain)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  'MAIN',
                  style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (branch['address'] != null)
              Text(
                branch['address'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: isActive ? Colors.green : Colors.red),
                const SizedBox(width: 4),
                Text(
                  isActive ? AppLocalizations.of(context)!.branchesActive : AppLocalizations.of(context)!.branchesInactive,
                  style: TextStyle(fontSize: 11, color: isActive ? Colors.green : Colors.red),
                ),
                if (branch['branch_code'] != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.branchesCode(branch['branch_code']),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
        onTap: () {
          // Navigate to branch detail/settings via store settings page
          final id = branch['id'] as String? ?? '';
          if (id.isNotEmpty) {
            // Use the existing store settings route
            // context.push('/store/settings/$id');
          }
        },
      ),
    );
  }
}
