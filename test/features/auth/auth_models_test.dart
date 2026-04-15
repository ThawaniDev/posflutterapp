import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/auth/models/user.dart';
import 'package:wameedpos/features/auth/models/auth_token.dart';
import 'package:wameedpos/features/auth/models/auth_response.dart';
import 'package:wameedpos/features/auth/enums/user_role.dart';

void main() {
  group('User', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'user-uuid-123',
        'store_id': 'store-uuid-456',
        'organization_id': 'org-uuid-789',
        'name': 'Test Owner',
        'email': 'owner@test.com',
        'phone': '+96891234567',
        'role': 'owner',
        'locale': 'ar',
        'is_active': true,
        'email_verified_at': '2024-01-01T00:00:00.000Z',
        'last_login_at': '2024-06-15T10:30:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
        'store': {
          'id': 'store-uuid-456',
          'name': 'Main Branch',
          'name_ar': 'الفرع الرئيسي',
          'slug': 'main-branch',
          'currency': 'SAR',
          'locale': 'ar',
          'business_type': 'retail',
          'is_main_branch': true,
        },
        'organization': {
          'id': 'org-uuid-789',
          'name': 'Test Org',
          'name_ar': 'منظمة تجريبية',
          'slug': 'test-org',
          'country': 'OM',
        },
        'permissions': ['pos.sell', 'orders.create'],
      };

      final user = User.fromJson(json);

      expect(user.id, 'user-uuid-123');
      expect(user.storeId, 'store-uuid-456');
      expect(user.organizationId, 'org-uuid-789');
      expect(user.name, 'Test Owner');
      expect(user.email, 'owner@test.com');
      expect(user.phone, '+96891234567');
      expect(user.role, UserRole.owner);
      expect(user.locale, 'ar');
      expect(user.isActive, true);
      expect(user.emailVerifiedAt, isNotNull);
      expect(user.lastLoginAt, isNotNull);
      expect(user.store, isNotNull);
      expect(user.store!.name, 'Main Branch');
      expect(user.store!.isMainBranch, true);
      expect(user.organization, isNotNull);
      expect(user.organization!.name, 'Test Org');
      expect(user.organization!.country, 'OM');
      expect(user.permissions, ['pos.sell', 'orders.create']);
    });

    test('fromJson resolves storeId from nested store', () {
      final json = {
        'id': 'user-1',
        'name': 'User',
        'store': {'id': 'store-from-nested', 'name': 'Store'},
      };

      final user = User.fromJson(json);
      expect(user.storeId, 'store-from-nested');
    });

    test('fromJson handles null optional fields', () {
      final json = {'id': 'user-1', 'name': 'Minimal User'};

      final user = User.fromJson(json);
      expect(user.email, isNull);
      expect(user.phone, isNull);
      expect(user.role, isNull);
      expect(user.store, isNull);
      expect(user.organization, isNull);
      expect(user.permissions, isNull);
      expect(user.isActive, true); // defaults to true
    });

    test('fromJson handles unknown role gracefully', () {
      final json = {'id': 'user-1', 'name': 'User', 'role': 'unknown_role'};

      final user = User.fromJson(json);
      expect(user.role, isNull); // tryFromValue returns null for unknown
    });

    test('toJson serializes correctly', () {
      final user = User(id: 'user-1', name: 'Test', email: 'test@test.com', role: UserRole.cashier, locale: 'en', isActive: true);

      final json = user.toJson();
      expect(json['id'], 'user-1');
      expect(json['name'], 'Test');
      expect(json['email'], 'test@test.com');
      expect(json['role'], 'cashier');
      expect(json['locale'], 'en');
      expect(json['is_active'], true);
    });

    test('isOwner returns true for owner role', () {
      final owner = User(id: '1', name: 'Owner', role: UserRole.owner);
      expect(owner.isOwner, true);

      final cashier = User(id: '2', name: 'Cashier', role: UserRole.cashier);
      expect(cashier.isOwner, false);
    });

    test('isManager returns true for manager roles', () {
      final branchMgr = User(id: '1', name: 'BM', role: UserRole.branchManager);
      expect(branchMgr.isManager, true);

      final chainMgr = User(id: '2', name: 'CM', role: UserRole.chainManager);
      expect(chainMgr.isManager, true);

      final cashier = User(id: '3', name: 'C', role: UserRole.cashier);
      expect(cashier.isManager, false);
    });

    test('equality is based on id', () {
      final user1 = User(id: 'same-id', name: 'User 1');
      final user2 = User(id: 'same-id', name: 'User 2');
      final user3 = User(id: 'other-id', name: 'User 1');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('copyWith creates modified copy', () {
      final user = User(id: '1', name: 'Original', email: 'a@b.com');
      final copy = user.copyWith(name: 'Modified');

      expect(copy.name, 'Modified');
      expect(copy.email, 'a@b.com'); // unchanged
      expect(copy.id, '1'); // unchanged
    });
  });

  group('UserStore', () {
    test('fromJson parses correctly', () {
      final json = {'id': 'store-1', 'name': 'My Store', 'name_ar': 'متجري', 'currency': 'SAR', 'is_main_branch': true};

      final store = UserStore.fromJson(json);
      expect(store.id, 'store-1');
      expect(store.name, 'My Store');
      expect(store.nameAr, 'متجري');
      expect(store.currency, 'SAR');
      expect(store.isMainBranch, true);
    });

    test('toJson round-trips', () {
      final store = UserStore(id: 'store-1', name: 'Store', currency: 'SAR', isMainBranch: false);

      final json = store.toJson();
      final restored = UserStore.fromJson(json);
      expect(restored.id, store.id);
      expect(restored.name, store.name);
      expect(restored.currency, store.currency);
    });
  });

  group('UserOrganization', () {
    test('fromJson parses correctly', () {
      final json = {'id': 'org-1', 'name': 'Test Org', 'country': 'OM'};

      final org = UserOrganization.fromJson(json);
      expect(org.id, 'org-1');
      expect(org.name, 'Test Org');
      expect(org.country, 'OM');
    });
  });

  group('AuthToken', () {
    test('fromJson parses correctly', () {
      final json = {'token': 'abc123token', 'token_type': 'Bearer'};

      final token = AuthToken.fromJson(json);
      expect(token.token, 'abc123token');
      expect(token.tokenType, 'Bearer');
    });

    test('defaults to Bearer if token_type missing', () {
      final json = {'token': 'test-token'};
      final token = AuthToken.fromJson(json);
      expect(token.tokenType, 'Bearer');
    });

    test('headerValue formats correctly', () {
      final token = AuthToken(token: 'mytoken123');
      expect(token.headerValue, 'Bearer mytoken123');
    });
  });

  group('AuthResponse', () {
    test('fromJson parses user and token', () {
      final json = {
        'user': {'id': 'user-1', 'name': 'Owner', 'email': 'owner@test.com', 'role': 'owner'},
        'token': 'generated-token-123',
        'token_type': 'Bearer',
      };

      final response = AuthResponse.fromJson(json);
      expect(response.user.id, 'user-1');
      expect(response.user.name, 'Owner');
      expect(response.user.role, UserRole.owner);
      expect(response.token.token, 'generated-token-123');
      expect(response.token.tokenType, 'Bearer');
    });
  });

  group('UserRole', () {
    test('fromValue parses all roles', () {
      expect(UserRole.fromValue('owner'), UserRole.owner);
      expect(UserRole.fromValue('chain_manager'), UserRole.chainManager);
      expect(UserRole.fromValue('branch_manager'), UserRole.branchManager);
      expect(UserRole.fromValue('cashier'), UserRole.cashier);
      expect(UserRole.fromValue('inventory_clerk'), UserRole.inventoryClerk);
      expect(UserRole.fromValue('accountant'), UserRole.accountant);
      expect(UserRole.fromValue('kitchen_staff'), UserRole.kitchenStaff);
    });

    test('fromValue throws for invalid value', () {
      expect(() => UserRole.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(UserRole.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for invalid', () {
      expect(UserRole.tryFromValue('nonexistent'), isNull);
    });
  });
}
