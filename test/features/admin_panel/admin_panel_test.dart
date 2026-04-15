import 'package:flutter_test/flutter_test.dart';

// Models (from branches)
import 'package:wameedpos/features/branches/models/admin_user.dart';
import 'package:wameedpos/features/branches/models/admin_activity_log.dart';
import 'package:wameedpos/features/branches/models/provider_note.dart';
import 'package:wameedpos/features/branches/models/provider_registration.dart';
import 'package:wameedpos/features/branches/models/provider_limit_override.dart';
import 'package:wameedpos/features/branches/models/admin_user_role.dart';

// Enum
import 'package:wameedpos/features/branches/enums/provider_registration_status.dart';

// States
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ProviderRegistrationStatus Enum
  // ════════════════════════════════════════════════════════

  group('ProviderRegistrationStatus', () {
    test('has 3 values', () {
      expect(ProviderRegistrationStatus.values.length, 3);
    });

    test('values contain correct strings', () {
      expect(ProviderRegistrationStatus.pending.value, 'pending');
      expect(ProviderRegistrationStatus.approved.value, 'approved');
      expect(ProviderRegistrationStatus.rejected.value, 'rejected');
    });

    test('fromValue returns correct enum for each value', () {
      expect(ProviderRegistrationStatus.fromValue('pending'), ProviderRegistrationStatus.pending);
      expect(ProviderRegistrationStatus.fromValue('approved'), ProviderRegistrationStatus.approved);
      expect(ProviderRegistrationStatus.fromValue('rejected'), ProviderRegistrationStatus.rejected);
    });

    test('fromValue throws for invalid value', () {
      expect(() => ProviderRegistrationStatus.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns correct enum', () {
      expect(ProviderRegistrationStatus.tryFromValue('pending'), ProviderRegistrationStatus.pending);
    });

    test('tryFromValue returns null for invalid value', () {
      expect(ProviderRegistrationStatus.tryFromValue('invalid'), isNull);
    });

    test('tryFromValue returns null for null', () {
      expect(ProviderRegistrationStatus.tryFromValue(null), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminUser Model
  // ════════════════════════════════════════════════════════

  group('AdminUser', () {
    final now = DateTime.parse('2025-01-01T12:00:00.000Z');
    final json = {
      'id': 'admin-uuid-1',
      'name': 'Super Admin',
      'email': 'admin@thawani.com',
      'password_hash': 'hashed_pw',
      'phone': '+96812345678',
      'avatar_url': 'https://img.test/avatar.png',
      'is_active': true,
      'two_factor_secret': null,
      'two_factor_enabled': false,
      'two_factor_confirmed_at': null,
      'last_login_at': '2025-01-01T12:00:00.000Z',
      'last_login_ip': '192.168.1.1',
      'created_at': '2025-01-01T12:00:00.000Z',
      'updated_at': '2025-01-01T12:00:00.000Z',
    };

    test('fromJson creates correct instance', () {
      final user = AdminUser.fromJson(json);
      expect(user.id, 'admin-uuid-1');
      expect(user.name, 'Super Admin');
      expect(user.email, 'admin@thawani.com');
      expect(user.passwordHash, 'hashed_pw');
      expect(user.phone, '+96812345678');
      expect(user.avatarUrl, 'https://img.test/avatar.png');
      expect(user.isActive, true);
      expect(user.twoFactorEnabled, false);
      expect(user.twoFactorSecret, isNull);
      expect(user.twoFactorConfirmedAt, isNull);
      expect(user.lastLoginAt, now);
      expect(user.lastLoginIp, '192.168.1.1');
      expect(user.createdAt, now);
      expect(user.updatedAt, now);
    });

    test('toJson produces correct map', () {
      final user = AdminUser.fromJson(json);
      final output = user.toJson();
      expect(output['id'], 'admin-uuid-1');
      expect(output['name'], 'Super Admin');
      expect(output['email'], 'admin@thawani.com');
      expect(output['password_hash'], 'hashed_pw');
      expect(output['is_active'], true);
    });

    test('fromJson handles nullable fields as null', () {
      final minJson = {'id': 'admin-uuid-2', 'name': 'Min Admin', 'email': 'min@test.com', 'password_hash': 'hash'};
      final user = AdminUser.fromJson(minJson);
      expect(user.phone, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.isActive, isNull);
      expect(user.lastLoginAt, isNull);
      expect(user.createdAt, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final user = AdminUser.fromJson(json);
      final updated = user.copyWith(name: 'New Name', isActive: false);
      expect(updated.name, 'New Name');
      expect(updated.isActive, false);
      expect(updated.email, user.email); // unchanged
      expect(updated.id, user.id); // unchanged
    });

    test('equality is based on id', () {
      final a = AdminUser.fromJson(json);
      final b = AdminUser.fromJson({...json, 'name': 'Different'});
      expect(a, equals(b));
    });

    test('different id means not equal', () {
      final a = AdminUser.fromJson(json);
      final b = AdminUser.fromJson({...json, 'id': 'other-id'});
      expect(a, isNot(equals(b)));
    });

    test('toString contains id and name', () {
      final user = AdminUser.fromJson(json);
      expect(user.toString(), contains('admin-uuid-1'));
      expect(user.toString(), contains('Super Admin'));
    });

    test('roundtrip fromJson -> toJson -> fromJson preserves data', () {
      final original = AdminUser.fromJson(json);
      final roundtrip = AdminUser.fromJson(original.toJson());
      expect(roundtrip.id, original.id);
      expect(roundtrip.name, original.name);
      expect(roundtrip.email, original.email);
      expect(roundtrip.isActive, original.isActive);
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminActivityLog Model
  // ════════════════════════════════════════════════════════

  group('AdminActivityLog', () {
    final json = {
      'id': 'log-uuid-1',
      'admin_user_id': 'admin-uuid-1',
      'action': 'store.suspended',
      'entity_type': 'store',
      'entity_id': 'store-uuid-1',
      'details': {'reason': 'Policy violation'},
      'ip_address': '10.0.0.1',
      'user_agent': 'Mozilla/5.0',
      'created_at': '2025-01-15T09:30:00.000Z',
    };

    test('fromJson creates correct instance', () {
      final log = AdminActivityLog.fromJson(json);
      expect(log.id, 'log-uuid-1');
      expect(log.adminUserId, 'admin-uuid-1');
      expect(log.action, 'store.suspended');
      expect(log.entityType, 'store');
      expect(log.entityId, 'store-uuid-1');
      expect(log.details, {'reason': 'Policy violation'});
      expect(log.ipAddress, '10.0.0.1');
      expect(log.userAgent, 'Mozilla/5.0');
      expect(log.createdAt, isA<DateTime>());
    });

    test('toJson produces correct map', () {
      final log = AdminActivityLog.fromJson(json);
      final output = log.toJson();
      expect(output['action'], 'store.suspended');
      expect(output['details'], {'reason': 'Policy violation'});
      expect(output['ip_address'], '10.0.0.1');
    });

    test('nullable fields can be null', () {
      final minJson = {'id': 'log-uuid-2', 'action': 'test', 'ip_address': '127.0.0.1'};
      final log = AdminActivityLog.fromJson(minJson);
      expect(log.adminUserId, isNull);
      expect(log.entityType, isNull);
      expect(log.entityId, isNull);
      expect(log.details, isNull);
      expect(log.userAgent, isNull);
      expect(log.createdAt, isNull);
    });

    test('copyWith updates fields', () {
      final log = AdminActivityLog.fromJson(json);
      final updated = log.copyWith(action: 'store.activated');
      expect(updated.action, 'store.activated');
      expect(updated.id, log.id);
    });

    test('equality is based on id', () {
      final a = AdminActivityLog.fromJson(json);
      final b = AdminActivityLog.fromJson({...json, 'action': 'other'});
      expect(a, equals(b));
    });

    test('roundtrip preserves data', () {
      final original = AdminActivityLog.fromJson(json);
      final roundtrip = AdminActivityLog.fromJson(original.toJson());
      expect(roundtrip.action, original.action);
      expect(roundtrip.entityType, original.entityType);
      expect(roundtrip.details, original.details);
    });
  });

  // ════════════════════════════════════════════════════════
  // ProviderNote Model
  // ════════════════════════════════════════════════════════

  group('ProviderNote', () {
    final json = {
      'id': 'note-uuid-1',
      'organization_id': 'org-uuid-1',
      'admin_user_id': 'admin-uuid-1',
      'note_text': 'Follow up on compliance docs',
      'created_at': '2025-02-10T14:00:00.000Z',
    };

    test('fromJson creates correct instance', () {
      final note = ProviderNote.fromJson(json);
      expect(note.id, 'note-uuid-1');
      expect(note.organizationId, 'org-uuid-1');
      expect(note.adminUserId, 'admin-uuid-1');
      expect(note.noteText, 'Follow up on compliance docs');
      expect(note.createdAt, isA<DateTime>());
    });

    test('toJson produces correct map', () {
      final note = ProviderNote.fromJson(json);
      final output = note.toJson();
      expect(output['note_text'], 'Follow up on compliance docs');
      expect(output['organization_id'], 'org-uuid-1');
    });

    test('nullable created_at', () {
      final minJson = {
        'id': 'note-uuid-2',
        'organization_id': 'org-uuid-2',
        'admin_user_id': 'admin-uuid-2',
        'note_text': 'No date',
      };
      final note = ProviderNote.fromJson(minJson);
      expect(note.createdAt, isNull);
    });

    test('copyWith updates note text', () {
      final note = ProviderNote.fromJson(json);
      final updated = note.copyWith(noteText: 'Updated text');
      expect(updated.noteText, 'Updated text');
      expect(updated.id, note.id);
    });

    test('equality is based on id', () {
      final a = ProviderNote.fromJson(json);
      final b = ProviderNote.fromJson({...json, 'note_text': 'Different'});
      expect(a, equals(b));
    });
  });

  // ════════════════════════════════════════════════════════
  // ProviderRegistration Model
  // ════════════════════════════════════════════════════════

  group('ProviderRegistration', () {
    final json = {
      'id': 'reg-uuid-1',
      'organization_name': 'Oman Foods LLC',
      'organization_name_ar': 'أغذية عمان',
      'owner_name': 'Ahmed Al-Balushi',
      'owner_email': 'ahmed@omanfoods.om',
      'owner_phone': '+96899887766',
      'cr_number': 'CR12345',
      'vat_number': 'VAT67890',
      'business_type_id': 'bt-restaurant',
      'status': 'pending',
      'reviewed_by': null,
      'reviewed_at': null,
      'rejection_reason': null,
      'created_at': '2025-03-01T08:00:00.000Z',
      'updated_at': '2025-03-01T08:00:00.000Z',
    };

    test('fromJson creates correct instance with enum status', () {
      final reg = ProviderRegistration.fromJson(json);
      expect(reg.id, 'reg-uuid-1');
      expect(reg.organizationName, 'Oman Foods LLC');
      expect(reg.organizationNameAr, 'أغذية عمان');
      expect(reg.ownerName, 'Ahmed Al-Balushi');
      expect(reg.ownerEmail, 'ahmed@omanfoods.om');
      expect(reg.ownerPhone, '+96899887766');
      expect(reg.crNumber, 'CR12345');
      expect(reg.vatNumber, 'VAT67890');
      expect(reg.businessTypeId, 'bt-restaurant');
      expect(reg.status, ProviderRegistrationStatus.pending);
      expect(reg.reviewedBy, isNull);
      expect(reg.reviewedAt, isNull);
      expect(reg.rejectionReason, isNull);
    });

    test('toJson serializes status as string', () {
      final reg = ProviderRegistration.fromJson(json);
      final output = reg.toJson();
      expect(output['status'], 'pending');
      expect(output['organization_name'], 'Oman Foods LLC');
    });

    test('fromJson with approved status', () {
      final approvedJson = {
        ...json,
        'status': 'approved',
        'reviewed_by': 'admin-uuid-1',
        'reviewed_at': '2025-03-02T10:00:00.000Z',
      };
      final reg = ProviderRegistration.fromJson(approvedJson);
      expect(reg.status, ProviderRegistrationStatus.approved);
      expect(reg.reviewedBy, 'admin-uuid-1');
      expect(reg.reviewedAt, isA<DateTime>());
    });

    test('fromJson with rejected status and reason', () {
      final rejectedJson = {
        ...json,
        'status': 'rejected',
        'reviewed_by': 'admin-uuid-1',
        'reviewed_at': '2025-03-02T10:00:00.000Z',
        'rejection_reason': 'Incomplete documents',
      };
      final reg = ProviderRegistration.fromJson(rejectedJson);
      expect(reg.status, ProviderRegistrationStatus.rejected);
      expect(reg.rejectionReason, 'Incomplete documents');
    });

    test('copyWith updates status', () {
      final reg = ProviderRegistration.fromJson(json);
      final updated = reg.copyWith(status: ProviderRegistrationStatus.approved);
      expect(updated.status, ProviderRegistrationStatus.approved);
      expect(updated.id, reg.id);
    });

    test('equality is based on id', () {
      final a = ProviderRegistration.fromJson(json);
      final b = ProviderRegistration.fromJson({...json, 'organization_name': 'Other'});
      expect(a, equals(b));
    });

    test('nullable fields can be null', () {
      final minJson = {
        'id': 'reg-uuid-2',
        'organization_name': 'Test',
        'owner_name': 'Owner',
        'owner_email': 'owner@test.com',
        'owner_phone': '+96811111111',
        'status': 'pending',
      };
      final reg = ProviderRegistration.fromJson(minJson);
      expect(reg.organizationNameAr, isNull);
      expect(reg.crNumber, isNull);
      expect(reg.vatNumber, isNull);
      expect(reg.businessTypeId, isNull);
      expect(reg.createdAt, isNull);
    });

    test('roundtrip fromJson -> toJson -> fromJson preserves data', () {
      final original = ProviderRegistration.fromJson(json);
      final roundtrip = ProviderRegistration.fromJson(original.toJson());
      expect(roundtrip.id, original.id);
      expect(roundtrip.status, original.status);
      expect(roundtrip.organizationName, original.organizationName);
    });
  });

  // ════════════════════════════════════════════════════════
  // ProviderLimitOverride Model
  // ════════════════════════════════════════════════════════

  group('ProviderLimitOverride', () {
    final json = {
      'id': 'limit-uuid-1',
      'store_id': 'store-uuid-1',
      'limit_key': 'max_products',
      'override_value': 500,
      'reason': 'Premium partner',
      'set_by': 'admin-uuid-1',
      'expires_at': '2025-12-31T23:59:59.000Z',
      'created_at': '2025-01-15T10:00:00.000Z',
    };

    test('fromJson creates correct instance', () {
      final lo = ProviderLimitOverride.fromJson(json);
      expect(lo.id, 'limit-uuid-1');
      expect(lo.storeId, 'store-uuid-1');
      expect(lo.limitKey, 'max_products');
      expect(lo.overrideValue, 500);
      expect(lo.reason, 'Premium partner');
      expect(lo.setBy, 'admin-uuid-1');
      expect(lo.expiresAt, isA<DateTime>());
      expect(lo.createdAt, isA<DateTime>());
    });

    test('toJson produces correct map', () {
      final lo = ProviderLimitOverride.fromJson(json);
      final output = lo.toJson();
      expect(output['limit_key'], 'max_products');
      expect(output['override_value'], 500);
      expect(output['set_by'], 'admin-uuid-1');
    });

    test('overrideValue handles numeric types', () {
      final jsonDouble = {...json, 'override_value': 500.0};
      final lo = ProviderLimitOverride.fromJson(jsonDouble);
      expect(lo.overrideValue, 500);
      expect(lo.overrideValue, isA<int>());
    });

    test('nullable fields can be null', () {
      final minJson = {
        'id': 'limit-uuid-2',
        'store_id': 'store-uuid-2',
        'limit_key': 'max_staff',
        'override_value': 10,
        'set_by': 'admin-uuid-2',
      };
      final lo = ProviderLimitOverride.fromJson(minJson);
      expect(lo.reason, isNull);
      expect(lo.expiresAt, isNull);
      expect(lo.createdAt, isNull);
    });

    test('copyWith updates value', () {
      final lo = ProviderLimitOverride.fromJson(json);
      final updated = lo.copyWith(overrideValue: 1000);
      expect(updated.overrideValue, 1000);
      expect(updated.limitKey, lo.limitKey);
    });

    test('equality is based on id', () {
      final a = ProviderLimitOverride.fromJson(json);
      final b = ProviderLimitOverride.fromJson({...json, 'override_value': 999});
      expect(a, equals(b));
    });

    test('roundtrip preserves data', () {
      final original = ProviderLimitOverride.fromJson(json);
      final roundtrip = ProviderLimitOverride.fromJson(original.toJson());
      expect(roundtrip.limitKey, original.limitKey);
      expect(roundtrip.overrideValue, original.overrideValue);
      expect(roundtrip.setBy, original.setBy);
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminUserRole Model
  // ════════════════════════════════════════════════════════

  group('AdminUserRole', () {
    final json = {
      'admin_user_id': 'admin-uuid-1',
      'admin_role_id': 'role-uuid-1',
      'assigned_at': '2025-01-01T00:00:00.000Z',
      'assigned_by': 'admin-uuid-0',
    };

    test('fromJson creates correct instance', () {
      final role = AdminUserRole.fromJson(json);
      expect(role.adminUserId, 'admin-uuid-1');
      expect(role.adminRoleId, 'role-uuid-1');
      expect(role.assignedAt, isA<DateTime>());
      expect(role.assignedBy, 'admin-uuid-0');
    });

    test('toJson produces correct map', () {
      final role = AdminUserRole.fromJson(json);
      final output = role.toJson();
      expect(output['admin_user_id'], 'admin-uuid-1');
      expect(output['admin_role_id'], 'role-uuid-1');
    });

    test('nullable fields can be null', () {
      final minJson = {'admin_user_id': 'admin-uuid-2', 'admin_role_id': 'role-uuid-2'};
      final role = AdminUserRole.fromJson(minJson);
      expect(role.assignedAt, isNull);
      expect(role.assignedBy, isNull);
    });

    test('copyWith updates fields', () {
      final role = AdminUserRole.fromJson(json);
      final updated = role.copyWith(adminRoleId: 'role-uuid-new');
      expect(updated.adminRoleId, 'role-uuid-new');
      expect(updated.adminUserId, role.adminUserId);
    });

    test('equality uses all fields', () {
      final a = AdminUserRole.fromJson(json);
      final b = AdminUserRole.fromJson(json);
      expect(a, equals(b));
    });

    test('different role means not equal', () {
      final a = AdminUserRole.fromJson(json);
      final b = AdminUserRole.fromJson({...json, 'admin_role_id': 'other'});
      expect(a, isNot(equals(b)));
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminStoreListState
  // ════════════════════════════════════════════════════════

  group('AdminStoreListState', () {
    test('Initial is default state', () {
      const state = AdminStoreListInitial();
      expect(state, isA<AdminStoreListState>());
    });

    test('Loading state', () {
      const state = AdminStoreListLoading();
      expect(state, isA<AdminStoreListState>());
    });

    test('Loaded holds stores and pagination', () {
      const state = AdminStoreListLoaded(
        stores: [
          {'id': '1', 'name': 'Store A'},
          {'id': '2', 'name': 'Store B'},
        ],
        total: 50,
        currentPage: 1,
        lastPage: 4,
      );
      expect(state.stores, hasLength(2));
      expect(state.total, 50);
      expect(state.currentPage, 1);
      expect(state.lastPage, 4);
    });

    test('Error holds message', () {
      const state = AdminStoreListError('Something went wrong');
      expect(state.message, 'Something went wrong');
    });

    test('sealed class exhaustive switch', () {
      AdminStoreListState state = const AdminStoreListLoading();
      final result = switch (state) {
        AdminStoreListInitial() => 'initial',
        AdminStoreListLoading() => 'loading',
        AdminStoreListLoaded(:final stores) => 'loaded:${stores.length}',
        AdminStoreListError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminStoreDetailState
  // ════════════════════════════════════════════════════════

  group('AdminStoreDetailState', () {
    test('Initial is default state', () {
      const state = AdminStoreDetailInitial();
      expect(state, isA<AdminStoreDetailState>());
    });

    test('Loading state', () {
      const state = AdminStoreDetailLoading();
      expect(state, isA<AdminStoreDetailState>());
    });

    test('Loaded holds store data', () {
      const state = AdminStoreDetailLoaded({'id': 'store-1', 'name': 'My Store', 'is_active': true});
      expect(state.store['name'], 'My Store');
      expect(state.store['is_active'], true);
    });

    test('Error holds message', () {
      const state = AdminStoreDetailError('Not found');
      expect(state.message, 'Not found');
    });

    test('sealed class exhaustive switch', () {
      AdminStoreDetailState state = const AdminStoreDetailError('oops');
      final result = switch (state) {
        AdminStoreDetailInitial() => 'initial',
        AdminStoreDetailLoading() => 'loading',
        AdminStoreDetailLoaded(:final store) => 'loaded:${store['id']}',
        AdminStoreDetailError(:final message) => 'error:$message',
      };
      expect(result, 'error:oops');
    });
  });

  // ════════════════════════════════════════════════════════
  // AdminActionState
  // ════════════════════════════════════════════════════════

  group('AdminActionState', () {
    test('Initial is default state', () {
      const state = AdminActionInitial();
      expect(state, isA<AdminActionState>());
    });

    test('Loading state', () {
      const state = AdminActionLoading();
      expect(state, isA<AdminActionState>());
    });

    test('Success holds message and optional data', () {
      const state = AdminActionSuccess('Store suspended');
      expect(state.message, 'Store suspended');
      expect(state.data, isNull);
    });

    test('Success holds message and data', () {
      const state = AdminActionSuccess('Store created', data: {'id': 'store-new'});
      expect(state.message, 'Store created');
      expect(state.data, isNotNull);
      expect(state.data!['id'], 'store-new');
    });

    test('Error holds message', () {
      const state = AdminActionError('Permission denied');
      expect(state.message, 'Permission denied');
    });

    test('sealed class exhaustive switch', () {
      AdminActionState state = const AdminActionSuccess('Done');
      final result = switch (state) {
        AdminActionInitial() => 'initial',
        AdminActionLoading() => 'loading',
        AdminActionSuccess(:final message) => 'success:$message',
        AdminActionError(:final message) => 'error:$message',
      };
      expect(result, 'success:Done');
    });
  });

  // ════════════════════════════════════════════════════════
  // RegistrationListState
  // ════════════════════════════════════════════════════════

  group('RegistrationListState', () {
    test('Initial is default state', () {
      const state = RegistrationListInitial();
      expect(state, isA<RegistrationListState>());
    });

    test('Loading state', () {
      const state = RegistrationListLoading();
      expect(state, isA<RegistrationListState>());
    });

    test('Loaded holds registrations and pagination', () {
      const state = RegistrationListLoaded(
        registrations: [
          {'id': 'r1', 'status': 'pending'},
        ],
        total: 10,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.registrations, hasLength(1));
      expect(state.total, 10);
      expect(state.currentPage, 1);
      expect(state.lastPage, 1);
    });

    test('Error holds message', () {
      const state = RegistrationListError('Network error');
      expect(state.message, 'Network error');
    });

    test('sealed class exhaustive switch', () {
      RegistrationListState state = const RegistrationListInitial();
      final result = switch (state) {
        RegistrationListInitial() => 'initial',
        RegistrationListLoading() => 'loading',
        RegistrationListLoaded(:final registrations) => 'loaded:${registrations.length}',
        RegistrationListError(:final message) => 'error:$message',
      };
      expect(result, 'initial');
    });
  });

  // ════════════════════════════════════════════════════════
  // LimitOverrideListState
  // ════════════════════════════════════════════════════════

  group('LimitOverrideListState', () {
    test('Initial is default state', () {
      const state = LimitOverrideListInitial();
      expect(state, isA<LimitOverrideListState>());
    });

    test('Loading state', () {
      const state = LimitOverrideListLoading();
      expect(state, isA<LimitOverrideListState>());
    });

    test('Loaded holds overrides', () {
      const state = LimitOverrideListLoaded([
        {'limit_key': 'max_products', 'override_value': 500},
        {'limit_key': 'max_staff', 'override_value': 20},
      ]);
      expect(state.overrides, hasLength(2));
      expect(state.overrides[0]['limit_key'], 'max_products');
    });

    test('Loaded with empty list', () {
      const state = LimitOverrideListLoaded([]);
      expect(state.overrides, isEmpty);
    });

    test('Error holds message', () {
      const state = LimitOverrideListError('Failed to load');
      expect(state.message, 'Failed to load');
    });

    test('sealed class exhaustive switch', () {
      LimitOverrideListState state = const LimitOverrideListLoaded([]);
      final result = switch (state) {
        LimitOverrideListInitial() => 'initial',
        LimitOverrideListLoading() => 'loading',
        LimitOverrideListLoaded(:final overrides) => 'loaded:${overrides.length}',
        LimitOverrideListError(:final message) => 'error:$message',
      };
      expect(result, 'loaded:0');
    });
  });

  // ════════════════════════════════════════════════════════
  // ProviderNotesState
  // ════════════════════════════════════════════════════════

  group('ProviderNotesState', () {
    test('Initial is default state', () {
      const state = ProviderNotesInitial();
      expect(state, isA<ProviderNotesState>());
    });

    test('Loading state', () {
      const state = ProviderNotesLoading();
      expect(state, isA<ProviderNotesState>());
    });

    test('Loaded holds notes', () {
      const state = ProviderNotesLoaded([
        {'id': 'n1', 'note_text': 'First note'},
        {'id': 'n2', 'note_text': 'Second note'},
      ]);
      expect(state.notes, hasLength(2));
      expect(state.notes[0]['note_text'], 'First note');
    });

    test('Loaded with empty list', () {
      const state = ProviderNotesLoaded([]);
      expect(state.notes, isEmpty);
    });

    test('Error holds message', () {
      const state = ProviderNotesError('Unauthorized');
      expect(state.message, 'Unauthorized');
    });

    test('sealed class exhaustive switch', () {
      ProviderNotesState state = const ProviderNotesLoading();
      final result = switch (state) {
        ProviderNotesInitial() => 'initial',
        ProviderNotesLoading() => 'loading',
        ProviderNotesLoaded(:final notes) => 'loaded:${notes.length}',
        ProviderNotesError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });
}
