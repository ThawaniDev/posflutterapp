import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/accounting/repositories/accounting_repository.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_state.dart';

// ════════════════════════════════════════════════════════
// Connection Status Provider
// ════════════════════════════════════════════════════════

final accountingConnectionProvider = StateNotifierProvider<AccountingConnectionNotifier, AccountingConnectionState>((ref) {
  return AccountingConnectionNotifier(ref.watch(accountingRepositoryProvider));
});

class AccountingConnectionNotifier extends StateNotifier<AccountingConnectionState> {
  final AccountingRepository _repository;

  AccountingConnectionNotifier(this._repository) : super(const AccountingConnectionInitial());

  Future<void> loadStatus() async {
    state = const AccountingConnectionLoading();
    try {
      final response = await _repository.getStatus();
      final data = response['data'] as Map<String, dynamic>;
      state = AccountingConnectionLoaded(
        connected: data['connected'] as bool,
        provider: data['provider'] as String?,
        companyName: data['company_name'] as String?,
        connectedAt: data['connected_at'] as String?,
        lastSyncAt: data['last_sync_at'] as String?,
        tokenExpiresAt: data['token_expires_at'] as String?,
        health: data['health'] as String,
      );
    } catch (e) {
      state = AccountingConnectionError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Connection Action Provider (connect/disconnect/refresh)
// ════════════════════════════════════════════════════════

final accountingActionProvider = StateNotifierProvider<AccountingActionNotifier, AccountingActionState>((ref) {
  return AccountingActionNotifier(ref.watch(accountingRepositoryProvider));
});

class AccountingActionNotifier extends StateNotifier<AccountingActionState> {
  final AccountingRepository _repository;

  AccountingActionNotifier(this._repository) : super(const AccountingActionInitial());

  Future<void> connect({
    required String provider,
    required String accessToken,
    required String refreshToken,
    required String tokenExpiresAt,
    String? realmId,
    String? tenantId,
    String? companyName,
  }) async {
    state = const AccountingActionLoading();
    try {
      final response = await _repository.connect(
        provider: provider,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenExpiresAt: tokenExpiresAt,
        realmId: realmId,
        tenantId: tenantId,
        companyName: companyName,
      );
      state = AccountingActionSuccess(
        response['message'] as String? ?? 'Connected',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AccountingActionError(e.toString());
    }
  }

  Future<void> disconnect() async {
    state = const AccountingActionLoading();
    try {
      final response = await _repository.disconnect();
      state = AccountingActionSuccess(response['message'] as String? ?? 'Disconnected');
    } catch (e) {
      state = AccountingActionError(e.toString());
    }
  }

  Future<void> refreshToken({required String accessToken, String? refreshTokenValue, required String tokenExpiresAt}) async {
    state = const AccountingActionLoading();
    try {
      final response = await _repository.refreshToken(
        accessToken: accessToken,
        refreshTokenValue: refreshTokenValue,
        tokenExpiresAt: tokenExpiresAt,
      );
      state = AccountingActionSuccess(
        response['message'] as String? ?? 'Token refreshed',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AccountingActionError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Account Mapping Provider
// ════════════════════════════════════════════════════════

final accountMappingProvider = StateNotifierProvider<AccountMappingNotifier, AccountMappingState>((ref) {
  return AccountMappingNotifier(ref.watch(accountingRepositoryProvider));
});

class AccountMappingNotifier extends StateNotifier<AccountMappingState> {
  final AccountingRepository _repository;

  AccountMappingNotifier(this._repository) : super(const AccountMappingInitial());

  Future<void> loadMappings() async {
    state = const AccountMappingLoading();
    try {
      final response = await _repository.getMappings();
      final data = response['data'] as Map<String, dynamic>;
      state = AccountMappingLoaded(
        mappings: List<Map<String, dynamic>>.from(data['mappings'] as List),
        posAccountKeys: data['pos_account_keys'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = AccountMappingError(e.toString());
    }
  }

  Future<void> saveMappings(List<Map<String, dynamic>> mappings) async {
    state = const AccountMappingLoading();
    try {
      final response = await _repository.saveMappings(mappings);
      final data = response['data'] as Map<String, dynamic>;
      state = AccountMappingLoaded(
        mappings: List<Map<String, dynamic>>.from(data['mappings'] as List),
        posAccountKeys: (state is AccountMappingLoaded) ? (state as AccountMappingLoaded).posAccountKeys : {},
      );
    } catch (e) {
      state = AccountMappingError(e.toString());
    }
  }

  Future<void> deleteMapping(String id) async {
    try {
      await _repository.deleteMapping(id);
      await loadMappings();
    } catch (e) {
      state = AccountMappingError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Exports Provider
// ════════════════════════════════════════════════════════

final accountingExportsProvider = StateNotifierProvider<AccountingExportsNotifier, AccountingExportsState>((ref) {
  return AccountingExportsNotifier(ref.watch(accountingRepositoryProvider));
});

class AccountingExportsNotifier extends StateNotifier<AccountingExportsState> {
  final AccountingRepository _repository;

  AccountingExportsNotifier(this._repository) : super(const AccountingExportsInitial());

  Future<void> loadExports({String? status, int? limit}) async {
    state = const AccountingExportsLoading();
    try {
      final response = await _repository.listExports(status: status, limit: limit);
      final data = response['data'] as List;
      state = AccountingExportsLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = AccountingExportsError(e.toString());
    }
  }

  Future<void> triggerExport({required String startDate, required String endDate, List<String>? exportTypes}) async {
    state = const AccountingExportsLoading();
    try {
      await _repository.triggerExport(startDate: startDate, endDate: endDate, exportTypes: exportTypes);
      await loadExports();
    } catch (e) {
      state = AccountingExportsError(e.toString());
    }
  }

  Future<void> retryExport(String id) async {
    try {
      await _repository.retryExport(id);
      await loadExports();
    } catch (e) {
      state = AccountingExportsError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Auto Export Config Provider
// ════════════════════════════════════════════════════════

final autoExportConfigProvider = StateNotifierProvider<AutoExportConfigNotifier, AutoExportConfigState>((ref) {
  return AutoExportConfigNotifier(ref.watch(accountingRepositoryProvider));
});

class AutoExportConfigNotifier extends StateNotifier<AutoExportConfigState> {
  final AccountingRepository _repository;

  AutoExportConfigNotifier(this._repository) : super(const AutoExportConfigInitial());

  Future<void> loadConfig() async {
    state = const AutoExportConfigLoading();
    try {
      final response = await _repository.getAutoExportConfig();
      final data = response['data'] as Map<String, dynamic>;
      state = AutoExportConfigLoaded(
        enabled: data['enabled'] as bool,
        frequency: data['frequency'] as String,
        dayOfWeek: data['day_of_week'] as int?,
        dayOfMonth: data['day_of_month'] as int?,
        time: data['time'] as String,
        exportTypes: data['export_types'] as List<dynamic>,
        notifyEmail: data['notify_email'] as String?,
        retryOnFailure: data['retry_on_failure'] as bool,
        lastRunAt: data['last_run_at'] as String?,
        nextRunAt: data['next_run_at'] as String?,
      );
    } catch (e) {
      state = AutoExportConfigError(e.toString());
    }
  }

  Future<void> updateConfig(Map<String, dynamic> data) async {
    state = const AutoExportConfigLoading();
    try {
      final response = await _repository.updateAutoExportConfig(data);
      final result = response['data'] as Map<String, dynamic>;
      state = AutoExportConfigLoaded(
        enabled: result['enabled'] as bool,
        frequency: result['frequency'] as String,
        dayOfWeek: result['day_of_week'] as int?,
        dayOfMonth: result['day_of_month'] as int?,
        time: result['time'] as String,
        exportTypes: result['export_types'] as List<dynamic>,
        notifyEmail: result['notify_email'] as String?,
        retryOnFailure: result['retry_on_failure'] as bool,
        lastRunAt: result['last_run_at'] as String?,
        nextRunAt: result['next_run_at'] as String?,
      );
    } catch (e) {
      state = AutoExportConfigError(e.toString());
    }
  }
}
