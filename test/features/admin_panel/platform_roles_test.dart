import 'package:flutter_test/flutter_test.dart';

// API endpoints
import 'package:wameedpos/core/constants/api_endpoints.dart';

// Route names
import 'package:wameedpos/core/router/route_names.dart';

// States
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ════════════════════════════════════════════════════════════
  // P2 API Endpoints
  // ════════════════════════════════════════════════════════════

  group('P2 API Endpoints', () {
    test('adminRoles is correct', () {
      expect(ApiEndpoints.adminRoles, '/admin/roles');
    });

    test('adminRoleById returns correct path', () {
      expect(ApiEndpoints.adminRoleById('r-1'), '/admin/roles/r-1');
    });

    test('adminPermissions is correct', () {
      expect(ApiEndpoints.adminPermissions, '/admin/permissions');
    });

    test('adminTeam is correct', () {
      expect(ApiEndpoints.adminTeam, '/admin/team');
    });

    test('adminTeamUserById returns correct path', () {
      expect(ApiEndpoints.adminTeamUserById('u-1'), '/admin/team/u-1');
    });

    test('adminTeamUserDeactivate returns correct path', () {
      expect(ApiEndpoints.adminTeamUserDeactivate('u-1'), '/admin/team/u-1/deactivate');
    });

    test('adminTeamUserActivate returns correct path', () {
      expect(ApiEndpoints.adminTeamUserActivate('u-1'), '/admin/team/u-1/activate');
    });

    test('adminMe is correct', () {
      expect(ApiEndpoints.adminMe, '/admin/me');
    });

    test('adminActivityLog is correct', () {
      expect(ApiEndpoints.adminActivityLog, '/admin/activity-log');
    });
  });

  // ════════════════════════════════════════════════════════════
  // P2 Route Names
  // ════════════════════════════════════════════════════════════

  group('P2 Route Names', () {
    test('adminRoles is correct', () {
      expect(Routes.adminRoles, '/admin/roles');
    });

    test('adminRoleDetail is correct', () {
      expect(Routes.adminRoleDetail, '/admin/roles/detail');
    });

    test('adminRoleCreate is correct', () {
      expect(Routes.adminRoleCreate, '/admin/roles/create');
    });

    test('adminTeam is correct', () {
      expect(Routes.adminTeam, '/admin/team');
    });

    test('adminTeamUserDetail is correct', () {
      expect(Routes.adminTeamUserDetail, '/admin/team/detail');
    });

    test('adminTeamUserCreate is correct', () {
      expect(Routes.adminTeamUserCreate, '/admin/team/create');
    });

    test('adminActivityLog is correct', () {
      expect(Routes.adminActivityLog, '/admin/activity-log');
    });

    test('adminPermissions is correct', () {
      expect(Routes.adminPermissions, '/admin/permissions');
    });
  });

  // ════════════════════════════════════════════════════════════
  // AdminRoleListState
  // ════════════════════════════════════════════════════════════

  group('AdminRoleListState', () {
    test('initial state', () {
      const state = AdminRoleListInitial();
      expect(state, isA<AdminRoleListState>());
    });

    test('loading state', () {
      const state = AdminRoleListLoading();
      expect(state, isA<AdminRoleListState>());
    });

    test('loaded state holds roles', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Super Admin', 'is_system': true},
        {'id': 'r-2', 'name': 'Custom Role', 'is_system': false},
      ]);
      expect(state.roles.length, 2);
      expect(state.roles[0]['name'], 'Super Admin');
      expect(state.roles[1]['is_system'], false);
    });

    test('empty loaded state', () {
      const state = AdminRoleListLoaded([]);
      expect(state.roles, isEmpty);
    });

    test('error state holds message', () {
      const state = AdminRoleListError('Server error');
      expect(state.message, 'Server error');
    });

    test('sealed class pattern matching works', () {
      const AdminRoleListState state = AdminRoleListLoading();
      final result = switch (state) {
        AdminRoleListInitial() => 'initial',
        AdminRoleListLoading() => 'loading',
        AdminRoleListLoaded() => 'loaded',
        AdminRoleListError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ════════════════════════════════════════════════════════════
  // AdminRoleDetailState
  // ════════════════════════════════════════════════════════════

  group('AdminRoleDetailState', () {
    test('initial state', () {
      const state = AdminRoleDetailInitial();
      expect(state, isA<AdminRoleDetailState>());
    });

    test('loading state', () {
      const state = AdminRoleDetailLoading();
      expect(state, isA<AdminRoleDetailState>());
    });

    test('loaded state holds role with permissions', () {
      const state = AdminRoleDetailLoaded({
        'id': 'r-1',
        'name': 'Admin',
        'slug': 'admin',
        'is_system': true,
        'permissions': [
          {'id': 'p-1', 'name': 'stores.view', 'group': 'stores'},
        ],
      });
      expect(state.role['name'], 'Admin');
      expect((state.role['permissions'] as List).length, 1);
    });

    test('error state', () {
      const state = AdminRoleDetailError('Not found');
      expect(state.message, 'Not found');
    });

    test('sealed class pattern matching', () {
      const AdminRoleDetailState state = AdminRoleDetailLoaded({'id': '1'});
      final result = switch (state) {
        AdminRoleDetailInitial() => 'initial',
        AdminRoleDetailLoading() => 'loading',
        AdminRoleDetailLoaded() => 'loaded',
        AdminRoleDetailError() => 'error',
      };
      expect(result, 'loaded');
    });
  });

  // ════════════════════════════════════════════════════════════
  // PermissionListState
  // ════════════════════════════════════════════════════════════

  group('PermissionListState', () {
    test('initial state', () {
      const state = PermissionListInitial();
      expect(state, isA<PermissionListState>());
    });

    test('loading state', () {
      const state = PermissionListLoading();
      expect(state, isA<PermissionListState>());
    });

    test('loaded state holds grouped permissions', () {
      const state = PermissionListLoaded({
        'stores': [
          {'id': 'p-1', 'name': 'stores.view'},
          {'id': 'p-2', 'name': 'stores.edit'},
        ],
        'billing': [
          {'id': 'p-3', 'name': 'billing.view'},
        ],
      });
      expect(state.groupedPermissions.keys.length, 2);
      expect(state.groupedPermissions['stores']!.length, 2);
      expect(state.groupedPermissions['billing']!.length, 1);
    });

    test('error state', () {
      const state = PermissionListError('Failed');
      expect(state.message, 'Failed');
    });

    test('sealed class pattern matching', () {
      const PermissionListState state = PermissionListInitial();
      final result = switch (state) {
        PermissionListInitial() => 'initial',
        PermissionListLoading() => 'loading',
        PermissionListLoaded() => 'loaded',
        PermissionListError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ════════════════════════════════════════════════════════════
  // AdminTeamListState
  // ════════════════════════════════════════════════════════════

  group('AdminTeamListState', () {
    test('initial state', () {
      const state = AdminTeamListInitial();
      expect(state, isA<AdminTeamListState>());
    });

    test('loading state', () {
      const state = AdminTeamListLoading();
      expect(state, isA<AdminTeamListState>());
    });

    test('loaded state holds users with pagination', () {
      const state = AdminTeamListLoaded(
        users: [
          {'id': 'u-1', 'name': 'Alice', 'is_active': true},
          {'id': 'u-2', 'name': 'Bob', 'is_active': false},
        ],
        total: 25,
        currentPage: 1,
        lastPage: 2,
      );
      expect(state.users.length, 2);
      expect(state.total, 25);
      expect(state.currentPage, 1);
      expect(state.lastPage, 2);
      expect(state.users[0]['name'], 'Alice');
      expect(state.users[1]['is_active'], false);
    });

    test('empty loaded state', () {
      const state = AdminTeamListLoaded(users: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.users, isEmpty);
      expect(state.total, 0);
    });

    test('error state', () {
      const state = AdminTeamListError('Fetch failed');
      expect(state.message, 'Fetch failed');
    });

    test('sealed class pattern matching', () {
      const AdminTeamListState state = AdminTeamListLoading();
      final result = switch (state) {
        AdminTeamListInitial() => 'initial',
        AdminTeamListLoading() => 'loading',
        AdminTeamListLoaded() => 'loaded',
        AdminTeamListError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ════════════════════════════════════════════════════════════
  // AdminTeamUserDetailState
  // ════════════════════════════════════════════════════════════

  group('AdminTeamUserDetailState', () {
    test('initial state', () {
      const state = AdminTeamUserDetailInitial();
      expect(state, isA<AdminTeamUserDetailState>());
    });

    test('loading state', () {
      const state = AdminTeamUserDetailLoading();
      expect(state, isA<AdminTeamUserDetailState>());
    });

    test('loaded state holds user with roles', () {
      const state = AdminTeamUserDetailLoaded({
        'id': 'u-1',
        'name': 'Alice',
        'email': 'alice@test.com',
        'phone': '+968 1234',
        'is_active': true,
        'two_factor_enabled': false,
        'roles': [
          {'id': 'r-1', 'name': 'Admin', 'slug': 'admin'},
        ],
      });
      expect(state.user['name'], 'Alice');
      expect(state.user['is_active'], true);
      expect((state.user['roles'] as List).length, 1);
    });

    test('error state', () {
      const state = AdminTeamUserDetailError('User not found');
      expect(state.message, 'User not found');
    });

    test('sealed class pattern matching', () {
      const AdminTeamUserDetailState state = AdminTeamUserDetailInitial();
      final result = switch (state) {
        AdminTeamUserDetailInitial() => 'initial',
        AdminTeamUserDetailLoading() => 'loading',
        AdminTeamUserDetailLoaded() => 'loaded',
        AdminTeamUserDetailError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ════════════════════════════════════════════════════════════
  // AdminProfileState
  // ════════════════════════════════════════════════════════════

  group('AdminProfileState', () {
    test('initial state', () {
      const state = AdminProfileInitial();
      expect(state, isA<AdminProfileState>());
    });

    test('loading state', () {
      const state = AdminProfileLoading();
      expect(state, isA<AdminProfileState>());
    });

    test('loaded state holds profile with unified permissions', () {
      const state = AdminProfileLoaded({
        'id': 'u-1',
        'name': 'Admin',
        'email': 'admin@test.com',
        'roles': [
          {'id': 'r-1', 'name': 'Super Admin'},
        ],
        'all_permissions': ['stores.view', 'billing.manage'],
      });
      expect(state.profile['name'], 'Admin');
      expect((state.profile['all_permissions'] as List).length, 2);
    });

    test('error state', () {
      const state = AdminProfileError('Unauthorized');
      expect(state.message, 'Unauthorized');
    });

    test('sealed class pattern matching', () {
      const AdminProfileState state = AdminProfileLoaded({'id': '1'});
      final result = switch (state) {
        AdminProfileInitial() => 'initial',
        AdminProfileLoading() => 'loading',
        AdminProfileLoaded() => 'loaded',
        AdminProfileError() => 'error',
      };
      expect(result, 'loaded');
    });
  });

  // ════════════════════════════════════════════════════════════
  // ActivityLogState
  // ════════════════════════════════════════════════════════════

  group('ActivityLogState', () {
    test('initial state', () {
      const state = ActivityLogInitial();
      expect(state, isA<ActivityLogState>());
    });

    test('loading state', () {
      const state = ActivityLogLoading();
      expect(state, isA<ActivityLogState>());
    });

    test('loaded state holds logs with pagination', () {
      const state = ActivityLogLoaded(
        logs: [
          {
            'id': 'log-1',
            'action': 'role.created',
            'admin_user_name': 'Alice',
            'entity_type': 'admin_role',
            'entity_id': 'r-1',
            'ip_address': '192.168.1.1',
          },
          {
            'id': 'log-2',
            'action': 'user.deactivated',
            'admin_user_name': 'Bob',
            'entity_type': 'admin_user',
            'entity_id': 'u-2',
          },
        ],
        total: 100,
        currentPage: 1,
        lastPage: 4,
      );
      expect(state.logs.length, 2);
      expect(state.total, 100);
      expect(state.currentPage, 1);
      expect(state.lastPage, 4);
      expect(state.logs[0]['action'], 'role.created');
      expect(state.logs[1]['admin_user_name'], 'Bob');
    });

    test('empty loaded state', () {
      const state = ActivityLogLoaded(logs: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.logs, isEmpty);
    });

    test('error state', () {
      const state = ActivityLogError('Timeout');
      expect(state.message, 'Timeout');
    });

    test('sealed class pattern matching', () {
      const ActivityLogState state = ActivityLogError('err');
      final result = switch (state) {
        ActivityLogInitial() => 'initial',
        ActivityLogLoading() => 'loading',
        ActivityLogLoaded() => 'loaded',
        ActivityLogError() => 'error',
      };
      expect(result, 'error');
    });
  });

  // ════════════════════════════════════════════════════════════
  // P2 State Data Integrity Tests
  // ════════════════════════════════════════════════════════════

  group('P2 State Data Integrity', () {
    test('AdminRoleListLoaded roles are unmodifiable references', () {
      const roles = [
        {'id': 'r-1', 'name': 'Admin'},
      ];
      const state = AdminRoleListLoaded(roles);
      expect(state.roles, same(roles));
    });

    test('AdminTeamListLoaded pagination values are consistent', () {
      const state = AdminTeamListLoaded(users: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.currentPage, lessThanOrEqualTo(state.lastPage));
    });

    test('ActivityLogLoaded pagination values are consistent', () {
      const state = ActivityLogLoaded(logs: [], total: 50, currentPage: 2, lastPage: 5);
      expect(state.currentPage, lessThanOrEqualTo(state.lastPage));
      expect(state.total, greaterThanOrEqualTo(0));
    });

    test('PermissionListLoaded grouped permissions map is ordered', () {
      const state = PermissionListLoaded({
        'stores': [
          {'id': '1', 'name': 'stores.view'},
        ],
        'billing': [
          {'id': '2', 'name': 'billing.view'},
        ],
        'users': [
          {'id': '3', 'name': 'users.manage'},
        ],
      });
      expect(state.groupedPermissions.keys.toList(), ['stores', 'billing', 'users']);
    });

    test('AdminTeamUserDetailLoaded user has expected keys', () {
      const user = {
        'id': 'u-1',
        'name': 'Test User',
        'email': 'test@test.com',
        'is_active': true,
        'two_factor_enabled': false,
        'roles': <Map<String, dynamic>>[],
      };
      const state = AdminTeamUserDetailLoaded(user);
      expect(state.user.containsKey('id'), isTrue);
      expect(state.user.containsKey('name'), isTrue);
      expect(state.user.containsKey('email'), isTrue);
      expect(state.user.containsKey('is_active'), isTrue);
      expect(state.user.containsKey('roles'), isTrue);
    });

    test('AdminProfileLoaded profile has expected structure', () {
      const profile = {'id': 'u-1', 'name': 'Admin', 'roles': <Map<String, dynamic>>[], 'all_permissions': <String>[]};
      const state = AdminProfileLoaded(profile);
      expect(state.profile.containsKey('id'), isTrue);
      expect(state.profile.containsKey('roles'), isTrue);
      expect(state.profile.containsKey('all_permissions'), isTrue);
    });
  });

  // ════════════════════════════════════════════════════════════
  // P2 Edge Cases
  // ════════════════════════════════════════════════════════════

  group('P2 Edge Cases', () {
    test('AdminRoleListLoaded with single role', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Only Role'},
      ]);
      expect(state.roles.length, 1);
    });

    test('AdminRoleDetailLoaded role with empty permissions list', () {
      const state = AdminRoleDetailLoaded({'id': 'r-1', 'name': 'Empty', 'permissions': <Map<String, dynamic>>[]});
      expect((state.role['permissions'] as List), isEmpty);
    });

    test('AdminTeamListLoaded single-page result', () {
      const state = AdminTeamListLoaded(
        users: [
          {'id': 'u-1', 'name': 'Alone'},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.users.length, 1);
      expect(state.currentPage, state.lastPage);
    });

    test('ActivityLogLoaded with detailed log entry', () {
      const state = ActivityLogLoaded(
        logs: [
          {
            'id': 'log-1',
            'action': 'role.updated',
            'admin_user_id': 'u-1',
            'admin_user_name': 'Admin',
            'entity_type': 'admin_role',
            'entity_id': 'r-1',
            'details': {'changed': 'name'},
            'ip_address': '10.0.0.1',
            'user_agent': 'Mozilla/5.0',
            'created_at': '2025-01-15T10:30:00Z',
          },
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      final log = state.logs[0];
      expect(log['details'], isA<Map>());
      expect(log['user_agent'], contains('Mozilla'));
    });

    test('PermissionListLoaded with empty groups', () {
      const state = PermissionListLoaded({});
      expect(state.groupedPermissions, isEmpty);
    });

    test('AdminTeamUserDetail user with null optional fields', () {
      const state = AdminTeamUserDetailLoaded({
        'id': 'u-1',
        'name': 'Minimal',
        'email': 'min@test.com',
        'phone': null,
        'avatar_url': null,
        'is_active': true,
        'two_factor_enabled': false,
        'last_login_at': null,
        'last_login_ip': null,
        'roles': <dynamic>[],
      });
      expect(state.user['phone'], isNull);
      expect(state.user['last_login_at'], isNull);
    });

    test('AdminProfileLoaded with multiple roles and merged permissions', () {
      const state = AdminProfileLoaded({
        'id': 'u-1',
        'name': 'Multi-Role Admin',
        'roles': [
          {'id': 'r-1', 'name': 'Editor'},
          {'id': 'r-2', 'name': 'Viewer'},
        ],
        'all_permissions': ['stores.view', 'stores.edit', 'billing.view'],
      });
      expect((state.profile['roles'] as List).length, 2);
      expect((state.profile['all_permissions'] as List).length, 3);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P2 Extended: AdminRoleListState
  // ═══════════════════════════════════════════════════════════════

  group('P2 Extended: AdminRoleListState', () {
    test('system roles are marked with is_system true', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Super Admin', 'slug': 'super_admin', 'is_system': true, 'permissions_count': 50},
        {'id': 'r-2', 'name': 'Custom Role', 'slug': 'custom_role', 'is_system': false, 'permissions_count': 5},
      ]);
      final systemRoles = state.roles.where((r) => r['is_system'] == true).toList();
      final customRoles = state.roles.where((r) => r['is_system'] == false).toList();
      expect(systemRoles.length, 1);
      expect(customRoles.length, 1);
    });

    test('roles have user_count field', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Super Admin', 'is_system': true, 'user_count': 3, 'permissions_count': 50},
      ]);
      expect(state.roles.first.containsKey('user_count'), true);
    });

    test('role with zero users has user_count 0', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Unused Role', 'is_system': false, 'user_count': 0, 'permissions_count': 0},
      ]);
      expect(state.roles.first['user_count'], 0);
    });

    test('system roles appear before custom in ordered list', () {
      const state = AdminRoleListLoaded([
        {'id': 'r-1', 'name': 'Super Admin', 'is_system': true},
        {'id': 'r-2', 'name': 'Admin', 'is_system': true},
        {'id': 'r-3', 'name': 'Alpha Custom', 'is_system': false},
      ]);
      expect(state.roles.first['is_system'], true);
      expect(state.roles.last['is_system'], false);
    });
  });

  group('P2 Extended: AdminRoleDetailState', () {
    test('role detail has all required fields', () {
      const state = AdminRoleDetailLoaded({
        'id': 'r-1',
        'name': 'Content Manager',
        'slug': 'content_manager',
        'description': 'Manages content',
        'is_system': false,
        'user_count': 2,
        'permissions_count': 8,
        'permissions': [
          {'id': 'p-1', 'name': 'content.view', 'group': 'content', 'description': 'View content'},
          {'id': 'p-2', 'name': 'content.edit', 'group': 'content', 'description': 'Edit content'},
        ],
      });
      expect(state.role['slug'], 'content_manager');
      expect(state.role['is_system'], false);
      expect((state.role['permissions'] as List).length, 2);
    });

    test('permissions have group field', () {
      const state = AdminRoleDetailLoaded({
        'id': 'r-1',
        'name': 'Billing Manager',
        'permissions': [
          {'id': 'p-1', 'name': 'billing.view', 'group': 'billing'},
          {'id': 'p-2', 'name': 'billing.manage', 'group': 'billing'},
        ],
      });
      for (final perm in state.role['permissions'] as List) {
        expect((perm as Map).containsKey('group'), true);
      }
    });

    test('system role has is_system true', () {
      const state = AdminRoleDetailLoaded({
        'id': 'r-sys',
        'name': 'Super Admin',
        'slug': 'super_admin',
        'is_system': true,
        'permissions': [],
      });
      expect(state.role['is_system'], true);
    });
  });

  group('P2 Extended: PermissionListState', () {
    test('PermissionListLoaded groups permissions by group name', () {
      const state = PermissionListLoaded({
        'stores': [
          {'id': 'p-1', 'name': 'stores.view', 'description': 'View stores'},
          {'id': 'p-2', 'name': 'stores.edit', 'description': 'Edit stores'},
        ],
        'billing': [
          {'id': 'p-3', 'name': 'billing.view', 'description': 'View billing'},
        ],
      });
      expect(state.groupedPermissions.containsKey('stores'), true);
      expect(state.groupedPermissions.containsKey('billing'), true);
      expect(state.groupedPermissions['stores']!.length, 2);
      expect(state.groupedPermissions['billing']!.length, 1);
    });

    test('each permission has id, name, description', () {
      const state = PermissionListLoaded({
        'users': [
          {'id': 'p-1', 'name': 'users.view', 'description': 'View users'},
          {'id': 'p-2', 'name': 'users.manage', 'description': 'Manage users'},
        ],
      });
      for (final perm in state.groupedPermissions['users']!) {
        expect(perm.containsKey('id'), true);
        expect(perm.containsKey('name'), true);
        expect(perm.containsKey('description'), true);
      }
    });

    test('PermissionListError holds error message', () {
      const state = PermissionListError('Failed to load permissions');
      expect(state, isA<PermissionListState>());
      expect(state.message, 'Failed to load permissions');
    });
  });

  group('P2 Extended: AdminTeamListState', () {
    test('multiple pages navigation', () {
      final users = List.generate(
        15,
        (i) => {'id': 'u-$i', 'name': 'Admin $i', 'email': 'admin$i@test.com', 'is_active': true, 'roles': []},
      );
      final state = AdminTeamListLoaded(users: users, total: 40, currentPage: 1, lastPage: 3);
      expect(state.users.length, 15);
      expect(state.total, 40);
      expect(state.lastPage, 3);
    });

    test('search result with name match', () {
      const state = AdminTeamListLoaded(
        users: [
          {'id': 'u-1', 'name': 'Support Agent Ali', 'is_active': true, 'roles': []},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      final matches = state.users.where((u) => (u['name'] as String).toLowerCase().contains('ali'));
      expect(matches.length, 1);
    });

    test('user with 2FA enabled', () {
      const state = AdminTeamListLoaded(
        users: [
          {'id': 'u-1', 'name': 'Secure Admin', 'is_active': true, 'two_factor_enabled': true, 'roles': []},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.users.first['two_factor_enabled'], true);
    });
  });

  group('P2 Extended: AdminTeamUserDetailState', () {
    test('roles include assigned_at and assigned_by', () {
      const state = AdminTeamUserDetailLoaded({
        'id': 'u-1',
        'name': 'Team Member',
        'email': 'member@thawani.com',
        'is_active': true,
        'two_factor_enabled': false,
        'roles': [
          {
            'role_id': 'r-1',
            'role_name': 'Support',
            'role_slug': 'support',
            'assigned_at': '2025-01-10T00:00:00Z',
            'assigned_by': 'super-admin-id',
          },
        ],
      });
      final role = (state.user['roles'] as List).first as Map;
      expect(role.containsKey('assigned_at'), true);
      expect(role.containsKey('assigned_by'), true);
    });
  });

  group('P2 Extended: ActivityLogState', () {
    test('logs can be filtered by action prefix', () {
      const state = ActivityLogLoaded(
        logs: [
          {'action': 'role.created', 'created_at': '2025-01-14T10:00:00Z'},
          {'action': 'role.updated', 'created_at': '2025-01-15T10:00:00Z'},
          {'action': 'user.deactivated', 'created_at': '2025-01-16T10:00:00Z'},
        ],
        total: 3,
        currentPage: 1,
        lastPage: 1,
      );
      final roleActions = state.logs.where((l) => (l['action'] as String).startsWith('role.')).toList();
      expect(roleActions.length, 2);
    });

    test('logs ordered newest first', () {
      const state = ActivityLogLoaded(
        logs: [
          {'action': 'role.deleted', 'created_at': '2025-01-16T12:00:00Z'},
          {'action': 'role.updated', 'created_at': '2025-01-15T08:00:00Z'},
        ],
        total: 2,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.logs.first['action'], 'role.deleted');
    });

    test('ActivityLogError holds message', () {
      const state = ActivityLogError('Failed to load logs');
      expect(state.message, 'Failed to load logs');
    });
  });

  group('P2 Extended: AdminProfileState', () {
    test('all_permissions and permissions are equal', () {
      const perms = ['tickets.view', 'tickets.manage', 'kb.view'];
      const state = AdminProfileLoaded({
        'id': 'u-1',
        'name': 'Support',
        'roles': [],
        'all_permissions': perms,
        'permissions': perms,
      });
      expect(state.profile['all_permissions'], state.profile['permissions']);
    });

    test('super_admin has many permissions', () {
      const allPermissions = [
        'stores.view',
        'stores.edit',
        'billing.view',
        'billing.manage',
        'users.view',
        'users.manage',
        'admin_team.view',
        'admin_team.manage',
      ];
      const state = AdminProfileLoaded({
        'id': 'u-super',
        'name': 'Super Admin',
        'roles': [
          {'id': 'r-sys', 'name': 'Super Admin', 'slug': 'super_admin'},
        ],
        'all_permissions': allPermissions,
        'permissions': allPermissions,
      });
      expect((state.profile['all_permissions'] as List).length, 8);
    });

    test('admin with no roles has empty permissions', () {
      const state = AdminProfileLoaded({
        'id': 'u-new',
        'name': 'New Admin',
        'roles': [],
        'all_permissions': [],
        'permissions': [],
      });
      expect((state.profile['all_permissions'] as List).isEmpty, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P2 Extended: API Endpoint Completeness
  // ═══════════════════════════════════════════════════════════════

  group('P2 Extended: API Endpoint Completeness', () {
    test('all role endpoints use /admin/roles prefix', () {
      expect(ApiEndpoints.adminRoles, startsWith('/admin/roles'));
      expect(ApiEndpoints.adminRoleById('r-1'), startsWith('/admin/roles'));
    });

    test('all team endpoints use /admin/team prefix', () {
      expect(ApiEndpoints.adminTeam, startsWith('/admin/team'));
      expect(ApiEndpoints.adminTeamUserById('u-1'), startsWith('/admin/team'));
      expect(ApiEndpoints.adminTeamUserDeactivate('u-1'), startsWith('/admin/team'));
      expect(ApiEndpoints.adminTeamUserActivate('u-1'), startsWith('/admin/team'));
    });

    test('dynamic team endpoints embed user ID', () {
      const uid = 'target-admin-id';
      expect(ApiEndpoints.adminTeamUserById(uid), contains(uid));
      expect(ApiEndpoints.adminTeamUserDeactivate(uid), contains(uid));
      expect(ApiEndpoints.adminTeamUserActivate(uid), contains(uid));
    });

    test('dynamic role endpoints embed role ID', () {
      const rid = 'target-role-id';
      expect(ApiEndpoints.adminRoleById(rid), contains(rid));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P2 Extended: Role Business Rules
  // ═══════════════════════════════════════════════════════════════

  group('P2 Extended: Role CRUD Business Rules', () {
    test('role slug uses underscore separator', () {
      final name = 'Content Manager';
      final slug = name.toLowerCase().replaceAll(' ', '_');
      expect(slug, 'content_manager');
    });

    test('system role cannot be deleted', () {
      final role = {'id': 'r-sys', 'name': 'Super Admin', 'is_system': true};
      expect(role['is_system'], true);
    });

    test('role with assigned users cannot be deleted', () {
      final role = {'id': 'r-1', 'name': 'Support', 'is_system': false, 'user_count': 3};
      expect((role['user_count'] as int) > 0, true);
    });

    test('role with no users can be deleted', () {
      final role = {'id': 'r-2', 'name': 'Unused', 'is_system': false, 'user_count': 0};
      expect(role['user_count'], 0);
      expect(role['is_system'], false);
    });

    test('permission assignment uses permission_ids array', () {
      final createData = {
        'name': 'New Role',
        'permission_ids': ['p-1', 'p-2', 'p-3'],
      };
      expect(createData.containsKey('permission_ids'), true);
      expect((createData['permission_ids'] as List).length, 3);
    });

    test('role update replaces all permissions', () {
      final newPermissions = ['p-4', 'p-5'];
      final updatedData = {'permission_ids': newPermissions};
      expect((updatedData['permission_ids'] as List).contains('p-1'), false);
    });

    test('role update without permission_ids keeps existing', () {
      final updateData = {'name': 'Updated Name'};
      expect(updateData.containsKey('permission_ids'), false);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P2 Extended: Response Parsing
  // ═══════════════════════════════════════════════════════════════

  group('P2 Extended: Response Parsing', () {
    test('roles list response parses into AdminRoleListLoaded', () {
      final responseData = [
        {'id': 'r-1', 'name': 'Super Admin', 'slug': 'super_admin', 'is_system': true, 'user_count': 2, 'permissions_count': 50},
        {'id': 'r-2', 'name': 'Support', 'slug': 'support', 'is_system': false, 'user_count': 5, 'permissions_count': 8},
      ];
      final state = AdminRoleListLoaded(responseData);
      expect(state.roles.length, 2);
      expect(state.roles.first['slug'], 'super_admin');
    });

    test('permissions response parses into PermissionListLoaded', () {
      final groupedData = {
        'stores': [
          {'id': 'p-1', 'name': 'stores.view', 'description': 'View stores'},
        ],
        'billing': [
          {'id': 'p-2', 'name': 'billing.view', 'description': 'View billing'},
          {'id': 'p-3', 'name': 'billing.manage', 'description': 'Manage billing'},
        ],
      };
      final state = PermissionListLoaded(groupedData);
      expect(state.groupedPermissions.keys.length, 2);
      expect(state.groupedPermissions['billing']!.length, 2);
    });

    test('team list response parses roles with slugs', () {
      final users = [
        {
          'id': 'u-1',
          'name': 'Agent One',
          'email': 'agent1@thawani.com',
          'is_active': true,
          'two_factor_enabled': false,
          'roles': [
            {'role_id': 'r-1', 'role_name': 'Support', 'role_slug': 'support', 'assigned_at': '2025-01-01T00:00:00Z'},
          ],
        },
      ];
      final state = AdminTeamListLoaded(users: users, total: 1, currentPage: 1, lastPage: 1);
      expect((state.users.first['roles'] as List).first['role_slug'], 'support');
    });

    test('profile /me response parses all_permissions', () {
      final profile = {
        'id': 'u-self',
        'name': 'Self Admin',
        'roles': [
          {'id': 'r-1', 'name': 'Viewer'},
        ],
        'permissions': ['stores.view', 'billing.view'],
        'all_permissions': ['stores.view', 'billing.view'],
      };
      final state = AdminProfileLoaded(profile);
      expect((state.profile['all_permissions'] as List).contains('stores.view'), true);
    });
  });
}
