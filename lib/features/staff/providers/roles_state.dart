import 'package:thawani_pos/features/staff/models/permission.dart';
import 'package:thawani_pos/features/staff/models/role.dart';

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

  const UserPermissionsState({this.permissions = const [], this.isLoaded = false, this.error});

  bool hasPermission(String code) => permissions.contains(code);

  UserPermissionsState copyWith({List<String>? permissions, bool? isLoaded, String? error}) {
    return UserPermissionsState(permissions: permissions ?? this.permissions, isLoaded: isLoaded ?? this.isLoaded, error: error);
  }
}
