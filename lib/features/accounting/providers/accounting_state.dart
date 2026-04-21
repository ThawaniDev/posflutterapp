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

  const AccountingConnectionLoaded({
    required this.connected,
    this.provider,
    this.companyName,
    this.connectedAt,
    this.lastSyncAt,
    this.tokenExpiresAt,
    required this.health,
  });
  final bool connected;
  final String? provider;
  final String? companyName;
  final String? connectedAt;
  final String? lastSyncAt;
  final String? tokenExpiresAt;
  final String health;
}

class AccountingConnectionError extends AccountingConnectionState {
  const AccountingConnectionError(this.message);
  final String message;
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
  const AccountingActionSuccess(this.message, {this.data});
  final String message;
  final Map<String, dynamic>? data;
}

class AccountingActionError extends AccountingActionState {
  const AccountingActionError(this.message);
  final String message;
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

  const AccountMappingLoaded({required this.mappings, required this.posAccountKeys});
  final List<Map<String, dynamic>> mappings;
  final Map<String, dynamic> posAccountKeys;
}

class AccountMappingError extends AccountMappingState {
  const AccountMappingError(this.message);
  final String message;
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

  const AccountingExportsLoaded(this.exports);
  final List<Map<String, dynamic>> exports;
}

class AccountingExportsError extends AccountingExportsState {
  const AccountingExportsError(this.message);
  final String message;
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
}

class AutoExportConfigError extends AutoExportConfigState {
  const AutoExportConfigError(this.message);
  final String message;
}
