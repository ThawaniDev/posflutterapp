import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_state.dart';

class PosTerminalsPage extends ConsumerStatefulWidget {
  const PosTerminalsPage({super.key});

  @override
  ConsumerState<PosTerminalsPage> createState() => _PosTerminalsPageState();
}

class _PosTerminalsPageState extends ConsumerState<PosTerminalsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(terminalsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // Delete
  // ──────────────────────────────────────────────────────────

  Future<void> _handleDelete(Register terminal) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: AppLocalizations.of(context)!.terminalsDeleteTitle,
      message: AppLocalizations.of(context)!.terminalsDeleteMessage(terminal.name),
      confirmLabel: AppLocalizations.of(context)!.posDelete,
      isDanger: true,
    );
    if (confirmed == true && mounted) {
      final ok = await ref.read(terminalsProvider.notifier).deleteTerminal(terminal.id);
      if (mounted) {
        if (ok) {
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.terminalsDeleted(terminal.name));
        } else {
          showPosErrorSnackbar(context, AppLocalizations.of(context)!.terminalsDeleteFailed);
        }
      }
    }
  }

  // ──────────────────────────────────────────────────────────
  // Toggle active
  // ──────────────────────────────────────────────────────────

  Future<void> _handleToggleStatus(Register terminal) async {
    final action = terminal.isActive
        ? AppLocalizations.of(context)!.terminalsDeactivate
        : AppLocalizations.of(context)!.terminalsActivate;
    final confirmed = await showPosConfirmDialog(
      context,
      title: AppLocalizations.of(context)!.terminalsToggleTitle(action),
      message: AppLocalizations.of(context)!.terminalsToggleMessage(action, terminal.name),
      confirmLabel: action,
      isDanger: terminal.isActive,
    );
    if (confirmed == true && mounted) {
      final ok = await ref.read(terminalsProvider.notifier).toggleTerminalStatus(terminal.id);
      if (mounted) {
        if (ok) {
          showPosSuccessSnackbar(
            context,
            AppLocalizations.of(context)!.terminalsToggled(
              terminal.name,
              terminal.isActive
                  ? AppLocalizations.of(context)!.terminalsDeactivatedLower
                  : AppLocalizations.of(context)!.terminalsActivatedLower,
            ),
          );
        } else {
          showPosErrorSnackbar(context, AppLocalizations.of(context)!.terminalsToggleFailed);
        }
      }
    }
  }

  // ──────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(terminalsProvider);
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: l10n.terminalsTitle,
      subtitle: l10n.terminalsSubtitle,
      searchController: _searchController,
      searchHint: l10n.terminalsSearch,
      onSearchChanged: (q) => ref.read(terminalsProvider.notifier).search(q),
      onSearchClear: () {
        _searchController.clear();
        ref.read(terminalsProvider.notifier).search('');
      },
      actions: [
        PosButton(label: l10n.terminalsAdd, icon: Icons.add_rounded, onPressed: () => context.push(Routes.posTerminalAdd)),
      ],
      child: _buildTable(state),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Table
  // ──────────────────────────────────────────────────────────

  Widget _buildTable(TerminalsState state) {
    final isLoading = state is TerminalsLoading || state is TerminalsInitial;
    final error = state is TerminalsError ? state.message : null;
    final items = state is TerminalsLoaded ? state.terminals : <Register>[];

    final loaded = state is TerminalsLoaded ? state : null;

    return PosDataTable<Register>(
      columns: [
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColName, flex: 2, sortable: false),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColDeviceId, flex: 2),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColPlatform, width: 110),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColDeviceModel, width: 140),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColSerialNo, width: 130),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColSoftpos, width: 100),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColAcquirer, width: 110),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColNfc, width: 60, numeric: true),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColVersion, width: 100),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColLastSync, width: 150),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColLastTxn, width: 150),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColOnline, width: 80, numeric: true),
        PosTableColumn(title: AppLocalizations.of(context)!.terminalsColStatus, width: 100),
      ],
      items: items,
      cellBuilder: _buildCell,
      actions: [
        PosTableRowAction<Register>(
          label: AppLocalizations.of(context)!.terminalsEdit,
          icon: Icons.edit_outlined,
          onTap: (terminal) => context.push(Routes.posTerminalEdit.replaceFirst(':id', terminal.id)),
        ),
        PosTableRowAction<Register>(
          label: AppLocalizations.of(context)!.terminalsToggleStatus,
          icon: Icons.toggle_on_outlined,
          onTap: _handleToggleStatus,
        ),
        PosTableRowAction<Register>(
          label: AppLocalizations.of(context)!.posDelete,
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: _handleDelete,
        ),
      ],
      // Pagination
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 20,
      onPreviousPage: () => ref.read(terminalsProvider.notifier).previousPage(),
      onNextPage: () => ref.read(terminalsProvider.notifier).nextPage(),
      perPageOptions: const [10, 20, 50],
      onPerPageChanged: (p) => ref.read(terminalsProvider.notifier).setPerPage(p),
      // States
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(terminalsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.point_of_sale_outlined,
        title: AppLocalizations.of(context)!.terminalsNoTerminals,
        subtitle: AppLocalizations.of(context)!.terminalsNoTerminalsSubtitle,
        actionLabel: AppLocalizations.of(context)!.terminalsAdd,
        action: () => context.push(Routes.posTerminalAdd),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Cell builder
  // ──────────────────────────────────────────────────────────

  Widget _buildCell(Register terminal, int colIndex, PosTableColumn col) {
    switch (colIndex) {
      case 0: // Name
        return Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
              child: const Icon(Icons.point_of_sale_outlined, size: 18, color: AppColors.primary),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: Text(terminal.name, style: AppTypography.titleMedium, overflow: TextOverflow.ellipsis),
            ),
          ],
        );
      case 1: // Device ID
        return Text(
          terminal.deviceId ?? '—',
          style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace'),
          overflow: TextOverflow.ellipsis,
        );
      case 2: // Platform
        return _PlatformChip(platform: terminal.platform);
      case 3: // Device Model
        return Text(terminal.deviceModel ?? '—', style: AppTypography.bodySmall, overflow: TextOverflow.ellipsis);
      case 4: // Serial Number
        return Text(
          terminal.serialNumber ?? '—',
          style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace'),
          overflow: TextOverflow.ellipsis,
        );
      case 5: // SoftPOS
        if (!terminal.softposEnabled) {
          return PosBadge(label: AppLocalizations.of(context)!.terminalsOff, variant: PosBadgeVariant.neutral);
        }
        return PosBadge(
          label: terminal.softposStatusLabel.isNotEmpty ? terminal.softposStatusLabel : AppLocalizations.of(context)!.terminalsOn,
          variant: terminal.softposStatus == 'active'
              ? PosBadgeVariant.success
              : terminal.softposStatus == 'suspended'
              ? PosBadgeVariant.error
              : PosBadgeVariant.warning,
        );
      case 6: // Acquirer
        return Text(terminal.acquirerLabel, style: AppTypography.bodySmall);
      case 7: // NFC
        return Center(
          child: Icon(
            terminal.nfcCapable ? Icons.nfc_rounded : Icons.nfc_outlined,
            size: 18,
            color: terminal.nfcCapable ? AppColors.success : AppColors.textDisabledLight,
          ),
        );
      case 8: // App Version
        return Text(terminal.appVersion ?? '—', style: AppTypography.bodySmall);
      case 9: // Last Sync
        return Text(
          terminal.lastSyncAt != null ? _formatDate(terminal.lastSyncAt!) : AppLocalizations.of(context)!.terminalsNever,
          style: AppTypography.bodySmall,
        );
      case 10: // Last Transaction
        return Text(
          terminal.lastTransactionAt != null
              ? _formatDate(terminal.lastTransactionAt!)
              : AppLocalizations.of(context)!.terminalsNever,
          style: AppTypography.bodySmall,
        );
      case 11: // Online
        return Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: terminal.isOnline ? AppColors.success : AppColors.textDisabledLight,
            ),
          ),
        );
      case 12: // Status
        return PosBadge(
          label: terminal.isActive
              ? AppLocalizations.of(context)!.terminalsActive
              : AppLocalizations.of(context)!.terminalsInactive,
          variant: terminal.isActive ? PosBadgeVariant.success : PosBadgeVariant.neutral,
        );
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
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

// ──────────────────────────────────────────────────────────────────────────────
// Platform chip helper
// ──────────────────────────────────────────────────────────────────────────────

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.platform});

  final String? platform;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = _meta(platform);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        AppSpacing.gapW4,
        Text(label, style: AppTypography.bodySmall.copyWith(color: color)),
      ],
    );
  }

  (String, IconData, Color) _meta(String? p) {
    switch (p?.toLowerCase()) {
      case 'windows':
        return ('Windows', Icons.laptop_windows_outlined, AppColors.info);
      case 'macos':
        return ('macOS', Icons.laptop_mac_outlined, AppColors.textSecondaryLight);
      case 'ios':
        return ('iOS', Icons.phone_iphone_outlined, AppColors.textSecondaryLight);
      case 'android':
        return ('Android', Icons.android_outlined, AppColors.success);
      default:
        return ('Unknown', Icons.device_unknown_outlined, AppColors.textMutedLight);
    }
  }
}
