// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/providers/roles_state.dart';
import 'package:wameedpos/features/staff/repositories/roles_repository.dart';
import 'package:wameedpos/features/staff/models/permission.dart';
import 'package:wameedpos/features/staff/models/role.dart';

// ─── No-op AuthLocalStorage ────────────────────────────────────────────────

class _NoOpAuthLocalStorage extends AuthLocalStorage {
  @override Future<String?> getStoreId() async => 'store-test';
  @override Future<String?> getToken() async => null;
  @override Future<void> saveToken(String token) async {}
  @override Future<void> deleteToken() async {}
}

// ─── Fake RolesRepository ─────────────────────────────────────────

class _FakeRolesRepository extends RolesRepository {
  _FakeRolesRepository(UserPermissionsState initialState)
      : _initialState = initialState,
        super(
          apiService: RoleApiService(Dio()),
          localStorage: _NoOpAuthLocalStorage(),
        );

  final UserPermissionsState _initialState;

  @override
  Future<Map<String, dynamic>> getMyPermissionsWithScope() async {
    return {
      'permissions': _initialState.permissions,
      'branch_scope': _initialState.branchScope,
      'accessible_store_ids': _initialState.accessibleStoreIds,
      'branch_roles': _initialState.branchRoles,
    };
  }

  @override Future<List<Role>> listRoles() async => [];
  @override Future<Role> createRole({String? name, String? displayName, String? description, List<int>? permissionIds}) async => throw UnimplementedError();
  @override Future<void> deleteRole(int roleId) async {}
  @override Future<void> assignRole(int roleId, String userId) async {}
  @override Future<void> unassignRole(int roleId, String userId) async {}
  @override Future<bool> checkPinRequired(String permissionCode) async => false;
  @override Future<List<Permission>> listPermissions() async => [];
  @override Future<Map<String, List<Permission>>> getPermissionsGrouped() async => {};
  @override Future<List<String>> getModules() async => [];
  @override Future<List<String>> getMyPermissions() async => [];
  @override Future<List<Permission>> getPinProtected() async => [];
  @override Future<Map<String, dynamic>> requestPinOverride({String? storeId, String? pin, String? permissionCode, Map<String, dynamic>? context}) async => {};
}

// ─── Helper: sets up a loaded permissions state via the notifier ──

class _PreloadedNotifier extends UserPermissionsNotifier {
  _PreloadedNotifier(super.repository, UserPermissionsState state) {
    // Directly set state after construction
    Future.microtask(() => this.state = state);
  }
}

// ─── Widget harness ───────────────────────────────────────────────

Widget _harness(
  Widget child, {
  required RolesRepository repo,
}) {
  return ProviderScope(
    overrides: [rolesRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  group('PermissionGuardPage', () {
    // ─ Loading state ─────────────────────────────────────────

    testWidgets('shows spinner while permissions are not yet loaded', (tester) async {
      // Start with unloaded state — never call load()
      final repo = _FakeRolesRepository(const UserPermissionsState());

      await tester.pumpWidget(
        _harness(
          PermissionGuardPage(
            permission: 'staff.view',
            child: const Text('SECRET CONTENT'),
          ),
          repo: repo,
        ),
      );

      // Initial frame — not yet loaded
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('SECRET CONTENT'), findsNothing);
    });

    // ─ Permission granted ─────────────────────────────────────

    testWidgets('shows child when user has the required permission', (tester) async {
      final repo = _FakeRolesRepository(const UserPermissionsState());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rolesRepositoryProvider.overrideWithValue(repo),
            userPermissionsProvider.overrideWith(
              (ref) => UserPermissionsNotifier(ref.watch(rolesRepositoryProvider))
                ..state = const UserPermissionsState(
                  isLoaded: true,
                  permissions: ['staff.view', 'staff.create'],
                  branchScope: 'branch',
                ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: PermissionGuardPage(
              permission: 'staff.view',
              child: const Text('ALLOWED CONTENT'),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ALLOWED CONTENT'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
    });

    // ─ Permission denied ──────────────────────────────────────

    testWidgets('shows locked page when user lacks required permission', (tester) async {
      final repo = _FakeRolesRepository(const UserPermissionsState());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rolesRepositoryProvider.overrideWithValue(repo),
            userPermissionsProvider.overrideWith(
              (ref) => UserPermissionsNotifier(ref.watch(rolesRepositoryProvider))
                ..state = const UserPermissionsState(
                  isLoaded: true,
                  permissions: ['staff.view'], // no staff.delete
                  branchScope: 'branch',
                ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: PermissionGuardPage(
              permission: 'staff.delete',
              child: const Text('RESTRICTED CONTENT'),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('RESTRICTED CONTENT'), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    // ─ anyOf logic ────────────────────────────────────────────

    testWidgets('anyOf: shows child when user has at least one of the permissions', (tester) async {
      final repo = _FakeRolesRepository(const UserPermissionsState());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rolesRepositoryProvider.overrideWithValue(repo),
            userPermissionsProvider.overrideWith(
              (ref) => UserPermissionsNotifier(ref.watch(rolesRepositoryProvider))
                ..state = const UserPermissionsState(
                  isLoaded: true,
                  permissions: ['reports.view'], // has only reports.view
                  branchScope: 'branch',
                ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: PermissionGuardPage(
              anyOf: const ['reports.view', 'reports.export'], // any of these suffices
              child: const Text('REPORTS PAGE'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('REPORTS PAGE'), findsOneWidget);
    });

    testWidgets('anyOf: shows locked page when user has none of the listed permissions', (tester) async {
      final repo = _FakeRolesRepository(const UserPermissionsState());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rolesRepositoryProvider.overrideWithValue(repo),
            userPermissionsProvider.overrideWith(
              (ref) => UserPermissionsNotifier(ref.watch(rolesRepositoryProvider))
                ..state = const UserPermissionsState(
                  isLoaded: true,
                  permissions: ['staff.view'], // unrelated permission
                  branchScope: 'branch',
                ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: PermissionGuardPage(
              anyOf: const ['reports.view', 'reports.export'],
              child: const Text('REPORTS PAGE'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('REPORTS PAGE'), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });
  });
}
