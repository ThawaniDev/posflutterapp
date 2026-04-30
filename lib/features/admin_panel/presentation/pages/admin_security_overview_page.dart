import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityOverviewPage extends ConsumerStatefulWidget {
  const AdminSecurityOverviewPage({super.key});

  @override
  ConsumerState<AdminSecurityOverviewPage> createState() => _AdminSecurityOverviewPageState();
}

class _AdminSecurityOverviewPageState extends ConsumerState<AdminSecurityOverviewPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(securityOverviewProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(securityOverviewProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityOverviewProvider);

    return PosListPage(
      title: l10n.adminSecurity,
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              SecurityOverviewLoading() => const PosLoading(),
              SecurityOverviewError(message: final msg) => PosErrorState(
                message: msg,
                onRetry: () => ref.read(securityOverviewProvider.notifier).load(storeId: _storeId),
              ),
              SecurityOverviewLoaded(data: final data) => _buildContent(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final overview = data['data'] as Map<String, dynamic>? ?? data;
    final alerts = overview['alerts'] as Map<String, dynamic>? ?? {};
    final sessions = overview['sessions'] as Map<String, dynamic>? ?? {};
    final devices = overview['devices'] as Map<String, dynamic>? ?? {};
    final logins = overview['login_attempts'] as Map<String, dynamic>? ?? {};
    final ipMgmt = overview['ip_management'] as Map<String, dynamic>? ?? {};

    final openAlerts = alerts['open'] ?? alerts['total'] ?? 0;
    final criticalAlerts = alerts['critical'] ?? 0;
    final activeSessions = sessions['active'] ?? sessions['total'] ?? 0;
    final activeDevices = devices['active'] ?? devices['total'] ?? 0;
    final failedLogins = logins['failed_24h'] ?? logins['failed'] ?? 0;
    final blockedIps = ipMgmt['blocked'] ?? 0;

    return RefreshIndicator(
      onRefresh: () => ref.read(securityOverviewProvider.notifier).load(storeId: _storeId),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ── KPI Grid ───────────────────────────────────────
          PosKpiGrid(
            desktopCols: 3,
            tabletCols: 3,
            mobileCols: 2,
            cards: [
              PosKpiCard(
                label: l10n.adminOpenAlerts,
                value: '$openAlerts',
                icon: Icons.warning_amber_rounded,
                iconColor: openAlerts > 0 ? AppColors.error : AppColors.success,
              ),
              PosKpiCard(
                label: l10n.adminCriticalAlerts,
                value: '$criticalAlerts',
                icon: Icons.crisis_alert,
                iconColor: criticalAlerts > 0 ? AppColors.error : AppColors.success,
              ),
              PosKpiCard(
                label: l10n.securityActiveSessions,
                value: '$activeSessions',
                icon: Icons.computer,
                iconColor: AppColors.info,
              ),
              PosKpiCard(
                label: l10n.securityActiveDevices,
                value: '$activeDevices',
                icon: Icons.phone_android,
                iconColor: AppColors.success,
              ),
              PosKpiCard(
                label: l10n.adminFailedLogins24h,
                value: '$failedLogins',
                icon: Icons.lock_outline,
                iconColor: failedLogins > 10 ? AppColors.error : AppColors.warning,
              ),
              PosKpiCard(label: l10n.adminBlockedIps, value: '$blockedIps', icon: Icons.block, iconColor: AppColors.purple),
            ],
          ),

          AppSpacing.gapH20,

          // ── Alert Severity Breakdown ──────────────────────
          if (alerts.isNotEmpty) ...[
            _SectionHeader(title: l10n.securityAlertsBySeverity, icon: Icons.warning_amber_rounded, color: AppColors.error),
            AppSpacing.gapH8,
            _SeverityRow(stats: alerts),
            AppSpacing.gapH20,
          ],

          // ── Sessions Section ──────────────────────────────
          if (sessions.isNotEmpty) ...[
            _SectionHeader(title: l10n.companionSessions, icon: Icons.devices, color: AppColors.info),
            AppSpacing.gapH8,
            _StatGrid(stats: sessions),
            AppSpacing.gapH20,
          ],

          // ── Device Section ────────────────────────────────
          if (devices.isNotEmpty) ...[
            _SectionHeader(title: l10n.securityDevices, icon: Icons.phone_android, color: AppColors.success),
            AppSpacing.gapH8,
            _StatGrid(stats: devices),
            AppSpacing.gapH20,
          ],

          // ── Login Attempts Section ────────────────────────
          if (logins.isNotEmpty) ...[
            _SectionHeader(title: l10n.adminLoginAttempts, icon: Icons.login, color: AppColors.warning),
            AppSpacing.gapH8,
            _StatGrid(stats: logins),
            AppSpacing.gapH20,
          ],

          // ── IP Management Section ─────────────────────────
          if (ipMgmt.isNotEmpty) ...[
            _SectionHeader(title: l10n.adminIpManagement, icon: Icons.shield_outlined, color: AppColors.purple),
            AppSpacing.gapH8,
            _StatGrid(stats: ipMgmt),
            AppSpacing.gapH20,
          ],
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// A responsive 2-column grid of numeric stats from a flat Map.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});
  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final entries = stats.entries.toList();
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: entries.map((e) {
        return SizedBox(
          width: 150,
          child: PosCard(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.key.replaceAll('_', ' '),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedFor(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('${e.value}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Color-coded severity chip row for alert severity breakdown.
class _SeverityRow extends StatelessWidget {
  const _SeverityRow({required this.stats});
  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final levels = <String, Color>{
      'critical': AppColors.error,
      'high': AppColors.warning,
      'medium': AppColors.info,
      'low': AppColors.success,
    };
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: levels.entries.map((e) {
        final count = stats[e.key] ?? 0;
        return Chip(
          label: Text('${e.key[0].toUpperCase()}${e.key.substring(1)}: $count'),
          backgroundColor: e.value.withOpacity(0.12),
          labelStyle: TextStyle(color: e.value, fontWeight: FontWeight.w600),
        );
      }).toList(),
    );
  }
}
