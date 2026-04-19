import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
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
        child: SecurityPolicyEditor(policy: p),
      ),
      SecurityPolicyError(message: final m) => PosErrorState(
        message: AppLocalizations.of(context)!.securityError(m),
        onRetry: () => ref.read(securityPolicyProvider.notifier).loadPolicy(_storeId!),
      ),
    };
  }

  Widget _buildAuditTab() {
    final state = ref.watch(auditLogListProvider);
    return switch (state) {
      AuditLogListInitial() || AuditLogListLoading() => Center(child: PosLoadingSkeleton.list()),
      AuditLogListLoaded(logs: final logs) => AuditLogListWidget(logs: logs),
      AuditLogListError(message: final m) => PosErrorState(
        message: AppLocalizations.of(context)!.securityError(m),
        onRetry: () => ref.read(auditLogListProvider.notifier).loadLogs(_storeId!),
      ),
    };
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
    final state = ref.watch(loginAttemptsProvider);
    return switch (state) {
      LoginAttemptsInitial() || LoginAttemptsLoading() => Center(child: PosLoadingSkeleton.list()),
      LoginAttemptsLoaded(attempts: final attempts) => _buildLoginList(attempts),
      LoginAttemptsError(message: final m) => PosErrorState(
        message: AppLocalizations.of(context)!.securityError(m),
        onRetry: () => ref.read(loginAttemptsProvider.notifier).loadAttempts(_storeId!),
      ),
    };
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
    final state = ref.watch(incidentListProvider);
    final actionState = ref.watch(securityActionProvider);
    final isLoading = actionState is SecurityActionLoading;

    return switch (state) {
      IncidentListInitial() || IncidentListLoading() => Center(child: PosLoadingSkeleton.list()),
      IncidentListLoaded(:final incidents) => IncidentListWidget(
        incidents: incidents,
        isActionLoading: isLoading,
        onResolve: (id, notes) => ref.read(securityActionProvider.notifier).resolveIncident(id, resolutionNotes: notes),
      ),
      IncidentListError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(incidentListProvider.notifier).loadIncidents(_storeId!),
      ),
    };
  }

  Widget _buildLoginList(List attempts) {
    final l10n = AppLocalizations.of(context)!;
    if (attempts.isEmpty) {
      return PosEmptyState(title: l10n.securityNoLoginAttempts, icon: Icons.login);
    }
    return ListView.builder(
      itemCount: attempts.length,
      itemBuilder: (context, index) {
        final a = attempts[index];
        final color = a.isSuccessful ? AppColors.success : AppColors.error;
        return ListTile(
          leading: Icon(a.isSuccessful ? Icons.check_circle : Icons.cancel, color: color),
          title: Text(a.userIdentifier),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${a.attemptType.value} • ${a.ipAddress ?? l10n.securityNA}'),
              if (a.userAgent != null) Text(a.userAgent!, style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context))),
              if (a.failureReason != null) Text(a.failureReason!, style: TextStyle(fontSize: 11, color: AppColors.error)),
            ],
          ),
          trailing: Text(
            a.isSuccessful ? l10n.securityLoginSuccess : l10n.securityLoginFailed,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
