import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  P11 — MARKETPLACE MANAGEMENT Tests
  // ═══════════════════════════════════════════════════════════════════════════

  group('P11 Endpoints', () {
    test('adminMarketplaceStores', () {
      expect(ApiEndpoints.adminMarketplaceStores, '/admin/marketplace/stores');
    });
    test('adminMarketplaceStoreById', () {
      expect(ApiEndpoints.adminMarketplaceStoreById('s1'), '/admin/marketplace/stores/s1');
    });
    test('adminMarketplaceStoreConnect', () {
      expect(ApiEndpoints.adminMarketplaceStoreConnect('s1'), '/admin/marketplace/stores/s1/connect');
    });
    test('adminMarketplaceStoreDisconnect', () {
      expect(ApiEndpoints.adminMarketplaceStoreDisconnect('s1'), '/admin/marketplace/stores/s1/disconnect');
    });
    test('adminMarketplaceProducts', () {
      expect(ApiEndpoints.adminMarketplaceProducts, '/admin/marketplace/products');
    });
    test('adminMarketplaceProductById', () {
      expect(ApiEndpoints.adminMarketplaceProductById('p1'), '/admin/marketplace/products/p1');
    });
    test('adminMarketplaceBulkPublish', () {
      expect(ApiEndpoints.adminMarketplaceBulkPublish, '/admin/marketplace/products/bulk-publish');
    });
    test('adminMarketplaceOrders', () {
      expect(ApiEndpoints.adminMarketplaceOrders, '/admin/marketplace/orders');
    });
    test('adminMarketplaceOrderById', () {
      expect(ApiEndpoints.adminMarketplaceOrderById('o1'), '/admin/marketplace/orders/o1');
    });
    test('adminMarketplaceSettlements', () {
      expect(ApiEndpoints.adminMarketplaceSettlements, '/admin/marketplace/settlements');
    });
    test('adminMarketplaceSettlementById', () {
      expect(ApiEndpoints.adminMarketplaceSettlementById('st1'), '/admin/marketplace/settlements/st1');
    });
    test('adminMarketplaceSettlementSummary', () {
      expect(ApiEndpoints.adminMarketplaceSettlementSummary, '/admin/marketplace/settlements/summary');
    });
  });

  // ─── State Classes ─────────────────────────────────────────────

  group('P11 MarketplaceStoreListState', () {
    test('Initial', () => expect(const MarketplaceStoreListInitial(), isA<MarketplaceStoreListState>()));
    test('Loading', () => expect(const MarketplaceStoreListLoading(), isA<MarketplaceStoreListState>()));
    test('Loaded', () {
      const s = MarketplaceStoreListLoaded({'total': 3});
      expect(s.data['total'], 3);
    });
    test('Error', () {
      const s = MarketplaceStoreListError('err');
      expect(s.message, 'err');
    });
  });

  group('P11 MarketplaceStoreDetailState', () {
    test('Initial', () => expect(const MarketplaceStoreDetailInitial(), isA<MarketplaceStoreDetailState>()));
    test('Loading', () => expect(const MarketplaceStoreDetailLoading(), isA<MarketplaceStoreDetailState>()));
    test('Loaded', () {
      const s = MarketplaceStoreDetailLoaded({'id': 'x'});
      expect(s.data['id'], 'x');
    });
    test('Error', () => expect(const MarketplaceStoreDetailError('e').message, 'e'));
  });

  group('P11 MarketplaceStoreActionState', () {
    test('Initial', () => expect(const MarketplaceStoreActionInitial(), isA<MarketplaceStoreActionState>()));
    test('Loading', () => expect(const MarketplaceStoreActionLoading(), isA<MarketplaceStoreActionState>()));
    test('Success', () {
      const s = MarketplaceStoreActionSuccess({'connected': true});
      expect(s.data['connected'], true);
    });
    test('Error', () => expect(const MarketplaceStoreActionError('e').message, 'e'));
  });

  group('P11 MarketplaceProductListState', () {
    test('Initial', () => expect(const MarketplaceProductListInitial(), isA<MarketplaceProductListState>()));
    test('Loading', () => expect(const MarketplaceProductListLoading(), isA<MarketplaceProductListState>()));
    test('Loaded', () {
      const s = MarketplaceProductListLoaded({'data': []});
      expect(s.data['data'], isEmpty);
    });
    test('Error', () => expect(const MarketplaceProductListError('e').message, 'e'));
  });

  group('P11 MarketplaceProductActionState', () {
    test('Initial', () => expect(const MarketplaceProductActionInitial(), isA<MarketplaceProductActionState>()));
    test('Loading', () => expect(const MarketplaceProductActionLoading(), isA<MarketplaceProductActionState>()));
    test('Success', () {
      const s = MarketplaceProductActionSuccess({'updated_count': 2});
      expect(s.data['updated_count'], 2);
    });
    test('Error', () => expect(const MarketplaceProductActionError('e').message, 'e'));
  });

  group('P11 MarketplaceOrderListState', () {
    test('Initial', () => expect(const MarketplaceOrderListInitial(), isA<MarketplaceOrderListState>()));
    test('Loading', () => expect(const MarketplaceOrderListLoading(), isA<MarketplaceOrderListState>()));
    test('Loaded', () {
      const s = MarketplaceOrderListLoaded({'total': 10});
      expect(s.data['total'], 10);
    });
    test('Error', () => expect(const MarketplaceOrderListError('e').message, 'e'));
  });

  group('P11 MarketplaceOrderDetailState', () {
    test('Initial', () => expect(const MarketplaceOrderDetailInitial(), isA<MarketplaceOrderDetailState>()));
    test('Loading', () => expect(const MarketplaceOrderDetailLoading(), isA<MarketplaceOrderDetailState>()));
    test('Loaded', () {
      const s = MarketplaceOrderDetailLoaded({'order_id': 'o1'});
      expect(s.data['order_id'], 'o1');
    });
    test('Error', () => expect(const MarketplaceOrderDetailError('e').message, 'e'));
  });

  group('P11 MarketplaceSettlementListState', () {
    test('Initial', () => expect(const MarketplaceSettlementListInitial(), isA<MarketplaceSettlementListState>()));
    test('Loading', () => expect(const MarketplaceSettlementListLoading(), isA<MarketplaceSettlementListState>()));
    test('Loaded', () {
      const s = MarketplaceSettlementListLoaded({'total': 5});
      expect(s.data['total'], 5);
    });
    test('Error', () => expect(const MarketplaceSettlementListError('e').message, 'e'));
  });

  group('P11 MarketplaceSettlementSummaryState', () {
    test('Initial', () => expect(const MarketplaceSettlementSummaryInitial(), isA<MarketplaceSettlementSummaryState>()));
    test('Loading', () => expect(const MarketplaceSettlementSummaryLoading(), isA<MarketplaceSettlementSummaryState>()));
    test('Loaded', () {
      const s = MarketplaceSettlementSummaryLoaded({'total_gross': 1000});
      expect(s.data['total_gross'], 1000);
    });
    test('Error', () => expect(const MarketplaceSettlementSummaryError('e').message, 'e'));
  });

  // ─── Endpoint Integrity ─────────────────────────────────────

  group('P11 Endpoint Integrity', () {
    test('all store endpoints under /admin/marketplace/stores', () {
      expect(ApiEndpoints.adminMarketplaceStores, startsWith('/admin/marketplace/stores'));
      expect(ApiEndpoints.adminMarketplaceStoreById('x'), startsWith('/admin/marketplace/stores'));
      expect(ApiEndpoints.adminMarketplaceStoreConnect('x'), startsWith('/admin/marketplace/stores'));
      expect(ApiEndpoints.adminMarketplaceStoreDisconnect('x'), startsWith('/admin/marketplace/stores'));
    });

    test('all product endpoints under /admin/marketplace/products', () {
      expect(ApiEndpoints.adminMarketplaceProducts, startsWith('/admin/marketplace/products'));
      expect(ApiEndpoints.adminMarketplaceProductById('x'), startsWith('/admin/marketplace/products'));
      expect(ApiEndpoints.adminMarketplaceBulkPublish, startsWith('/admin/marketplace/products'));
    });

    test('all settlement endpoints under /admin/marketplace/settlements', () {
      expect(ApiEndpoints.adminMarketplaceSettlements, startsWith('/admin/marketplace/settlements'));
      expect(ApiEndpoints.adminMarketplaceSettlementById('x'), startsWith('/admin/marketplace/settlements'));
      expect(ApiEndpoints.adminMarketplaceSettlementSummary, startsWith('/admin/marketplace/settlements'));
    });

    test('endpoint ids are embedded properly', () {
      expect(ApiEndpoints.adminMarketplaceStoreById('abc'), contains('abc'));
      expect(ApiEndpoints.adminMarketplaceProductById('def'), contains('def'));
      expect(ApiEndpoints.adminMarketplaceOrderById('ghi'), contains('ghi'));
      expect(ApiEndpoints.adminMarketplaceSettlementById('jkl'), contains('jkl'));
    });
  });
}
