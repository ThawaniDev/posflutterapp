import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_state.dart';
import 'package:thawani_pos/features/security/enums/session_status.dart';

class PosSessionsPage extends ConsumerStatefulWidget {
  const PosSessionsPage({super.key});

  @override
  ConsumerState<PosSessionsPage> createState() => _PosSessionsPageState();
}

class _PosSessionsPageState extends ConsumerState<PosSessionsPage> {
  final _searchController = TextEditingController();
  String? _sortColumnKey;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(posSessionsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // Open session dialog
  // ──────────────────────────────────────────────────────────

  Future<void> _handleOpenSession() async {
    final openingCashController = TextEditingController(text: '0.000');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.sessionsOpenPosSession, style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(ctx)!.sessionsOpenSessionDescription,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            ),
            AppSpacing.gapH16,
            PosTextField(
              controller: openingCashController,
              label: AppLocalizations.of(ctx)!.sessionsOpeningCash,
              hint: '0.000',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(ctx)!.posCancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(ctx)!.sessionsOpenSession)),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final amount = double.tryParse(openingCashController.text) ?? 0.0;
      await ref.read(posSessionsProvider.notifier).openSession({'opening_cash': amount});
      if (mounted) showPosSuccessSnackbar(context, AppLocalizations.of(context)!.sessionsSessionOpened);
    }
  }

  // ──────────────────────────────────────────────────────────
  // Close session dialog
  // ──────────────────────────────────────────────────────────

  Future<void> _handleCloseSession(PosSession session) async {
    final closingCashController = TextEditingController(text: '0.000');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.sessionsCloseSession, style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(ctx)!.sessionsCloseSessionDescription,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            ),
            AppSpacing.gapH16,
            PosTextField(
              controller: closingCashController,
              label: AppLocalizations.of(ctx)!.sessionsClosingCash,
              hint: '0.000',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(ctx)!.posCancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(ctx)!.sessionsCloseSession),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final amount = double.tryParse(closingCashController.text) ?? 0.0;
      await ref.read(posSessionsProvider.notifier).closeSession(session.id, {'closing_cash': amount});
      if (mounted) showPosSuccessSnackbar(context, AppLocalizations.of(context)!.sessionsSessionClosed);
    }
  }

  // ──────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posSessionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolbar(context, isDark, state),
          Expanded(child: _buildTable(state)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Toolbar
  // ──────────────────────────────────────────────────────────

  Widget _buildToolbar(BuildContext context, bool isDark, PosSessionsState state) {
    final isLoaded = state is PosSessionsLoaded;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.sessionsTitle, style: AppTypography.headlineMedium),
              Text(
                isLoaded
                    ? '${state.total} ${state.total == 1 ? AppLocalizations.of(context)!.sessionsSessionSingular : AppLocalizations.of(context)!.sessionsSessionPlural}'
                    : AppLocalizations.of(context)!.sessionsHistory,
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
          const Spacer(),

          // Open session button
          PosButton(
            label: AppLocalizations.of(context)!.sessionsOpenSession,
            icon: Icons.play_circle_outline_rounded,
            onPressed: _handleOpenSession,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Table
  // ──────────────────────────────────────────────────────────

  Widget _buildTable(PosSessionsState state) {
    final isLoading = state is PosSessionsLoading || state is PosSessionsInitial;
    final error = state is PosSessionsError ? state.message : null;
    final items = state is PosSessionsLoaded ? state.sessions : <PosSession>[];
    final loaded = state is PosSessionsLoaded ? state : null;

    return PosDataTable<PosSession>(
      columns: [
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColSessionId, width: 200),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColRegister, flex: 1),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColCashier, flex: 1),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColStatus, width: 100),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColOpeningCash, width: 130, numeric: true),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColTotalSales, width: 120, numeric: true),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColTransactions, width: 110, numeric: true),
        PosTableColumn(title: AppLocalizations.of(context)!.sessionsColOpenedAt, width: 150),
      ],
      items: items,
      cellBuilder: _buildCell,
      sortColumnKey: _sortColumnKey,
      sortAscending: _sortAscending,
      onSort: (key, asc) => setState(() {
        _sortColumnKey = key;
        _sortAscending = asc;
      }),
      actions: [
        PosTableRowAction<PosSession>(
          label: AppLocalizations.of(context)!.sessionsCloseSession,
          icon: Icons.stop_circle_outlined,
          isDestructive: true,
          isVisible: (s) => s.status == SessionStatus.open,
          onTap: _handleCloseSession,
        ),
      ],
      // Pagination
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 20,
      onPreviousPage: () => ref.read(posSessionsProvider.notifier).previousPage(),
      onNextPage: () => ref.read(posSessionsProvider.notifier).nextPage(),
      perPageOptions: const [10, 20, 50],
      onPerPageChanged: (p) => ref.read(posSessionsProvider.notifier).setPerPage(p),
      // States
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(posSessionsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: AppLocalizations.of(context)!.sessionsNoSessions,
        subtitle: AppLocalizations.of(context)!.sessionsNoSessionsSubtitle,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Cell builder
  // ──────────────────────────────────────────────────────────

  Widget _buildCell(PosSession session, int colIndex, PosTableColumn col) {
    switch (colIndex) {
      case 0: // Session ID
        return Text(
          session.id.length > 8 ? '...${session.id.substring(session.id.length - 8)}' : session.id,
          style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace'),
        );
      case 1: // Register
        return Text(
          session.registerId.length > 8
              ? '...${session.registerId.substring(session.registerId.length - 8)}'
              : session.registerId,
          style: AppTypography.bodySmall,
        );
      case 2: // Cashier
        return Text(
          session.cashierId.length > 8 ? '...${session.cashierId.substring(session.cashierId.length - 8)}' : session.cashierId,
          style: AppTypography.bodySmall,
        );
      case 3: // Status
        return PosBadge(
          label: session.status.value == 'open'
              ? AppLocalizations.of(context)!.sessionsStatusOpen
              : AppLocalizations.of(context)!.sessionsStatusClosed,
          variant: session.status == SessionStatus.open ? PosBadgeVariant.success : PosBadgeVariant.neutral,
        );
      case 4: // Opening Cash
        return Text('${session.openingCash.toStringAsFixed(3)} SAR', style: AppTypography.bodySmall, textAlign: TextAlign.right);
      case 5: // Total Sales
        final total = (session.totalCashSales ?? 0) + (session.totalCardSales ?? 0) + (session.totalOtherSales ?? 0);
        return Text('${total.toStringAsFixed(3)} SAR', style: AppTypography.bodySmall, textAlign: TextAlign.right);
      case 6: // Transactions
        return Text('${session.transactionCount ?? 0}', style: AppTypography.bodySmall, textAlign: TextAlign.right);
      case 7: // Opened At
        return Text(session.openedAt != null ? _formatDate(session.openedAt!) : '—', style: AppTypography.bodySmall);
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return AppLocalizations.of(context)!.posJustNow;
    if (diff.inHours < 1) return AppLocalizations.of(context)!.posMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return AppLocalizations.of(context)!.posHoursAgo(diff.inHours);
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)} ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
