import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/backup/models/backup_history.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';

void main() {
  // ── Model Tests ──────────────────────────────────────────────

  group('BackupHistory model', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'bh-1',
        'store_id': 'store-1',
        'terminal_id': 'term-1',
        'backup_type': 'manual',
        'storage_location': 'cloud',
        'local_path': '/path/to/backup.sql.gz',
        'cloud_key': 'stores/s1/backups/bh-1',
        'file_size_bytes': 12345,
        'checksum': 'abc123def',
        'db_version': '1.0.0',
        'records_count': 500,
        'is_verified': true,
        'is_encrypted': false,
        'status': 'completed',
        'error_message': null,
      };

      final model = BackupHistory.fromJson(json);

      expect(model.id, 'bh-1');
      expect(model.storeId, 'store-1');
      expect(model.terminalId, 'term-1');
      expect(model.backupType, 'manual');
      expect(model.fileSizeBytes, 12345);
      expect(model.recordsCount, 500);
      expect(model.isVerified, true);
      expect(model.isEncrypted, false);
      expect(model.status, 'completed');
    });

    test('toJson round-trips', () {
      final model = BackupHistory(
        id: 'bh-2',
        storeId: 'store-2',
        backupType: 'auto',
        status: 'failed',
        fileSizeBytes: 0,
        recordsCount: 0,
      );

      final json = model.toJson();
      final restored = BackupHistory.fromJson(json);

      expect(restored.id, model.id);
      expect(restored.storeId, model.storeId);
      expect(restored.backupType, model.backupType);
      expect(restored.status, model.status);
    });

    test('copyWith changes only specified field', () {
      final model = BackupHistory(id: 'bh-3', storeId: 'store-3', backupType: 'manual', status: 'completed');

      final updated = model.copyWith(status: 'failed');

      expect(updated.id, 'bh-3');
      expect(updated.status, 'failed');
      expect(updated.backupType, 'manual');
    });

    test('equality by id', () {
      final a = BackupHistory(id: 'bh-x', storeId: 's', backupType: 'auto', status: 'completed');
      final b = BackupHistory(id: 'bh-x', storeId: 's2', backupType: 'manual', status: 'failed');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality', () {
      final a = BackupHistory(id: 'bh-a', storeId: 's', backupType: 'auto', status: 'completed');
      final b = BackupHistory(id: 'bh-b', storeId: 's', backupType: 'auto', status: 'completed');

      expect(a, isNot(equals(b)));
    });

    test('defaults for optional fields', () {
      final model = BackupHistory(id: 'bh-d', storeId: 'store-d', backupType: 'manual', status: 'completed');

      expect(model.fileSizeBytes, 0);
      expect(model.recordsCount, 0);
      expect(model.isVerified, false);
      expect(model.isEncrypted, false);
      expect(model.terminalId, isNull);
      expect(model.checksum, isNull);
    });

    test('fromJson handles missing optional fields', () {
      final json = {'id': 'bh-e', 'store_id': 'store-e', 'backup_type': 'pre_update', 'status': 'corrupted'};

      final model = BackupHistory.fromJson(json);

      expect(model.fileSizeBytes, 0);
      expect(model.recordsCount, 0);
      expect(model.isVerified, false);
      expect(model.isEncrypted, false);
    });
  });

  // ── State Tests ──────────────────────────────────────────────

  group('BackupListState', () {
    test('initial state', () {
      const state = BackupListInitial();
      expect(state, isA<BackupListState>());
    });

    test('loading state', () {
      const state = BackupListLoading();
      expect(state, isA<BackupListState>());
    });

    test('loaded state holds data', () {
      const state = BackupListLoaded({'backups': []});
      expect(state, isA<BackupListState>());
      expect(state.data, containsPair('backups', <dynamic>[]));
    });

    test('error state holds message', () {
      const state = BackupListError('timeout');
      expect(state, isA<BackupListState>());
      expect(state.message, 'timeout');
    });
  });

  group('BackupScheduleState', () {
    test('initial state', () {
      const state = BackupScheduleInitial();
      expect(state, isA<BackupScheduleState>());
    });

    test('loading state', () {
      const state = BackupScheduleLoading();
      expect(state, isA<BackupScheduleState>());
    });

    test('loaded state', () {
      const state = BackupScheduleLoaded({'frequency': 'daily'});
      expect(state.data['frequency'], 'daily');
    });

    test('error state', () {
      const state = BackupScheduleError('fail');
      expect(state.message, 'fail');
    });
  });

  group('BackupStorageState', () {
    test('initial state', () {
      const state = BackupStorageInitial();
      expect(state, isA<BackupStorageState>());
    });

    test('loading state', () {
      const state = BackupStorageLoading();
      expect(state, isA<BackupStorageState>());
    });

    test('loaded state', () {
      const state = BackupStorageLoaded({'quota_bytes': 5368709120});
      expect(state.data['quota_bytes'], 5368709120);
    });

    test('error state', () {
      const state = BackupStorageError('disk full');
      expect(state.message, 'disk full');
    });
  });

  group('BackupOperationState', () {
    test('idle state', () {
      const state = BackupOperationIdle();
      expect(state, isA<BackupOperationState>());
    });

    test('running state', () {
      const state = BackupOperationRunning();
      expect(state, isA<BackupOperationState>());
    });

    test('success state', () {
      const state = BackupOperationSuccess({'backup_id': 'bk-1'});
      expect(state.data['backup_id'], 'bk-1');
    });

    test('error state', () {
      const state = BackupOperationError('restore failed');
      expect(state.message, 'restore failed');
    });
  });

  // ── Endpoint Tests ───────────────────────────────────────────

  group('API Endpoints', () {
    test('backupCreate', () {
      expect(ApiEndpoints.backupCreate, '/backup/create');
    });

    test('backupList', () {
      expect(ApiEndpoints.backupList, '/backup/list');
    });

    test('backupSchedule', () {
      expect(ApiEndpoints.backupSchedule, '/backup/schedule');
    });

    test('backupStorage', () {
      expect(ApiEndpoints.backupStorage, '/backup/storage');
    });

    test('backupExport', () {
      expect(ApiEndpoints.backupExport, '/backup/export');
    });

    test('backupProviderStatus', () {
      expect(ApiEndpoints.backupProviderStatus, '/backup/provider-status');
    });

    test('backupById', () {
      expect(ApiEndpoints.backupById('abc'), '/backup/abc');
    });

    test('backupRestore', () {
      expect(ApiEndpoints.backupRestore('abc'), '/backup/abc/restore');
    });

    test('backupVerify', () {
      expect(ApiEndpoints.backupVerify('abc'), '/backup/abc/verify');
    });

    test('backupDelete', () {
      expect(ApiEndpoints.backupDelete('abc'), '/backup/abc');
    });
  });

  // ── Route Tests ──────────────────────────────────────────────

  group('Route names', () {
    test('backupDashboard route', () {
      expect(Routes.backupDashboard, '/backup');
    });
  });

  // ── Cross-cutting Tests ──────────────────────────────────────

  group('Cross-cutting', () {
    test('BackupHistory encrypted flag', () {
      final model = BackupHistory(
        id: 'enc-1',
        storeId: 'store-enc',
        backupType: 'manual',
        status: 'completed',
        isEncrypted: true,
      );

      expect(model.isEncrypted, true);
      final json = model.toJson();
      expect(json['is_encrypted'], true);
    });

    test('BackupHistory pre_update type', () {
      final model = BackupHistory.fromJson({
        'id': 'pru-1',
        'store_id': 'store-pru',
        'backup_type': 'pre_update',
        'status': 'completed',
      });

      expect(model.backupType, 'pre_update');
    });

    test('state pattern matching works for all types', () {
      final states = <BackupListState>[
        const BackupListInitial(),
        const BackupListLoading(),
        const BackupListLoaded({'x': 1}),
        const BackupListError('err'),
      ];

      for (final s in states) {
        final label = switch (s) {
          BackupListInitial() => 'initial',
          BackupListLoading() => 'loading',
          BackupListLoaded() => 'loaded',
          BackupListError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    test('BackupOperationState pattern matching exhaustive', () {
      final states = <BackupOperationState>[
        const BackupOperationIdle(),
        const BackupOperationRunning(),
        const BackupOperationSuccess({'ok': true}),
        const BackupOperationError('fail'),
      ];

      for (final s in states) {
        final label = switch (s) {
          BackupOperationIdle() => 'idle',
          BackupOperationRunning() => 'running',
          BackupOperationSuccess() => 'success',
          BackupOperationError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });
}
