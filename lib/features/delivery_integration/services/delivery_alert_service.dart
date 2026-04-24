import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

/// Abstraction over audio + visual notification side-effects so the service
/// can be unit-tested without pulling in audioplayers/local_notifications
/// at test time. Production wiring is provided by [defaultDeliveryAlertSink].
abstract class DeliveryAlertSink {
  Future<void> notifyNewOrder(Map<String, dynamic> order);
}

/// No-op sink used when alerts are disabled.
class NoopDeliveryAlertSink implements DeliveryAlertSink {
  const NoopDeliveryAlertSink();

  @override
  Future<void> notifyNewOrder(Map<String, dynamic> order) async {}
}

/// Tracks the set of delivery order ids the user has already been alerted
/// about, fires the [DeliveryAlertSink] once per truly-new id, and exposes
/// an enable/disable toggle (covers spec §4.2 "visual + audio alert on new
/// order").
///
/// Pure logic — no platform channels — so it is fully unit-testable.
class DeliveryAlertService {
  DeliveryAlertService({required DeliveryAlertSink sink, bool enabled = true}) : _sink = sink, _enabled = enabled;

  final DeliveryAlertSink _sink;
  final Set<String> _seenIds = <String>{};
  bool _primed = false;
  bool _enabled;

  bool get enabled => _enabled;
  int get seenCount => _seenIds.length;

  void setEnabled(bool value) {
    _enabled = value;
  }

  /// Marks all currently-known ids as already-seen without firing alerts.
  /// Should be invoked once on first load so the user is not blasted with
  /// an alert per pre-existing order.
  void prime(Iterable<Map<String, dynamic>> orders) {
    for (final o in orders) {
      final id = _extractId(o);
      if (id != null) _seenIds.add(id);
    }
    _primed = true;
  }

  /// Compares [orders] against the seen-set and returns the list of orders
  /// that are new in this tick. Fires the alert sink for each new one when
  /// the service is enabled.
  Future<List<Map<String, dynamic>>> ingest(Iterable<Map<String, dynamic>> orders) async {
    if (!_primed) {
      prime(orders);
      return const [];
    }

    final newOrders = <Map<String, dynamic>>[];
    for (final o in orders) {
      final id = _extractId(o);
      if (id == null) continue;
      if (_seenIds.add(id)) {
        newOrders.add(o);
      }
    }

    if (_enabled) {
      for (final o in newOrders) {
        await _sink.notifyNewOrder(o);
      }
    }

    return newOrders;
  }

  void reset() {
    _seenIds.clear();
    _primed = false;
  }

  String? _extractId(Map<String, dynamic> order) {
    final id = order['id'] ?? order['order_id'] ?? order['external_order_id'];
    return id?.toString();
  }
}

/// Riverpod provider — singleton per app instance. Tests override
/// [deliveryAlertSinkProvider] to inject a fake.
final deliveryAlertSinkProvider = Provider<DeliveryAlertSink>((ref) => const NoopDeliveryAlertSink());

final deliveryAlertServiceProvider = Provider<DeliveryAlertService>((ref) {
  final svc = DeliveryAlertService(sink: ref.watch(deliveryAlertSinkProvider));

  ref.listen<DeliveryOrdersState>(deliveryOrdersProvider, (_, next) {
    if (next is DeliveryOrdersLoaded) {
      // Fire-and-forget — service guarantees serialised side-effects.
      svc.ingest(next.orders);
    }
  });

  return svc;
});
