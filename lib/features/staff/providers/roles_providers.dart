import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/staff/providers/roles_state.dart';
import 'package:thawani_pos/features/staff/repositories/roles_repository.dart';

// ─── Roles List ────────────────────────────────────────────────────

final rolesProvider = StateNotifierProvider<RolesNotifier, RolesState>((ref) {
  return RolesNotifier(ref.watch(rolesRepositoryProvider));
});

class RolesNotifier extends StateNotifier<RolesState> {
  final RolesRepository _repository;

  RolesNotifier(this._repository) : super(const RolesInitial());

  Future<void> load() async {
    state = const RolesLoading();
    try {
      final roles = await _repository.listRoles();
      state = RolesLoaded(roles: roles);
    } on DioException catch (e) {
      state = RolesError(message: _extractError(e));
    } catch (e) {
      state = RolesError(message: e.toString());
    }
  }

  Future<void> createRole({
    required String name,
    required String displayName,
    String? description,
    List<int>? permissionIds,
  }) async {
    try {
      final role = await _repository.createRole(
        name: name,
        displayName: displayName,
        description: description,
        permissionIds: permissionIds,
      );
      // Add to current list if loaded
      if (state is RolesLoaded) {
        final current = (state as RolesLoaded).roles;
        state = RolesLoaded(roles: [...current, role]);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> deleteRole(int roleId) async {
    try {
      await _repository.deleteRole(roleId);
      if (state is RolesLoaded) {
        final current = (state as RolesLoaded).roles;
        state = RolesLoaded(roles: current.where((r) => r.id != roleId).toList());
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> assignRole(int roleId, String userId) async {
    try {
      await _repository.assignRole(roleId, userId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> unassignRole(int roleId, String userId) async {
    try {
      await _repository.unassignRole(roleId, userId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ─── Role Detail ───────────────────────────────────────────────────

final roleDetailProvider = StateNotifierProvider.family<RoleDetailNotifier, RoleDetailState, int>((ref, roleId) {
  return RoleDetailNotifier(ref.watch(rolesRepositoryProvider), roleId);
});

class RoleDetailNotifier extends StateNotifier<RoleDetailState> {
  final RolesRepository _repository;
  final int _roleId;

  RoleDetailNotifier(this._repository, this._roleId) : super(const RoleDetailInitial());

  Future<void> load() async {
    state = const RoleDetailLoading();
    try {
      final role = await _repository.getRole(_roleId);
      state = RoleDetailLoaded(role: role);
    } on DioException catch (e) {
      state = RoleDetailError(message: _extractError(e));
    } catch (e) {
      state = RoleDetailError(message: e.toString());
    }
  }

  Future<void> update({String? name, String? displayName, String? description, List<int>? permissionIds}) async {
    state = const RoleDetailSaving();
    try {
      final role = await _repository.updateRole(
        _roleId,
        name: name,
        displayName: displayName,
        description: description,
        permissionIds: permissionIds,
      );
      state = RoleDetailSaved(role: role);
    } on DioException catch (e) {
      state = RoleDetailError(message: _extractError(e));
    } catch (e) {
      state = RoleDetailError(message: e.toString());
    }
  }
}

// ─── Permissions Catalog ───────────────────────────────────────────

final permissionsCatalogProvider = StateNotifierProvider<PermissionsCatalogNotifier, PermissionsState>((ref) {
  return PermissionsCatalogNotifier(ref.watch(rolesRepositoryProvider));
});

class PermissionsCatalogNotifier extends StateNotifier<PermissionsState> {
  final RolesRepository _repository;

  PermissionsCatalogNotifier(this._repository) : super(const PermissionsInitial());

  Future<void> load() async {
    state = const PermissionsLoading();
    try {
      final grouped = await _repository.getPermissionsGrouped();
      state = PermissionsLoaded(grouped: grouped);
    } on DioException catch (e) {
      state = PermissionsError(message: _extractError(e));
    } catch (e) {
      state = PermissionsError(message: e.toString());
    }
  }
}

// ─── User Effective Permissions ────────────────────────────────────

final userPermissionsProvider = StateNotifierProvider<UserPermissionsNotifier, UserPermissionsState>((ref) {
  return UserPermissionsNotifier(ref.watch(rolesRepositoryProvider));
});

/// Convenience: does the current user have this permission?
final hasPermissionProvider = Provider.family<bool, String>((ref, code) {
  final state = ref.watch(userPermissionsProvider);
  return state.hasPermission(code);
});

class UserPermissionsNotifier extends StateNotifier<UserPermissionsState> {
  final RolesRepository _repository;

  UserPermissionsNotifier(this._repository) : super(const UserPermissionsState());

  Future<void> load() async {
    try {
      final permissions = await _repository.getMyPermissions();
      state = UserPermissionsState(permissions: permissions, isLoaded: true);
    } catch (e) {
      state = UserPermissionsState(error: e.toString());
    }
  }

  void clear() {
    state = const UserPermissionsState();
  }
}

// ─── PIN Override Check ────────────────────────────────────────────

/// FutureProvider to check if a permission requires PIN override.
final pinRequiredProvider = FutureProvider.family<bool, String>((ref, code) {
  return ref.watch(rolesRepositoryProvider).checkPinRequired(code);
});

// ─── Shared Helpers ────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    if (data.containsKey('message')) {
      return data['message'] as String;
    }
    if (data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }
  }
  return e.message ?? 'An unexpected error occurred.';
}
