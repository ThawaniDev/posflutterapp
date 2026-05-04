import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/backup/models/backup_schedule_settings.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class BackupScheduleWidget extends ConsumerStatefulWidget {
  const BackupScheduleWidget({super.key});

  @override
  ConsumerState<BackupScheduleWidget> createState() => _BackupScheduleWidgetState();
}

class _BackupScheduleWidgetState extends ConsumerState<BackupScheduleWidget> {
  bool? _autoEnabled;
  String? _frequency;
  int? _retentionDays;
  bool? _encryptBackups;
  bool? _localEnabled;
  bool? _cloudEnabled;
  int? _backupHour;
  bool _isDirty = false;
  bool _isSaving = false;

  void _initFromSettings(BackupScheduleSettings s) {
    if (_isDirty) return;
    _autoEnabled = s.autoBackupEnabled;
    _frequency = s.frequency;
    _retentionDays = s.retentionDays;
    _encryptBackups = s.encryptBackups;
    _localEnabled = s.localBackupEnabled;
    _cloudEnabled = s.cloudBackupEnabled;
    _backupHour = s.backupHour;
  }

  Future<void> _save(AppLocalizations l10n) async {
    setState(() => _isSaving = true);
    try {
      await ref
          .read(backupScheduleProvider.notifier)
          .update(
            autoBackupEnabled: _autoEnabled ?? true,
            frequency: _frequency ?? 'daily',
            retentionDays: _retentionDays ?? 30,
            encryptBackups: _encryptBackups ?? false,
            localBackupEnabled: _localEnabled ?? true,
            cloudBackupEnabled: _cloudEnabled ?? true,
            backupHour: _backupHour ?? 2,
          );
      if (mounted) {
        setState(() => _isDirty = false);
        showPosSuccessSnackbar(context, l10n.backupScheduleSaved);
      }
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, l10n.backupScheduleSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(backupScheduleProvider);

    return switch (state) {
      BackupScheduleInitial() || BackupScheduleLoading() => const PosLoading(),
      BackupScheduleError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(backupScheduleProvider.notifier).load(),
      ),
      BackupScheduleLoaded(:final data) => _buildForm(context, l10n, data),
    };
  }

  Widget _buildForm(BuildContext context, AppLocalizations l10n, Map<String, dynamic> data) {
    final raw = data['data'] as Map<String, dynamic>? ?? data;
    final settings = BackupScheduleSettings.fromJson(raw);
    _initFromSettings(settings);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Info Cards Row ───────────────────────────────
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  context,
                  icon: Icons.history_rounded,
                  label: l10n.backupLastBackup,
                  value: settings.lastBackup != null ? _formatBackupRef(settings.lastBackup!) : '—',
                  iconColor: AppColors.info,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _infoCard(
                  context,
                  icon: Icons.schedule_rounded,
                  label: l10n.backupNextScheduled,
                  value: settings.nextScheduled != null ? _formatDate(settings.nextScheduled!) : '—',
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _infoCard(
                  context,
                  icon: Icons.backup_rounded,
                  label: l10n.backupTotalBackups,
                  value: '${settings.totalBackups}',
                  iconColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Settings Card ────────────────────────────────
          PosCard(
            padding: AppSpacing.paddingAll24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.backupAutoSettings, style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.xl),

                PosToggle(
                  label: l10n.backupEnableAutoBackup,
                  subtitle: l10n.backupEnableAutoBackupHint,
                  value: _autoEnabled ?? true,
                  onChanged: (v) => setState(() {
                    _autoEnabled = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),

                PosDropdown<String>(
                  label: l10n.backupSchedule,
                  value: _frequency ?? 'daily',
                  items: [
                    DropdownMenuItem(value: 'hourly', child: Text(l10n.backupFrequencyHourly)),
                    DropdownMenuItem(value: 'daily', child: Text(l10n.backupFrequencyDaily)),
                    DropdownMenuItem(value: 'weekly', child: Text(l10n.backupFrequencyWeekly)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _frequency = v;
                        _isDirty = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.backupRetentionDays, style: AppTypography.bodyMedium),
                          const SizedBox(height: AppSpacing.sm),
                          PosNumericCounter(
                            value: _retentionDays ?? 30,
                            min: 1,
                            max: 365,
                            step: 1,
                            onChanged: (v) => setState(() {
                              _retentionDays = v;
                              _isDirty = true;
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.backupBackupHour, style: AppTypography.bodyMedium),
                          const SizedBox(height: AppSpacing.sm),
                          PosNumericCounter(
                            value: _backupHour ?? 2,
                            min: 0,
                            max: 23,
                            step: 1,
                            onChanged: (v) => setState(() {
                              _backupHour = v;
                              _isDirty = true;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                const PosDivider(),
                const SizedBox(height: AppSpacing.lg),

                PosToggle(
                  label: l10n.backupLocalEnabled,
                  value: _localEnabled ?? true,
                  onChanged: (v) => setState(() {
                    _localEnabled = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                PosToggle(
                  label: l10n.backupCloudEnabled,
                  value: _cloudEnabled ?? true,
                  onChanged: (v) => setState(() {
                    _cloudEnabled = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                PosToggle(
                  label: l10n.backupEncrypt,
                  value: _encryptBackups ?? false,
                  onChanged: (v) => setState(() {
                    _encryptBackups = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  width: double.infinity,
                  child: PosButton(
                    label: l10n.backupSaveSchedule,
                    icon: Icons.save_outlined,
                    isLoading: _isSaving,
                    isFullWidth: true,
                    onPressed: _isDirty ? () => _save(l10n) : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.titleSmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatBackupRef(Map<String, dynamic> b) {
    final status = b['status'] as String? ?? '';
    final size = (b['file_size_bytes'] as num?)?.toInt() ?? 0;
    return '$status • ${_formatBytes(size)}';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
