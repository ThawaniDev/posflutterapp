import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/security/enums/login_attempt_type.dart';
import 'package:wameedpos/features/security/models/login_attempt.dart';
import 'package:wameedpos/features/security/providers/security_providers.dart';
import 'package:wameedpos/features/security/providers/security_state.dart';
import 'package:wameedpos/features/security/widgets/audit_log_list_widget.dart';
import 'package:wameedpos/features/security/widgets/device_list_widget.dart';
import 'package:wameedpos/features/security/widgets/security_overview_widget.dart';
import 'package:wameedpos/features/security/widgets/security_policy_editor.dart';
import 'package:wameedpos/features/security/widgets/session_list_widget.dart';
import 'package:wameedpos/features/security/widgets/incident_list_widget.dart';

class SecurityDashboardPage extends ConsumerStatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  ConsumerState<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends ConsumerState<SecurityDashboardPage> {
  int _currentTab = 0;
  String? _storeId;

  // ─── Login attempts filter state ─────────────────
  LoginAttemptType? _loginFilterType;
  bool? _loginFilterSuccess;

  // ─── Audit log filter state ───────────────────────
  String? _auditFilterAction;
  String? _auditFilterSeverity;

  // ─── Incidents filter state ───────────────────────
  String? _incidentFilterSeverity;
  bool? _incidentFilterResolved;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final storeId = await ref.read(authLocalStorageProvider).getStoreId();
      if (storeId == null || !mounted) return;
      setState(() => _storeId = storeId);
      ref.read(securityOverviewProvider.notifier).load(storeId);
      ref.read(securityPolicyProvider.notifier).loadPolicy(storeId);
      ref.read(auditLogListProvider.notifier).loadLogs(storeId);
      ref.read(deviceListProvider.notifier).loadDevices(storeId);
      ref.read(loginAttemptsProvider.notifier).loadAttempts(storeId);
      ref.read(sessionListProvider.notifier).loadSessions(storeId);
      ref.read(incidentListProvider.notifier).loadIncidents(storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<SecurityActionState>(securityActionProvider, (prev, next) {
      if (next is SecurityActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        final sid = _storeId;
        if (sid != null) {
          ref.read(securityOverviewProvider.notifier).load(sid);
          ref.read(deviceListProvider.notifier).loadDevices(sid);
          ref.read(sessionListProvider.notifier).loadSessions(sid);
          ref.read(incidentListProvider.notifier).loadIncidents(sid);
        }
        ref.read(securityActionProvider.notifier).reset();
      } else if (next is SecurityActionError) {
        showPosErrorSnackbar(context, next.message);
        ref.read(securityActionProvider.notifier).reset();
      }
    });

    return PosListPage(
      title: l10n.securityTitle,
      showSearch: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: PosTabs(
              selectedIndex: _currentTab,
              onChanged: (i) => setState(() => _currentTab = i),
              tabs: [
                PosTabItem(label: l10n.securityOverview),
                PosTabItem(label: l10n.securityPolicy),
                PosTabItem(label: l10n.securityAuditLogs),
                PosTabItem(label: l10n.securityDevices),
                PosTabItem(label: l10n.securityLogins),
                PosTabItem(label: l10n.securitySessions),
                PosTabItem(label: l10n.securityIncidents),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildOverviewTab(),
                _buildPolicyTab(),
                _buildAuditTab(),
                _buildDevicesTab(),
                _buildLoginsTab(),
                _buildSessionsTab(),
                _buildIncidentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final state = ref.watch(securityOverviewProvider);
    return switch (state) {
      SecurityOverviewInitial() || SecurityOverviewLoading() => Center(child: PosLoadingSkeleton.list()),
      SecurityOverviewLoaded(:final overview) => SecurityOverviewWidget(data: overview),
      SecurityOverviewError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(securityOverviewProvider.notifier).load(_storeId!),
      ),
    };
  }

  Widget _buildPolicyTab() {
    final state = ref.watch(securityPolicyProvider);
    return switch (state) {
      SecurityPolicyInitial() || SecurityPolicyLoading() => Center(child: PosLoadingSkeleton.list()),
      SecurityPolicyLoaded(policy: final p) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: SecurityPolicyEditor(
          policy: p,
          isSaving: ref.watch(securityPolicyProvider) is SecurityPolicyLoading,
          onSave: _storeId == null ? null : (data) => ref.read(securityPolicyProvider.notifier).updatePolicy(_storeId!, data),
        ),
      ),
      SecurityPolicyError(message: final m) => PosErrorState(
        message: AppLocalizations.of(context)!.securityError(m),
        onRetry: () => ref.read(securityPolicyProvider.notifier).loadPolicy(_storeId!),
      ),
    };
  }

  Widget _buildAuditTab() {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(auditLogListProvider);
    final actionState = ref.watch(securityActionProvider);
    final isExporting = actionState is SecurityActionLoading;

    void reload() {
      if (_storeId == null) return;
      ref.read(auditLogListProvider.notifier).loadLogs(_storeId!, action: _auditFilterAction, severity: _auditFilterSeverity);
    }

    Future<void> exportCsv() async {
      if (_storeId == null) return;
      final csv = await ref
          .read(securityActionProvider.notifier)
          .exportAuditLogs(storeId: _storeId!, action: _auditFilterAction, severity: _auditFilterSeverity);
      if (!mounted) return;
      if (csv == null) {
        showPosErrorSnackbar(context, l10n.securityExportError);
        ref.read(securityActionProvider.notifier).reset();
        return;
      }
      final filename = 'audit-log-${DateTime.now().toIso8601String().substring(0, 10)}.csv';
      final savePath = await FilePicker.saveFile(
        dialogTitle: l10n.securityExportCsv,
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: Uint8List.fromList(csv.codeUnits),
      );
      if (!mounted) return;
      if (savePath != null) {
        showPosSuccessSnackbar(context, l10n.securityExportSuccess);
      }
      ref.read(securityActionProvider.notifier).reset();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: PosDropdown<String?>(
                  label: l10n.securityFilterByAction,
                  value: _auditFilterAction,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllActions)),
                    ...[
                      'login',
                      'logout',
                      'create',
                      'update',
                      'delete',
                      'view',
                      'export',
                      'print',
                      'void',
                      'refund',
                    ].map((a) => DropdownMenuItem(value: a, child: Text(a))),
                  ],
                  onChanged: (v) {
                    setState(() => _auditFilterAction = v);
                    reload();
                  },
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: PosDropdown<String?>(
                  label: l10n.securityFilterBySeverity,
                  value: _auditFilterSeverity,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllSeverities)),
                    ...['info', 'warning', 'critical'].map((s) => DropdownMenuItem(value: s, child: Text(s))),
                  ],
                  onChanged: (v) {
                    setState(() => _auditFilterSeverity = v);
                    reload();
                  },
                ),
              ),
              AppSpacing.gapW12,
              PosButton(
                label: isExporting ? l10n.securityExporting : l10n.securityExportCsv,
                variant: PosButtonVariant.outline,
                icon: Icons.download_rounded,
                isLoading: isExporting,
                onPressed: isExporting ? null : exportCsv,
              ),
            ],
          ),
        ),
        AppSpacing.gapH8,
        Expanded(
          child: switch (state) {
            AuditLogListInitial() || AuditLogListLoading() => Center(child: PosLoadingSkeleton.list()),
            AuditLogListLoaded(logs: final logs) => AuditLogListWidget(logs: logs),
            AuditLogListError(message: final m) => PosErrorState(message: l10n.securityError(m), onRetry: reload),
          },
        ),
      ],
    );
  }

  Widget _buildDevicesTab() {
    final actionState = ref.watch(securityActionProvider);
    final state = ref.watch(deviceListProvider);
    final isLoading = actionState is SecurityActionLoading;

    return switch (state) {
      DeviceListInitial() || DeviceListLoading() => Center(child: PosLoadingSkeleton.list()),
      DeviceListLoaded(devices: final devices) => DeviceListWidget(
        devices: devices,
        isActionLoading: isLoading,
        onDeactivate: (id) => ref.read(securityActionProvider.notifier).deactivateDevice(id),
        onRemoteWipe: (id) => ref.read(securityActionProvider.notifier).requestRemoteWipe(id),
      ),
      DeviceListError(message: final m) => PosErrorState(
        message: AppLocalizations.of(context)!.securityError(m),
        onRetry: () => ref.read(deviceListProvider.notifier).loadDevices(_storeId!),
      ),
    };
  }

  Widget _buildLoginsTab() {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(loginAttemptsProvider);

    void reload() {
      if (_storeId == null) return;
      ref
          .read(loginAttemptsProvider.notifier)
          .loadAttempts(_storeId!, attemptType: _loginFilterType?.value, isSuccessful: _loginFilterSuccess);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: PosDropdown<LoginAttemptType?>(
                  label: l10n.securityFilterByType,
                  value: _loginFilterType,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllActions)),
                    ...LoginAttemptType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.value))),
                  ],
                  onChanged: (v) {
                    setState(() => _loginFilterType = v);
                    reload();
                  },
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: PosDropdown<bool?>(
                  label: l10n.securityFilterByStatus,
                  value: _loginFilterSuccess,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllStatuses)),
                    DropdownMenuItem(value: true, child: Text(l10n.securityLoginSuccess)),
                    DropdownMenuItem(value: false, child: Text(l10n.securityLoginFailed)),
                  ],
                  onChanged: (v) {
                    setState(() => _loginFilterSuccess = v);
                    reload();
                  },
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH8,
        Expanded(
          child: switch (state) {
            LoginAttemptsInitial() || LoginAttemptsLoading() => Center(child: PosLoadingSkeleton.list()),
            LoginAttemptsLoaded(attempts: final attempts) => _buildLoginList(attempts),
            LoginAttemptsError(message: final m) => PosErrorState(message: l10n.securityError(m), onRetry: reload),
          },
        ),
      ],
    );
  }

  Widget _buildSessionsTab() {
    final state = ref.watch(sessionListProvider);
    final actionState = ref.watch(securityActionProvider);
    final isLoading = actionState is SecurityActionLoading;

    return switch (state) {
      SessionListInitial() || SessionListLoading() => Center(child: PosLoadingSkeleton.list()),
      SessionListLoaded(:final sessions) => SessionListWidget(
        sessions: sessions,
        isActionLoading: isLoading,
        onEndSession: (id) => ref.read(securityActionProvider.notifier).endSession(id),
        onEndAllSessions: () => ref.read(securityActionProvider.notifier).endAllSessions(_storeId!),
      ),
      SessionListError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(sessionListProvider.notifier).loadSessions(_storeId!),
      ),
    };
  }

  Widget _buildIncidentsTab() {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(incidentListProvider);
    final actionState = ref.watch(securityActionProvider);
    final isLoading = actionState is SecurityActionLoading;

    void reload() {
      if (_storeId == null) return;
      ref
          .read(incidentListProvider.notifier)
          .loadIncidents(_storeId!, severity: _incidentFilterSeverity, isResolved: _incidentFilterResolved);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: PosDropdown<String?>(
                  label: l10n.securityFilterBySeverity,
                  value: _incidentFilterSeverity,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllSeverities)),
                    ...['low', 'medium', 'high', 'critical'].map((s) => DropdownMenuItem(value: s, child: Text(s))),
                  ],
                  onChanged: (v) {
                    setState(() => _incidentFilterSeverity = v);
                    reload();
                  },
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: PosDropdown<bool?>(
                  label: l10n.securityFilterByStatus,
                  value: _incidentFilterResolved,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.securityAllStatuses)),
                    DropdownMenuItem(value: false, child: Text(l10n.securityIncidentStatusOpen)),
                    DropdownMenuItem(value: true, child: Text(l10n.securityIncidentStatusResolved)),
                  ],
                  onChanged: (v) {
                    setState(() => _incidentFilterResolved = v);
                    reload();
                  },
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH8,
        Expanded(
          child: switch (state) {
            IncidentListInitial() || IncidentListLoading() => Center(child: PosLoadingSkeleton.list()),
            IncidentListLoaded(:final incidents) => IncidentListWidget(
              incidents: incidents,
              isActionLoading: isLoading,
              onResolve: (id, notes) => ref.read(securityActionProvider.notifier).resolveIncident(id, resolutionNotes: notes),
            ),
            IncidentListError(:final message) => PosErrorState(message: message, onRetry: reload),
          },
        ),
      ],
    );
  }

  Widget _buildLoginList(List<LoginAttempt> attempts) {
    final l10n = AppLocalizations.of(context)!;
    return PosDataTable<LoginAttempt>(
      items: attempts,
      emptyConfig: PosTableEmptyConfig(title: l10n.securityNoLoginAttempts, icon: Icons.login_outlined),
      columns: [
        PosTableColumn(title: l10n.securityLoginUser, flex: 2, sortable: true, key: 'user'),
        PosTableColumn(title: l10n.securityLoginType, flex: 1, key: 'type'),
        PosTableColumn(title: l10n.securityLoginStatus, flex: 1, key: 'status'),
        PosTableColumn(title: l10n.securityLoginIp, flex: 1, key: 'ip'),
        PosTableColumn(title: l10n.securityLoginTime, flex: 1, sortable: true, key: 'time'),
        PosTableColumn(title: l10n.securityLoginUserAgent, flex: 2, key: 'agent'),
      ],
      cellBuilder: (item, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.userIdentifier, style: const TextStyle(fontWeight: FontWeight.w500)),
                if (item.deviceName != null)
                  Text(item.deviceName!, style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context))),
              ],
            );
          case 1:
            return PosBadge(label: item.attemptType.value, variant: _attemptTypeVariant(item.attemptType));
          case 2:
            return PosStatusBadge(
              label: item.isSuccessful ? l10n.securityLoginSuccess : l10n.securityLoginFailed,
              variant: item.isSuccessful ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.error,
            );
          case 3:
            return Text(item.ipAddress ?? l10n.securityNA, style: const TextStyle(fontFamily: 'monospace', fontSize: 12));
          case 4:
            final dt = item.attemptedAt;
            return Text(
              dt != null
                  ? '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                  : l10n.securityNA,
              style: const TextStyle(fontSize: 12),
            );
          case 5:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.userAgent != null)
                  Text(
                    item.userAgent!,
                    style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (item.failureReason != null)
                  Text(item.failureReason!, style: const TextStyle(fontSize: 11, color: AppColors.error)),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  PosBadgeVariant _attemptTypeVariant(LoginAttemptType type) {
    switch (type) {
      case LoginAttemptType.pin:
        return PosBadgeVariant.primary;
      case LoginAttemptType.password:
        return PosBadgeVariant.info;
      case LoginAttemptType.biometric:
        return PosBadgeVariant.success;
      case LoginAttemptType.twoFactor:
        return PosBadgeVariant.warning;
    }
  }
}
