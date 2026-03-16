import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_deployment_release_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P12 Deployment & Release Management — Endpoints
  // ═══════════════════════════════════════════════════════════════
  group('P12 Endpoints', () {
    test('deployment overview', () {
      expect(ApiEndpoints.adminDeploymentOverview, '/admin/deployment/overview');
    });
    test('deployment releases', () {
      expect(ApiEndpoints.adminDeploymentReleases, '/admin/deployment/releases');
    });
    test('deployment release by id', () {
      expect(ApiEndpoints.adminDeploymentReleaseById('r1'), '/admin/deployment/releases/r1');
    });
    test('deployment release activate', () {
      expect(ApiEndpoints.adminDeploymentReleaseActivate('r1'), '/admin/deployment/releases/r1/activate');
    });
    test('deployment release deactivate', () {
      expect(ApiEndpoints.adminDeploymentReleaseDeactivate('r1'), '/admin/deployment/releases/r1/deactivate');
    });
    test('deployment release rollout', () {
      expect(ApiEndpoints.adminDeploymentReleaseRollout('r1'), '/admin/deployment/releases/r1/rollout');
    });
    test('deployment release stats', () {
      expect(ApiEndpoints.adminDeploymentReleaseStats('r1'), '/admin/deployment/releases/r1/stats');
    });
    test('deployment release summary', () {
      expect(ApiEndpoints.adminDeploymentReleaseSummary('r1'), '/admin/deployment/releases/r1/summary');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P12 States
  // ═══════════════════════════════════════════════════════════════
  group('P12 DeploymentOverviewState', () {
    test('initial', () {
      const s = DeploymentOverviewInitial();
      expect(s, isA<DeploymentOverviewState>());
    });
    test('loading', () {
      const s = DeploymentOverviewLoading();
      expect(s, isA<DeploymentOverviewState>());
    });
    test('loaded', () {
      const s = DeploymentOverviewLoaded({'platforms': []});
      expect(s.data, containsPair('platforms', []));
    });
    test('error', () {
      const s = DeploymentOverviewError('fail');
      expect(s.message, 'fail');
    });
  });

  group('P12 DeploymentReleaseListState', () {
    test('initial', () {
      const s = DeploymentReleaseListInitial();
      expect(s, isA<DeploymentReleaseListState>());
    });
    test('loading', () {
      const s = DeploymentReleaseListLoading();
      expect(s, isA<DeploymentReleaseListState>());
    });
    test('loaded', () {
      const s = DeploymentReleaseListLoaded({'data': []});
      expect(s.data, containsPair('data', []));
    });
    test('error', () {
      const s = DeploymentReleaseListError('fail');
      expect(s.message, 'fail');
    });
  });

  group('P12 DeploymentReleaseDetailState', () {
    test('initial', () => expect(const DeploymentReleaseDetailInitial(), isA<DeploymentReleaseDetailState>()));
    test('loading', () => expect(const DeploymentReleaseDetailLoading(), isA<DeploymentReleaseDetailState>()));
    test('loaded', () {
      const s = DeploymentReleaseDetailLoaded({'id': '1'});
      expect(s.data['id'], '1');
    });
    test('error', () {
      const s = DeploymentReleaseDetailError('not found');
      expect(s.message, 'not found');
    });
  });

  group('P12 DeploymentReleaseActionState', () {
    test('initial', () => expect(const DeploymentReleaseActionInitial(), isA<DeploymentReleaseActionState>()));
    test('loading', () => expect(const DeploymentReleaseActionLoading(), isA<DeploymentReleaseActionState>()));
    test('success', () {
      const s = DeploymentReleaseActionSuccess({'done': true});
      expect(s.data['done'], true);
    });
    test('error', () {
      const s = DeploymentReleaseActionError('err');
      expect(s.message, 'err');
    });
  });

  group('P12 DeploymentStatsListState', () {
    test('initial', () => expect(const DeploymentStatsListInitial(), isA<DeploymentStatsListState>()));
    test('loading', () => expect(const DeploymentStatsListLoading(), isA<DeploymentStatsListState>()));
    test('loaded', () {
      const s = DeploymentStatsListLoaded({'stats': []});
      expect(s.data, containsPair('stats', []));
    });
    test('error', () {
      const s = DeploymentStatsListError('fail');
      expect(s.message, 'fail');
    });
  });

  group('P12 DeploymentReleaseSummaryState', () {
    test('initial', () => expect(const DeploymentReleaseSummaryInitial(), isA<DeploymentReleaseSummaryState>()));
    test('loading', () => expect(const DeploymentReleaseSummaryLoading(), isA<DeploymentReleaseSummaryState>()));
    test('loaded', () {
      const s = DeploymentReleaseSummaryLoaded({'total_installs': 500});
      expect(s.data['total_installs'], 500);
    });
    test('error', () {
      const s = DeploymentReleaseSummaryError('err');
      expect(s.message, 'err');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P12 Widgets
  // ═══════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════
  // P12 Widgets — verify classes exist and construct
  // ═══════════════════════════════════════════════════════════════
  group('P12 Release List Page', () {
    test('class exists', () {
      expect(AdminDeploymentReleaseListPage, isNotNull);
    });
    test('is a widget', () {
      const page = AdminDeploymentReleaseListPage();
      expect(page, isA<Widget>());
    });
  });

  group('P12 Overview Page', () {
    test('class exists', () {
      expect(AdminDeploymentOverviewPage, isNotNull);
    });
    test('is a widget', () {
      const page = AdminDeploymentOverviewPage();
      expect(page, isA<Widget>());
    });
  });
}
