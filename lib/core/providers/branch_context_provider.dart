import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';

/// The currently active branch (store) ID.
///
/// - Branch-scoped users: always their own store_id (cannot change).
/// - Organization-scoped users: defaults to their store_id, can switch.
final activeBranchIdProvider = StateProvider<String?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) {
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
/// Falls back to the user's own store_id if no active branch is set.
final resolvedStoreIdProvider = Provider<String?>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  final activeBranch = ref.watch(activeBranchIdProvider);
  final authState = ref.watch(authProvider);

  final userStoreId = authState is AuthAuthenticated ? authState.user.storeId : null;

  // Branch-scoped users always use their own store
  if (permsState.isBranchScoped) {
    return userStoreId;
  }

  // Org-scoped users use the selected branch, or default to own store
  return activeBranch ?? userStoreId;
});

/// The role info for the currently active branch, if any.
final activeBranchRoleProvider = Provider<BranchRoleInfo?>((ref) {
  final permsState = ref.watch(userPermissionsProvider);
  final activeBranch = ref.watch(activeBranchIdProvider);
  if (activeBranch == null) return null;
  return permsState.roleForBranch(activeBranch);
});
