import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
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
        BranchListInitial() || BranchListLoading() => Center(child: PosLoadingSkeleton.list()),
        BranchListError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(branchListProvider.notifier).load(),
        ),
        BranchListLoaded(:final branches) =>
          branches.isEmpty
              ? PosEmptyState(title: AppLocalizations.of(context)!.branchesNoBranches, icon: Icons.store_outlined)
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
          backgroundColor: isActive ? AppColors.success.withValues(alpha: 0.15) : AppColors.textSecondary.withValues(alpha: 0.15),
          child: Icon(isMain ? Icons.store : Icons.storefront, color: isActive ? AppColors.success : AppColors.textSecondary),
        ),
        title: Row(
          children: [
            Expanded(child: Text(branch['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (isMain)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  'MAIN',
                  style: TextStyle(fontSize: 10, color: AppColors.info, fontWeight: FontWeight.bold),
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
                Icon(Icons.circle, size: 8, color: isActive ? AppColors.success : AppColors.error),
                const SizedBox(width: 4),
                Text(
                  isActive ? AppLocalizations.of(context)!.branchesActive : AppLocalizations.of(context)!.branchesInactive,
                  style: TextStyle(fontSize: 11, color: isActive ? AppColors.success : AppColors.error),
                ),
                if (branch['branch_code'] != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.branchesCode(branch['branch_code']),
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
