import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/backup/models/backup_history.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BackupListWidget extends ConsumerStatefulWidget {
  const BackupListWidget({super.key});

  @override
  ConsumerState<BackupListWidget> createState() => _BackupListWidgetState();
}

class _BackupListWidgetState extends ConsumerState<BackupListWidget> {
  String? _filterType;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  void _load() {
    ref.read(backupListProvider.notifier).load(
      backupType: _filterType,
      status: _filterStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(backupListProvider);

    return Column(
      children: [
        _buildFilterBar(context, l10n),
        Expanded(
          child: switch (state) {
            BackupListInitial() => const PosLoading(),
            BackupListLoading() => const PosLoading(),
            BackupListError(:final message) => PosErrorState(
              message: message,
              onRetry: _load,
            ),
            BackupListLoaded(:final data) => _buildTable(context, l10n, data),
          },
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.md, AppSpacing.xxxl, 0),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: PosDropdown<String?>(
              label: l10n.backupFilterType,
              hint: l10n.backupFilterAllTypes,
              value: _filterType,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.backupFilterAllTypes)),
                DropdownMenuItem(value: 'auto', child: Text(l10n.backupTypeAuto)),
                DropdownMenuItem(value: 'manual', child: Text(l10n.backupTypeManual)),
                DropdownMenuItem(value: 'pre_update', child: Text(l10n.backupTypePreUpdate)),
              ],
              onChanged: (v) {
                setState(() => _filterType = v);
                _load();
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 180,
            child: PosDropdown<String?>(
              label: l10n.backupFilterStatus,
              hint: l10n.backupFilterAllStatuses,
              value: _filterStatus,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.backupFilterAllStatuses)),
                DropdownMenuItem(value: 'completed', child: Text(l10n.backupStatusCompleted)),
                DropdownMenuItem(value: 'failed', child: Text(l10n.backupStatusFailed)),
                DropdownMenuItem(value: 'corrupted', child: Text(l10n.backupStatusCorrupted)),
              ],
              onChanged: (v) {
                setState(() => _filterStatus = v);
                _load();
              },
            ),
          ),
          const Spacer(),
          if (_filterType != null || _filterStatus != null)
            PosButton(
              label: l10n.commonClear,
              variant: PosButtonVariant.ghost,
              size: PosButtonSize.sm,
              onPressed: () {
                setState(() {
                  _filterType = null;
                  _filterStatus = null;
                });
                _load();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, AppLocalizations l10n, Map<String, dynamic> data) {
    final rawBackups = data['data']?['backups'] as List? ?? (data['backups'] as List? ?? []);
    final backups = rawBackups
        .whereType<Map<String, dynamic>>()
        .map(BackupHistory.fromJson)
        .toList();

    ref.watch(backupOperationProvider);

    return PosDataTable<BackupHistory>(
      columns: [
        PosTableColumn(title: l10n.backupColType, width: 130),
        PosTableColumn(title: l10n.backupColDate, flex: 2),
        PosTableColumn(title: l10n.backupColSize, width: 100, numeric: true),
        PosTableColumn(title: l10n.backupColLocation, width: 120),
        PosTableColumn(title: l10n.backupColStatus, width: 120),
        PosTableColumn(title: l10n.backupColVerified, width: 90),
      ],
      items: backups,
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.cloud_upload_outlined,
        title: l10n.noBackupsYet,
        subtitle: l10n.backupNowHint,
      ),
      actions: [
        PosTableRowAction<BackupHistory>(
          label: l10n.backupRestore,
          icon: Icons.restore_rounded,
          isVisible: (b) => b.status == 'completed',
          onTap: (b) => _handleRestore(l10n, b),
        ),
        PosTableRowAction<BackupHistory>(
          label: l10n.backupVerify,
          icon: Icons.verified_outlined,
          isVisible: (b) => !b.isVerified && b.status == 'completed',
          onTap: (b) => _handleVerify(l10n, b),
        ),
        PosTableRowAction<BackupHistory>(
          label: l10n.backupDelete,
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: (b) => _handleDelete(l10n, b),
        ),
      ],
      cellBuilder: (b, colIndex, col) {
        switch (colIndex) {
          case 0:
            return _typeBadge(context, l10n, b.backupType);
          case 1:
            return Text(
              b.createdAt != null ? _formatDate(b.createdAt!) : '—',
              style: AppTypography.bodyMedium,
            );
          case 2:
            return Text(
              _formatBytes(b.fileSizeBytes),
              style: AppTypography.bodyMedium,
            );
          case 3:
            return _locationBadge(context, l10n, b.storageLocation);
          case 4:
            return _statusBadge(context, l10n, b.status);
          case 5:
            return b.isVerified
                ? const Icon(Icons.verified, color: AppColors.info, size: 18)
                : Icon(Icons.remove_circle_outline, color: AppColors.mutedFor(context), size: 18);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _typeBadge(BuildContext context, AppLocalizations l10n, String type) {
    String label;
    PosBadgeVariant variant;
    switch (type) {
      case 'auto':
        label = l10n.backupTypeAuto;
        variant = PosBadgeVariant.info;
      case 'pre_update':
        label = l10n.backupTypePreUpdate;
        variant = PosBadgeVariant.warning;
      default:
        label = l10n.backupTypeManual;
        variant = PosBadgeVariant.neutral;
    }
    return PosBadge(label: label, variant: variant, isSmall: true);
  }

  Widget _locationBadge(BuildContext context, AppLocalizations l10n, String? location) {
    String label;
    PosBadgeVariant variant;
    switch (location) {
      case 'local':
        label = l10n.backupStorageLocal;
        variant = PosBadgeVariant.neutral;
      case 'cloud':
        label = l10n.backupStorageCloud;
        variant = PosBadgeVariant.primary;
      case 'both':
        label = l10n.backupStorageBoth;
        variant = PosBadgeVariant.success;
      default:
        label = location ?? '—';
        variant = PosBadgeVariant.neutral;
    }
    return PosBadge(label: label, variant: variant, isSmall: true);
  }

  Widget _statusBadge(BuildContext context, AppLocalizations l10n, String status) {
    String label;
    PosBadgeVariant variant;
    switch (status) {
      case 'completed':
        label = l10n.backupStatusCompleted;
        variant = PosBadgeVariant.success;
      case 'failed':
        label = l10n.backupStatusFailed;
        variant = PosBadgeVariant.error;
      case 'corrupted':
        label = l10n.backupStatusCorrupted;
        variant = PosBadgeVariant.error;
      default:
        label = status;
        variant = PosBadgeVariant.neutral;
    }
    return PosBadge(label: label, variant: variant, isSmall: true);
  }

  Future<void> _handleRestore(AppLocalizations l10n, BackupHistory b) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.backupConfirmRestore,
      message: l10n.backupRestoreWarning,
      confirmLabel: l10n.backupStartRestore,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed != true || !mounted) return;
    await ref.read(backupOperationProvider.notifier).restoreBackup(b.id);
    if (!mounted) return;
    final opState = ref.read(backupOperationProvider);
    if (opState is BackupOperationSuccess) {
      showPosSuccessSnackbar(context, l10n.backupRestoreInitiated);
    } else if (opState is BackupOperationError) {
      showPosErrorSnackbar(context, opState.message);
    }
  }

  Future<void> _handleVerify(AppLocalizations l10n, BackupHistory b) async {
    await ref.read(backupOperationProvider.notifier).verifyBackup(b.id);
    if (!mounted) return;
    final opState = ref.read(backupOperationProvider);
    if (opState is BackupOperationSuccess) {
      showPosSuccessSnackbar(context, l10n.backupVerifySuccess);
      _load();
    } else if (opState is BackupOperationError) {
      showPosErrorSnackbar(context, opState.message);
    }
  }

  Future<void> _handleDelete(AppLocalizations l10n, BackupHistory b) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.backupDeleteConfirmTitle,
      message: l10n.backupDeleteConfirmMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed != true || !mounted) return;
    await ref.read(backupOperationProvider.notifier).deleteBackup(b.id);
    if (!mounted) return;
    final opState = ref.read(backupOperationProvider);
    if (opState is BackupOperationSuccess) {
      showPosSuccessSnackbar(context, l10n.backupDeleteSuccess);
      _load();
    } else if (opState is BackupOperationError) {
      showPosErrorSnackbar(context, opState.message);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }
}

