import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
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
  // Rename
  // ──────────────────────────────────────────────────────────

  Future<void> _handleRename(Register terminal) async {
    final updatedName = await showDialog<String>(
      context: context,
      builder: (context) => _RenameTerminalDialog(initialName: terminal.name),
    );

    final name = updatedName?.trim();
    if (name == null || name.isEmpty || name == terminal.name) return;

    final ok = await ref.read(terminalsProvider.notifier).renameTerminal(terminal.id, name);
    if (!mounted) return;

    if (ok) {
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.termFormUpdated);
    } else {
      showPosErrorSnackbar(context, AppLocalizations.of(context)!.termFormUpdateFailed);
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
          icon: Icons.drive_file_rename_outline_rounded,
          onTap: _handleRename,
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

class _RenameTerminalDialog extends StatefulWidget {
  const _RenameTerminalDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenameTerminalDialog> createState() => _RenameTerminalDialogState();
}

class _RenameTerminalDialogState extends State<_RenameTerminalDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = AppLocalizations.of(context)!.termFormNameRequired);
      return;
    }

    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidthDialog),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.terminalsEdit, style: AppTypography.headlineSmall),
              AppSpacing.gapH20,
              PosTextField(
                controller: _controller,
                label: l10n.posTerminalName,
                hint: l10n.posTerminalNameHint,
                errorText: _errorText,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
                onSubmitted: (_) => _submit(),
              ),
              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: l10n.cancel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(label: l10n.save, icon: Icons.save_outlined, onPressed: _submit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Platform chip helper
// ──────────────────────────────────────────────────────────────────────────────

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.platform});

  final String? platform;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = _meta(context, platform);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        AppSpacing.gapW4,
        Text(label, style: AppTypography.bodySmall.copyWith(color: color)),
      ],
    );
  }

  (String, IconData, Color) _meta(BuildContext context, String? p) {
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
        return ('Unknown', Icons.device_unknown_outlined, AppColors.mutedFor(context));
    }
  }
}
