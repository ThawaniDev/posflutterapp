import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/industry_restaurant/enums/restaurant_table_status.dart';
import 'package:wameedpos/features/industry_restaurant/enums/kitchen_ticket_status.dart';
import 'package:wameedpos/features/industry_restaurant/enums/table_reservation_status.dart';
import 'package:wameedpos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:wameedpos/features/industry_restaurant/models/kitchen_ticket.dart';
import 'package:wameedpos/features/industry_restaurant/models/table_reservation.dart';
import 'package:wameedpos/features/industry_restaurant/models/open_tab.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_state.dart';

void main() {
  // ═══════════════ Enums ═══════════════
  group('RestaurantTableStatus', () {
    test('all values', () {
      expect(RestaurantTableStatus.values, hasLength(4));
      expect(RestaurantTableStatus.available.value, 'available');
      expect(RestaurantTableStatus.occupied.value, 'occupied');
      expect(RestaurantTableStatus.reserved.value, 'reserved');
      expect(RestaurantTableStatus.cleaning.value, 'cleaning');
    });

    test('fromValue round-trip', () {
      for (final e in RestaurantTableStatus.values) {
        expect(RestaurantTableStatus.fromValue(e.value), e);
      }
    });
  });

  group('KitchenTicketStatus', () {
    test('all values', () {
      expect(KitchenTicketStatus.values, hasLength(4));
      expect(KitchenTicketStatus.pending.value, 'pending');
      expect(KitchenTicketStatus.preparing.value, 'preparing');
      expect(KitchenTicketStatus.ready.value, 'ready');
      expect(KitchenTicketStatus.served.value, 'served');
    });

    test('fromValue round-trip', () {
      for (final e in KitchenTicketStatus.values) {
        expect(KitchenTicketStatus.fromValue(e.value), e);
      }
    });
  });

  group('TableReservationStatus', () {
    test('all values', () {
      expect(TableReservationStatus.values, hasLength(5));
      expect(TableReservationStatus.confirmed.value, 'confirmed');
      expect(TableReservationStatus.seated.value, 'seated');
      expect(TableReservationStatus.completed.value, 'completed');
      expect(TableReservationStatus.cancelled.value, 'cancelled');
      expect(TableReservationStatus.noShow.value, 'no_show');
    });

    test('fromValue round-trip', () {
      for (final e in TableReservationStatus.values) {
        expect(TableReservationStatus.fromValue(e.value), e);
      }
    });
  });

  // ═══════════════ RestaurantTable Model ═══════════════
  group('RestaurantTable', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'table_number': 'T-01',
      'display_name': 'Table 1',
      'seats': 4,
      'zone': 'Main Hall',
      'position_x': 10,
      'position_y': 20,
      'status': 'available',
      'is_active': true,
    };

    test('fromJson', () {
      final t = RestaurantTable.fromJson(json);
      expect(t.tableNumber, 'T-01');
      expect(t.displayName, 'Table 1');
      expect(t.seats, 4);
      expect(t.zone, 'Main Hall');
      expect(t.status, RestaurantTableStatus.available);
    });

    test('toJson round-trip', () {
      final t = RestaurantTable.fromJson(json);
      final out = t.toJson();
      expect(out['table_number'], 'T-01');
      expect(out['seats'], 4);
    });
  });

  // ═══════════════ KitchenTicket Model ═══════════════
  group('KitchenTicket', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'order_id': 'o1',
      'table_id': 't1',
      'ticket_number': 42,
      'items_json': {'burger': 2, 'fries': 1},
      'station': 'grill',
      'status': 'pending',
      'course_number': 1,
    };

    test('fromJson', () {
      final k = KitchenTicket.fromJson(json);
      expect(k.ticketNumber, 42);
      expect(k.station, 'grill');
      expect(k.status, KitchenTicketStatus.pending);
      expect(k.courseNumber, 1);
    });

    test('toJson round-trip', () {
      final k = KitchenTicket.fromJson(json);
      final out = k.toJson();
      expect(out['ticket_number'], 42);
      expect(out['station'], 'grill');
    });
  });

  // ═══════════════ TableReservation Model ═══════════════
  group('TableReservation', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'table_id': 't1',
      'customer_name': 'Ahmed',
      'customer_phone': '+96899887766',
      'party_size': 6,
      'reservation_date': '2025-06-20',
      'reservation_time': '19:30',
      'duration_minutes': 90,
      'status': 'confirmed',
      'notes': 'Birthday',
    };

    test('fromJson', () {
      final r = TableReservation.fromJson(json);
      expect(r.customerName, 'Ahmed');
      expect(r.partySize, 6);
      expect(r.reservationTime, '19:30');
      expect(r.status, TableReservationStatus.confirmed);
      expect(r.durationMinutes, 90);
    });

    test('toJson round-trip', () {
      final r = TableReservation.fromJson(json);
      final out = r.toJson();
      expect(out['customer_name'], 'Ahmed');
      expect(out['party_size'], 6);
    });
  });

  // ═══════════════ OpenTab Model ═══════════════
  group('OpenTab', () {
    final json = {'id': '1', 'store_id': 's1', 'order_id': 'o1', 'customer_name': 'Ali', 'table_id': 't1', 'status': 'open'};

    test('fromJson', () {
      final t = OpenTab.fromJson(json);
      expect(t.customerName, 'Ali');
      expect(t.orderId, 'o1');
    });

    test('toJson round-trip', () {
      final t = OpenTab.fromJson(json);
      final out = t.toJson();
      expect(out['customer_name'], 'Ali');
      expect(out['order_id'], 'o1');
    });
  });

  // ═══════════════ RestaurantState ═══════════════
  group('RestaurantState', () {
    test('initial', () {
      const s = RestaurantInitial();
      expect(s, isA<RestaurantState>());
    });

    test('loading', () {
      const s = RestaurantLoading();
      expect(s, isA<RestaurantState>());
    });

    test('loaded', () {
      const s = RestaurantLoaded(tables: [], kitchenTickets: [], reservations: [], openTabs: []);
      expect(s.tables, isEmpty);
      expect(s.kitchenTickets, isEmpty);
      expect(s.reservations, isEmpty);
      expect(s.openTabs, isEmpty);
    });

    test('loaded copyWith', () {
      const s = RestaurantLoaded(tables: [], kitchenTickets: [], reservations: [], openTabs: []);
      final s2 = s.copyWith(tables: []);
      expect(s2.tables, isEmpty);
    });

    test('error', () {
      const s = RestaurantError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Restaurant endpoints', () {
    test('tables', () {
      expect(ApiEndpoints.restaurantTables, '/industry/restaurant/tables');
    });

    test('kitchen tickets', () {
      expect(ApiEndpoints.restaurantKitchenTickets, '/industry/restaurant/kitchen-tickets');
    });

    test('reservations', () {
      expect(ApiEndpoints.restaurantReservations, '/industry/restaurant/reservations');
    });

    test('tabs', () {
      expect(ApiEndpoints.restaurantTabs, '/industry/restaurant/tabs');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Restaurant route', () {
    test('route constant', () {
      expect(Routes.industryRestaurant, '/industry/restaurant');
    });
  });
}
