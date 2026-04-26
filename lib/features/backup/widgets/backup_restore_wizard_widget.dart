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

class BackupRestoreWizardWidget extends ConsumerStatefulWidget {
  const BackupRestoreWizardWidget({super.key});

  @override
  ConsumerState<BackupRestoreWizardWidget> createState() => _BackupRestoreWizardWidgetState();
}

class _BackupRestoreWizardWidgetState extends ConsumerState<BackupRestoreWizardWidget> {
  int _step = 0;
  BackupHistory? _selected;
  bool _createPreBackup = true;
  bool _verifyDone = false;
  bool _isVerifying = false;
  bool _isRestoring = false;
  Map<String, dynamic>? _restoreResult;
  String? _restoreError;

  static const int _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(backupListProvider.notifier).load(status: 'completed'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(backupListProvider);

    return Column(
      children: [
        _buildStepIndicator(context, l10n),
        Expanded(
          child: switch (_step) {
            0 => _buildStepSelectBackup(context, l10n, listState),
            1 => _buildStepVerify(context, l10n),
            2 => _buildStepConfirm(context, l10n),
            3 => _buildStepProgress(context, l10n),
            4 => _buildStepComplete(context, l10n),
            _ => const SizedBox.shrink(),
          },
        ),
        _buildNavBar(context, l10n),
      ],
    );
  }

  // ── Step Indicator ───────────────────────────────────────

  Widget _buildStepIndicator(BuildContext context, AppLocalizations l10n) {
    final labels = [
      l10n.backupRestoreStep1,
      l10n.backupRestoreStep2,
      l10n.backupRestoreStep3,
      l10n.backupRestoreStep4,
      l10n.backupRestoreStep5,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Row(
        children: List.generate(_totalSteps * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            final isCompleted = _step > stepIdx;
            return Expanded(child: Container(height: 2, color: isCompleted ? AppColors.primary : AppColors.borderFor(context)));
          }
          final stepIdx = i ~/ 2;
          final isActive = _step == stepIdx;
          final isCompleted = _step > stepIdx;
          final color = isCompleted || isActive ? AppColors.primary : AppColors.borderFor(context);
          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary
                      : isActive
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.borderFor(context),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${stepIdx + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            color: isActive ? AppColors.primary : AppColors.mutedFor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[stepIdx],
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.primary : AppColors.mutedFor(context),
                  fontSize: 10,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── Step 1: Select Backup ────────────────────────────────

  Widget _buildStepSelectBackup(BuildContext context, AppLocalizations l10n, BackupListState listState) {
    if (listState is BackupListLoading || listState is BackupListInitial) {
      return const PosLoading();
    }
    if (listState is BackupListError) {
      return PosErrorState(
        message: listState.message,
        onRetry: () => ref.read(backupListProvider.notifier).load(status: 'completed'),
      );
    }

    final data = (listState as BackupListLoaded).data;
    final rawBackups = data['data']?['backups'] as List? ?? (data['backups'] as List? ?? []);
    final backups =
        rawBackups.whereType<Map<String, dynamic>>().map(BackupHistory.fromJson).where((b) => b.status == 'completed').toList()
          ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

    if (backups.isEmpty) {
      return PosEmptyState(
        icon: Icons.cloud_off_outlined,
        title: l10n.backupSelectForRestore,
        subtitle: l10n.backupOnlyCompletedRestore,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.backupSelectForRestore, style: AppTypography.titleMedium),
          Text(l10n.backupOnlyCompletedRestore, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
          const SizedBox(height: AppSpacing.lg),
          ...backups.map((b) {
            final isSelected = _selected?.id == b.id;
            return GestureDetector(
              onTap: () => setState(() => _selected = b),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.07)
                      : (Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight),
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderFor(context),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : AppColors.mutedFor(context),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              PosBadge(label: b.backupType, variant: PosBadgeVariant.primary, isSmall: true),
                              const SizedBox(width: AppSpacing.sm),
                              if (b.isVerified)
                                PosBadge(
                                  label: l10n.backupVerified,
                                  variant: PosBadgeVariant.success,
                                  isSmall: true,
                                  icon: Icons.verified_outlined,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(b.createdAt != null ? _formatDate(b.createdAt!) : '—', style: AppTypography.bodyMedium),
                          Text(
                            '${_formatBytes(b.fileSizeBytes)} • ${b.recordsCount} ${l10n.backupRecordsCount(b.recordsCount.toString()).replaceAll(b.recordsCount.toString(), '').trim()}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Step 2: Verify ───────────────────────────────────────

  Widget _buildStepVerify(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: PosCard(
        padding: AppSpacing.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.backupVerifyStep, style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.backupChecksum, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
            const SizedBox(height: AppSpacing.xl),

            _infoRow(context, l10n.backupChecksum, _selected?.checksum?.substring(0, 16) ?? '—'),
            _infoRow(context, l10n.backupDbVersion, '${_selected?.dbVersion ?? '—'}'),
            _infoRow(context, l10n.backupColSize, _formatBytes(_selected?.fileSizeBytes ?? 0)),
            _infoRow(context, l10n.backupEncrypted, _selected?.isEncrypted == true ? l10n.commonYes : l10n.commonNo),

            const SizedBox(height: AppSpacing.xl),

            if (_verifyDone)
              Container(
                padding: AppSpacing.paddingAll12,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.10),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.30)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(l10n.backupVerifySuccess, style: AppTypography.bodyMedium.copyWith(color: AppColors.success)),
                  ],
                ),
              )
            else
              PosButton(
                label: l10n.backupVerifyStep,
                icon: Icons.verified_outlined,
                isLoading: _isVerifying,
                onPressed: () => _doVerify(l10n),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _doVerify(AppLocalizations l10n) async {
    if (_selected == null) return;
    setState(() => _isVerifying = true);
    await ref.read(backupOperationProvider.notifier).verifyBackup(_selected!.id);
    final opState = ref.read(backupOperationProvider);
    if (mounted) {
      if (opState is BackupOperationSuccess) {
        setState(() {
          _verifyDone = true;
          _isVerifying = false;
        });
      } else if (opState is BackupOperationError) {
        setState(() => _isVerifying = false);
        showPosErrorSnackbar(context, opState.message);
      }
    }
  }

  // ── Step 3: Confirm ──────────────────────────────────────

  Widget _buildStepConfirm(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.30)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(l10n.backupRestoreWarning, style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          PosCard(
            padding: AppSpacing.paddingAll20,
            child: Column(
              children: [
                _infoRow(context, l10n.backupColType, _selected?.backupType ?? '—'),
                _infoRow(context, l10n.backupColDate, _selected?.createdAt != null ? _formatDate(_selected!.createdAt!) : '—'),
                _infoRow(context, l10n.backupColSize, _formatBytes(_selected?.fileSizeBytes ?? 0)),
                _infoRow(context, l10n.backupRecordsCount(''), '${_selected?.recordsCount ?? 0}'),
                _infoRow(context, l10n.backupDbVersion, '${_selected?.dbVersion ?? '—'}'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          PosCheckboxTile(
            label: l10n.backupCreatePreRestoreBackup,
            value: _createPreBackup,
            onChanged: (v) => setState(() => _createPreBackup = v ?? true),
          ),
        ],
      ),
    );
  }

  // ── Step 4: Progress ─────────────────────────────────────

  Widget _buildStepProgress(BuildContext context, AppLocalizations l10n) {
    final estimated = _selected != null ? (_selected!.recordsCount / 2000).ceil().clamp(5, 300) : 30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _restoreError == null && !_isRestoring ? 1.0 : null),
            duration: Duration(seconds: estimated),
            builder: (context, value, _) => Column(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.borderMd,
                  child: LinearProgressIndicator(
                    value: _restoreError != null ? 0 : (_isRestoring ? null : value),
                    minHeight: 8,
                    backgroundColor: AppColors.borderFor(context),
                    color: _restoreError != null ? AppColors.error : AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.backupRestoreProgress, style: AppTypography.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${l10n.backupEstimatedDuration}: ${l10n.backupEstimatedDurationSeconds('$estimated')}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 5: Complete ─────────────────────────────────────

  Widget _buildStepComplete(BuildContext context, AppLocalizations l10n) {
    final isSuccess = _restoreError == null;
    final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;
    final color = isSuccess ? AppColors.success : AppColors.error;
    final title = isSuccess ? l10n.backupRestoreComplete : l10n.backupRestoreFailed;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.10), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: AppTypography.headlineMedium.copyWith(color: color)),
          const SizedBox(height: AppSpacing.md),
          if (isSuccess)
            Text(
              _restoreResult?['message'] as String? ?? l10n.backupRestoreInitiated,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
              textAlign: TextAlign.center,
            )
          else
            Text(
              _restoreError ?? '',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: AppSpacing.xxxl),
          PosButton(
            label: l10n.commonDone,
            onPressed: () => setState(() {
              _step = 0;
              _selected = null;
              _verifyDone = false;
              _restoreResult = null;
              _restoreError = null;
            }),
          ),
        ],
      ),
    );
  }

  // ── Navigation bar ───────────────────────────────────────

  Widget _buildNavBar(BuildContext context, AppLocalizations l10n) {
    if (_step == 4) return const SizedBox.shrink();

    final canNext = switch (_step) {
      0 => _selected != null,
      1 => _verifyDone,
      2 => true,
      3 => false,
      _ => false,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Row(
        children: [
          if (_step > 0 && _step < 3)
            PosButton(
              label: l10n.commonBack,
              variant: PosButtonVariant.outline,
              icon: Icons.arrow_back,
              onPressed: () => setState(() => _step--),
            ),
          const Spacer(),
          if (_step < 3)
            PosButton(
              label: _step == 2 ? l10n.backupStartRestore : l10n.commonNext,
              trailingIcon: Icons.arrow_forward,
              onPressed: canNext ? () => _handleNext(l10n) : null,
            ),
        ],
      ),
    );
  }

  Future<void> _handleNext(AppLocalizations l10n) async {
    if (_step == 2) {
      setState(() {
        _step = 3;
        _isRestoring = true;
      });
      await ref.read(backupOperationProvider.notifier).restoreBackup(_selected!.id);
      final opState = ref.read(backupOperationProvider);
      if (mounted) {
        if (opState is BackupOperationSuccess) {
          setState(() {
            _restoreResult = opState.data;
            _isRestoring = false;
            _step = 4;
          });
        } else if (opState is BackupOperationError) {
          setState(() {
            _restoreError = opState.message;
            _isRestoring = false;
            _step = 4;
          });
        }
      }
    } else {
      setState(() => _step++);
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
          ),
          Expanded(flex: 3, child: Text(value, style: AppTypography.bodyMedium)),
        ],
      ),
    );
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
