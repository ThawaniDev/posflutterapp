// ════════════════════════════════════════════════════════
// Accounting Connection State
// ════════════════════════════════════════════════════════

sealed class AccountingConnectionState {
  const AccountingConnectionState();
}

class AccountingConnectionInitial extends AccountingConnectionState {
  const AccountingConnectionInitial();
}

class AccountingConnectionLoading extends AccountingConnectionState {
  const AccountingConnectionLoading();
}

class AccountingConnectionLoaded extends AccountingConnectionState {
  final bool connected;
  final String? provider;
  final String? companyName;
  final String? connectedAt;
  final String? lastSyncAt;
  final String? tokenExpiresAt;
  final String health;

  const AccountingConnectionLoaded({
    required this.connected,
    this.provider,
    this.companyName,
    this.connectedAt,
    this.lastSyncAt,
    this.tokenExpiresAt,
    required this.health,
  });
}

class AccountingConnectionError extends AccountingConnectionState {
  final String message;
  const AccountingConnectionError(this.message);
}

// ════════════════════════════════════════════════════════
// Accounting Action State (connect, disconnect, refresh)
// ════════════════════════════════════════════════════════

sealed class AccountingActionState {
  const AccountingActionState();
}

class AccountingActionInitial extends AccountingActionState {
  const AccountingActionInitial();
}

class AccountingActionLoading extends AccountingActionState {
  const AccountingActionLoading();
}

class AccountingActionSuccess extends AccountingActionState {
  final String message;
  final Map<String, dynamic>? data;
  const AccountingActionSuccess(this.message, {this.data});
}

class AccountingActionError extends AccountingActionState {
  final String message;
  const AccountingActionError(this.message);
}

// ════════════════════════════════════════════════════════
// Account Mapping State
// ════════════════════════════════════════════════════════

sealed class AccountMappingState {
  const AccountMappingState();
}

class AccountMappingInitial extends AccountMappingState {
  const AccountMappingInitial();
}

class AccountMappingLoading extends AccountMappingState {
  const AccountMappingLoading();
}

class AccountMappingLoaded extends AccountMappingState {
  final List<Map<String, dynamic>> mappings;
  final Map<String, dynamic> posAccountKeys;

  const AccountMappingLoaded({required this.mappings, required this.posAccountKeys});
}

class AccountMappingError extends AccountMappingState {
  final String message;
  const AccountMappingError(this.message);
}

// ════════════════════════════════════════════════════════
// Accounting Exports State
// ════════════════════════════════════════════════════════

sealed class AccountingExportsState {
  const AccountingExportsState();
}

class AccountingExportsInitial extends AccountingExportsState {
  const AccountingExportsInitial();
}

class AccountingExportsLoading extends AccountingExportsState {
  const AccountingExportsLoading();
}

class AccountingExportsLoaded extends AccountingExportsState {
  final List<Map<String, dynamic>> exports;

  const AccountingExportsLoaded(this.exports);
}

class AccountingExportsError extends AccountingExportsState {
  final String message;
  const AccountingExportsError(this.message);
}

// ════════════════════════════════════════════════════════
// Auto Export Config State
// ════════════════════════════════════════════════════════

sealed class AutoExportConfigState {
  const AutoExportConfigState();
}

class AutoExportConfigInitial extends AutoExportConfigState {
  const AutoExportConfigInitial();
}

class AutoExportConfigLoading extends AutoExportConfigState {
  const AutoExportConfigLoading();
}

class AutoExportConfigLoaded extends AutoExportConfigState {
  final bool enabled;
  final String frequency;
  final int? dayOfWeek;
  final int? dayOfMonth;
  final String time;
  final List<dynamic> exportTypes;
  final String? notifyEmail;
  final bool retryOnFailure;
  final String? lastRunAt;
  final String? nextRunAt;

  const AutoExportConfigLoaded({
    required this.enabled,
    required this.frequency,
    this.dayOfWeek,
    this.dayOfMonth,
    required this.time,
    required this.exportTypes,
    this.notifyEmail,
    required this.retryOnFailure,
    this.lastRunAt,
    this.nextRunAt,
  });
}

class AutoExportConfigError extends AutoExportConfigState {
  final String message;
  const AutoExportConfigError(this.message);
}
