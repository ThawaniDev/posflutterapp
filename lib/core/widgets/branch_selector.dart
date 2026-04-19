import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/providers/branch_providers.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';

/// Dropdown selector for switching between branches.
/// Shows per-branch role name. Org-scoped users can switch; branch-scoped see their branch + role.
class BranchSelector extends ConsumerStatefulWidget {
  const BranchSelector({super.key});

  @override
  ConsumerState<BranchSelector> createState() => _BranchSelectorState();
}

class _BranchSelectorState extends ConsumerState<BranchSelector> {
  @override
  void initState() {
    super.initState();
    // Load branches if not already loaded
    Future.microtask(() {
      final state = ref.read(branchListProvider);
      if (state is BranchListInitial) {
        ref.read(branchListProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canSwitch = ref.watch(canSwitchBranchProvider);
    final permsState = ref.watch(userPermissionsProvider);
    final activeBranchId = ref.watch(activeBranchIdProvider);
    final activeRole = ref.watch(activeBranchRoleProvider);
    final locale = Localizations.localeOf(context).languageCode;

    // Branch-scoped user: show current branch name + role (no dropdown)
    if (!canSwitch) {
      if (activeRole == null) return const SizedBox.shrink();
      final roleName = locale == 'ar' ? (activeRole.displayNameAr ?? activeRole.displayName) : activeRole.displayName;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge_rounded, size: 14, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              roleName,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // Org-scoped user: dropdown with branch names + roles
    final branchState = ref.watch(branchListProvider);
    final accessibleIds = ref.watch(accessibleBranchIdsProvider);

    List<Store> branches = [];
    if (branchState is BranchListLoaded) {
      branches = branchState.branches.where((b) => accessibleIds.contains(b.id)).toList();
    }

    if (branches.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedBranch = branches.where((b) => b.id == activeBranchId).firstOrNull;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PosSearchableDropdown<String>(
        hint: AppLocalizations.of(context)!.selectBranch,
        items: branches.map((store) {
          final roleInfo = permsState.roleForBranch(store.id);
          final roleName = roleInfo != null
              ? (locale == 'ar' ? (roleInfo.displayNameAr ?? roleInfo.displayName) : roleInfo.displayName)
              : null;
          return PosDropdownItem<String>(
            value: store.id,
            label: store.name,
            subtitle: roleName,
            icon: store.isMainBranch ? Icons.star_rounded : null,
          );
        }).toList(),
        selectedValue: selectedBranch?.id ?? activeBranchId,
        onChanged: (newId) {
          if (newId != null && newId != activeBranchId) {
            ref.read(activeBranchIdProvider.notifier).state = newId;
          }
        },
        showSearch: true,
        clearable: false,
      ),
    );
  }
}
