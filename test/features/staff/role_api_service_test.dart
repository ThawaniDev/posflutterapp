// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';

// ─── Helpers ──────────────────────────────────────────────────────

Dio _fakeDio(Map<String, dynamic> Function(RequestOptions opts) handler) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        try {
          requestHandler.resolve(
            Response(data: handler(opts), requestOptions: opts, statusCode: 200),
          );
        } catch (e) {
          requestHandler.reject(DioException(requestOptions: opts, error: e));
        }
      },
    ),
  );
  return dio;
}

Map<String, dynamic> _roleJson({int id = 1, String name = 'cashier'}) => {
      'id': id,
      'store_id': 'store-001',
      'name': name,
      'display_name': name.replaceAll('_', ' '),
      'description': null,
      'permission_ids': <int>[],
    };

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  group('RoleApiService', () {
    // ─ listRoles ─────────────────────────────────────────────

    test('listRoles: sends store_id param and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.roles);
        expect(opts.method, 'GET');
        expect(opts.queryParameters['store_id'], 'store-001');
        return {
          'success': true,
          'data': [_roleJson(id: 1), _roleJson(id: 2, name: 'supervisor')],
        };
      });

      final svc = RoleApiService(dio);
      final roles = await svc.listRoles('store-001');

      expect(roles.length, 2);
      expect(roles.first.id, 1);
      expect(roles.last.name, 'supervisor');
    });

    // ─ createRole ────────────────────────────────────────────

    test('createRole: sends required fields in body and returns new role', () async {
      late Map<String, dynamic> sentBody;
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.roles);
        sentBody = opts.data as Map<String, dynamic>;
        return {'success': true, 'data': _roleJson(id: 10, name: 'custom')};
      });

      final svc = RoleApiService(dio);
      final role = await svc.createRole(
        storeId: 'store-001',
        name: 'custom',
        displayName: 'Custom Role',
      );

      expect(role.id, 10);
      expect(role.name, 'custom');
      expect(sentBody['store_id'], 'store-001');
      expect(sentBody['name'], 'custom');
      expect(sentBody['display_name'], 'Custom Role');
    });

    // ─ updateRole ────────────────────────────────────────────

    test('updateRole: sends PUT to correct endpoint', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'PUT');
        expect(opts.path, '${ApiEndpoints.roles}/1');
        return {'success': true, 'data': _roleJson(id: 1, name: 'updated')};
      });

      final svc = RoleApiService(dio);
      final role = await svc.updateRole(1, {'display_name': 'Updated'});

      expect(role.id, 1);
    });

    // ─ deleteRole ────────────────────────────────────────────

    test('deleteRole: sends DELETE to correct endpoint', () async {
      var deleteCalled = false;
      final dio = _fakeDio((opts) {
        expect(opts.method, 'DELETE');
        expect(opts.path, '${ApiEndpoints.roles}/5');
        deleteCalled = true;
        return {'success': true, 'data': null};
      });

      final svc = RoleApiService(dio);
      await svc.deleteRole(5);

      expect(deleteCalled, true);
    });

    // ─ assignRole ────────────────────────────────────────────

    test('assignRole: POSTs to roles/:id/assign with user_id', () async {
      late Map<String, dynamic> sentBody;
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.roles}/3/assign');
        expect(opts.method, 'POST');
        sentBody = opts.data as Map<String, dynamic>;
        return {'success': true, 'data': null};
      });

      final svc = RoleApiService(dio);
      await svc.assignRole(3, 'user-xyz');

      expect(sentBody['user_id'], 'user-xyz');
    });

    // ─ unassignRole ──────────────────────────────────────────

    test('unassignRole: POSTs to roles/:id/unassign with user_id', () async {
      late Map<String, dynamic> sentBody;
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.roles}/3/unassign');
        sentBody = opts.data as Map<String, dynamic>;
        return {'success': true, 'data': null};
      });

      final svc = RoleApiService(dio);
      await svc.unassignRole(3, 'user-xyz');

      expect(sentBody['user_id'], 'user-xyz');
    });

    // ─ getUserPermissionsWithScope ────────────────────────────

    test('getUserPermissionsWithScope: parses permissions, scope, and accessible stores', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.userPermissions);
        expect(opts.method, 'GET');
        return {
          'success': true,
          'data': {
            'permissions': ['staff.view', 'staff.create', 'pos.sell'],
            'branch_scope': 'branch',
            'accessible_store_ids': ['store-001'],
            'branch_roles': <String, dynamic>{},
            'store_id': 'store-001',
          },
        };
      });

      final svc = RoleApiService(dio);
      final result = await svc.getUserPermissionsWithScope('store-001');

      expect(result['permissions'], containsAll(['staff.view', 'staff.create', 'pos.sell']));
      expect(result['branch_scope'], 'branch');
      expect(result['accessible_store_ids'], contains('store-001'));
    });

    test('getUserPermissionsWithScope: organization scope returns multiple store ids', () async {
      final dio = _fakeDio((_) => {
            'success': true,
            'data': {
              'permissions': ['staff.view'],
              'branch_scope': 'organization',
              'accessible_store_ids': ['store-001', 'store-002'],
              'branch_roles': <String, dynamic>{},
              'store_id': null,
            },
          });

      final svc = RoleApiService(dio);
      final result = await svc.getUserPermissionsWithScope(null);

      expect(result['branch_scope'], 'organization');
      final ids = result['accessible_store_ids'] as List<String>;
      expect(ids.length, 2);
    });

    // ─ getUserPermissionsWithScope: no store_id param when null ──

    test('getUserPermissionsWithScope: no query params sent when storeId is null', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters, isEmpty);
        return {
          'success': true,
          'data': {
            'permissions': <String>[],
            'branch_scope': 'branch',
            'accessible_store_ids': <String>[],
            'branch_roles': <String, dynamic>{},
          },
        };
      });

      final svc = RoleApiService(dio);
      await svc.getUserPermissionsWithScope(null);
    });

    // ─ listPermissions ───────────────────────────────────────

    test('listPermissions: parses permissions list', () async {
      final dio = _fakeDio((_) => {
            'success': true,
            'data': [
              {'id': 1, 'name': 'staff.view', 'display_name': 'View Staff', 'module': 'staff'},
              {'id': 2, 'name': 'staff.create', 'display_name': 'Create Staff', 'module': 'staff'},
            ],
          });

      final svc = RoleApiService(dio);
      final perms = await svc.listPermissions();

      expect(perms.length, 2);
      expect(perms.first.name, 'staff.view');
    });

    // ─ getRole ───────────────────────────────────────────────

    test('getRole: fetches and parses single role', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.roles}/7');
        return {'success': true, 'data': _roleJson(id: 7, name: 'manager')};
      });

      final svc = RoleApiService(dio);
      final role = await svc.getRole(7);

      expect(role.id, 7);
      expect(role.name, 'manager');
    });
  });
}
