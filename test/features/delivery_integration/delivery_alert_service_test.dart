import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/delivery_integration/services/delivery_alert_service.dart';

class _RecordingSink implements DeliveryAlertSink {
  final List<Map<String, dynamic>> notified = [];

  @override
  Future<void> notifyNewOrder(Map<String, dynamic> order) async {
    notified.add(order);
  }
}

void main() {
  group('DeliveryAlertService', () {
    test('first ingest primes the seen-set without firing alerts', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      final fired = await svc.ingest([
        {'id': 'A', 'platform': 'jahez'},
        {'id': 'B', 'platform': 'jahez'},
      ]);

      expect(fired, isEmpty);
      expect(sink.notified, isEmpty);
      expect(svc.seenCount, 2);
    });

    test('ingest fires for ids never seen before', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      await svc.ingest([
        {'id': 'A'},
      ]);

      final fired = await svc.ingest([
        {'id': 'A'},
        {'id': 'B'},
        {'id': 'C'},
      ]);

      expect(fired.map((o) => o['id']).toList(), ['B', 'C']);
      expect(sink.notified.length, 2);
    });

    test('repeated ingest of the same id only alerts once', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      svc.prime(const []);
      await svc.ingest([
        {'id': 'X'},
      ]);
      await svc.ingest([
        {'id': 'X'},
      ]);
      await svc.ingest([
        {'id': 'X'},
      ]);

      expect(sink.notified.length, 1);
    });

    test('disabled service does not fire alerts but still tracks ids', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink, enabled: false);

      svc.prime(const []);

      await svc.ingest([
        {'id': 'A'},
        {'id': 'B'},
      ]);

      expect(sink.notified, isEmpty);
      expect(svc.seenCount, 2);
    });

    test('setEnabled toggles alert dispatch on subsequent ingests', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      svc.prime(const []);
      svc.setEnabled(false);
      await svc.ingest([
        {'id': 'silent'},
      ]);
      svc.setEnabled(true);
      await svc.ingest([
        {'id': 'loud'},
      ]);

      expect(sink.notified.length, 1);
      expect(sink.notified.single['id'], 'loud');
    });

    test('extracts id from id / order_id / external_order_id', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      svc.prime(const []);
      await svc.ingest([
        {'id': 'one'},
        {'order_id': 'two'},
        {'external_order_id': 'three'},
        {'platform': 'jahez'}, // no id at all - skipped
      ]);

      expect(sink.notified.length, 3);
      expect(svc.seenCount, 3);
    });

    test('reset clears state and re-primes on next ingest', () async {
      final sink = _RecordingSink();
      final svc = DeliveryAlertService(sink: sink);

      svc.prime(const []);
      await svc.ingest([
        {'id': 'A'},
      ]);
      svc.reset();

      // First ingest after reset primes and does not alert.
      await svc.ingest([
        {'id': 'A'},
      ]);
      expect(sink.notified.length, 1);

      // Second ingest with new id alerts.
      await svc.ingest([
        {'id': 'A'},
        {'id': 'B'},
      ]);
      expect(sink.notified.length, 2);
    });

    test('NoopDeliveryAlertSink completes without side-effects', () async {
      const sink = NoopDeliveryAlertSink();
      await sink.notifyNewOrder({'id': 'x'});
    });
  });
}
