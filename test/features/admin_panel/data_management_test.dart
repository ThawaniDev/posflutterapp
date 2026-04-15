import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/admin_panel/data/remote/admin_api_service.dart';
import 'package:wameedpos/features/admin_panel/repositories/admin_repository.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_data_management_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_database_backup_list_page.dart';

void main() {
  // ─── Endpoint Tests ───────────────────────────────────────────────
  group('P13 Data Management Endpoints', () {
    test('overview endpoint', () {
      expect(ApiEndpoints.adminDataManagementOverview, '/admin/data-management/overview');
    });
    test('database backups endpoint', () {
      expect(ApiEndpoints.adminDatabaseBackups, '/admin/data-management/database-backups');
    });
    test('database backup by id endpoint', () {
      expect(ApiEndpoints.adminDatabaseBackupById('5'), '/admin/data-management/database-backups/5');
    });
    test('database backup complete endpoint', () {
      expect(ApiEndpoints.adminDatabaseBackupComplete('5'), '/admin/data-management/database-backups/5/complete');
    });
    test('backup history endpoint', () {
      expect(ApiEndpoints.adminBackupHistory, '/admin/data-management/backup-history');
    });
    test('backup history by id endpoint', () {
      expect(ApiEndpoints.adminBackupHistoryById('3'), '/admin/data-management/backup-history/3');
    });
    test('sync logs endpoint', () {
      expect(ApiEndpoints.adminSyncLogs, '/admin/data-management/sync-logs');
    });
    test('sync log by id endpoint', () {
      expect(ApiEndpoints.adminSyncLogById('7'), '/admin/data-management/sync-logs/7');
    });
    test('sync log summary endpoint', () {
      expect(ApiEndpoints.adminSyncLogSummary, '/admin/data-management/sync-logs/summary');
    });
    test('sync conflicts endpoint', () {
      expect(ApiEndpoints.adminSyncConflicts, '/admin/data-management/sync-conflicts');
    });
    test('sync conflict by id endpoint', () {
      expect(ApiEndpoints.adminSyncConflictById('9'), '/admin/data-management/sync-conflicts/9');
    });
    test('sync conflict resolve endpoint', () {
      expect(ApiEndpoints.adminSyncConflictResolve('9'), '/admin/data-management/sync-conflicts/9/resolve');
    });
    test('provider backup statuses endpoint', () {
      expect(ApiEndpoints.adminProviderBackupStatuses, '/admin/data-management/provider-backup-statuses');
    });
    test('provider backup status by id endpoint', () {
      expect(ApiEndpoints.adminProviderBackupStatusById('2'), '/admin/data-management/provider-backup-statuses/2');
    });
  });

  // ─── Service method existence ─────────────────────────────────────
  group('P13 AdminApiService methods', () {
    test('has getDataManagementOverview method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getDatabaseBackups method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has createDatabaseBackup method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has completeDatabaseBackup method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getBackupHistory method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSyncLogs method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSyncLogSummary method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSyncConflicts method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has resolveSyncConflict method', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getProviderBackupStatuses method', () {
      expect(AdminApiService, isNotNull);
    });
  });

  // ─── Repository method existence ──────────────────────────────────
  group('P13 AdminRepository methods', () {
    test('has getDataManagementOverview', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getDatabaseBackups', () {
      expect(AdminRepository, isNotNull);
    });
    test('has createDatabaseBackup', () {
      expect(AdminRepository, isNotNull);
    });
    test('has completeDatabaseBackup', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getBackupHistory', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSyncLogs', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSyncLogSummary', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSyncConflicts', () {
      expect(AdminRepository, isNotNull);
    });
    test('has resolveSyncConflict', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getProviderBackupStatuses', () {
      expect(AdminRepository, isNotNull);
    });
  });

  // ─── State classes ────────────────────────────────────────────────
  group('P13 State classes', () {
    test('DataManagementOverviewState hierarchy', () {
      expect(const DataManagementOverviewInitial(), isA<DataManagementOverviewState>());
      expect(const DataManagementOverviewLoading(), isA<DataManagementOverviewState>());
      expect(const DataManagementOverviewLoaded({}), isA<DataManagementOverviewState>());
      expect(const DataManagementOverviewError('err'), isA<DataManagementOverviewState>());
    });
    test('DatabaseBackupListState hierarchy', () {
      expect(const DatabaseBackupListInitial(), isA<DatabaseBackupListState>());
      expect(const DatabaseBackupListLoading(), isA<DatabaseBackupListState>());
      expect(const DatabaseBackupListLoaded({}), isA<DatabaseBackupListState>());
      expect(const DatabaseBackupListError('err'), isA<DatabaseBackupListState>());
    });
    test('DatabaseBackupActionState hierarchy', () {
      expect(const DatabaseBackupActionInitial(), isA<DatabaseBackupActionState>());
      expect(const DatabaseBackupActionLoading(), isA<DatabaseBackupActionState>());
      expect(const DatabaseBackupActionSuccess({}), isA<DatabaseBackupActionState>());
      expect(const DatabaseBackupActionError('err'), isA<DatabaseBackupActionState>());
    });
    test('BackupHistoryListState hierarchy', () {
      expect(const BackupHistoryListInitial(), isA<BackupHistoryListState>());
      expect(const BackupHistoryListLoading(), isA<BackupHistoryListState>());
      expect(const BackupHistoryListLoaded({}), isA<BackupHistoryListState>());
      expect(const BackupHistoryListError('err'), isA<BackupHistoryListState>());
    });
    test('SyncLogListState hierarchy', () {
      expect(const SyncLogListInitial(), isA<SyncLogListState>());
      expect(const SyncLogListLoading(), isA<SyncLogListState>());
      expect(const SyncLogListLoaded({}), isA<SyncLogListState>());
      expect(const SyncLogListError('err'), isA<SyncLogListState>());
    });
    test('SyncLogSummaryState hierarchy', () {
      expect(const SyncLogSummaryInitial(), isA<SyncLogSummaryState>());
      expect(const SyncLogSummaryLoading(), isA<SyncLogSummaryState>());
      expect(const SyncLogSummaryLoaded({}), isA<SyncLogSummaryState>());
      expect(const SyncLogSummaryError('err'), isA<SyncLogSummaryState>());
    });
    test('SyncConflictListState hierarchy', () {
      expect(const SyncConflictListInitial(), isA<SyncConflictListState>());
      expect(const SyncConflictListLoading(), isA<SyncConflictListState>());
      expect(const SyncConflictListLoaded({}), isA<SyncConflictListState>());
      expect(const SyncConflictListError('err'), isA<SyncConflictListState>());
    });
    test('SyncConflictActionState hierarchy', () {
      expect(const SyncConflictActionInitial(), isA<SyncConflictActionState>());
      expect(const SyncConflictActionLoading(), isA<SyncConflictActionState>());
      expect(const SyncConflictActionSuccess({}), isA<SyncConflictActionState>());
      expect(const SyncConflictActionError('err'), isA<SyncConflictActionState>());
    });
  });

  // ─── Provider existence ───────────────────────────────────────────
  group('P13 Providers', () {
    test('dataManagementOverviewProvider exists', () {
      expect(dataManagementOverviewProvider, isNotNull);
    });
    test('databaseBackupListProvider exists', () {
      expect(databaseBackupListProvider, isNotNull);
    });
    test('databaseBackupActionProvider exists', () {
      expect(databaseBackupActionProvider, isNotNull);
    });
    test('backupHistoryListProvider exists', () {
      expect(backupHistoryListProvider, isNotNull);
    });
    test('syncLogListProvider exists', () {
      expect(syncLogListProvider, isNotNull);
    });
    test('syncLogSummaryProvider exists', () {
      expect(syncLogSummaryProvider, isNotNull);
    });
    test('syncConflictListProvider exists', () {
      expect(syncConflictListProvider, isNotNull);
    });
    test('syncConflictActionProvider exists', () {
      expect(syncConflictActionProvider, isNotNull);
    });
  });

  // ─── Page existence ───────────────────────────────────────────────
  group('P13 Pages', () {
    test('AdminDataManagementOverviewPage exists', () {
      expect(AdminDataManagementOverviewPage, isNotNull);
    });
    test('AdminDatabaseBackupListPage exists', () {
      expect(AdminDatabaseBackupListPage, isNotNull);
    });
  });
}
