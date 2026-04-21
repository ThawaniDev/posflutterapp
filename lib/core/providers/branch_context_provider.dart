import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';

/// The currently active branch (store) ID.
///
/// - Branch-scoped users: always their own store_id (cannot change).
/// - Organization-scoped users: defaults to null (all stores), can select a specific branch.
final activeBranchIdProvider = StateProvider<String?>((ref) {
  final authState = ref.watch(authProvider);
  final permsState = ref.watch(userPermissionsProvider);
  if (authState is AuthAuthenticated) {
    // Org-scoped users default to "all" (null); branch-scoped default to own store
    if (permsState.isOrganizationScoped) return null;
    return authState.user.storeId;
  }
  return null;
});

/// Whether the current user can switch between branches.
final canSwitchBranchProvider = Provider<bool>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  return permsState.isOrganizationScoped && permsState.accessibleStoreIds.length > 1;
});

/// The list of store IDs the user can access.
final accessibleBranchIdsProvider = Provider<List<String>>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  return permsState.accessibleStoreIds;
});

/// The resolved store_id to use in API calls.
/// Returns null for org-scoped users when "All" is selected (no branch filter).
/// Falls back to the user's own store_id for branch-scoped users.
final resolvedStoreIdProvider = Provider<String?>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  final activeBranch = ref.watch(activeBranchIdProvider);
  final authState = ref.watch(authProvider);

  final userStoreId = authState is AuthAuthenticated ? authState.user.storeId : null;

  // Branch-scoped users always use their own store
  if (permsState.isBranchScoped) {
    return userStoreId;
  }

  // Org-scoped users: null means "all stores", otherwise the selected branch
  return activeBranch;
});

/// The role info for the currently active branch, if any.
final activeBranchRoleProvider = Provider<BranchRoleInfo?>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  final activeBranch = ref.watch(activeBranchIdProvider);
  if (activeBranch == null) return null;
  return permsState.roleForBranch(activeBranch);
});
