import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BackupStorageWidget extends ConsumerWidget {
  const BackupStorageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(backupStorageProvider);

    return switch (state) {
      BackupStorageInitial() || BackupStorageLoading() => const PosLoading(),
      BackupStorageError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(backupStorageProvider.notifier).load(),
      ),
      BackupStorageLoaded(:final data) => _buildContent(context, l10n, data),
    };
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n, Map<String, dynamic> data) {
    final d = data['data'] as Map<String, dynamic>? ?? data;
    final totalBytes = (d['total_backup_bytes'] as num?)?.toInt() ?? 0;
    final quotaBytes = (d['quota_bytes'] as num?)?.toInt() ?? 1;
    final usagePct = (d['usage_percentage'] != null ? double.tryParse(d['usage_percentage'].toString()) : null) ?? 0.0;
    final backupCount = (d['backup_count'] as num?)?.toInt() ?? 0;
    final byTypeRaw = d['by_type'] as List? ?? [];
    final byTypeList = byTypeRaw.whereType<Map<String, dynamic>>().toList();
    final recentBackups = d['recent_backups'] as List? ?? [];

    final progressColor = usagePct >= 90
        ? AppColors.error
        : usagePct >= 70
        ? AppColors.warning
        : AppColors.success;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── KPI cards ───────────────────────────────────
          Row(
            children: [
              Expanded(
                child: PosKpiCard(
                  label: l10n.backupTotalSize,
                  value: _formatBytes(totalBytes),
                  icon: Icons.storage_rounded,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primary.withValues(alpha: 0.10),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PosKpiCard(
                  label: l10n.backupTotalBackups,
                  value: '$backupCount',
                  icon: Icons.backup_rounded,
                  iconColor: AppColors.info,
                  iconBgColor: AppColors.info.withValues(alpha: 0.10),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PosKpiCard(
                  label: l10n.backupUsagePercent,
                  value: '${usagePct.toStringAsFixed(1)}%',
                  icon: Icons.pie_chart_rounded,
                  iconColor: progressColor,
                  iconBgColor: progressColor.withValues(alpha: 0.10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Usage bar ────────────────────────────────────
          PosCard(
            padding: AppSpacing.paddingAll20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.backupStorageUsed, style: AppTypography.titleMedium),
                    Text(
                      '${_formatBytes(totalBytes)} / ${_formatBytes(quotaBytes)}',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: (usagePct / 100).clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: AppRadius.borderMd,
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: AppColors.borderFor(context),
                      color: progressColor,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${usagePct.toStringAsFixed(1)}% ${l10n.backupQuota.toLowerCase()}',
                  style: AppTypography.bodySmall.copyWith(color: progressColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── By type breakdown ────────────────────────────
          if (byTypeList.isNotEmpty) ...[
            Text(l10n.backupByType, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            PosCard(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: byTypeList.map((item) {
                  final typeName = item['type'] as String? ?? '';
                  final typeBytes = (item['size_bytes'] as num?)?.toInt() ?? 0;
                  final typeCount = (item['count'] as num?)?.toInt() ?? 0;
                  final pct = totalBytes > 0 ? typeBytes / totalBytes : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        SizedBox(width: 100, child: Text(_typeLabel(context, typeName), style: AppTypography.bodyMedium)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.borderMd,
                            child: LinearProgressIndicator(
                              value: pct.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.borderFor(context),
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '$typeCount × ${_formatBytes(typeBytes ~/ (typeCount > 0 ? typeCount : 1))}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Recent backups ───────────────────────────────
          if (recentBackups.isNotEmpty) ...[
            Text(l10n.backupRecentBackups, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            PosCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: recentBackups.take(5).toList().asMap().entries.map((e) {
                  final b = e.value as Map<String, dynamic>;
                  final isLast = e.key == recentBackups.take(5).length - 1;
                  final type = b['backup_type'] as String? ?? 'manual';
                  final status = b['status'] as String? ?? '';
                  final size = (b['file_size_bytes'] as num?)?.toInt() ?? 0;
                  final createdAt = b['created_at'] != null ? DateTime.tryParse(b['created_at'] as String) : null;
                  final statusColor = status == 'completed'
                      ? AppColors.success
                      : status == 'failed'
                      ? AppColors.error
                      : AppColors.warning;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
                          child: Icon(Icons.backup_rounded, color: statusColor, size: 18),
                        ),
                        title: Text(
                          '${type[0].toUpperCase()}${type.substring(1)} — ${_formatBytes(size)}',
                          style: AppTypography.bodyMedium,
                        ),
                        subtitle: Text(
                          createdAt != null ? _formatDate(createdAt) : '—',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                        ),
                        trailing: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ),
                      ),
                      if (!isLast) PosDivider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    switch (type) {
      case 'auto':
        return AppLocalizations.of(context)!.backupTypeAuto;
      case 'manual':
        return AppLocalizations.of(context)!.backupTypeManual;
      case 'pre_update':
        return AppLocalizations.of(context)!.backupTypePreUpdate;
      default:
        return type;
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
