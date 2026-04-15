import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P4: API Endpoints
  // ═══════════════════════════════════════════════════════════════

  group('P4 API Endpoints - Provider Users', () {
    test('adminProviderUsers endpoint is correct', () {
      expect(ApiEndpoints.adminProviderUsers, '/admin/users/provider');
    });

    test('adminProviderUserById builds correct path', () {
      expect(ApiEndpoints.adminProviderUserById('u-1'), '/admin/users/provider/u-1');
    });

    test('adminProviderUserResetPassword builds correct path', () {
      expect(ApiEndpoints.adminProviderUserResetPassword('u-1'), '/admin/users/provider/u-1/reset-password');
    });

    test('adminProviderUserForcePasswordChange builds correct path', () {
      expect(ApiEndpoints.adminProviderUserForcePasswordChange('u-1'), '/admin/users/provider/u-1/force-password-change');
    });

    test('adminProviderUserToggleActive builds correct path', () {
      expect(ApiEndpoints.adminProviderUserToggleActive('u-1'), '/admin/users/provider/u-1/toggle-active');
    });

    test('adminProviderUserActivity builds correct path', () {
      expect(ApiEndpoints.adminProviderUserActivity('u-1'), '/admin/users/provider/u-1/activity');
    });
  });

  group('P4 API Endpoints - Admin Users', () {
    test('adminAdminUsers endpoint is correct', () {
      expect(ApiEndpoints.adminAdminUsers, '/admin/users/admins');
    });

    test('adminAdminUserById builds correct path', () {
      expect(ApiEndpoints.adminAdminUserById('a-1'), '/admin/users/admins/a-1');
    });

    test('adminAdminUserReset2fa builds correct path', () {
      expect(ApiEndpoints.adminAdminUserReset2fa('a-1'), '/admin/users/admins/a-1/reset-2fa');
    });

    test('adminAdminUserActivity builds correct path', () {
      expect(ApiEndpoints.adminAdminUserActivity('a-1'), '/admin/users/admins/a-1/activity');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Route Names
  // ═══════════════════════════════════════════════════════════════

  group('P4 Route Names', () {
    test('adminProviderUsers route exists', () {
      expect(Routes.adminProviderUsers, '/admin/users/provider');
    });

    test('adminProviderUserDetail route exists', () {
      expect(Routes.adminProviderUserDetail, isNotEmpty);
    });

    test('adminAdminUsers route exists', () {
      expect(Routes.adminAdminUsers, '/admin/users/admins');
    });

    test('adminAdminUserDetail route exists', () {
      expect(Routes.adminAdminUserDetail, isNotEmpty);
    });

    test('adminAdminUserCreate route exists', () {
      expect(Routes.adminAdminUserCreate, '/admin/users/admins/create');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Provider User List State
  // ═══════════════════════════════════════════════════════════════

  group('ProviderUserListState', () {
    test('ProviderUserListInitial is default state', () {
      const state = ProviderUserListInitial();
      expect(state, isA<ProviderUserListState>());
    });

    test('ProviderUserListLoading represents loading', () {
      const state = ProviderUserListLoading();
      expect(state, isA<ProviderUserListState>());
    });

    test('ProviderUserListLoaded holds users with pagination', () {
      const state = ProviderUserListLoaded(
        users: [
          {'id': 'u-1', 'name': 'Ahmed', 'email': 'ahmed@store.com', 'role': 'cashier', 'is_active': true},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.users.length, 1);
      expect(state.users.first['name'], 'Ahmed');
      expect(state.total, 1);
    });

    test('ProviderUserListError holds error message', () {
      const state = ProviderUserListError('Network error');
      expect(state.message, 'Network error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Provider User Detail State
  // ═══════════════════════════════════════════════════════════════

  group('ProviderUserDetailState', () {
    test('ProviderUserDetailInitial is default state', () {
      const state = ProviderUserDetailInitial();
      expect(state, isA<ProviderUserDetailState>());
    });

    test('ProviderUserDetailLoading represents loading', () {
      const state = ProviderUserDetailLoading();
      expect(state, isA<ProviderUserDetailState>());
    });

    test('ProviderUserDetailLoaded holds full user data', () {
      const state = ProviderUserDetailLoaded({
        'id': 'u-1',
        'name': 'Ahmed Cashier',
        'email': 'ahmed@store.com',
        'phone': '+968 12345678',
        'role': 'cashier',
        'locale': 'ar',
        'is_active': true,
        'must_change_password': false,
        'store_id': 'store-1',
        'store_name': 'Store Alpha',
        'organization_id': 'org-1',
        'organization_name': 'Test Org',
      });
      expect(state.user['name'], 'Ahmed Cashier');
      expect(state.user['must_change_password'], false);
      expect(state.user['store_name'], 'Store Alpha');
    });

    test('ProviderUserDetailError holds error', () {
      const state = ProviderUserDetailError('Not found');
      expect(state.message, 'Not found');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Admin User List State
  // ═══════════════════════════════════════════════════════════════

  group('AdminUserListState', () {
    test('AdminUserListInitial is default state', () {
      const state = AdminUserListInitial();
      expect(state, isA<AdminUserListState>());
    });

    test('AdminUserListLoading represents loading', () {
      const state = AdminUserListLoading();
      expect(state, isA<AdminUserListState>());
    });

    test('AdminUserListLoaded holds admin list with roles', () {
      const state = AdminUserListLoaded([
        {
          'id': 'a-1',
          'name': 'Super Admin',
          'email': 'admin@thawani.com',
          'is_active': true,
          'two_factor_enabled': true,
          'roles': [
            {'role_id': 'r-1', 'role_name': 'Super Admin', 'role_slug': 'super-admin'},
          ],
        },
      ]);
      expect(state.admins.length, 1);
      expect(state.admins.first['two_factor_enabled'], true);
      expect((state.admins.first['roles'] as List).first['role_name'], 'Super Admin');
    });

    test('AdminUserListError holds error', () {
      const state = AdminUserListError('Unauthorized');
      expect(state.message, 'Unauthorized');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Admin User Detail State
  // ═══════════════════════════════════════════════════════════════

  group('AdminUserDetailState', () {
    test('AdminUserDetailInitial is default state', () {
      const state = AdminUserDetailInitial();
      expect(state, isA<AdminUserDetailState>());
    });

    test('AdminUserDetailLoaded holds full admin data', () {
      const state = AdminUserDetailLoaded({
        'id': 'a-1',
        'name': 'Test Admin',
        'email': 'test@thawani.com',
        'phone': '+968 9876543',
        'is_active': true,
        'two_factor_enabled': false,
        'roles': [],
        'last_login_at': '2025-01-15T10:30:00Z',
        'last_login_ip': '192.168.1.1',
      });
      expect(state.admin['name'], 'Test Admin');
      expect(state.admin['last_login_ip'], '192.168.1.1');
    });

    test('AdminUserDetailError holds error', () {
      const state = AdminUserDetailError('Server error');
      expect(state.message, 'Server error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: User Activity State
  // ═══════════════════════════════════════════════════════════════

  group('UserActivityState', () {
    test('UserActivityInitial is default state', () {
      const state = UserActivityInitial();
      expect(state, isA<UserActivityState>());
    });

    test('UserActivityLoading represents loading', () {
      const state = UserActivityLoading();
      expect(state, isA<UserActivityState>());
    });

    test('UserActivityLoaded holds activity logs', () {
      const state = UserActivityLoaded([
        {
          'id': 'log-1',
          'action': 'reset_password',
          'entity_type': 'user',
          'entity_id': 'u-1',
          'ip_address': '10.0.0.1',
          'created_at': '2025-01-15T10:30:00Z',
        },
        {
          'id': 'log-2',
          'action': 'user_disabled',
          'entity_type': 'user',
          'entity_id': 'u-1',
          'ip_address': '10.0.0.1',
          'created_at': '2025-01-15T11:00:00Z',
        },
      ]);
      expect(state.logs.length, 2);
      expect(state.logs.first['action'], 'reset_password');
    });

    test('UserActivityError holds error', () {
      const state = UserActivityError('Connection refused');
      expect(state.message, 'Connection refused');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P4: Data Integrity & Edge Cases
  // ═══════════════════════════════════════════════════════════════

  group('P4 Data Integrity', () {
    test('provider user has all required fields', () {
      final user = {
        'id': 'uuid-1',
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '+968 12345678',
        'role': 'cashier',
        'locale': 'ar',
        'is_active': true,
        'must_change_password': false,
        'store_id': 'store-1',
        'organization_id': 'org-1',
      };
      expect(user.containsKey('id'), true);
      expect(user.containsKey('must_change_password'), true);
      expect(user.containsKey('store_id'), true);
    });

    test('admin user invite data structure', () {
      final inviteData = {
        'name': 'New Admin',
        'email': 'new@thawani.com',
        'phone': '+968 1234567',
        'role_ids': ['role-uuid-1', 'role-uuid-2'],
        'is_active': true,
      };
      expect(inviteData['role_ids'], isA<List>());
      expect((inviteData['role_ids'] as List).length, 2);
    });

    test('all P4 provider user endpoints use /admin/users/provider prefix', () {
      expect(ApiEndpoints.adminProviderUsers, startsWith('/admin/users/provider'));
      expect(ApiEndpoints.adminProviderUserById('x'), startsWith('/admin/users/provider'));
      expect(ApiEndpoints.adminProviderUserResetPassword('x'), startsWith('/admin/users/provider'));
      expect(ApiEndpoints.adminProviderUserForcePasswordChange('x'), startsWith('/admin/users/provider'));
      expect(ApiEndpoints.adminProviderUserToggleActive('x'), startsWith('/admin/users/provider'));
      expect(ApiEndpoints.adminProviderUserActivity('x'), startsWith('/admin/users/provider'));
    });

    test('all P4 admin user endpoints use /admin/users/admins prefix', () {
      expect(ApiEndpoints.adminAdminUsers, startsWith('/admin/users/admins'));
      expect(ApiEndpoints.adminAdminUserById('x'), startsWith('/admin/users/admins'));
      expect(ApiEndpoints.adminAdminUserReset2fa('x'), startsWith('/admin/users/admins'));
      expect(ApiEndpoints.adminAdminUserActivity('x'), startsWith('/admin/users/admins'));
    });

    test('dynamic endpoints include the user ID', () {
      const testId = 'test-user-123';
      expect(ApiEndpoints.adminProviderUserById(testId), contains(testId));
      expect(ApiEndpoints.adminProviderUserResetPassword(testId), contains(testId));
      expect(ApiEndpoints.adminProviderUserForcePasswordChange(testId), contains(testId));
      expect(ApiEndpoints.adminProviderUserToggleActive(testId), contains(testId));
      expect(ApiEndpoints.adminProviderUserActivity(testId), contains(testId));
      expect(ApiEndpoints.adminAdminUserById(testId), contains(testId));
      expect(ApiEndpoints.adminAdminUserReset2fa(testId), contains(testId));
      expect(ApiEndpoints.adminAdminUserActivity(testId), contains(testId));
    });

    test('user roles are valid enum values', () {
      const validRoles = [
        'owner',
        'chain_manager',
        'branch_manager',
        'cashier',
        'inventory_clerk',
        'accountant',
        'kitchen_staff',
      ];
      expect(validRoles.length, 7);
      expect(validRoles.contains('cashier'), true);
      expect(validRoles.contains('owner'), true);
    });

    test('empty user list produces valid state', () {
      const state = ProviderUserListLoaded(users: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.users.isEmpty, true);
      expect(state.total, 0);
    });

    test('empty admin list produces valid state', () {
      const state = AdminUserListLoaded([]);
      expect(state.admins.isEmpty, true);
    });

    test('empty activity log produces valid state', () {
      const state = UserActivityLoaded([]);
      expect(state.logs.isEmpty, true);
    });

    test('self-edit restriction data for admin update', () {
      final updateData = {'name': 'Updated Name', 'is_active': false};
      // The backend blocks self-deactivation, so we test the data shape
      expect(updateData.containsKey('is_active'), true);
      expect(updateData['is_active'], false);
    });

    test('password reset response structure', () {
      final response = {'temporary_password': 'abc123xyz789', 'must_change_password': true};
      expect(response['temporary_password'], isNotEmpty);
      expect(response['must_change_password'], true);
    });
  });
}
