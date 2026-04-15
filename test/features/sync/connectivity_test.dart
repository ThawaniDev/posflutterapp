import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/sync/services/connectivity_service.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // ConnectivityStatus Enum
  // ═══════════════════════════════════════════════════════════

  group('ConnectivityStatus', () {
    test('has 3 values', () {
      expect(ConnectivityStatus.values, hasLength(3));
    });

    test('contains online, offline, unknown', () {
      expect(
        ConnectivityStatus.values,
        containsAll([ConnectivityStatus.online, ConnectivityStatus.offline, ConnectivityStatus.unknown]),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ConnectivityService
  // ═══════════════════════════════════════════════════════════

  group('ConnectivityService', () {
    late ConnectivityService service;

    setUp(() {
      service = ConnectivityService(checkInterval: const Duration(seconds: 60));
    });

    tearDown(() {
      service.dispose();
    });

    test('initial status is unknown', () {
      expect(service.currentStatus, ConnectivityStatus.unknown);
    });

    test('isOnline is false initially', () {
      expect(service.isOnline, false);
    });

    test('provides a status stream', () {
      expect(service.statusStream, isA<Stream<ConnectivityStatus>>());
    });

    test('checkNow returns a status', () async {
      final status = await service.checkNow();
      expect(status, isA<ConnectivityStatus>());
      // After checking, status should not be unknown
      expect(service.currentStatus, isNot(ConnectivityStatus.unknown));
    });

    test('stopMonitoring does not throw when not started', () {
      expect(() => service.stopMonitoring(), returnsNormally);
    });

    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });

    test('statusStream emits on status change', () async {
      // Use checkNow to trigger status emission
      final statusFuture = service.statusStream.first;
      await service.checkNow();
      final status = await statusFuture.timeout(const Duration(seconds: 10));
      expect(status, isA<ConnectivityStatus>());
    });
  });
}
