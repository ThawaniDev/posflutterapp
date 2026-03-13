import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/orders/enums/order_source.dart';
import 'package:thawani_pos/features/orders/enums/order_status.dart';
import 'package:thawani_pos/features/orders/enums/return_refund_method.dart';
import 'package:thawani_pos/features/orders/enums/return_type.dart';
import 'package:thawani_pos/features/orders/models/order.dart';
import 'package:thawani_pos/features/orders/models/sale_return.dart';
import 'package:thawani_pos/features/orders/providers/order_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // OrdersState Tests
  // ═══════════════════════════════════════════════════════════════

  group('OrdersState', () {
    test('OrdersInitial is default state', () {
      const state = OrdersInitial();
      expect(state, isA<OrdersState>());
    });

    test('OrdersLoading indicates loading', () {
      const state = OrdersLoading();
      expect(state, isA<OrdersState>());
    });

    test('OrdersLoaded holds orders and pagination info', () {
      final orders = [
        Order(
          id: 'o1',
          storeId: 's1',
          orderNumber: 'ORD-001',
          source: OrderSource.pos,
          status: OrderStatus.completed,
          subtotal: 100.0,
          taxAmount: 15.0,
          total: 115.0,
        ),
        Order(
          id: 'o2',
          storeId: 's1',
          orderNumber: 'ORD-002',
          source: OrderSource.thawani,
          status: OrderStatus.newValue,
          subtotal: 50.0,
          taxAmount: 7.5,
          total: 57.5,
        ),
      ];

      final state = OrdersLoaded(orders: orders, total: 100, currentPage: 1, lastPage: 5, perPage: 20);

      expect(state, isA<OrdersState>());
      expect(state.orders, hasLength(2));
      expect(state.total, 100);
      expect(state.hasMore, true);
    });

    test('OrdersLoaded hasMore is false on last page', () {
      final state = OrdersLoaded(orders: [], total: 5, currentPage: 1, lastPage: 1, perPage: 20);
      expect(state.hasMore, false);
    });

    test('OrdersLoaded copyWith replaces fields', () {
      final state = OrdersLoaded(
        orders: [
          Order(
            id: 'o1',
            storeId: 's1',
            orderNumber: 'ORD-001',
            source: OrderSource.pos,
            status: OrderStatus.completed,
            subtotal: 100.0,
            taxAmount: 15.0,
            total: 115.0,
          ),
        ],
        total: 10,
        currentPage: 1,
        lastPage: 2,
        perPage: 20,
      );

      final updated = state.copyWith(currentPage: 2, total: 50);
      expect(updated.currentPage, 2);
      expect(updated.total, 50);
      expect(updated.orders.first.orderNumber, 'ORD-001');
    });

    test('OrdersError holds message', () {
      const state = OrdersError(message: 'Server unavailable');
      expect(state, isA<OrdersState>());
      expect(state.message, 'Server unavailable');
    });

    test('sealed class exhaustive switch', () {
      OrdersState state = const OrdersLoading();
      final result = switch (state) {
        OrdersInitial() => 'initial',
        OrdersLoading() => 'loading',
        OrdersLoaded(:final orders) => 'loaded:${orders.length}',
        OrdersError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ReturnsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('ReturnsState', () {
    test('all subtypes are ReturnsState', () {
      expect(const ReturnsInitial(), isA<ReturnsState>());
      expect(const ReturnsLoading(), isA<ReturnsState>());
      expect(const ReturnsError(message: 'err'), isA<ReturnsState>());
    });

    test('ReturnsLoaded holds returns and pagination', () {
      final returns = [
        SaleReturn(
          id: 'r1',
          storeId: 's1',
          orderId: 'o1',
          returnNumber: 'RTN-001',
          type: ReturnType.full,
          reasonCode: 'defective',
          refundMethod: ReturnRefundMethod.cash,
          subtotal: 50.0,
          taxAmount: 7.5,
          totalRefund: 57.5,
          processedBy: 'user1',
        ),
      ];

      final state = ReturnsLoaded(returns: returns, total: 10, currentPage: 1, lastPage: 1, perPage: 20);

      expect(state.returns, hasLength(1));
      expect(state.total, 10);
      expect(state.hasMore, false);
    });

    test('ReturnsLoaded copyWith', () {
      final state = ReturnsLoaded(returns: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20);
      final updated = state.copyWith(currentPage: 2, total: 30);
      expect(updated.currentPage, 2);
      expect(updated.total, 30);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Order & Return Enum Tests
  // ═══════════════════════════════════════════════════════════════

  group('Order Enums', () {
    test('OrderSource values', () {
      expect(OrderSource.pos.value, 'pos');
      expect(OrderSource.thawani.value, 'thawani');
      expect(OrderSource.web.value, 'web');
      expect(OrderSource.fromValue('pos'), OrderSource.pos);
    });

    test('OrderStatus values', () {
      expect(OrderStatus.newValue.value, 'new');
      expect(OrderStatus.completed.value, 'completed');
      expect(OrderStatus.cancelled.value, 'cancelled');
      expect(OrderStatus.fromValue('preparing'), OrderStatus.preparing);
    });

    test('ReturnType values', () {
      expect(ReturnType.full.value, 'full');
      expect(ReturnType.partial.value, 'partial');
    });

    test('ReturnRefundMethod values', () {
      expect(ReturnRefundMethod.cash.value, 'cash');
      expect(ReturnRefundMethod.storeCredit.value, 'store_credit');
      expect(ReturnRefundMethod.originalMethod.value, 'original_method');
    });
  });
}
