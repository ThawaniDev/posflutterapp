import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/features/backup/widgets/backup_export_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_list_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_restore_wizard_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_schedule_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_storage_widget.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';

class BackupDashboardPage extends ConsumerStatefulWidget {
  const BackupDashboardPage({super.key});

  @override
  ConsumerState<BackupDashboardPage> createState() => _BackupDashboardPageState();
}

class _BackupDashboardPageState extends ConsumerState<BackupDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(backupScheduleProvider.notifier).load();
      ref.read(backupStorageProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Listen for operation state changes and show snackbars
    ref.listen<BackupOperationState>(backupOperationProvider, (prev, next) {
      if (!mounted) return;
      if (next is BackupOperationSuccess && prev is BackupOperationRunning) {
        final msg = next.data['message'] as String? ?? l10n.backupCreate;
        showPosSuccessSnackbar(context, msg);
        ref.read(backupListProvider.notifier).load();
        ref.read(backupStorageProvider.notifier).load();
      } else if (next is BackupOperationError && prev is BackupOperationRunning) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final permsState = ref.watch(userPermissionsProvider);
    final canManage = permsState.hasPermission(Permissions.backupManage);

    return PermissionGuardPage(
      permission: Permissions.backupView,
      child: PosListPage(
        title: l10n.backupTitle,
        showSearch: false,
        actions: [
          if (canManage)
            PosButton(
              label: l10n.backupNow,
              icon: Icons.cloud_upload_rounded,
              size: PosButtonSize.sm,
              onPressed: () => _showBackupNowDialog(context, l10n),
            ),
        ],
        child: Column(
          children: [
            PosTabs(
              selectedIndex: _currentTab,
              onChanged: (i) => setState(() => _currentTab = i),
              tabs: [
                PosTabItem(label: l10n.backupHistory, icon: Icons.backup_rounded),
                PosTabItem(label: l10n.backupSchedule, icon: Icons.schedule_rounded),
                PosTabItem(label: l10n.backupStorage, icon: Icons.storage_rounded),
                PosTabItem(label: l10n.backupRestoreWizard, icon: Icons.restore_rounded),
                PosTabItem(label: l10n.backupExportData, icon: Icons.download_rounded),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: const [
                  BackupListWidget(),
                  BackupScheduleWidget(),
                  BackupStorageWidget(),
                  BackupRestoreWizardWidget(),
                  BackupExportWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBackupNowDialog(BuildContext context, AppLocalizations l10n) async {
    final terminalController = TextEditingController();
    bool encrypt = false;
    String backupType = 'manual';
    bool confirmed = false;

    await showPosBottomSheet(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosBottomSheetHeader(title: l10n.backupNowTitle, subtitle: l10n.backupNowHint, showClose: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
              child: Column(
                children: [
                  PosTextField(
                    controller: terminalController,
                    label: l10n.backupTerminalId,
                    hint: 'e.g. terminal-001',
                    prefixIcon: Icons.devices_rounded,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PosDropdown<String>(
                    label: l10n.backupTypeLabel,
                    value: backupType,
                    items: [
                      DropdownMenuItem(value: 'manual', child: Text(l10n.backupTypeManual)),
                      DropdownMenuItem(value: 'pre_update', child: Text(l10n.backupTypePreUpdate)),
                    ],
                    onChanged: (v) => setDialogState(() => backupType = v ?? 'manual'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PosToggle(
                    label: l10n.backupEncryptThisBackup,
                    value: encrypt,
                    onChanged: (v) => setDialogState(() => encrypt = v),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: PosButton(
                          label: l10n.commonCancel,
                          variant: PosButtonVariant.outline,
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PosButton(
                          label: l10n.backupCreate,
                          icon: Icons.cloud_upload_rounded,
                          onPressed: () {
                            confirmed = true;
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!confirmed || !mounted) return;
    final terminalId = terminalController.text.trim();
    if (terminalId.isEmpty) {
      // ignore: use_build_context_synchronously
      showPosErrorSnackbar(context, l10n.backupTerminalId);
      return;
    }

    await ref
        .read(backupOperationProvider.notifier)
        .createBackup(terminalId: terminalId, backupType: backupType, encrypt: encrypt);
  }
}
