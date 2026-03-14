import 'package:flutter_test/flutter_test.dart';

// API endpoints
import 'package:thawani_pos/core/constants/api_endpoints.dart';

// Route names
import 'package:thawani_pos/core/router/route_names.dart';

// States
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

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
}
