import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/cash_event_type.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';
import 'package:wameedpos/features/security/enums/session_status.dart';

class CashSessionsPage extends ConsumerStatefulWidget {
  const CashSessionsPage({super.key});

  @override
  ConsumerState<CashSessionsPage> createState() => _CashSessionsPageState();
}

class _CashSessionsPageState extends ConsumerState<CashSessionsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cashSessionsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(cashSessionsProvider);

    return PosListPage(
      title: l10n.adminFinOpsCashSessions,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showCashSessionsInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      isLoading: state is CashSessionsInitial || state is CashSessionsLoading,
      hasError: state is CashSessionsError,
      errorMessage: state is CashSessionsError ? (state).message : null,
      onRetry: () => ref.read(cashSessionsProvider.notifier).load(),
      isEmpty: state is CashSessionsLoaded && (state).sessions.isEmpty,
      emptyTitle: l10n.noCashSessionsFound,
      emptyIcon: Icons.receipt_long_outlined,
      child: switch (state) {
        CashSessionsLoaded(:final sessions, :final hasMore) => _buildList(theme, sessions, hasMore),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildList(ThemeData theme, List<CashSession> sessions, bool hasMore) {
    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: sessions.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        if (index == sessions.length) {
          return Padding(
            padding: AppSpacing.paddingAll16,
            child: Center(
              child: PosButton(
                label: 'Load more',
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(cashSessionsProvider.notifier).loadMore(),
              ),
            ),
          );
        }
        final session = sessions[index];
        return _SessionRow(session: session, theme: theme, onTap: () => _showSessionDetail(context, session));
      },
    );
  }

  void _showSessionDetail(BuildContext context, CashSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _SessionDetailSheet(session: session),
    );
  }
}

// ─── Session Row ─────────────────────────────────────────────────

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session, required this.theme, required this.onTap});
  final CashSession session;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOpen = session.status == SessionStatus.open;
    final statusColor = isOpen ? AppColors.success : AppColors.info;

    return PosCard(
      borderRadius: AppRadius.borderMd,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Row(
          children: [
            // Icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
              child: Icon(Icons.point_of_sale, color: statusColor, size: 20),
            ),
            AppSpacing.gapW12,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        session.terminalId != null ? 'Terminal: ${session.terminalId}' : 'No Terminal',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSpacing.gapW8,
                      _StatusBadge(status: session.status),
                    ],
                  ),
                  AppSpacing.gapH2,
                  if (session.openedAt != null)
                    Text(
                      _formatDateTime(session.openedAt!),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                    ),
                  if (session.closedAt != null)
                    Text(
                      'Closed: ${_formatDateTime(session.closedAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                    ),
                ],
              ),
            ),
            // Float + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.openingFloat.toStringAsFixed(2)} \u0631',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (session.variance != null)
                  Text(
                    '${session.variance! >= 0 ? '+' : ''}${session.variance!.toStringAsFixed(2)} \u0631',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: session.variance! >= 0 ? AppColors.success : AppColors.error,
                      fontSize: 11,
                    ),
                  ),
                Icon(Icons.chevron_right, size: 16, color: theme.hintColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Status Badge ────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final SessionStatus? status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      SessionStatus.open => (AppColors.success, 'Open'),
      SessionStatus.active => (AppColors.success, 'Open'),
      SessionStatus.closed => (AppColors.info, 'Closed'),
      SessionStatus.expired => (AppColors.warning, 'Expired'),
      SessionStatus.revoked => (AppColors.error, 'Revoked'),
      null => (const Color(0xFF6B7280), 'Unknown'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderFull),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Session Detail Sheet ─────────────────────────────────────────

class _SessionDetailSheet extends ConsumerStatefulWidget {
  const _SessionDetailSheet({required this.session});
  final CashSession session;

  @override
  ConsumerState<_SessionDetailSheet> createState() => _SessionDetailSheetState();
}

class _SessionDetailSheetState extends ConsumerState<_SessionDetailSheet> with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late TabController _tabController;

  List<CashEvent> _cashEvents = [];
  List<Expense> _expenses = [];
  bool _loadingDetail = false;
  String? _detailError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loadingDetail = true;
      _detailError = null;
    });
    try {
      final detail = await ref.read(paymentRepositoryProvider).getCashSession(widget.session.id);
      if (mounted) {
        setState(() {
          _cashEvents = detail.cashEvents ?? [];
          _expenses = detail.expenses ?? [];
        });
      }
    } catch (e) {
      if (mounted) setState(() => _detailError = e.toString());
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = widget.session;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: theme.dividerColor, borderRadius: AppRadius.borderFull),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.cashSessionDetailTitle, style: theme.textTheme.titleLarge),
                _StatusBadge(status: session.status),
              ],
            ),
          ),
          AppSpacing.gapH8,
          // KPI row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _KpiCell(
                    theme: theme,
                    label: l10n.cashSessionOpenFloat,
                    value: '${session.openingFloat.toStringAsFixed(2)} \u0631',
                  ),
                ),
                AppSpacing.gapW8,
                if (session.expectedCash != null)
                  Expanded(
                    child: _KpiCell(
                      theme: theme,
                      label: l10n.cashSessionExpectedCash,
                      value: '${session.expectedCash!.toStringAsFixed(2)} \u0631',
                    ),
                  ),
                AppSpacing.gapW8,
                if (session.variance != null)
                  Expanded(
                    child: _KpiCell(
                      theme: theme,
                      label: l10n.cashSessionVariance,
                      value: '${session.variance! >= 0 ? '+' : ''}${session.variance!.toStringAsFixed(2)} \u0631',
                      valueColor: session.variance! >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapH8,
          // Timestamps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (session.openedAt != null)
                  Expanded(
                    child: Text(
                      '${l10n.cashSessionOpenedAt}: ${_fmtDt(session.openedAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                  ),
                if (session.closedAt != null)
                  Expanded(
                    child: Text(
                      '${l10n.cashSessionClosedAt}: ${_fmtDt(session.closedAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapH12,
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.cashSessionEventsTab),
              Tab(text: l10n.cashSessionExpensesTab),
            ],
          ),
          // Tab content
          Expanded(
            child: _loadingDetail
                ? const Center(child: CircularProgressIndicator())
                : _detailError != null
                ? Center(
                    child: Text(_detailError!, style: const TextStyle(color: AppColors.error)),
                  )
                : TabBarView(controller: _tabController, children: [_buildCashEventsTab(theme), _buildExpensesTab(theme)]),
          ),
        ],
      ),
    );
  }

  Widget _buildCashEventsTab(ThemeData theme) {
    if (_cashEvents.isEmpty) {
      return Center(
        child: Text(l10n.cashSessionNoEvents, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
      );
    }
    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: _cashEvents.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        final event = _cashEvents[index];
        final isIn = event.type == CashEventType.cashIn;
        final color = isIn ? AppColors.success : AppColors.error;

        return PosCard(
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: AppSpacing.paddingAll12,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(isIn ? Icons.add : Icons.remove, color: color, size: 18),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.reason, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      if (event.notes != null)
                        Text(event.notes!, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                      if (event.createdAt != null)
                        Text(
                          _fmtDt(event.createdAt!),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${isIn ? '+' : '-'}${event.amount.toStringAsFixed(2)} \u0631',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpensesTab(ThemeData theme) {
    if (_expenses.isEmpty) {
      return Center(
        child: Text(l10n.cashSessionNoExpenses, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
      );
    }
    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: _expenses.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return PosCard(
          borderRadius: AppRadius.borderMd,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.error.withValues(alpha: 0.12),
              child: const Icon(Icons.receipt_long, color: AppColors.error, size: 18),
            ),
            title: Text(
              expense.description ?? expense.category.value.replaceAll('_', ' '),
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              expense.category.value.replaceAll('_', ' '),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            trailing: Text(
              '${expense.amount.toStringAsFixed(2)} \u0631',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.error),
            ),
          ),
        );
      },
    );
  }

  String _fmtDt(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─── KPI Cell ─────────────────────────────────────────────────────

class _KpiCell extends StatelessWidget {
  const _KpiCell({required this.theme, required this.label, required this.value, this.valueColor});
  final ThemeData theme;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11)),
            AppSpacing.gapH2,
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

void showCashSessionsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showPosInfoDialog(context, title: l10n.adminFinOpsCashSessions, message: l10n.cashSessionsInfoMessage);
}
