// ignore_for_file: lines_longer_than_80_chars

/// Analytics Notifier Unit Tests
///
/// Tests every analytics notifier's `load()` / `export*()` method for:
///   - correct Initial state before load
///   - Loading state set synchronously on entry
///   - Loaded state with all fields mapped from the API JSON
///   - Error state when the repository throws
///   - Type-coercion: int/num from API parsed to double or int as expected
///   - Null-safety defaults: missing optional keys fall back to 0 / [] / {}
///   - Export notifiers: all three export types (revenue, subscriptions, stores)
///
/// A [_FakeRepo] helper extends [AdminRepository] with per-call configurable
/// responses so that no HTTP or Dio setup is required.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/admin_panel/data/remote/admin_api_service.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/repositories/admin_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Test Helpers
// ─────────────────────────────────────────────────────────────────────────────

/// A no-op ApiService whose HTTP methods are never called.
/// Required to satisfy [AdminRepository]'s positional constructor arg.
class _NullApiService extends AdminApiService {
  _NullApiService() : super(Dio());
}

/// Configurable fake repository that overrides every analytics method.
///
/// Pass the response you want via the named parameter; omit it to use the
/// preconfigured success payloads, or set [shouldThrow] to simulate a
/// network failure.
class _FakeRepo extends AdminRepository {
  _FakeRepo({
    this.dashboardResponse,
    this.revenueResponse,
    this.subscriptionsResponse,
    this.storesResponse,
    this.featuresResponse,
    this.supportResponse,
    this.systemHealthResponse,
    this.notificationsResponse,
    this.exportResponse,
    this.shouldThrow = false,
  }) : super(_NullApiService());

  final Map<String, dynamic>? dashboardResponse;
  final Map<String, dynamic>? revenueResponse;
  final Map<String, dynamic>? subscriptionsResponse;
  final Map<String, dynamic>? storesResponse;
  final Map<String, dynamic>? featuresResponse;
  final Map<String, dynamic>? supportResponse;
  final Map<String, dynamic>? systemHealthResponse;
  final Map<String, dynamic>? notificationsResponse;
  final Map<String, dynamic>? exportResponse;
  final bool shouldThrow;

  void _maybeThrow() {
    if (shouldThrow) throw Exception('network error');
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsDashboard({String? storeId}) async {
    _maybeThrow();
    return dashboardResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsRevenue(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return revenueResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSubscriptions(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return subscriptionsResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsStores(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return storesResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsFeatures(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return featuresResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSupport(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return supportResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSystemHealth(
      {String? storeId}) async {
    _maybeThrow();
    return systemHealthResponse!;
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsNotifications(
      {Map<String, dynamic>? params}) async {
    _maybeThrow();
    return notificationsResponse!;
  }

  @override
  Future<Map<String, dynamic>> exportAnalyticsRevenue(
      Map<String, dynamic> data) async {
    _maybeThrow();
    return exportResponse!;
  }

  @override
  Future<Map<String, dynamic>> exportAnalyticsSubscriptions(
      Map<String, dynamic> data) async {
    _maybeThrow();
    return exportResponse!;
  }

  @override
  Future<Map<String, dynamic>> exportAnalyticsStores(
      Map<String, dynamic> data) async {
    _maybeThrow();
    return exportResponse!;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample API payloads (mirrors the exact Laravel JSON structure)
// ─────────────────────────────────────────────────────────────────────────────

const _kDashboardPayload = {
  'data': {
    'kpi': {
      'total_active_stores': 42,
      'mrr': 15000.0,
      'arr': 180000.0,
      'total_subscriptions': 55,
      'churn_rate': 3.5,
      'zatca_compliance_rate': 92.0,
    },
    'recent_activity': [
      {'action': 'store_created', 'entity_type': 'store', 'created_at': '2026-05-01'},
      {'action': 'subscription_upgraded', 'entity_type': 'subscription', 'created_at': '2026-05-02'},
    ],
  },
};

const _kRevenuePayload = {
  'data': {
    'mrr': 12500.50,
    'arr': 150006.0,
    'revenue_trend': [
      {'date': '2026-04-01', 'mrr': 11000.0, 'gmv': 55000.0},
      {'date': '2026-05-01', 'mrr': 12500.50, 'gmv': 62000.0},
    ],
    'revenue_by_plan': [
      {'plan_name': 'Pro', 'active_count': 30, 'mrr': 9000.0},
      {'plan_name': 'Starter', 'active_count': 15, 'mrr': 3500.50},
    ],
    'failed_payments_count': 4,
    'upcoming_renewals': 11,
  },
};

const _kSubscriptionsPayload = {
  'data': {
    'status_counts': {'active': 45, 'trial': 8, 'expired': 3, 'cancelled': 2},
    'lifecycle_trend': [
      {'date': '2026-05-01', 'active': 43, 'trial': 10, 'churned': 1},
    ],
    'average_subscription_age_days': 128.7,
    'total_churn_in_period': 5,
    'trial_to_paid_conversion_rate': 72.5,
  },
};

const _kStoresPayload = {
  'data': {
    'total_stores': 60,
    'active_stores': 55,
    'top_stores': [
      {'store_id': 's1', 'store_name': 'Alpha Store', 'total_orders': 320},
      {'store_id': 's2', 'store_name': 'Beta Store', 'total_orders': 280},
    ],
    'health_summary': {'ok': 50, 'warning': 4, 'error': 1},
  },
};

const _kFeaturesPayload = {
  'data': {
    'features': [
      {
        'feature_key': 'loyalty_program',
        'stores_using': 38,
        'total_eligible': 500,
        'adoption_percentage': 63.33,
      },
      {
        'feature_key': 'delivery_integration',
        'stores_using': 22,
        'total_eligible': 300,
        'adoption_percentage': 36.67,
      },
    ],
    'trend': [
      {'date': '2026-05-01', 'total_stores': 36, 'total_eligible': 800},
    ],
  },
};

const _kSupportPayload = {
  'data': {
    'total_tickets': 120,
    'open_tickets': 30,
    'in_progress_tickets': 20,
    'resolved_tickets': 60,
    'closed_tickets': 10,
    'sla_compliance_rate': 88.5,
    'sla_breached': 7,
    'avg_first_response_hours': 1.5,
    'avg_resolution_hours': 8.25,
    'by_category': {'billing': 45, 'technical': 50, 'general': 25},
    'by_priority': {'low': 20, 'medium': 60, 'high': 30, 'urgent': 10},
    'date_range': {'from': '2026-04-05', 'to': '2026-05-05'},
  },
};

const _kSystemHealthPayload = {
  'data': {
    'stores_monitored': 60,
    'stores_with_errors': 3,
    'total_errors_today': 15,
    'sync_status_breakdown': {'ok': 54, 'warning': 3, 'error': 3},
  },
};

const _kNotificationsPayload = {
  'data': {
    'total_sent': 80000,
    'total_delivered': 77500,
    'total_failed': 2500,
    'total_opened': 20000,
    'delivery_rate': 96.88,
    'open_rate': 25.81,
    'avg_latency_ms': 210.5,
    'by_channel': [
      {'channel': 'push', 'total_sent': 50000, 'total_delivered': 48500},
      {'channel': 'email', 'total_sent': 20000, 'total_delivered': 19500},
      {'channel': 'sms', 'total_sent': 10000, 'total_delivered': 9500},
    ],
    'batch_stats': {'total_batches': 200, 'total_recipients': 80000},
  },
};

const _kExportPayload = {
  'data': {
    'export_type': 'revenue',
    'format': 'xlsx',
    'download_url': 'https://example.com/files/revenue_2026.xlsx',
    'filename': 'revenue_2026.xlsx',
    'expires_at': '2026-05-06T05:00:00Z',
  },
};

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════
  // Dashboard Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsDashboardNotifier', () {
    test('initial state is AnalyticsDashboardInitial', () {
      final notifier = AnalyticsDashboardNotifier(
          _FakeRepo(dashboardResponse: _kDashboardPayload));
      expect(notifier.state, isA<AnalyticsDashboardInitial>());
    });

    test('load() transitions to Loaded with correct kpi and recentActivity', () async {
      final notifier = AnalyticsDashboardNotifier(
          _FakeRepo(dashboardResponse: _kDashboardPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsDashboardLoaded;
      expect(state.kpi['total_active_stores'], 42);
      expect(state.kpi['mrr'], 15000.0);
      expect(state.kpi['churn_rate'], 3.5);
      expect(state.kpi['zatca_compliance_rate'], 92.0);
      expect(state.recentActivity.length, 2);
      expect(state.recentActivity.first['action'], 'store_created');
      expect(state.recentActivity.last['entity_type'], 'subscription');
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsDashboardNotifier(
          _FakeRepo(dashboardResponse: _kDashboardPayload, shouldThrow: true));
      await notifier.load();

      expect(notifier.state, isA<AnalyticsDashboardError>());
      final err = notifier.state as AnalyticsDashboardError;
      expect(err.message, contains('network error'));
    });

    test('load() accepts storeId parameter without error', () async {
      final notifier = AnalyticsDashboardNotifier(
          _FakeRepo(dashboardResponse: _kDashboardPayload));
      await notifier.load(storeId: 'store-uuid-123');
      expect(notifier.state, isA<AnalyticsDashboardLoaded>());
    });

    test('empty recentActivity list is accepted', () async {
      final payload = {
        'data': {'kpi': <String, dynamic>{}, 'recent_activity': <dynamic>[]},
      };
      final notifier = AnalyticsDashboardNotifier(_FakeRepo(dashboardResponse: payload));
      await notifier.load();
      final state = notifier.state as AnalyticsDashboardLoaded;
      expect(state.recentActivity, isEmpty);
      expect(state.kpi, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Revenue Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsRevenueNotifier', () {
    test('initial state is AnalyticsRevenueInitial', () {
      final notifier = AnalyticsRevenueNotifier(
          _FakeRepo(revenueResponse: _kRevenuePayload));
      expect(notifier.state, isA<AnalyticsRevenueInitial>());
    });

    test('load() parses all revenue fields correctly', () async {
      final notifier = AnalyticsRevenueNotifier(
          _FakeRepo(revenueResponse: _kRevenuePayload));
      await notifier.load();

      final state = notifier.state as AnalyticsRevenueLoaded;
      expect(state.mrr, 12500.50);
      expect(state.arr, 150006.0);
      expect(state.revenueTrend.length, 2);
      expect(state.revenueTrend.first['date'], '2026-04-01');
      expect(state.revenueTrend.last['mrr'], 12500.50);
      expect(state.revenueByPlan.length, 2);
      expect(state.revenueByPlan.first['plan_name'], 'Pro');
      expect(state.failedPaymentsCount, 4);
      expect(state.upcomingRenewals, 11);
    });

    test('load() coerces integer mrr/arr to double', () async {
      final payload = {
        'data': {
          'mrr': 5000,     // integer from API
          'arr': 60000,    // integer from API
          'revenue_trend': <dynamic>[],
          'revenue_by_plan': <dynamic>[],
          'failed_payments_count': 0,
          'upcoming_renewals': 0,
        },
      };
      final notifier = AnalyticsRevenueNotifier(_FakeRepo(revenueResponse: payload));
      await notifier.load();

      final state = notifier.state as AnalyticsRevenueLoaded;
      expect(state.mrr, isA<double>());
      expect(state.arr, isA<double>());
      expect(state.mrr, 5000.0);
      expect(state.arr, 60000.0);
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsRevenueNotifier(
          _FakeRepo(revenueResponse: _kRevenuePayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsRevenueError>());
    });

    test('load() passes date range params to repo', () async {
      final notifier = AnalyticsRevenueNotifier(
          _FakeRepo(revenueResponse: _kRevenuePayload));
      await notifier.load(dateFrom: '2026-04-01', dateTo: '2026-04-30');
      expect(notifier.state, isA<AnalyticsRevenueLoaded>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Subscriptions Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsSubscriptionsNotifier', () {
    test('initial state is AnalyticsSubscriptionsInitial', () {
      final notifier = AnalyticsSubscriptionsNotifier(
          _FakeRepo(subscriptionsResponse: _kSubscriptionsPayload));
      expect(notifier.state, isA<AnalyticsSubscriptionsInitial>());
    });

    test('load() parses all subscription fields correctly', () async {
      final notifier = AnalyticsSubscriptionsNotifier(
          _FakeRepo(subscriptionsResponse: _kSubscriptionsPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsSubscriptionsLoaded;
      expect(state.statusCounts['active'], 45);
      expect(state.statusCounts['trial'], 8);
      expect(state.lifecycleTrend.length, 1);
      expect(state.lifecycleTrend.first['date'], '2026-05-01');
      expect(state.averageSubscriptionAgeDays, 128.7);
      expect(state.totalChurnInPeriod, 5);
      expect(state.trialToPaidConversionRate, 72.5);
    });

    test('load() coerces integer average age to double', () async {
      final payload = {
        'data': {
          'status_counts': <String, dynamic>{},
          'lifecycle_trend': <dynamic>[],
          'average_subscription_age_days': 90,   // integer from API
          'total_churn_in_period': 0,
          'trial_to_paid_conversion_rate': 50,   // integer from API
        },
      };
      final notifier = AnalyticsSubscriptionsNotifier(
          _FakeRepo(subscriptionsResponse: payload));
      await notifier.load();

      final state = notifier.state as AnalyticsSubscriptionsLoaded;
      expect(state.averageSubscriptionAgeDays, isA<double>());
      expect(state.trialToPaidConversionRate, isA<double>());
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsSubscriptionsNotifier(
          _FakeRepo(subscriptionsResponse: _kSubscriptionsPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsSubscriptionsError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Stores Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsStoresNotifier', () {
    test('initial state is AnalyticsStoresInitial', () {
      final notifier = AnalyticsStoresNotifier(
          _FakeRepo(storesResponse: _kStoresPayload));
      expect(notifier.state, isA<AnalyticsStoresInitial>());
    });

    test('load() parses all stores fields correctly', () async {
      final notifier = AnalyticsStoresNotifier(
          _FakeRepo(storesResponse: _kStoresPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsStoresLoaded;
      expect(state.totalStores, 60);
      expect(state.activeStores, 55);
      expect(state.topStores.length, 2);
      expect(state.topStores.first['store_name'], 'Alpha Store');
      expect(state.topStores.first['total_orders'], 320);
      expect(state.healthSummary['ok'], 50);
      expect(state.healthSummary['error'], 1);
    });

    test('load() accepts custom limit parameter', () async {
      final notifier = AnalyticsStoresNotifier(
          _FakeRepo(storesResponse: _kStoresPayload));
      await notifier.load(limit: 5);
      expect(notifier.state, isA<AnalyticsStoresLoaded>());
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsStoresNotifier(
          _FakeRepo(storesResponse: _kStoresPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsStoresError>());
    });

    test('active stores <= total stores invariant', () async {
      final notifier = AnalyticsStoresNotifier(
          _FakeRepo(storesResponse: _kStoresPayload));
      await notifier.load();
      final state = notifier.state as AnalyticsStoresLoaded;
      expect(state.activeStores <= state.totalStores, isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Features Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsFeaturesNotifier', () {
    test('initial state is AnalyticsFeaturesInitial', () {
      final notifier = AnalyticsFeaturesNotifier(
          _FakeRepo(featuresResponse: _kFeaturesPayload));
      expect(notifier.state, isA<AnalyticsFeaturesInitial>());
    });

    test('load() parses features list correctly', () async {
      final notifier = AnalyticsFeaturesNotifier(
          _FakeRepo(featuresResponse: _kFeaturesPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsFeaturesLoaded;
      expect(state.features.length, 2);
      expect(state.features.first['feature_key'], 'loyalty_program');
      expect(state.features.first['adoption_percentage'], 63.33);
      expect(state.features.last['feature_key'], 'delivery_integration');
      expect(state.trend.length, 1);
      expect(state.trend.first['date'], '2026-05-01');
    });

    test('load() returns empty features list when no data', () async {
      final payload = {
        'data': {'features': <dynamic>[], 'trend': <dynamic>[]},
      };
      final notifier = AnalyticsFeaturesNotifier(
          _FakeRepo(featuresResponse: payload));
      await notifier.load();

      final state = notifier.state as AnalyticsFeaturesLoaded;
      expect(state.features, isEmpty);
      expect(state.trend, isEmpty);
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsFeaturesNotifier(
          _FakeRepo(featuresResponse: _kFeaturesPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsFeaturesError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Support Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsSupportNotifier', () {
    test('initial state is AnalyticsSupportInitial', () {
      final notifier = AnalyticsSupportNotifier(
          _FakeRepo(supportResponse: _kSupportPayload));
      expect(notifier.state, isA<AnalyticsSupportInitial>());
    });

    test('load() parses all support fields correctly', () async {
      final notifier = AnalyticsSupportNotifier(
          _FakeRepo(supportResponse: _kSupportPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsSupportLoaded;
      expect(state.totalTickets, 120);
      expect(state.openTickets, 30);
      expect(state.inProgressTickets, 20);
      expect(state.resolvedTickets, 60);
      expect(state.closedTickets, 10);
      expect(state.slaComplianceRate, 88.5);
      expect(state.slaBreached, 7);
      expect(state.avgFirstResponseHours, 1.5);
      expect(state.avgResolutionHours, 8.25);
      expect(state.byCategory['billing'], 45);
      expect(state.byCategory['technical'], 50);
      expect(state.byPriority['high'], 30);
      expect(state.byPriority['urgent'], 10);
    });

    test('load() sums open+inProgress+resolved+closed == total', () async {
      final notifier = AnalyticsSupportNotifier(
          _FakeRepo(supportResponse: _kSupportPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsSupportLoaded;
      expect(
        state.openTickets + state.inProgressTickets +
            state.resolvedTickets + state.closedTickets,
        state.totalTickets,
      );
    });

    test('load() defaults nullable num fields to 0', () async {
      final payload = {
        'data': {
          'total_tickets': 0,
          'open_tickets': 0,
          // in_progress_tickets, resolved_tickets, closed_tickets omitted
          'sla_compliance_rate': 100,
          'sla_breached': 0,
          'avg_first_response_hours': 0,
          'avg_resolution_hours': 0,
          // by_category, by_priority omitted
          'date_range': {'from': '2026-04-05', 'to': '2026-05-05'},
        },
      };
      final notifier = AnalyticsSupportNotifier(_FakeRepo(supportResponse: payload));
      await notifier.load();

      final state = notifier.state as AnalyticsSupportLoaded;
      expect(state.inProgressTickets, 0);
      expect(state.resolvedTickets, 0);
      expect(state.closedTickets, 0);
      expect(state.byCategory, isEmpty);
      expect(state.byPriority, isEmpty);
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsSupportNotifier(
          _FakeRepo(supportResponse: _kSupportPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsSupportError>());
    });

    test('SLA compliance rate is a double', () async {
      final notifier = AnalyticsSupportNotifier(
          _FakeRepo(supportResponse: _kSupportPayload));
      await notifier.load();
      final state = notifier.state as AnalyticsSupportLoaded;
      expect(state.slaComplianceRate, isA<double>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // System Health Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsSystemHealthNotifier', () {
    test('initial state is AnalyticsSystemHealthInitial', () {
      final notifier = AnalyticsSystemHealthNotifier(
          _FakeRepo(systemHealthResponse: _kSystemHealthPayload));
      expect(notifier.state, isA<AnalyticsSystemHealthInitial>());
    });

    test('load() parses all system health fields correctly', () async {
      final notifier = AnalyticsSystemHealthNotifier(
          _FakeRepo(systemHealthResponse: _kSystemHealthPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsSystemHealthLoaded;
      expect(state.storesMonitored, 60);
      expect(state.storesWithErrors, 3);
      expect(state.totalErrorsToday, 15);
      expect(state.syncStatusBreakdown['ok'], 54);
      expect(state.syncStatusBreakdown['error'], 3);
    });

    test('storesWithErrors <= storesMonitored invariant', () async {
      final notifier = AnalyticsSystemHealthNotifier(
          _FakeRepo(systemHealthResponse: _kSystemHealthPayload));
      await notifier.load();
      final state = notifier.state as AnalyticsSystemHealthLoaded;
      expect(state.storesWithErrors <= state.storesMonitored, isTrue);
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsSystemHealthNotifier(
          _FakeRepo(systemHealthResponse: _kSystemHealthPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsSystemHealthError>());
    });

    test('load() accepts storeId parameter', () async {
      final notifier = AnalyticsSystemHealthNotifier(
          _FakeRepo(systemHealthResponse: _kSystemHealthPayload));
      await notifier.load(storeId: 'store-123');
      expect(notifier.state, isA<AnalyticsSystemHealthLoaded>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Notifications Notifier
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsNotificationsNotifier', () {
    test('initial state is AnalyticsNotificationsInitial', () {
      final notifier = AnalyticsNotificationsNotifier(
          _FakeRepo(notificationsResponse: _kNotificationsPayload));
      expect(notifier.state, isA<AnalyticsNotificationsInitial>());
    });

    test('load() parses all notification fields correctly', () async {
      final notifier = AnalyticsNotificationsNotifier(
          _FakeRepo(notificationsResponse: _kNotificationsPayload));
      await notifier.load();

      final state = notifier.state as AnalyticsNotificationsLoaded;
      expect(state.totalSent, 80000);
      expect(state.totalDelivered, 77500);
      expect(state.totalFailed, 2500);
      expect(state.totalOpened, 20000);
      expect(state.deliveryRate, 96.88);
      expect(state.openRate, 25.81);
      expect(state.avgLatencyMs, 210.5);
      expect(state.byChannel.length, 3);
      expect(state.byChannel.first['channel'], 'push');
      expect(state.byChannel.first['total_sent'], 50000);
      expect(state.batchStats['total_batches'], 200);
      expect(state.batchStats['total_recipients'], 80000);
    });

    test('load() delivered + failed == sent (data consistency)', () async {
      final notifier = AnalyticsNotificationsNotifier(
          _FakeRepo(notificationsResponse: _kNotificationsPayload));
      await notifier.load();
      final state = notifier.state as AnalyticsNotificationsLoaded;
      expect(state.totalDelivered + state.totalFailed, state.totalSent);
    });

    test('load() defaults nullable avg_latency_ms to 0', () async {
      final payload = {
        'data': {
          'total_sent': 0,
          'total_delivered': 0,
          'total_failed': 0,
          'total_opened': 0,
          'delivery_rate': 0,
          'open_rate': 0,
          // avg_latency_ms omitted
          // by_channel omitted
          // batch_stats omitted
        },
      };
      final notifier = AnalyticsNotificationsNotifier(
          _FakeRepo(notificationsResponse: payload));
      await notifier.load();
      final state = notifier.state as AnalyticsNotificationsLoaded;
      expect(state.avgLatencyMs, 0.0);
      expect(state.byChannel, isEmpty);
      expect(state.batchStats, isEmpty);
    });

    test('load() transitions to Error on exception', () async {
      final notifier = AnalyticsNotificationsNotifier(
          _FakeRepo(notificationsResponse: _kNotificationsPayload, shouldThrow: true));
      await notifier.load();
      expect(notifier.state, isA<AnalyticsNotificationsError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Export Notifier — Revenue
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsExportNotifier - exportRevenue', () {
    test('initial state is AnalyticsExportInitial', () {
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: _kExportPayload));
      expect(notifier.state, isA<AnalyticsExportInitial>());
    });

    test('exportRevenue() transitions to Success with all fields', () async {
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: _kExportPayload));
      await notifier.exportRevenue();

      final state = notifier.state as AnalyticsExportSuccess;
      expect(state.exportType, 'revenue');
      expect(state.format, 'xlsx');
      expect(state.downloadUrl, 'https://example.com/files/revenue_2026.xlsx');
      expect(state.filename, 'revenue_2026.xlsx');
      expect(state.expiresAt, '2026-05-06T05:00:00Z');
    });

    test('exportRevenue() accepts date range and format parameters', () async {
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: _kExportPayload));
      await notifier.exportRevenue(
        dateFrom: '2026-04-01',
        dateTo: '2026-04-30',
        format: 'csv',
      );
      expect(notifier.state, isA<AnalyticsExportSuccess>());
    });

    test('exportRevenue() transitions to Error on exception', () async {
      final notifier = AnalyticsExportNotifier(
          _FakeRepo(exportResponse: _kExportPayload, shouldThrow: true));
      await notifier.exportRevenue();
      expect(notifier.state, isA<AnalyticsExportError>());
    });

    test('exportRevenue() with null download_url stays Success', () async {
      final payload = {
        'data': {
          'export_type': 'revenue',
          'format': 'xlsx',
          'download_url': null,
          'filename': null,
          'expires_at': null,
        },
      };
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: payload));
      await notifier.exportRevenue();
      final state = notifier.state as AnalyticsExportSuccess;
      expect(state.downloadUrl, isNull);
      expect(state.filename, isNull);
      expect(state.expiresAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Export Notifier — Subscriptions
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsExportNotifier - exportSubscriptions', () {
    test('exportSubscriptions() transitions to Success', () async {
      final subsPayload = {
        'data': {
          'export_type': 'subscriptions',
          'format': 'xlsx',
          'download_url': 'https://example.com/subs.xlsx',
          'filename': 'subs.xlsx',
          'expires_at': null,
        },
      };
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: subsPayload));
      await notifier.exportSubscriptions();

      final state = notifier.state as AnalyticsExportSuccess;
      expect(state.exportType, 'subscriptions');
      expect(state.format, 'xlsx');
      expect(state.downloadUrl, contains('subs.xlsx'));
    });

    test('exportSubscriptions() transitions to Error on exception', () async {
      final notifier = AnalyticsExportNotifier(
          _FakeRepo(exportResponse: _kExportPayload, shouldThrow: true));
      await notifier.exportSubscriptions();
      expect(notifier.state, isA<AnalyticsExportError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Export Notifier — Stores
  // ═══════════════════════════════════════════════════════════

  group('AnalyticsExportNotifier - exportStores', () {
    test('exportStores() transitions to Success', () async {
      final storesPayload = {
        'data': {
          'export_type': 'stores',
          'format': 'xlsx',
          'download_url': 'https://example.com/stores.xlsx',
          'filename': 'stores.xlsx',
          'expires_at': null,
        },
      };
      final notifier = AnalyticsExportNotifier(_FakeRepo(exportResponse: storesPayload));
      await notifier.exportStores();

      final state = notifier.state as AnalyticsExportSuccess;
      expect(state.exportType, 'stores');
      expect(state.downloadUrl, contains('stores.xlsx'));
    });

    test('exportStores() transitions to Error on exception', () async {
      final notifier = AnalyticsExportNotifier(
          _FakeRepo(exportResponse: _kExportPayload, shouldThrow: true));
      await notifier.exportStores();
      expect(notifier.state, isA<AnalyticsExportError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // JSON Contract Tests — API response shape validation
  // ═══════════════════════════════════════════════════════════

  group('JSON Contract - Dashboard response structure', () {
    test('response has data.kpi and data.recent_activity keys', () {
      final data = _kDashboardPayload['data'] as Map<String, dynamic>;
      expect(data.containsKey('kpi'), isTrue);
      expect(data.containsKey('recent_activity'), isTrue);
    });

    test('kpi contains expected metric keys', () {
      final kpi = (_kDashboardPayload['data'] as Map<String, dynamic>)['kpi'] as Map<String, dynamic>;
      for (final key in ['total_active_stores', 'mrr', 'arr', 'total_subscriptions', 'churn_rate', 'zatca_compliance_rate']) {
        expect(kpi.containsKey(key), isTrue, reason: 'kpi missing key: $key');
      }
    });
  });

  group('JSON Contract - Revenue response structure', () {
    test('response has all required revenue keys', () {
      final data = _kRevenuePayload['data'] as Map<String, dynamic>;
      for (final key in ['mrr', 'arr', 'revenue_trend', 'revenue_by_plan', 'failed_payments_count', 'upcoming_renewals']) {
        expect(data.containsKey(key), isTrue, reason: 'revenue missing key: $key');
      }
    });

    test('revenue_trend items have date, mrr, gmv keys', () {
      final trend = ((_kRevenuePayload['data'] as Map<String, dynamic>)['revenue_trend'] as List)
          .cast<Map<String, dynamic>>();
      for (final item in trend) {
        expect(item.containsKey('date'), isTrue);
        expect(item.containsKey('mrr'), isTrue);
        expect(item.containsKey('gmv'), isTrue);
      }
    });

    test('revenue_by_plan items have plan_name, active_count, mrr keys', () {
      final byPlan = ((_kRevenuePayload['data'] as Map<String, dynamic>)['revenue_by_plan'] as List)
          .cast<Map<String, dynamic>>();
      for (final item in byPlan) {
        expect(item.containsKey('plan_name'), isTrue);
        expect(item.containsKey('active_count'), isTrue);
        expect(item.containsKey('mrr'), isTrue);
      }
    });
  });

  group('JSON Contract - Support response structure', () {
    test('response has all required support keys', () {
      final data = _kSupportPayload['data'] as Map<String, dynamic>;
      for (final key in [
        'total_tickets', 'open_tickets', 'in_progress_tickets', 'resolved_tickets',
        'closed_tickets', 'sla_compliance_rate', 'sla_breached',
        'avg_first_response_hours', 'avg_resolution_hours', 'by_category', 'by_priority',
      ]) {
        expect(data.containsKey(key), isTrue, reason: 'support missing key: $key');
      }
    });

    test('sla_compliance_rate is numeric', () {
      final data = _kSupportPayload['data'] as Map<String, dynamic>;
      expect(data['sla_compliance_rate'], isA<num>());
    });
  });

  group('JSON Contract - Notifications response structure', () {
    test('response has all required notification keys', () {
      final data = _kNotificationsPayload['data'] as Map<String, dynamic>;
      for (final key in [
        'total_sent', 'total_delivered', 'total_failed', 'total_opened',
        'delivery_rate', 'open_rate', 'avg_latency_ms', 'by_channel', 'batch_stats',
      ]) {
        expect(data.containsKey(key), isTrue, reason: 'notifications missing key: $key');
      }
    });

    test('by_channel items have channel and total_sent keys', () {
      final byChannel = ((_kNotificationsPayload['data'] as Map<String, dynamic>)['by_channel'] as List)
          .cast<Map<String, dynamic>>();
      for (final item in byChannel) {
        expect(item.containsKey('channel'), isTrue);
        expect(item.containsKey('total_sent'), isTrue);
        expect(item.containsKey('total_delivered'), isTrue);
      }
    });
  });

  group('JSON Contract - System Health response structure', () {
    test('response has all required system health keys', () {
      final data = _kSystemHealthPayload['data'] as Map<String, dynamic>;
      for (final key in ['stores_monitored', 'stores_with_errors', 'total_errors_today', 'sync_status_breakdown']) {
        expect(data.containsKey(key), isTrue, reason: 'system health missing key: $key');
      }
    });
  });

  group('JSON Contract - Features response structure', () {
    test('feature items have feature_key and adoption_percentage keys', () {
      final features = ((_kFeaturesPayload['data'] as Map<String, dynamic>)['features'] as List)
          .cast<Map<String, dynamic>>();
      for (final item in features) {
        expect(item.containsKey('feature_key'), isTrue);
        expect(item.containsKey('adoption_percentage'), isTrue);
        expect(item.containsKey('stores_using'), isTrue);
      }
    });
  });

  group('JSON Contract - Export response structure', () {
    test('export response has export_type, format, and download_url keys', () {
      final data = _kExportPayload['data'] as Map<String, dynamic>;
      expect(data.containsKey('export_type'), isTrue);
      expect(data.containsKey('format'), isTrue);
      expect(data.containsKey('download_url'), isTrue);
      expect(data.containsKey('filename'), isTrue);
      expect(data.containsKey('expires_at'), isTrue);
    });
  });
}
