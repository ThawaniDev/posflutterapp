import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/industry_electronics/enums/device_imei_status.dart';
import 'package:thawani_pos/features/industry_electronics/enums/repair_job_status.dart';
import 'package:thawani_pos/features/industry_electronics/models/device_imei_record.dart';
import 'package:thawani_pos/features/industry_electronics/models/repair_job.dart';
import 'package:thawani_pos/features/industry_electronics/models/trade_in_record.dart';
import 'package:thawani_pos/features/industry_electronics/providers/electronics_state.dart';

void main() {
  // ═══════════════ Enums ═══════════════
  group('DeviceImeiStatus', () {
    test('all values', () {
      expect(DeviceImeiStatus.values, hasLength(4));
      expect(DeviceImeiStatus.inStock.value, 'in_stock');
      expect(DeviceImeiStatus.sold.value, 'sold');
      expect(DeviceImeiStatus.tradedIn.value, 'traded_in');
      expect(DeviceImeiStatus.returned.value, 'returned');
    });

    test('fromValue round-trip', () {
      for (final e in DeviceImeiStatus.values) {
        expect(DeviceImeiStatus.fromValue(e.value), e);
      }
    });
  });

  group('RepairJobStatus', () {
    test('all values', () {
      expect(RepairJobStatus.values, hasLength(7));
      expect(RepairJobStatus.received.value, 'received');
      expect(RepairJobStatus.diagnosing.value, 'diagnosing');
      expect(RepairJobStatus.repairing.value, 'repairing');
      expect(RepairJobStatus.testing.value, 'testing');
      expect(RepairJobStatus.ready.value, 'ready');
      expect(RepairJobStatus.collected.value, 'collected');
      expect(RepairJobStatus.cancelled.value, 'cancelled');
    });

    test('fromValue round-trip', () {
      for (final e in RepairJobStatus.values) {
        expect(RepairJobStatus.fromValue(e.value), e);
      }
    });
  });

  // ═══════════════ DeviceImeiRecord Model ═══════════════
  group('DeviceImeiRecord', () {
    final json = {
      'id': '1',
      'product_id': 'p1',
      'store_id': 's1',
      'imei': '123456789012345',
      'imei2': '543210987654321',
      'serial_number': 'SN-001',
      'condition_grade': 'A',
      'purchase_price': 350.0,
      'status': 'in_stock',
      'warranty_end_date': '2026-01-01',
    };

    test('fromJson', () {
      final r = DeviceImeiRecord.fromJson(json);
      expect(r.imei, '123456789012345');
      expect(r.status, DeviceImeiStatus.inStock);
      expect(r.purchasePrice, 350.0);
    });

    test('toJson round-trip', () {
      final r = DeviceImeiRecord.fromJson(json);
      final out = r.toJson();
      expect(out['imei'], '123456789012345');
      expect(out['status'], 'in_stock');
    });
  });

  // ═══════════════ RepairJob Model ═══════════════
  group('RepairJob', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'customer_id': 'c1',
      'device_description': 'iPhone 15 Pro',
      'imei': '111222333444555',
      'issue_description': 'Cracked screen',
      'status': 'received',
      'estimated_cost': 120.0,
      'staff_user_id': 'u1',
    };

    test('fromJson', () {
      final j = RepairJob.fromJson(json);
      expect(j.deviceDescription, 'iPhone 15 Pro');
      expect(j.issueDescription, 'Cracked screen');
      expect(j.status, RepairJobStatus.received);
      expect(j.estimatedCost, 120.0);
    });

    test('toJson round-trip', () {
      final j = RepairJob.fromJson(json);
      final out = j.toJson();
      expect(out['device_description'], 'iPhone 15 Pro');
      expect(out['status'], 'received');
    });
  });

  // ═══════════════ TradeInRecord Model ═══════════════
  group('TradeInRecord', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'customer_id': 'c1',
      'device_description': 'Samsung Galaxy S24',
      'imei': '999888777666555',
      'condition_grade': 'B',
      'assessed_value': 200.0,
      'staff_user_id': 'u1',
    };

    test('fromJson', () {
      final t = TradeInRecord.fromJson(json);
      expect(t.deviceDescription, 'Samsung Galaxy S24');
      expect(t.conditionGrade, 'B');
      expect(t.assessedValue, 200.0);
    });

    test('toJson round-trip', () {
      final t = TradeInRecord.fromJson(json);
      final out = t.toJson();
      expect(out['condition_grade'], 'B');
      expect(out['assessed_value'], 200.0);
    });
  });

  // ═══════════════ ElectronicsState ═══════════════
  group('ElectronicsState', () {
    test('initial', () {
      const s = ElectronicsInitial();
      expect(s, isA<ElectronicsState>());
    });

    test('loading', () {
      const s = ElectronicsLoading();
      expect(s, isA<ElectronicsState>());
    });

    test('loaded', () {
      const s = ElectronicsLoaded(imeiRecords: [], repairJobs: [], tradeIns: []);
      expect(s.imeiRecords, isEmpty);
      expect(s.repairJobs, isEmpty);
      expect(s.tradeIns, isEmpty);
    });

    test('loaded copyWith', () {
      const s = ElectronicsLoaded(imeiRecords: [], repairJobs: [], tradeIns: []);
      final s2 = s.copyWith(repairJobs: []);
      expect(s2.repairJobs, isEmpty);
    });

    test('error', () {
      const s = ElectronicsError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Electronics endpoints', () {
    test('IMEI records', () {
      expect(ApiEndpoints.electronicsImeiRecords, '/industry/electronics/imei-records');
    });

    test('repair jobs', () {
      expect(ApiEndpoints.electronicsRepairJobs, '/industry/electronics/repair-jobs');
    });

    test('trade-ins', () {
      expect(ApiEndpoints.electronicsTradeIns, '/industry/electronics/trade-ins');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Electronics route', () {
    test('route constant', () {
      expect(Routes.industryElectronics, '/industry/electronics');
    });
  });
}
