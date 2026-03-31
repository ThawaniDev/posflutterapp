import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: Text('Open POS Session', style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the opening cash amount for this session.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            ),
            AppSpacing.gapH16,
            PosTextField(
              controller: openingCashController,
              label: 'Opening Cash',
              hint: '0.000',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Open Session')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final amount = double.tryParse(openingCashController.text) ?? 0.0;
      await ref.read(posSessionsProvider.notifier).openSession({'opening_cash': amount});
      if (mounted) showPosSuccessSnackbar(context, 'POS session opened.');
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
        title: Text('Close Session', style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the closing cash amount to close this session.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            ),
            AppSpacing.gapH16,
            PosTextField(
              controller: closingCashController,
              label: 'Closing Cash',
              hint: '0.000',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Close Session'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final amount = double.tryParse(closingCashController.text) ?? 0.0;
      await ref.read(posSessionsProvider.notifier).closeSession(session.id, {'closing_cash': amount});
      if (mounted) showPosSuccessSnackbar(context, 'Session closed.');
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
              Text('POS Sessions', style: AppTypography.headlineMedium),
              Text(
                isLoaded ? '${state.total} session${state.total == 1 ? '' : 's'}' : 'Session history',
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
          const Spacer(),

          // Open session button
          PosButton(label: 'Open Session', icon: Icons.play_circle_outline_rounded, onPressed: _handleOpenSession),
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
      columns: const [
        PosTableColumn(title: 'Session ID', width: 200),
        PosTableColumn(title: 'Register', flex: 1),
        PosTableColumn(title: 'Cashier', flex: 1),
        PosTableColumn(title: 'Status', width: 100),
        PosTableColumn(title: 'Opening Cash', width: 130, numeric: true),
        PosTableColumn(title: 'Total Sales', width: 120, numeric: true),
        PosTableColumn(title: 'Transactions', width: 110, numeric: true),
        PosTableColumn(title: 'Opened At', width: 150),
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
          label: 'Close Session',
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
      emptyConfig: const PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: 'No sessions found',
        subtitle: 'Open a POS session to start processing transactions.',
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
          label: session.status.value == 'open' ? 'Open' : 'Closed',
          variant: session.status == SessionStatus.open ? PosBadgeVariant.success : PosBadgeVariant.neutral,
        );
      case 4: // Opening Cash
        return Text('${session.openingCash.toStringAsFixed(3)} OMR', style: AppTypography.bodySmall, textAlign: TextAlign.right);
      case 5: // Total Sales
        final total = (session.totalCashSales ?? 0) + (session.totalCardSales ?? 0) + (session.totalOtherSales ?? 0);
        return Text('${total.toStringAsFixed(3)} OMR', style: AppTypography.bodySmall, textAlign: TextAlign.right);
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
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)} ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
