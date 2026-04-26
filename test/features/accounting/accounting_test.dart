import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/accounting/enums/accounting_provider.dart';
import 'package:wameedpos/features/accounting/enums/accounting_export_status.dart';
import 'package:wameedpos/features/accounting/enums/export_frequency.dart';
import 'package:wameedpos/features/accounting/enums/export_triggered_by.dart';
import 'package:wameedpos/features/accounting/models/store_accounting_config.dart';
import 'package:wameedpos/features/accounting/models/account_mapping.dart';
import 'package:wameedpos/features/accounting/models/accounting_export.dart';
import 'package:wameedpos/features/accounting/models/auto_export_config.dart';
import 'package:wameedpos/features/accounting/providers/accounting_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('AccountingProvider', () {
    test('has correct values', () {
      expect(AccountingProvider.quickbooks.value, 'quickbooks');
      expect(AccountingProvider.xero.value, 'xero');
      expect(AccountingProvider.qoyod.value, 'qoyod');
    });

    test('has 3 values', () {
      expect(AccountingProvider.values.length, 3);
    });

    test('fromValue returns correct enum', () {
      expect(AccountingProvider.fromValue('quickbooks'), AccountingProvider.quickbooks);
      expect(AccountingProvider.fromValue('xero'), AccountingProvider.xero);
      expect(AccountingProvider.fromValue('qoyod'), AccountingProvider.qoyod);
    });

    test('fromValue throws for invalid value', () {
      expect(() => AccountingProvider.fromValue('sage'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(AccountingProvider.tryFromValue('sage'), isNull);
      expect(AccountingProvider.tryFromValue(null), isNull);
    });

    test('tryFromValue returns enum for valid', () {
      expect(AccountingProvider.tryFromValue('xero'), AccountingProvider.xero);
    });
  });

  group('AccountingExportStatus', () {
    test('has correct values', () {
      expect(AccountingExportStatus.pending.value, 'pending');
      expect(AccountingExportStatus.processing.value, 'processing');
      expect(AccountingExportStatus.success.value, 'success');
      expect(AccountingExportStatus.failed.value, 'failed');
    });

    test('has 4 values', () {
      expect(AccountingExportStatus.values.length, 5);
    });

    test('fromValue works for all values', () {
      for (final s in AccountingExportStatus.values) {
        expect(AccountingExportStatus.fromValue(s.value), s);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => AccountingExportStatus.fromValue('cancelled'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(AccountingExportStatus.tryFromValue('cancelled'), isNull);
      expect(AccountingExportStatus.tryFromValue(null), isNull);
    });
  });

  group('ExportFrequency', () {
    test('has correct values', () {
      expect(ExportFrequency.daily.value, 'daily');
      expect(ExportFrequency.weekly.value, 'weekly');
      expect(ExportFrequency.monthly.value, 'monthly');
    });

    test('has 3 values', () {
      expect(ExportFrequency.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final f in ExportFrequency.values) {
        expect(ExportFrequency.fromValue(f.value), f);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => ExportFrequency.fromValue('yearly'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(ExportFrequency.tryFromValue('yearly'), isNull);
    });

    test('tryFromValue returns enum for valid', () {
      expect(ExportFrequency.tryFromValue('weekly'), ExportFrequency.weekly);
    });
  });

  group('ExportTriggeredBy', () {
    test('has correct values', () {
      expect(ExportTriggeredBy.manual.value, 'manual');
      expect(ExportTriggeredBy.scheduled.value, 'scheduled');
    });

    test('has 2 values', () {
      expect(ExportTriggeredBy.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final t in ExportTriggeredBy.values) {
        expect(ExportTriggeredBy.fromValue(t.value), t);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => ExportTriggeredBy.fromValue('automatic'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(ExportTriggeredBy.tryFromValue('automatic'), isNull);
      expect(ExportTriggeredBy.tryFromValue(null), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // MODELS
  // ════════════════════════════════════════════════════════

  group('StoreAccountingConfig model', () {
    final json = {
      'id': 'cfg-1',
      'store_id': 'store-1',
      'provider': 'quickbooks',
      'access_token_encrypted': 'enc_token',
      'refresh_token_encrypted': 'enc_refresh',
      'token_expires_at': '2025-06-01T00:00:00.000Z',
      'realm_id': 'realm-123',
      'tenant_id': null,
      'company_name': 'Test Store LLC',
      'connected_at': '2025-01-15T10:00:00.000Z',
      'last_sync_at': '2025-03-01T14:30:00.000Z',
      'created_at': '2025-01-15T10:00:00.000Z',
      'updated_at': '2025-03-01T14:30:00.000Z',
    };

    test('fromJson', () {
      final config = StoreAccountingConfig.fromJson(json);
      expect(config.id, 'cfg-1');
      expect(config.storeId, 'store-1');
      expect(config.provider, AccountingProvider.quickbooks);
      expect(config.accessTokenEncrypted, 'enc_token');
      expect(config.refreshTokenEncrypted, 'enc_refresh');
      expect(config.tokenExpiresAt, isA<DateTime>());
      expect(config.realmId, 'realm-123');
      expect(config.tenantId, isNull);
      expect(config.companyName, 'Test Store LLC');
      expect(config.connectedAt, isNotNull);
      expect(config.lastSyncAt, isNotNull);
    });

    test('toJson round-trip', () {
      final config = StoreAccountingConfig.fromJson(json);
      final output = config.toJson();
      expect(output['id'], 'cfg-1');
      expect(output['provider'], 'quickbooks');
      expect(output['realm_id'], 'realm-123');
      expect(output['tenant_id'], isNull);
      expect(output['company_name'], 'Test Store LLC');
    });

    test('nullable fields', () {
      final minimalJson = {
        'id': 'cfg-2',
        'store_id': 'store-2',
        'provider': 'xero',
        'access_token_encrypted': 'enc',
        'refresh_token_encrypted': 'enc',
        'token_expires_at': '2025-12-31T00:00:00.000Z',
        'realm_id': null,
        'tenant_id': 'tenant-1',
        'company_name': null,
        'connected_at': null,
        'last_sync_at': null,
        'created_at': null,
        'updated_at': null,
      };
      final config = StoreAccountingConfig.fromJson(minimalJson);
      expect(config.provider, AccountingProvider.xero);
      expect(config.realmId, isNull);
      expect(config.tenantId, 'tenant-1');
      expect(config.companyName, isNull);
      expect(config.connectedAt, isNull);
      expect(config.lastSyncAt, isNull);
    });

    test('copyWith', () {
      final config = StoreAccountingConfig.fromJson(json);
      final copy = config.copyWith(provider: AccountingProvider.xero, companyName: 'New Name');
      expect(copy.provider, AccountingProvider.xero);
      expect(copy.companyName, 'New Name');
      expect(copy.id, 'cfg-1'); // unchanged
      expect(copy.storeId, 'store-1'); // unchanged
    });
  });

  group('AccountMapping model', () {
    final json = {
      'id': 'map-1',
      'store_id': 'store-1',
      'pos_account_key': 'cash_sales',
      'provider_account_id': 'acct-100',
      'provider_account_name': 'Sales Revenue',
      'created_at': '2025-01-15T10:00:00.000Z',
      'updated_at': '2025-03-01T14:30:00.000Z',
    };

    test('fromJson', () {
      final mapping = AccountMapping.fromJson(json);
      expect(mapping.id, 'map-1');
      expect(mapping.storeId, 'store-1');
      expect(mapping.posAccountKey, 'cash_sales');
      expect(mapping.providerAccountId, 'acct-100');
      expect(mapping.providerAccountName, 'Sales Revenue');
      expect(mapping.createdAt, isNotNull);
      expect(mapping.updatedAt, isNotNull);
    });

    test('toJson round-trip', () {
      final mapping = AccountMapping.fromJson(json);
      final output = mapping.toJson();
      expect(output['pos_account_key'], 'cash_sales');
      expect(output['provider_account_id'], 'acct-100');
      expect(output['provider_account_name'], 'Sales Revenue');
    });

    test('nullable timestamps', () {
      final partial = {
        'id': 'map-2',
        'store_id': 'store-2',
        'pos_account_key': 'tax_collected',
        'provider_account_id': 'acct-200',
        'provider_account_name': 'Tax Payable',
        'created_at': null,
        'updated_at': null,
      };
      final mapping = AccountMapping.fromJson(partial);
      expect(mapping.createdAt, isNull);
      expect(mapping.updatedAt, isNull);
    });

    test('equality is by id', () {
      final a = AccountMapping.fromJson(json);
      final b = AccountMapping.fromJson({...json, 'pos_account_key': 'different'});
      expect(a, equals(b));
    });

    test('copyWith', () {
      final mapping = AccountMapping.fromJson(json);
      final copy = mapping.copyWith(providerAccountName: 'Updated Name');
      expect(copy.providerAccountName, 'Updated Name');
      expect(copy.posAccountKey, 'cash_sales'); // unchanged
    });
  });

  group('AccountingExport model', () {
    final json = {
      'id': 'exp-1',
      'store_id': 'store-1',
      'provider': 'quickbooks',
      'start_date': '2025-01-01T00:00:00.000Z',
      'end_date': '2025-01-31T00:00:00.000Z',
      'export_types': {'daily_summary': true, 'payment_breakdown': true},
      'status': 'success',
      'entries_count': 42,
      'error_message': null,
      'journal_entry_ids': {'jnl-1': 'abc', 'jnl-2': 'def'},
      'csv_url': 'https://example.com/export.csv',
      'triggered_by': 'manual',
      'created_at': '2025-02-01T00:00:00.000Z',
      'completed_at': '2025-02-01T00:05:00.000Z',
    };

    test('fromJson', () {
      final export = AccountingExport.fromJson(json);
      expect(export.id, 'exp-1');
      expect(export.storeId, 'store-1');
      expect(export.provider, 'quickbooks');
      expect(export.startDate, isA<DateTime>());
      expect(export.endDate, isA<DateTime>());
      expect(export.status, AccountingExportStatus.success);
      expect(export.entriesCount, 42);
      expect(export.errorMessage, isNull);
      expect(export.journalEntryIds, isNotNull);
      expect(export.csvUrl, 'https://example.com/export.csv');
      expect(export.triggeredBy, ExportTriggeredBy.manual);
      expect(export.createdAt, isNotNull);
      expect(export.completedAt, isNotNull);
    });

    test('toJson round-trip', () {
      final export = AccountingExport.fromJson(json);
      final output = export.toJson();
      expect(output['provider'], 'quickbooks');
      expect(output['status'], 'success');
      expect(output['entries_count'], 42);
      expect(output['triggered_by'], 'manual');
      expect(output['csv_url'], 'https://example.com/export.csv');
    });

    test('nullable fields', () {
      final partial = {
        'id': 'exp-2',
        'store_id': 'store-2',
        'provider': 'xero',
        'start_date': '2025-03-01T00:00:00.000Z',
        'end_date': '2025-03-31T00:00:00.000Z',
        'export_types': {'full_reconciliation': true},
        'status': 'pending',
        'entries_count': null,
        'error_message': null,
        'journal_entry_ids': null,
        'csv_url': null,
        'triggered_by': 'scheduled',
        'created_at': null,
        'completed_at': null,
      };
      final export = AccountingExport.fromJson(partial);
      expect(export.status, AccountingExportStatus.pending);
      expect(export.triggeredBy, ExportTriggeredBy.scheduled);
      expect(export.entriesCount, isNull);
      expect(export.errorMessage, isNull);
      expect(export.journalEntryIds, isNull);
      expect(export.csvUrl, isNull);
      expect(export.createdAt, isNull);
      expect(export.completedAt, isNull);
    });

    test('failed export with error', () {
      final failedJson = {...json, 'status': 'failed', 'error_message': 'API rate limit exceeded', 'completed_at': null};
      final export = AccountingExport.fromJson(failedJson);
      expect(export.status, AccountingExportStatus.failed);
      expect(export.errorMessage, 'API rate limit exceeded');
      expect(export.completedAt, isNull);
    });

    test('equality is by id', () {
      final a = AccountingExport.fromJson(json);
      final b = AccountingExport.fromJson({...json, 'provider': 'xero'});
      expect(a, equals(b));
    });

    test('copyWith', () {
      final export = AccountingExport.fromJson(json);
      final copy = export.copyWith(status: AccountingExportStatus.processing, entriesCount: 100);
      expect(copy.status, AccountingExportStatus.processing);
      expect(copy.entriesCount, 100);
      expect(copy.id, 'exp-1'); // unchanged
    });
  });

  group('AutoExportConfig model', () {
    final json = {
      'id': 'aec-1',
      'store_id': 'store-1',
      'enabled': true,
      'frequency': 'weekly',
      'day_of_week': 1,
      'day_of_month': null,
      'export_types': {'daily_summary': true},
      'notify_email': 'admin@example.com',
      'retry_on_failure': true,
      'last_run_at': '2025-03-01T23:00:00.000Z',
      'next_run_at': '2025-03-08T23:00:00.000Z',
      'created_at': '2025-01-01T00:00:00.000Z',
      'updated_at': '2025-03-01T23:00:00.000Z',
    };

    test('fromJson', () {
      final config = AutoExportConfig.fromJson(json);
      expect(config.id, 'aec-1');
      expect(config.storeId, 'store-1');
      expect(config.enabled, true);
      expect(config.frequency, ExportFrequency.weekly);
      expect(config.dayOfWeek, 1);
      expect(config.dayOfMonth, isNull);
      expect(config.notifyEmail, 'admin@example.com');
      expect(config.retryOnFailure, true);
      expect(config.lastRunAt, isNotNull);
      expect(config.nextRunAt, isNotNull);
    });

    test('toJson round-trip', () {
      final config = AutoExportConfig.fromJson(json);
      final output = config.toJson();
      expect(output['enabled'], true);
      expect(output['frequency'], 'weekly');
      expect(output['day_of_week'], 1);
      expect(output['day_of_month'], isNull);
      expect(output['notify_email'], 'admin@example.com');
      expect(output['retry_on_failure'], true);
    });

    test('monthly frequency', () {
      final monthlyJson = {...json, 'frequency': 'monthly', 'day_of_week': null, 'day_of_month': 15};
      final config = AutoExportConfig.fromJson(monthlyJson);
      expect(config.frequency, ExportFrequency.monthly);
      expect(config.dayOfWeek, isNull);
      expect(config.dayOfMonth, 15);
    });

    test('daily frequency', () {
      final dailyJson = {...json, 'frequency': 'daily', 'day_of_week': null, 'day_of_month': null};
      final config = AutoExportConfig.fromJson(dailyJson);
      expect(config.frequency, ExportFrequency.daily);
    });

    test('nullable fields', () {
      final partial = {
        'id': 'aec-2',
        'store_id': 'store-2',
        'enabled': null,
        'frequency': 'daily',
        'day_of_week': null,
        'day_of_month': null,
        'export_types': {},
        'notify_email': null,
        'retry_on_failure': null,
        'last_run_at': null,
        'next_run_at': null,
        'created_at': null,
        'updated_at': null,
      };
      final config = AutoExportConfig.fromJson(partial);
      expect(config.enabled, isNull);
      expect(config.dayOfWeek, isNull);
      expect(config.dayOfMonth, isNull);
      expect(config.notifyEmail, isNull);
      expect(config.retryOnFailure, isNull);
      expect(config.lastRunAt, isNull);
      expect(config.nextRunAt, isNull);
    });

    test('equality is by id', () {
      final a = AutoExportConfig.fromJson(json);
      final b = AutoExportConfig.fromJson({...json, 'enabled': false});
      expect(a, equals(b));
    });

    test('copyWith', () {
      final config = AutoExportConfig.fromJson(json);
      final copy = config.copyWith(enabled: false, frequency: ExportFrequency.monthly, dayOfMonth: 28);
      expect(copy.enabled, false);
      expect(copy.frequency, ExportFrequency.monthly);
      expect(copy.dayOfMonth, 28);
      expect(copy.id, 'aec-1'); // unchanged
      expect(copy.notifyEmail, 'admin@example.com'); // unchanged
    });
  });

  // ════════════════════════════════════════════════════════
  // STATES
  // ════════════════════════════════════════════════════════

  group('AccountingConnectionState', () {
    test('initial state', () {
      const state = AccountingConnectionInitial();
      expect(state, isA<AccountingConnectionState>());
    });

    test('loading state', () {
      const state = AccountingConnectionLoading();
      expect(state, isA<AccountingConnectionState>());
    });

    test('loaded connected', () {
      const state = AccountingConnectionLoaded(
        connected: true,
        provider: 'quickbooks',
        companyName: 'Test LLC',
        connectedAt: '2025-01-01T00:00:00Z',
        lastSyncAt: '2025-03-01T00:00:00Z',
        tokenExpiresAt: '2025-06-01T00:00:00Z',
        health: 'healthy',
      );
      expect(state.connected, true);
      expect(state.provider, 'quickbooks');
      expect(state.companyName, 'Test LLC');
      expect(state.health, 'healthy');
    });

    test('loaded disconnected', () {
      const state = AccountingConnectionLoaded(connected: false, health: 'none');
      expect(state.connected, false);
      expect(state.provider, isNull);
      expect(state.companyName, isNull);
    });

    test('error state', () {
      const state = AccountingConnectionError('Failed to load status');
      expect(state.message, 'Failed to load status');
    });
  });

  group('AccountingActionState', () {
    test('initial state', () {
      const state = AccountingActionInitial();
      expect(state, isA<AccountingActionState>());
    });

    test('loading state', () {
      const state = AccountingActionLoading();
      expect(state, isA<AccountingActionState>());
    });

    test('success state with message', () {
      const state = AccountingActionSuccess('Provider connected');
      expect(state.message, 'Provider connected');
      expect(state.data, isNull);
    });

    test('success state with data', () {
      const state = AccountingActionSuccess('Connected', data: {'id': 'cfg-1'});
      expect(state.message, 'Connected');
      expect(state.data, isNotNull);
      expect(state.data!['id'], 'cfg-1');
    });

    test('error state', () {
      const state = AccountingActionError('Invalid token');
      expect(state.message, 'Invalid token');
    });
  });

  group('AccountMappingState', () {
    test('initial state', () {
      const state = AccountMappingInitial();
      expect(state, isA<AccountMappingState>());
    });

    test('loading state', () {
      const state = AccountMappingLoading();
      expect(state, isA<AccountMappingState>());
    });

    test('loaded with mappings and keys', () {
      const state = AccountMappingLoaded(
        mappings: [
          {'id': 'm1', 'pos_account_key': 'cash_sales', 'provider_account_id': '100'},
        ],
        posAccountKeys: {
          'cash_sales': {'label': 'Cash Sales', 'direction': 'debit', 'required': true},
        },
      );
      expect(state.mappings.length, 1);
      expect(state.posAccountKeys['cash_sales'], isNotNull);
    });

    test('loaded empty', () {
      const state = AccountMappingLoaded(mappings: [], posAccountKeys: {});
      expect(state.mappings, isEmpty);
      expect(state.posAccountKeys, isEmpty);
    });

    test('error state', () {
      const state = AccountMappingError('Not connected');
      expect(state.message, 'Not connected');
    });
  });

  group('AccountingExportsState', () {
    test('initial state', () {
      const state = AccountingExportsInitial();
      expect(state, isA<AccountingExportsState>());
    });

    test('loading state', () {
      const state = AccountingExportsLoading();
      expect(state, isA<AccountingExportsState>());
    });

    test('loaded with exports', () {
      const state = AccountingExportsLoaded([
        {'id': 'e1', 'status': 'success'},
        {'id': 'e2', 'status': 'pending'},
      ]);
      expect(state.exports.length, 2);
    });

    test('loaded empty', () {
      const state = AccountingExportsLoaded([]);
      expect(state.exports, isEmpty);
    });

    test('error state', () {
      const state = AccountingExportsError('Export failed');
      expect(state.message, 'Export failed');
    });
  });

  group('AutoExportConfigState', () {
    test('initial state', () {
      const state = AutoExportConfigInitial();
      expect(state, isA<AutoExportConfigState>());
    });

    test('loading state', () {
      const state = AutoExportConfigLoading();
      expect(state, isA<AutoExportConfigState>());
    });

    test('loaded with full config', () {
      const state = AutoExportConfigLoaded(
        enabled: true,
        frequency: 'weekly',
        dayOfWeek: 1,
        dayOfMonth: null,
        time: '23:00',
        exportTypes: ['daily_summary', 'payment_breakdown'],
        notifyEmail: 'test@example.com',
        retryOnFailure: true,
        lastRunAt: '2025-03-01T23:00:00Z',
        nextRunAt: '2025-03-08T23:00:00Z',
      );
      expect(state.enabled, true);
      expect(state.frequency, 'weekly');
      expect(state.dayOfWeek, 1);
      expect(state.dayOfMonth, isNull);
      expect(state.time, '23:00');
      expect(state.exportTypes.length, 2);
      expect(state.notifyEmail, 'test@example.com');
      expect(state.retryOnFailure, true);
      expect(state.lastRunAt, isNotNull);
      expect(state.nextRunAt, isNotNull);
    });

    test('loaded with defaults', () {
      const state = AutoExportConfigLoaded(
        enabled: false,
        frequency: 'daily',
        time: '23:00',
        exportTypes: [],
        retryOnFailure: true,
      );
      expect(state.enabled, false);
      expect(state.dayOfWeek, isNull);
      expect(state.dayOfMonth, isNull);
      expect(state.notifyEmail, isNull);
      expect(state.lastRunAt, isNull);
      expect(state.nextRunAt, isNull);
    });

    test('error state', () {
      const state = AutoExportConfigError('Server error');
      expect(state.message, 'Server error');
    });
  });
}
