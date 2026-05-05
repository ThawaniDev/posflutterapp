// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/staff/data/remote/staff_api_service.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';

// ─── Helpers ──────────────────────────────────────────────────────

/// Creates a Dio instance whose interceptor resolves every request with the
/// provided [handler]. Ideal for unit tests that need HTTP faking without an
/// actual network or build_runner codegen.
Dio _fakeDio(Map<String, dynamic> Function(RequestOptions opts) handler) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        try {
          final data = handler(opts);
          requestHandler.resolve(Response(data: data, requestOptions: opts, statusCode: 200));
        } catch (e) {
          requestHandler.reject(DioException(requestOptions: opts, error: e));
        }
      },
    ),
  );
  return dio;
}

/// Standard API envelope wrapping [data].
Map<String, dynamic> _envelope(dynamic data, {String message = 'ok'}) => {'success': true, 'message': message, 'data': data};

/// Minimal valid StaffUser JSON.
Map<String, dynamic> _staffJson({String id = 'su-001', String? nfcBadgeUid}) => {
  'id': id,
  'store_id': 'store-001',
  'first_name': 'Test',
  'last_name': 'User',
  'employment_type': 'full_time',
  'salary_type': 'monthly',
  'hire_date': '2024-01-01',
  'status': 'active',
  if (nfcBadgeUid != null) 'nfc_badge_uid': nfcBadgeUid,
};

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  group('StaffApiService', () {
    // ─ listStaff ─────────────────────────────────────────────

    test('listStaff: parses paginated Map response', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.staffMembers);
        expect(opts.method, 'GET');
        return _envelope({
          'data': [_staffJson(id: 'su-001'), _staffJson(id: 'su-002')],
          'total': 2,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        });
      });

      final svc = StaffApiService(dio);
      final result = await svc.listStaff();

      expect(result.items.length, 2);
      expect(result.total, 2);
      expect(result.currentPage, 1);
      expect(result.hasMore, false);
      expect(result.items.first.id, 'su-001');
    });

    test('listStaff: parses flat List response', () async {
      final dio = _fakeDio((_) => _envelope([_staffJson()]));

      final svc = StaffApiService(dio);
      final result = await svc.listStaff();

      expect(result.items.length, 1);
      expect(result.currentPage, 1);
      expect(result.lastPage, 1);
    });

    test('listStaff: sends page and per_page params', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['page'], 2);
        expect(opts.queryParameters['per_page'], 10);
        return _envelope({'data': [], 'total': 0, 'current_page': 2, 'last_page': 2, 'per_page': 10});
      });

      final svc = StaffApiService(dio);
      await svc.listStaff(page: 2, perPage: 10);
    });

    // ─ getStaff ──────────────────────────────────────────────

    test('getStaff: parses single staff response', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.staffMemberById('su-001'));
        return _envelope(_staffJson(id: 'su-001'));
      });

      final svc = StaffApiService(dio);
      final staff = await svc.getStaff('su-001');

      expect(staff.id, 'su-001');
      expect(staff.firstName, 'Test');
    });

    // ─ createStaff ───────────────────────────────────────────

    test('createStaff: returns StaffUser from response', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.staffMembers);
        return _envelope(_staffJson(id: 'su-new'));
      });

      final svc = StaffApiService(dio);
      final staff = await svc.createStaff({
        'first_name': 'Test',
        'last_name': 'User',
        'employment_type': 'full_time',
        'salary_type': 'monthly',
        'hire_date': '2024-01-01',
      });

      expect(staff.id, 'su-new');
    });

    // ─ setPin ────────────────────────────────────────────────

    test('setPin: sends pin in request body', () async {
      late Map<String, dynamic> sentData;
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.staffMemberPin('su-001'));
        expect(opts.method, 'POST');
        sentData = opts.data as Map<String, dynamic>;
        return _envelope(null);
      });

      final svc = StaffApiService(dio);
      await svc.setPin('su-001', '1234');

      expect(sentData['pin'], '1234');
    });

    // ─ registerNfc ───────────────────────────────────────────

    test('registerNfc: sends nfc_badge_uid in body and returns updated staff', () async {
      late Map<String, dynamic> sentData;
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.staffMemberNfc('su-001'));
        expect(opts.method, 'POST');
        sentData = opts.data as Map<String, dynamic>;
        return _envelope(_staffJson(id: 'su-001', nfcBadgeUid: 'NFC123'));
      });

      final svc = StaffApiService(dio);
      final staff = await svc.registerNfc('su-001', 'NFC123');

      expect(sentData['nfc_badge_uid'], 'NFC123');
      expect(staff.nfcBadgeUid, 'NFC123');
    });

    // ─ updateStaff ───────────────────────────────────────────

    test('updateStaff: sends PUT and returns updated staff', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'PUT');
        expect(opts.path, ApiEndpoints.staffMemberById('su-001'));
        return _envelope(_staffJson(id: 'su-001'));
      });

      final svc = StaffApiService(dio);
      final staff = await svc.updateStaff('su-001', {'first_name': 'Updated'});

      expect(staff.id, 'su-001');
    });

    // ─ deleteStaff ───────────────────────────────────────────

    test('deleteStaff: sends DELETE to correct endpoint', () async {
      var deleteCalled = false;
      final dio = _fakeDio((opts) {
        expect(opts.method, 'DELETE');
        expect(opts.path, ApiEndpoints.staffMemberById('su-001'));
        deleteCalled = true;
        return _envelope(null);
      });

      final svc = StaffApiService(dio);
      await svc.deleteStaff('su-001');

      expect(deleteCalled, true);
    });

    // ─ listStaff pagination hasMore ──────────────────────────

    test('listStaff: hasMore=true when currentPage < lastPage', () async {
      final dio = _fakeDio(
        (_) => _envelope({
          'data': [_staffJson()],
          'total': 50,
          'current_page': 1,
          'last_page': 5,
          'per_page': 10,
        }),
      );

      final svc = StaffApiService(dio);
      final result = await svc.listStaff();

      expect(result.hasMore, true);
      expect(result.lastPage, 5);
    });
  });
}
