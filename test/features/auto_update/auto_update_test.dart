import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';

void main() {
  // ═══════════════ UpdateCheckState ═══════════════
  group('UpdateCheckState', () {
    test('initial', () {
      const s = UpdateCheckInitial();
      expect(s, isA<UpdateCheckState>());
    });

    test('loading', () {
      const s = UpdateCheckLoading();
      expect(s, isA<UpdateCheckState>());
    });

    test('loaded — update available', () {
      const s = UpdateCheckLoaded(
        updateAvailable: true,
        latestVersion: '2.0.0',
        downloadUrl: 'https://example.com/app.ipa',
        isForceUpdate: false,
        releaseId: 'abc-123',
        raw: {'update_available': true},
      );
      expect(s.updateAvailable, isTrue);
      expect(s.latestVersion, '2.0.0');
      expect(s.downloadUrl, isNotNull);
      expect(s.isForceUpdate, isFalse);
    });

    test('loaded — up to date', () {
      const s = UpdateCheckLoaded(updateAvailable: false, raw: {'update_available': false});
      expect(s.updateAvailable, isFalse);
      expect(s.latestVersion, isNull);
    });

    test('loaded — force update', () {
      const s = UpdateCheckLoaded(
        updateAvailable: true,
        latestVersion: '3.0.0',
        isForceUpdate: true,
        raw: {'is_force_update': true},
      );
      expect(s.isForceUpdate, isTrue);
    });

    test('error', () {
      const s = UpdateCheckError('Network failure');
      expect(s.message, 'Network failure');
    });
  });

  // ═══════════════ ChangelogState ═══════════════
  group('ChangelogState', () {
    test('initial', () {
      const s = ChangelogInitial();
      expect(s, isA<ChangelogState>());
    });

    test('loading', () {
      const s = ChangelogLoading();
      expect(s, isA<ChangelogState>());
    });

    test('loaded with releases', () {
      const s = ChangelogLoaded(
        releases: [
          {'version_number': '2.0.0', 'release_notes': 'New features'},
          {'version_number': '1.5.0', 'release_notes': 'Bug fixes'},
        ],
      );
      expect(s.releases, hasLength(2));
      expect(s.releases.first['version_number'], '2.0.0');
    });

    test('loaded empty', () {
      const s = ChangelogLoaded(releases: []);
      expect(s.releases, isEmpty);
    });

    test('error', () {
      const s = ChangelogError('Timeout');
      expect(s.message, 'Timeout');
    });
  });

  // ═══════════════ UpdateHistoryState ═══════════════
  group('UpdateHistoryState', () {
    test('initial', () {
      const s = HistoryInitial();
      expect(s, isA<UpdateHistoryState>());
    });

    test('loading', () {
      const s = HistoryLoading();
      expect(s, isA<UpdateHistoryState>());
    });

    test('loaded with entries', () {
      const s = HistoryLoaded(
        entries: [
          {
            'status': 'installed',
            'app_release': {'version_number': '2.0.0'},
          },
        ],
      );
      expect(s.entries, hasLength(1));
      expect(s.entries.first['status'], 'installed');
    });

    test('error', () {
      const s = HistoryError('No data');
      expect(s.message, 'No data');
    });
  });

  // ═══════════════ UpdateOperationState ═══════════════
  group('UpdateOperationState', () {
    test('idle', () {
      const s = UpdateOperationIdle();
      expect(s, isA<UpdateOperationState>());
    });

    test('running', () {
      const s = UpdateOperationRunning('report_status');
      expect(s.operation, 'report_status');
    });

    test('success', () {
      const s = UpdateOperationSuccess('Done', data: {'status': 'installed'});
      expect(s.message, 'Done');
      expect(s.data, isNotNull);
    });

    test('error', () {
      const s = UpdateOperationError('Failed');
      expect(s.message, 'Failed');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('AutoUpdate endpoints', () {
    test('check', () {
      expect(ApiEndpoints.autoUpdateCheck, '/auto-update/check');
    });

    test('report-status', () {
      expect(ApiEndpoints.autoUpdateReportStatus, '/auto-update/report-status');
    });

    test('changelog', () {
      expect(ApiEndpoints.autoUpdateChangelog, '/auto-update/changelog');
    });

    test('history', () {
      expect(ApiEndpoints.autoUpdateHistory, '/auto-update/history');
    });

    test('current-version', () {
      expect(ApiEndpoints.autoUpdateCurrentVersion, '/auto-update/current-version');
    });
  });

  // ═══════════════ Route ═══════════════
  group('AutoUpdate route', () {
    test('route constant', () {
      expect(Routes.autoUpdateDashboard, '/auto-update');
    });
  });

  // ═══════════════ Cross-cutting ═══════════════
  group('AutoUpdate cross-cutting', () {
    test('all states are sealed', () {
      expect(const UpdateCheckInitial(), isA<UpdateCheckState>());
      expect(const ChangelogInitial(), isA<ChangelogState>());
      expect(const HistoryInitial(), isA<UpdateHistoryState>());
      expect(const UpdateOperationIdle(), isA<UpdateOperationState>());
    });

    test('error states carry messages', () {
      expect(const UpdateCheckError('e').message, 'e');
      expect(const ChangelogError('e').message, 'e');
      expect(const HistoryError('e').message, 'e');
      expect(const UpdateOperationError('e').message, 'e');
    });

    test('loaded states immutable via const', () {
      const s = UpdateCheckLoaded(updateAvailable: true, raw: {'update_available': true});
      expect(s.updateAvailable, isTrue);
    });

    test('operation running has operation name', () {
      const s = UpdateOperationRunning('download');
      expect(s.operation, 'download');
    });

    test('release notes nullable', () {
      const s = UpdateCheckLoaded(updateAvailable: true, raw: {});
      expect(s.releaseNotes, isNull);
      expect(s.releaseNotesAr, isNull);
      expect(s.storeUrl, isNull);
    });
  });
}
