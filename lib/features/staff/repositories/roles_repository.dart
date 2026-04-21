import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/models/permission.dart';
import 'package:wameedpos/features/staff/models/role.dart';

final rolesRepositoryProvider = Provider<RolesRepository>((ref) {
  return RolesRepository(apiService: ref.watch(roleApiServiceProvider), localStorage: ref.watch(authLocalStorageProvider));
});

/// Repository that orchestrates roles/permissions API calls.
/// Automatically resolves the current store ID from auth session.
class RolesRepository {
  RolesRepository({required RoleApiService apiService, required AuthLocalStorage localStorage})
    : _apiService = apiService,
      _localStorage = localStorage;
  final RoleApiService _apiService;
  final AuthLocalStorage _localStorage;

  Future<String> _getStoreId() async {
    final storeId = await _localStorage.getStoreId();
    if (storeId == null) {
      throw Exception('No store selected. Please log in again.');
    }
    return storeId;
  }

  // ─── Roles ─────────────────────────────────────────────────────

  Future<List<Role>> listRoles() async {
    final storeId = await _getStoreId();
    return _apiService.listRoles(storeId);
  }

  Future<Role> getRole(int roleId) async {
    return _apiService.getRole(roleId);
  }

  Future<Role> createRole({
    required String name,
    required String displayName,
    String? description,
    List<int>? permissionIds,
  }) async {
    final storeId = await _getStoreId();
    return _apiService.createRole(
      storeId: storeId,
      name: name,
      displayName: displayName,
      description: description,
      permissionIds: permissionIds,
    );
  }

  Future<Role> updateRole(int roleId, {String? name, String? displayName, String? description, List<int>? permissionIds}) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (displayName != null) data['display_name'] = displayName;
    if (description != null) data['description'] = description;
    if (permissionIds != null) data['permission_ids'] = permissionIds;
    return _apiService.updateRole(roleId, data);
  }

  Future<void> deleteRole(int roleId) async {
    return _apiService.deleteRole(roleId);
  }

  // ─── Role Assignment ───────────────────────────────────────────

  Future<void> assignRole(int roleId, String userId) async {
    return _apiService.assignRole(roleId, userId);
  }

  Future<void> unassignRole(int roleId, String userId) async {
    return _apiService.unassignRole(roleId, userId);
  }

  // ─── Current User Permissions ──────────────────────────────────

  Future<List<String>> getMyPermissions() async {
    final storeId = await _localStorage.getStoreId();
    return _apiService.getUserPermissions(storeId);
  }

  /// Get permissions + branch scope + accessible store IDs.
  /// `store_id` is optional; backend resolves a default for org-scoped users.
  /// If the response includes a resolved store_id, persist it so subsequent
  /// repository calls (which still require a store id) succeed.
  Future<Map<String, dynamic>> getMyPermissionsWithScope() async {
    final storeId = await _localStorage.getStoreId();
    final result = await _apiService.getUserPermissionsWithScope(storeId);

    final resolvedStoreId =
        (result['store_id'] as String?) ??
        ((result['accessible_store_ids'] as List?)?.isNotEmpty ?? false
            ? (result['accessible_store_ids'] as List).first as String
            : null);
    if (storeId == null && resolvedStoreId != null) {
      await _localStorage.saveStoreId(resolvedStoreId);
    }

    return result;
  }

  // ─── Permissions Catalog ───────────────────────────────────────

  Future<List<Permission>> listPermissions() async {
    return _apiService.listPermissions();
  }

  Future<Map<String, List<Permission>>> getPermissionsGrouped() async {
    return _apiService.getPermissionsGrouped();
  }

  Future<List<String>> getModules() async {
    return _apiService.getModules();
  }

  Future<List<Permission>> getPinProtected() async {
    return _apiService.getPinProtected();
  }

  // ─── PIN Override ──────────────────────────────────────────────

  Future<Map<String, dynamic>> requestPinOverride({
    required String pin,
    required String permissionCode,
    Map<String, dynamic>? context,
  }) async {
    final storeId = await _getStoreId();
    return _apiService.requestPinOverride(storeId: storeId, pin: pin, permissionCode: permissionCode, context: context);
  }

  Future<bool> checkPinRequired(String permissionCode) async {
    return _apiService.checkPinRequired(permissionCode);
  }
}
