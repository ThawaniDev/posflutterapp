import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/models/permission.dart';
import 'package:wameedpos/features/staff/models/role.dart';

/// State for the roles list screen
sealed class RolesState {
  const RolesState();
}

class RolesInitial extends RolesState {
  const RolesInitial();
}

class RolesLoading extends RolesState {
  const RolesLoading();
}

class RolesLoaded extends RolesState {
  final List<Role> roles;

  const RolesLoaded({required this.roles});

  RolesLoaded copyWith({List<Role>? roles}) => RolesLoaded(roles: roles ?? this.roles);
}

class RolesError extends RolesState {
  final String message;

  const RolesError({required this.message});
}

/// State for role detail/edit screen
sealed class RoleDetailState {
  const RoleDetailState();
}

class RoleDetailInitial extends RoleDetailState {
  const RoleDetailInitial();
}

class RoleDetailLoading extends RoleDetailState {
  const RoleDetailLoading();
}

class RoleDetailLoaded extends RoleDetailState {
  final Role role;

  const RoleDetailLoaded({required this.role});
}

class RoleDetailSaving extends RoleDetailState {
  const RoleDetailSaving();
}

class RoleDetailSaved extends RoleDetailState {
  final Role role;

  const RoleDetailSaved({required this.role});
}

class RoleDetailError extends RoleDetailState {
  final String message;

  const RoleDetailError({required this.message});
}

/// State for the permissions catalog
sealed class PermissionsState {
  const PermissionsState();
}

class PermissionsInitial extends PermissionsState {
  const PermissionsInitial();
}

class PermissionsLoading extends PermissionsState {
  const PermissionsLoading();
}

class PermissionsLoaded extends PermissionsState {
  final Map<String, List<Permission>> grouped;

  const PermissionsLoaded({required this.grouped});

  List<String> get modules => grouped.keys.toList();

  List<Permission> get all => grouped.values.expand((perms) => perms).toList();
}

class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError({required this.message});
}

/// State for the current user's effective permissions (locally cached)
class UserPermissionsState {
  final List<String> permissions;
  final bool isLoaded;
  final String? error;

  /// 'organization' = can access all branches, 'branch' = restricted to own store
  final String branchScope;

  /// Store IDs the user can access (empty until loaded)
  final List<String> accessibleStoreIds;

  /// Per-branch role info keyed by store ID
  final Map<String, BranchRoleInfo> branchRoles;

  const UserPermissionsState({
    this.permissions = const [],
    this.isLoaded = false,
    this.error,
    this.branchScope = 'branch',
    this.accessibleStoreIds = const [],
    this.branchRoles = const {},
  });

  bool hasPermission(String code) => permissions.contains(code);

  bool get isOrganizationScoped => branchScope == 'organization';
  bool get isBranchScoped => branchScope == 'branch';

  /// Get the role info for a specific branch, or null if none assigned.
  BranchRoleInfo? roleForBranch(String storeId) => branchRoles[storeId];

  UserPermissionsState copyWith({
    List<String>? permissions,
    bool? isLoaded,
    String? error,
    String? branchScope,
    List<String>? accessibleStoreIds,
    Map<String, BranchRoleInfo>? branchRoles,
  }) {
    return UserPermissionsState(
      permissions: permissions ?? this.permissions,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      branchScope: branchScope ?? this.branchScope,
      accessibleStoreIds: accessibleStoreIds ?? this.accessibleStoreIds,
      branchRoles: branchRoles ?? this.branchRoles,
    );
  }
}
