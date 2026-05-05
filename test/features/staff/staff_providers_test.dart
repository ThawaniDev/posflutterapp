// ignore_for_file: prefer_const_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/data/remote/staff_api_service.dart';
import 'package:wameedpos/features/staff/enums/employment_type.dart';
import 'package:wameedpos/features/staff/enums/salary_type.dart';
import 'package:wameedpos/features/staff/models/permission.dart';
import 'package:wameedpos/features/staff/models/role.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/providers/roles_state.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/features/staff/repositories/roles_repository.dart';
import 'package:wameedpos/features/staff/repositories/staff_repository.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:dio/dio.dart';

// ─── Fake StaffRepository ─────────────────────────────────────────

class _FakeStaffRepository extends StaffRepository {
  _FakeStaffRepository() : super(StaffApiService(Dio()));

  final Map<int, PaginatedResult<StaffUser>> _pageResults = {};
  Exception? _listError;
  final List<String> deletedIds = [];

  void stubList(PaginatedResult<StaffUser> result) {
    _pageResults[result.currentPage] = result;
  }

  void stubPage(int page, PaginatedResult<StaffUser> result) => _pageResults[page] = result;

  void stubListError(Exception e) => _listError = e;

  @override
  Future<PaginatedResult<StaffUser>> listStaff({
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
    String? employmentType,
    String? storeId,
  }) async {
    if (_listError != null) throw _listError!;
    return _pageResults[page] ?? _pageResults[1]!;
  }

  @override
  Future<void> deleteStaff(String id) async => deletedIds.add(id);
}

// ─── No-op AuthLocalStorage ──────────────────────────────────────

/// Avoids FlutterSecureStorage native calls in tests by overriding all methods.
class _NoOpAuthLocalStorage extends AuthLocalStorage {
  @override
  Future<String?> getStoreId() async => 'store-test';
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> saveToken(String token) async {}
  @override
  Future<void> deleteToken() async {}
}

// ─── Fake RolesRepository ─────────────────────────────────────────

class _FakeRolesRepository extends RolesRepository {
  _FakeRolesRepository() : super(apiService: RoleApiService(Dio()), localStorage: _NoOpAuthLocalStorage());

  List<Role>? _rolesResult;
  Exception? _rolesError;
  Role? _createResult;
  Map<String, dynamic>? _permissionsResult;
  Exception? _permissionsError;

  void stubRoles(List<Role> roles) => _rolesResult = roles;
  void stubRolesError(Exception e) => _rolesError = e;
  void stubCreate(Role role) => _createResult = role;
  void stubPermissions(Map<String, dynamic> result) => _permissionsResult = result;
  void stubPermissionsError(Exception e) => _permissionsError = e;

  @override
  Future<List<Role>> listRoles() async {
    if (_rolesError != null) throw _rolesError!;
    return _rolesResult!;
  }

  @override
  Future<Role> createRole({String? name, String? displayName, String? description, List<int>? permissionIds}) async =>
      _createResult!;

  @override
  Future<void> deleteRole(int roleId) async {}

  @override
  Future<void> assignRole(int roleId, String userId) async {}

  @override
  Future<void> unassignRole(int roleId, String userId) async {}

  @override
  Future<Map<String, dynamic>> getMyPermissionsWithScope() async {
    if (_permissionsError != null) throw _permissionsError!;
    return _permissionsResult!;
  }

  @override
  Future<bool> checkPinRequired(String permissionCode) async => false;

  @override
  Future<List<Permission>> listPermissions() async => [];

  @override
  Future<Map<String, List<Permission>>> getPermissionsGrouped() async => {};

  @override
  Future<List<String>> getModules() async => [];

  @override
  Future<List<String>> getMyPermissions() async => [];

  @override
  Future<List<Permission>> getPinProtected() async => [];

  @override
  Future<Map<String, dynamic>> requestPinOverride({
    String? storeId,
    String? pin,
    String? permissionCode,
    Map<String, dynamic>? context,
  }) async => {};
}

// ─── Helper factories ─────────────────────────────────────────────

StaffUser _makeStaff({String id = 'su-001', String firstName = 'Test'}) => StaffUser(
  id: id,
  storeId: 'store-001',
  firstName: firstName,
  lastName: 'User',
  employmentType: EmploymentType.fullTime,
  salaryType: SalaryType.monthly,
  hireDate: DateTime(2024, 1, 1),
);

Role _makeRole({int id = 1, String name = 'cashier'}) => Role(id: id, name: name, displayName: name.replaceAll('_', ' '));

PaginatedResult<StaffUser> _singlePage(List<StaffUser> items) =>
    PaginatedResult<StaffUser>(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: 20);

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════
  // StaffListNotifier
  // ═══════════════════════════════════════════════════════════════
  group('StaffListNotifier', () {
    late _FakeStaffRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = _FakeStaffRepository();
      container = ProviderContainer(overrides: [staffRepositoryProvider.overrideWithValue(fakeRepo)]);
    });

    tearDown(() => container.dispose());

    test('initial state is StaffListInitial', () {
      expect(container.read(staffListProvider), isA<StaffListInitial>());
    });

    test('load emits StaffListLoading then StaffListLoaded', () async {
      fakeRepo.stubList(_singlePage([_makeStaff()]));

      final notifier = container.read(staffListProvider.notifier);
      final loadFuture = notifier.load();
      expect(container.read(staffListProvider), isA<StaffListLoading>());

      await loadFuture;
      final state = container.read(staffListProvider);
      expect(state, isA<StaffListLoaded>());
      final loaded = state as StaffListLoaded;
      expect(loaded.staff.length, 1);
      expect(loaded.total, 1);
      expect(loaded.hasMore, false);
    });

    test('load emits StaffListError on exception', () async {
      fakeRepo.stubListError(Exception('Network error'));

      await container.read(staffListProvider.notifier).load();

      final state = container.read(staffListProvider);
      expect(state, isA<StaffListError>());
      expect((state as StaffListError).message, contains('Network error'));
    });

    test('deleteStaff removes item and decrements total', () async {
      fakeRepo.stubList(_singlePage([_makeStaff(id: 'su-001'), _makeStaff(id: 'su-002')]));

      await container.read(staffListProvider.notifier).load();
      await container.read(staffListProvider.notifier).deleteStaff('su-001');

      expect(fakeRepo.deletedIds, contains('su-001'));
      final state = container.read(staffListProvider) as StaffListLoaded;
      expect(state.staff.length, 1);
      expect(state.staff.first.id, 'su-002');
      expect(state.total, 1);
    });

    test('loadMore appends items when hasMore=true', () async {
      fakeRepo.stubList(
        PaginatedResult<StaffUser>(items: [_makeStaff(id: 'su-001')], total: 2, currentPage: 1, lastPage: 2, perPage: 1),
      );
      fakeRepo.stubPage(
        2,
        PaginatedResult<StaffUser>(items: [_makeStaff(id: 'su-002')], total: 2, currentPage: 2, lastPage: 2, perPage: 1),
      );

      final notifier = container.read(staffListProvider.notifier);
      await notifier.load();
      await notifier.loadMore();

      final state = container.read(staffListProvider) as StaffListLoaded;
      expect(state.staff.length, 2);
      expect(state.staff.map((s) => s.id), containsAll(['su-001', 'su-002']));
      expect(state.hasMore, false);
    });

    test('loadMore is a no-op when hasMore=false', () async {
      fakeRepo.stubList(_singlePage([_makeStaff()]));

      final notifier = container.read(staffListProvider.notifier);
      await notifier.load();
      // deletedIds unchanged means no extra calls happened
      await notifier.loadMore();

      final state = container.read(staffListProvider) as StaffListLoaded;
      expect(state.staff.length, 1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // RolesNotifier
  // ═══════════════════════════════════════════════════════════════
  group('RolesNotifier', () {
    late _FakeRolesRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = _FakeRolesRepository();
      container = ProviderContainer(overrides: [rolesRepositoryProvider.overrideWithValue(fakeRepo)]);
    });

    tearDown(() => container.dispose());

    test('initial state is RolesInitial', () {
      expect(container.read(rolesProvider), isA<RolesInitial>());
    });

    test('load emits RolesLoading then RolesLoaded', () async {
      fakeRepo.stubRoles([_makeRole(id: 1), _makeRole(id: 2, name: 'supervisor')]);

      final notifier = container.read(rolesProvider.notifier);
      final loadFuture = notifier.load();
      expect(container.read(rolesProvider), isA<RolesLoading>());

      await loadFuture;
      final state = container.read(rolesProvider);
      expect(state, isA<RolesLoaded>());
      expect((state as RolesLoaded).roles.length, 2);
    });

    test('load emits RolesError on failure', () async {
      fakeRepo.stubRolesError(Exception('API unavailable'));

      await container.read(rolesProvider.notifier).load();

      expect(container.read(rolesProvider), isA<RolesError>());
    });

    test('createRole appends new role to list', () async {
      fakeRepo.stubRoles([_makeRole(id: 1)]);
      fakeRepo.stubCreate(_makeRole(id: 2, name: 'supervisor'));

      await container.read(rolesProvider.notifier).load();
      await container.read(rolesProvider.notifier).createRole(name: 'supervisor', displayName: 'Supervisor');

      final state = container.read(rolesProvider) as RolesLoaded;
      expect(state.roles.length, 2);
      expect(state.roles.last.name, 'supervisor');
    });

    test('deleteRole removes role from list', () async {
      fakeRepo.stubRoles([_makeRole(id: 1), _makeRole(id: 2, name: 'custom')]);

      await container.read(rolesProvider.notifier).load();
      await container.read(rolesProvider.notifier).deleteRole(1);

      final state = container.read(rolesProvider) as RolesLoaded;
      expect(state.roles.length, 1);
      expect(state.roles.first.id, 2);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // UserPermissionsNotifier
  // ═══════════════════════════════════════════════════════════════
  group('UserPermissionsNotifier', () {
    late _FakeRolesRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = _FakeRolesRepository();
      container = ProviderContainer(overrides: [rolesRepositoryProvider.overrideWithValue(fakeRepo)]);
    });

    tearDown(() => container.dispose());

    test('initial: isLoaded=false, permissions empty, error=null', () {
      final state = container.read(userPermissionsProvider);
      expect(state.isLoaded, false);
      expect(state.permissions, isEmpty);
      expect(state.error, isNull);
    });

    test('load populates permissions and sets isLoaded=true', () async {
      fakeRepo.stubPermissions({
        'permissions': ['staff.view', 'staff.edit', 'pos.sell'],
        'branch_scope': 'branch',
        'accessible_store_ids': <String>['store-001'],
        'branch_roles': <String, BranchRoleInfo>{},
      });

      await container.read(userPermissionsProvider.notifier).load();

      final state = container.read(userPermissionsProvider);
      expect(state.isLoaded, true);
      expect(state.permissions, containsAll(['staff.view', 'staff.edit', 'pos.sell']));
      expect(state.branchScope, 'branch');
    });

    test('hasPermission returns true for granted, false for absent', () async {
      fakeRepo.stubPermissions({
        'permissions': ['staff.view', 'staff.create'],
        'branch_scope': 'branch',
        'accessible_store_ids': <String>[],
        'branch_roles': <String, BranchRoleInfo>{},
      });

      await container.read(userPermissionsProvider.notifier).load();
      final state = container.read(userPermissionsProvider);

      expect(state.hasPermission('staff.view'), true);
      expect(state.hasPermission('staff.delete'), false);
    });

    test('isOrganizationScoped=true when scope is "organization"', () async {
      fakeRepo.stubPermissions({
        'permissions': <String>[],
        'branch_scope': 'organization',
        'accessible_store_ids': <String>['store-001', 'store-002'],
        'branch_roles': <String, BranchRoleInfo>{},
      });

      await container.read(userPermissionsProvider.notifier).load();
      final state = container.read(userPermissionsProvider);

      expect(state.isOrganizationScoped, true);
      expect(state.isBranchScoped, false);
    });

    test('clear resets to initial state', () async {
      fakeRepo.stubPermissions({
        'permissions': ['staff.view'],
        'branch_scope': 'branch',
        'accessible_store_ids': <String>[],
        'branch_roles': <String, BranchRoleInfo>{},
      });

      await container.read(userPermissionsProvider.notifier).load();
      expect(container.read(userPermissionsProvider).isLoaded, true);

      container.read(userPermissionsProvider.notifier).clear();

      final state = container.read(userPermissionsProvider);
      expect(state.isLoaded, false);
      expect(state.permissions, isEmpty);
      expect(state.error, isNull);
    });

    test('load sets error when repository throws', () async {
      fakeRepo.stubPermissionsError(Exception('Token expired'));

      await container.read(userPermissionsProvider.notifier).load();

      final state = container.read(userPermissionsProvider);
      expect(state.isLoaded, false);
      expect(state.error, isNotNull);
      expect(state.error, contains('Token expired'));
    });

    test('hasPermissionProvider reflects loaded permissions', () async {
      fakeRepo.stubPermissions({
        'permissions': ['reports.view'],
        'branch_scope': 'branch',
        'accessible_store_ids': <String>[],
        'branch_roles': <String, BranchRoleInfo>{},
      });

      await container.read(userPermissionsProvider.notifier).load();

      expect(container.read(hasPermissionProvider('reports.view')), true);
      expect(container.read(hasPermissionProvider('reports.export')), false);
    });
  });
}
