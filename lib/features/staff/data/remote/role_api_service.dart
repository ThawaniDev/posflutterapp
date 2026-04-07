import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/staff/models/permission.dart';
import 'package:thawani_pos/features/staff/models/role.dart';

final roleApiServiceProvider = Provider<RoleApiService>((ref) {
  return RoleApiService(ref.watch(dioClientProvider));
});

class RoleApiService {
  final Dio _dio;

  RoleApiService(this._dio);

  /// GET /staff/roles?store_id=xxx
  Future<List<Role>> listRoles(String storeId) async {
    final response = await _dio.get(ApiEndpoints.roles, queryParameters: {'store_id': storeId});
    final List data = response.data['data'] as List;
    return data.map((j) => Role.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /staff/roles/:id
  Future<Role> getRole(int roleId) async {
    final response = await _dio.get('${ApiEndpoints.roles}/$roleId');
    return Role.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /staff/roles
  Future<Role> createRole({
    required String storeId,
    required String name,
    required String displayName,
    String? description,
    List<int>? permissionIds,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.roles,
      data: {
        'store_id': storeId,
        'name': name,
        'display_name': displayName,
        if (description != null) 'description': description,
        if (permissionIds != null) 'permission_ids': permissionIds,
      },
    );
    return Role.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// PUT /staff/roles/:id
  Future<Role> updateRole(int roleId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.roles}/$roleId', data: data);
    return Role.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// DELETE /staff/roles/:id
  Future<void> deleteRole(int roleId) async {
    await _dio.delete('${ApiEndpoints.roles}/$roleId');
  }

  /// POST /staff/roles/:id/assign
  Future<void> assignRole(int roleId, String userId) async {
    await _dio.post('${ApiEndpoints.roles}/$roleId/assign', data: {'user_id': userId});
  }

  /// POST /staff/roles/:id/unassign
  Future<void> unassignRole(int roleId, String userId) async {
    await _dio.post('${ApiEndpoints.roles}/$roleId/unassign', data: {'user_id': userId});
  }

  /// GET /staff/roles/user-permissions?store_id=xxx
  /// Returns permissions, branch_scope, accessible_store_ids, and branch_roles.
  Future<Map<String, dynamic>> getUserPermissionsWithScope(String storeId) async {
    final response = await _dio.get(ApiEndpoints.userPermissions, queryParameters: {'store_id': storeId});
    final data = response.data['data'] as Map<String, dynamic>;
    final List perms = data['permissions'] as List;
    final String branchScope = (data['branch_scope'] as String?) ?? 'branch';
    final List accessibleIds = (data['accessible_store_ids'] as List?) ?? [];

    // Parse per-branch role map: { storeId: { role_name, display_name, display_name_ar, scope } }
    final Map<String, dynamic> rawBranchRoles = (data['branch_roles'] as Map<String, dynamic>?) ?? {};
    final Map<String, BranchRoleInfo> branchRoles = rawBranchRoles.map(
      (storeId, info) => MapEntry(storeId, BranchRoleInfo.fromJson(info as Map<String, dynamic>)),
    );

    return {
      'permissions': perms.cast<String>(),
      'branch_scope': branchScope,
      'accessible_store_ids': accessibleIds.cast<String>(),
      'branch_roles': branchRoles,
    };
  }

  /// Legacy: returns only the permissions list.
  Future<List<String>> getUserPermissions(String storeId) async {
    final result = await getUserPermissionsWithScope(storeId);
    return result['permissions'] as List<String>;
  }

  /// GET /staff/permissions
  Future<List<Permission>> listPermissions() async {
    final response = await _dio.get(ApiEndpoints.permissions);
    final List data = response.data['data'] as List;
    return data.map((j) => Permission.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /staff/permissions/grouped
  Future<Map<String, List<Permission>>> getPermissionsGrouped() async {
    final response = await _dio.get(ApiEndpoints.permissionsGrouped);
    final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
    return data.map(
      (module, perms) => MapEntry(module, (perms as List).map((p) => Permission.fromJson(p as Map<String, dynamic>)).toList()),
    );
  }

  /// GET /staff/permissions/modules
  Future<List<String>> getModules() async {
    final response = await _dio.get(ApiEndpoints.permissionsModules);
    final List data = response.data['data'] as List;
    return data.cast<String>();
  }

  /// GET /staff/permissions/pin-protected
  Future<List<Permission>> getPinProtected() async {
    final response = await _dio.get(ApiEndpoints.permissionsPinProtected);
    final List data = response.data['data'] as List;
    return data.map((j) => Permission.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// POST /staff/pin-override
  Future<Map<String, dynamic>> requestPinOverride({
    required String storeId,
    required String pin,
    required String permissionCode,
    Map<String, dynamic>? context,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.pinOverride,
      data: {'store_id': storeId, 'pin': pin, 'permission_code': permissionCode, if (context != null) 'context': context},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  /// GET /staff/pin-override/check?permission_code=xxx
  Future<bool> checkPinRequired(String permissionCode) async {
    final response = await _dio.get(ApiEndpoints.pinOverrideCheck, queryParameters: {'permission_code': permissionCode});
    return response.data['data']['requires_pin'] as bool;
  }
}

/// Per-branch role information returned by the user-permissions API.
class BranchRoleInfo {
  final String roleName;
  final String displayName;
  final String? displayNameAr;
  final String scope;

  const BranchRoleInfo({required this.roleName, required this.displayName, this.displayNameAr, required this.scope});

  factory BranchRoleInfo.fromJson(Map<String, dynamic> json) {
    return BranchRoleInfo(
      roleName: json['role_name'] as String,
      displayName: json['display_name'] as String,
      displayNameAr: json['display_name_ar'] as String?,
      scope: json['scope'] as String,
    );
  }
}
