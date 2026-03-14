import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P6: API Endpoints – Dashboard & Dashboards
  // ═══════════════════════════════════════════════════════════════

  group('P6 API Endpoints - Analytics Dashboard', () {
    test('adminAnalyticsDashboard endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsDashboard, '/admin/analytics/dashboard');
    });

    test('adminAnalyticsRevenue endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsRevenue, '/admin/analytics/revenue');
    });

    test('adminAnalyticsSubscriptions endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsSubscriptions, '/admin/analytics/subscriptions');
    });

    test('adminAnalyticsStores endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsStores, '/admin/analytics/stores');
    });

    test('adminAnalyticsFeatures endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsFeatures, '/admin/analytics/features');
    });

    test('adminAnalyticsSupport endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsSupport, '/admin/analytics/support');
    });

    test('adminAnalyticsSystemHealth endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsSystemHealth, '/admin/analytics/system-health');
    });

    test('adminAnalyticsNotifications endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsNotifications, '/admin/analytics/notifications');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: API Endpoints – Raw Stats
  // ═══════════════════════════════════════════════════════════════

  group('P6 API Endpoints - Analytics Stats', () {
    test('adminAnalyticsDailyStats endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsDailyStats, '/admin/analytics/daily-stats');
    });

    test('adminAnalyticsPlanStats endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsPlanStats, '/admin/analytics/plan-stats');
    });

    test('adminAnalyticsFeatureStats endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsFeatureStats, '/admin/analytics/feature-stats');
    });

    test('adminAnalyticsStoreHealth endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsStoreHealth, '/admin/analytics/store-health');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: API Endpoints – Exports
  // ═══════════════════════════════════════════════════════════════

  group('P6 API Endpoints - Analytics Exports', () {
    test('adminAnalyticsExportRevenue endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsExportRevenue, '/admin/analytics/export/revenue');
    });

    test('adminAnalyticsExportSubscriptions endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsExportSubscriptions, '/admin/analytics/export/subscriptions');
    });

    test('adminAnalyticsExportStores endpoint is correct', () {
      expect(ApiEndpoints.adminAnalyticsExportStores, '/admin/analytics/export/stores');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsDashboardState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsDashboardState', () {
    test('AnalyticsDashboardInitial is correct type', () {
      const state = AnalyticsDashboardInitial();
      expect(state, isA<AnalyticsDashboardState>());
    });

    test('AnalyticsDashboardLoading is correct type', () {
      const state = AnalyticsDashboardLoading();
      expect(state, isA<AnalyticsDashboardState>());
    });

    test('AnalyticsDashboardLoaded holds kpi and recentActivity', () {
      const state = AnalyticsDashboardLoaded(
        kpi: {'total_active_stores': 10, 'mrr': 500.0},
        recentActivity: [
          {'action': 'login', 'entity_type': 'admin'},
        ],
      );
      expect(state, isA<AnalyticsDashboardState>());
      expect(state.kpi['total_active_stores'], 10);
      expect(state.kpi['mrr'], 500.0);
      expect(state.recentActivity.length, 1);
      expect(state.recentActivity.first['action'], 'login');
    });

    test('AnalyticsDashboardError holds message', () {
      const state = AnalyticsDashboardError('Network error');
      expect(state, isA<AnalyticsDashboardState>());
      expect(state.message, 'Network error');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsDashboardState>[
        AnalyticsDashboardInitial(),
        AnalyticsDashboardLoading(),
        AnalyticsDashboardLoaded(kpi: {}, recentActivity: []),
        AnalyticsDashboardError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsDashboardInitial() => 'init',
          AnalyticsDashboardLoading() => 'loading',
          AnalyticsDashboardLoaded() => 'loaded',
          AnalyticsDashboardError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsRevenueState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsRevenueState', () {
    test('AnalyticsRevenueInitial is correct type', () {
      const state = AnalyticsRevenueInitial();
      expect(state, isA<AnalyticsRevenueState>());
    });

    test('AnalyticsRevenueLoading is correct type', () {
      const state = AnalyticsRevenueLoading();
      expect(state, isA<AnalyticsRevenueState>());
    });

    test('AnalyticsRevenueLoaded holds all fields', () {
      const state = AnalyticsRevenueLoaded(
        mrr: 1200.50,
        arr: 14406.0,
        revenueTrend: [
          {'date': '2026-03-01', 'mrr': 1100.0},
        ],
        revenueByPlan: [
          {'plan_name': 'Pro', 'active_count': 5, 'mrr': 500.0},
        ],
        failedPaymentsCount: 3,
        upcomingRenewals: 7,
      );
      expect(state, isA<AnalyticsRevenueState>());
      expect(state.mrr, 1200.50);
      expect(state.arr, 14406.0);
      expect(state.revenueTrend.length, 1);
      expect(state.revenueByPlan.first['plan_name'], 'Pro');
      expect(state.failedPaymentsCount, 3);
      expect(state.upcomingRenewals, 7);
    });

    test('AnalyticsRevenueError holds message', () {
      const state = AnalyticsRevenueError('timeout');
      expect(state.message, 'timeout');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsRevenueState>[
        AnalyticsRevenueInitial(),
        AnalyticsRevenueLoading(),
        AnalyticsRevenueLoaded(mrr: 0, arr: 0, revenueTrend: [], revenueByPlan: [], failedPaymentsCount: 0, upcomingRenewals: 0),
        AnalyticsRevenueError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsRevenueInitial() => 'init',
          AnalyticsRevenueLoading() => 'loading',
          AnalyticsRevenueLoaded() => 'loaded',
          AnalyticsRevenueError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsSubscriptionsState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsSubscriptionsState', () {
    test('AnalyticsSubscriptionsInitial is correct type', () {
      const state = AnalyticsSubscriptionsInitial();
      expect(state, isA<AnalyticsSubscriptionsState>());
    });

    test('AnalyticsSubscriptionsLoading is correct type', () {
      const state = AnalyticsSubscriptionsLoading();
      expect(state, isA<AnalyticsSubscriptionsState>());
    });

    test('AnalyticsSubscriptionsLoaded holds all fields', () {
      const state = AnalyticsSubscriptionsLoaded(
        statusCounts: {'active': 50, 'trial': 10, 'cancelled': 5},
        lifecycleTrend: [
          {'date': '2026-03-01', 'active': 48, 'trial': 12, 'churned': 1},
        ],
        averageSubscriptionAgeDays: 120.5,
        totalChurnInPeriod: 3,
        trialToPaidConversionRate: 83.3,
      );
      expect(state, isA<AnalyticsSubscriptionsState>());
      expect(state.statusCounts['active'], 50);
      expect(state.lifecycleTrend.length, 1);
      expect(state.averageSubscriptionAgeDays, 120.5);
      expect(state.totalChurnInPeriod, 3);
      expect(state.trialToPaidConversionRate, 83.3);
    });

    test('AnalyticsSubscriptionsError holds message', () {
      const state = AnalyticsSubscriptionsError('fail');
      expect(state.message, 'fail');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsSubscriptionsState>[
        AnalyticsSubscriptionsInitial(),
        AnalyticsSubscriptionsLoading(),
        AnalyticsSubscriptionsLoaded(
          statusCounts: {},
          lifecycleTrend: [],
          averageSubscriptionAgeDays: 0,
          totalChurnInPeriod: 0,
          trialToPaidConversionRate: 0,
        ),
        AnalyticsSubscriptionsError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsSubscriptionsInitial() => 'init',
          AnalyticsSubscriptionsLoading() => 'loading',
          AnalyticsSubscriptionsLoaded() => 'loaded',
          AnalyticsSubscriptionsError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsStoresState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsStoresState', () {
    test('AnalyticsStoresInitial is correct type', () {
      const state = AnalyticsStoresInitial();
      expect(state, isA<AnalyticsStoresState>());
    });

    test('AnalyticsStoresLoading is correct type', () {
      const state = AnalyticsStoresLoading();
      expect(state, isA<AnalyticsStoresState>());
    });

    test('AnalyticsStoresLoaded holds all fields', () {
      const state = AnalyticsStoresLoaded(
        totalStores: 100,
        activeStores: 85,
        topStores: [
          {'id': '1', 'name': 'Store A', 'is_active': true},
        ],
        healthSummary: {'ok': 70, 'error': 15},
      );
      expect(state, isA<AnalyticsStoresState>());
      expect(state.totalStores, 100);
      expect(state.activeStores, 85);
      expect(state.topStores.length, 1);
      expect(state.healthSummary['ok'], 70);
    });

    test('AnalyticsStoresError holds message', () {
      const state = AnalyticsStoresError('not found');
      expect(state.message, 'not found');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsStoresState>[
        AnalyticsStoresInitial(),
        AnalyticsStoresLoading(),
        AnalyticsStoresLoaded(totalStores: 0, activeStores: 0, topStores: [], healthSummary: {}),
        AnalyticsStoresError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsStoresInitial() => 'init',
          AnalyticsStoresLoading() => 'loading',
          AnalyticsStoresLoaded() => 'loaded',
          AnalyticsStoresError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsFeaturesState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsFeaturesState', () {
    test('AnalyticsFeaturesInitial is correct type', () {
      const state = AnalyticsFeaturesInitial();
      expect(state, isA<AnalyticsFeaturesState>());
    });

    test('AnalyticsFeaturesLoading is correct type', () {
      const state = AnalyticsFeaturesLoading();
      expect(state, isA<AnalyticsFeaturesState>());
    });

    test('AnalyticsFeaturesLoaded holds features and trend', () {
      const state = AnalyticsFeaturesLoaded(
        features: [
          {'feature_key': 'pos', 'stores_using': 50, 'total_eligible': 100, 'adoption_percentage': 50.0},
        ],
        trend: [
          {'date': '2026-03-01', 'total_stores': 50, 'total_eligible': 100},
        ],
      );
      expect(state, isA<AnalyticsFeaturesState>());
      expect(state.features.length, 1);
      expect(state.features.first['feature_key'], 'pos');
      expect(state.trend.length, 1);
    });

    test('AnalyticsFeaturesError holds message', () {
      const state = AnalyticsFeaturesError('503');
      expect(state.message, '503');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsFeaturesState>[
        AnalyticsFeaturesInitial(),
        AnalyticsFeaturesLoading(),
        AnalyticsFeaturesLoaded(features: [], trend: []),
        AnalyticsFeaturesError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsFeaturesInitial() => 'init',
          AnalyticsFeaturesLoading() => 'loading',
          AnalyticsFeaturesLoaded() => 'loaded',
          AnalyticsFeaturesError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsSystemHealthState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsSystemHealthState', () {
    test('AnalyticsSystemHealthInitial is correct type', () {
      const state = AnalyticsSystemHealthInitial();
      expect(state, isA<AnalyticsSystemHealthState>());
    });

    test('AnalyticsSystemHealthLoading is correct type', () {
      const state = AnalyticsSystemHealthLoading();
      expect(state, isA<AnalyticsSystemHealthState>());
    });

    test('AnalyticsSystemHealthLoaded holds all fields', () {
      const state = AnalyticsSystemHealthLoaded(
        storesMonitored: 80,
        storesWithErrors: 5,
        totalErrorsToday: 12,
        syncStatusBreakdown: {'ok': 75, 'error': 5},
      );
      expect(state, isA<AnalyticsSystemHealthState>());
      expect(state.storesMonitored, 80);
      expect(state.storesWithErrors, 5);
      expect(state.totalErrorsToday, 12);
      expect(state.syncStatusBreakdown['ok'], 75);
    });

    test('AnalyticsSystemHealthError holds message', () {
      const state = AnalyticsSystemHealthError('down');
      expect(state.message, 'down');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsSystemHealthState>[
        AnalyticsSystemHealthInitial(),
        AnalyticsSystemHealthLoading(),
        AnalyticsSystemHealthLoaded(storesMonitored: 0, storesWithErrors: 0, totalErrorsToday: 0, syncStatusBreakdown: {}),
        AnalyticsSystemHealthError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsSystemHealthInitial() => 'init',
          AnalyticsSystemHealthLoading() => 'loading',
          AnalyticsSystemHealthLoaded() => 'loaded',
          AnalyticsSystemHealthError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: State – AnalyticsExportState
  // ═══════════════════════════════════════════════════════════════

  group('P6 State - AnalyticsExportState', () {
    test('AnalyticsExportInitial is correct type', () {
      const state = AnalyticsExportInitial();
      expect(state, isA<AnalyticsExportState>());
    });

    test('AnalyticsExportLoading is correct type', () {
      const state = AnalyticsExportLoading();
      expect(state, isA<AnalyticsExportState>());
    });

    test('AnalyticsExportSuccess holds all fields', () {
      const state = AnalyticsExportSuccess(exportType: 'revenue', format: 'xlsx', recordCount: 30, downloadUrl: null);
      expect(state, isA<AnalyticsExportState>());
      expect(state.exportType, 'revenue');
      expect(state.format, 'xlsx');
      expect(state.recordCount, 30);
      expect(state.downloadUrl, isNull);
    });

    test('AnalyticsExportSuccess with download URL', () {
      const state = AnalyticsExportSuccess(
        exportType: 'stores',
        format: 'csv',
        recordCount: 100,
        downloadUrl: 'https://example.com/export.csv',
      );
      expect(state.downloadUrl, 'https://example.com/export.csv');
    });

    test('AnalyticsExportError holds message', () {
      const state = AnalyticsExportError('forbidden');
      expect(state.message, 'forbidden');
    });

    test('exhaustive switch covers all variants', () {
      const states = <AnalyticsExportState>[
        AnalyticsExportInitial(),
        AnalyticsExportLoading(),
        AnalyticsExportSuccess(exportType: 'revenue', format: 'xlsx', recordCount: 0),
        AnalyticsExportError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          AnalyticsExportInitial() => 'init',
          AnalyticsExportLoading() => 'loading',
          AnalyticsExportSuccess() => 'success',
          AnalyticsExportError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: Cross-cutting – Empty data handling
  // ═══════════════════════════════════════════════════════════════

  group('P6 Cross-cutting - Empty data edge cases', () {
    test('AnalyticsDashboardLoaded with empty kpi and activity', () {
      const state = AnalyticsDashboardLoaded(kpi: {}, recentActivity: []);
      expect(state.kpi.isEmpty, true);
      expect(state.recentActivity.isEmpty, true);
    });

    test('AnalyticsRevenueLoaded with zero values', () {
      const state = AnalyticsRevenueLoaded(
        mrr: 0.0,
        arr: 0.0,
        revenueTrend: [],
        revenueByPlan: [],
        failedPaymentsCount: 0,
        upcomingRenewals: 0,
      );
      expect(state.mrr, 0.0);
      expect(state.arr, 0.0);
      expect(state.revenueTrend.isEmpty, true);
    });

    test('AnalyticsSubscriptionsLoaded with no churn', () {
      const state = AnalyticsSubscriptionsLoaded(
        statusCounts: {'active': 100},
        lifecycleTrend: [],
        averageSubscriptionAgeDays: 365.0,
        totalChurnInPeriod: 0,
        trialToPaidConversionRate: 100.0,
      );
      expect(state.totalChurnInPeriod, 0);
      expect(state.trialToPaidConversionRate, 100.0);
    });

    test('AnalyticsStoresLoaded with zero inactive', () {
      const state = AnalyticsStoresLoaded(totalStores: 50, activeStores: 50, topStores: [], healthSummary: {});
      expect(state.totalStores - state.activeStores, 0);
    });

    test('AnalyticsFeaturesLoaded with empty features', () {
      const state = AnalyticsFeaturesLoaded(features: [], trend: []);
      expect(state.features.isEmpty, true);
      expect(state.trend.isEmpty, true);
    });

    test('AnalyticsSystemHealthLoaded with zero errors', () {
      const state = AnalyticsSystemHealthLoaded(
        storesMonitored: 100,
        storesWithErrors: 0,
        totalErrorsToday: 0,
        syncStatusBreakdown: {'ok': 100},
      );
      expect(state.storesWithErrors, 0);
      expect(state.totalErrorsToday, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: Multiple export types
  // ═══════════════════════════════════════════════════════════════

  group('P6 Export types', () {
    test('revenue export type', () {
      const state = AnalyticsExportSuccess(exportType: 'revenue', format: 'xlsx', recordCount: 10);
      expect(state.exportType, 'revenue');
    });

    test('subscriptions export type', () {
      const state = AnalyticsExportSuccess(exportType: 'subscriptions', format: 'xlsx', recordCount: 25);
      expect(state.exportType, 'subscriptions');
    });

    test('stores export type', () {
      const state = AnalyticsExportSuccess(exportType: 'stores', format: 'csv', recordCount: 100);
      expect(state.exportType, 'stores');
      expect(state.format, 'csv');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P6: Rich data scenarios
  // ═══════════════════════════════════════════════════════════════

  group('P6 Rich data scenarios', () {
    test('AnalyticsDashboardLoaded with many activity items', () {
      final activity = List.generate(
        20,
        (i) => {'id': '$i', 'action': 'action_$i', 'entity_type': 'store', 'created_at': '2026-03-14T10:00:00Z'},
      );
      final state = AnalyticsDashboardLoaded(kpi: const {'total_active_stores': 200, 'mrr': 10000.0}, recentActivity: activity);
      expect(state.recentActivity.length, 20);
    });

    test('AnalyticsRevenueLoaded with multi-plan data', () {
      const state = AnalyticsRevenueLoaded(
        mrr: 5000.0,
        arr: 60000.0,
        revenueTrend: [
          {'date': '2026-03-01', 'mrr': 4800.0, 'gmv': 120000.0},
          {'date': '2026-03-02', 'mrr': 4900.0, 'gmv': 125000.0},
          {'date': '2026-03-03', 'mrr': 5000.0, 'gmv': 130000.0},
        ],
        revenueByPlan: [
          {'plan_name': 'Basic', 'active_count': 50, 'mrr': 1500.0},
          {'plan_name': 'Pro', 'active_count': 30, 'mrr': 2000.0},
          {'plan_name': 'Enterprise', 'active_count': 10, 'mrr': 1500.0},
        ],
        failedPaymentsCount: 5,
        upcomingRenewals: 15,
      );
      expect(state.revenueByPlan.length, 3);
      expect(state.revenueTrend.length, 3);
    });

    test('AnalyticsSubscriptionsLoaded with many statuses', () {
      const state = AnalyticsSubscriptionsLoaded(
        statusCounts: {'active': 100, 'trial': 20, 'cancelled': 15, 'past_due': 5, 'expired': 10},
        lifecycleTrend: [],
        averageSubscriptionAgeDays: 200.0,
        totalChurnInPeriod: 10,
        trialToPaidConversionRate: 83.3,
      );
      expect(state.statusCounts.length, 5);
      expect(state.statusCounts.values.reduce((a, b) => (a as int) + (b as int)), 150);
    });

    test('AnalyticsFeaturesLoaded with multiple features', () {
      const state = AnalyticsFeaturesLoaded(
        features: [
          {'feature_key': 'pos', 'stores_using': 80, 'total_eligible': 100, 'adoption_percentage': 80.0},
          {'feature_key': 'inventory', 'stores_using': 60, 'total_eligible': 100, 'adoption_percentage': 60.0},
          {'feature_key': 'ecommerce', 'stores_using': 30, 'total_eligible': 100, 'adoption_percentage': 30.0},
        ],
        trend: [],
      );
      expect(state.features.length, 3);
      expect(state.features.first['adoption_percentage'], 80.0);
    });

    test('AnalyticsSystemHealthLoaded with sync breakdown', () {
      const state = AnalyticsSystemHealthLoaded(
        storesMonitored: 90,
        storesWithErrors: 10,
        totalErrorsToday: 25,
        syncStatusBreakdown: {'ok': 75, 'warning': 5, 'error': 10},
      );
      expect(state.syncStatusBreakdown.length, 3);
    });
  });
}
