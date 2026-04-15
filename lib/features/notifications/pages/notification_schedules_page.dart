import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/models/notification_schedule.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';

class NotificationSchedulesPage extends ConsumerStatefulWidget {
  const NotificationSchedulesPage({super.key});

  @override
  ConsumerState<NotificationSchedulesPage> createState() => _NotificationSchedulesPageState();
}

class _NotificationSchedulesPageState extends ConsumerState<NotificationSchedulesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(schedulesProvider.notifier).load());
  }

  void _showCreateDialog() {
    final l10n = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    String category = 'system';
    String priority = 'normal';
    String channel = 'in_app';
    String scheduleType = 'once';
    DateTime scheduledAt = DateTime.now().add(const Duration(hours: 1));

    showPosFullScreenDialog(
      context,
      title: l10n.notifScheduleCreate,
      body: StatefulBuilder(
        builder: (ctx, setDialogState) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.base),
          children: [
            PosTextField(controller: titleCtrl, label: l10n.notifScheduleTitle),
            AppSpacing.gapH12,
            PosTextField(controller: messageCtrl, label: l10n.notifScheduleMessage, maxLines: 3),
            AppSpacing.gapH12,
            PosSearchableDropdown<String>(
              items: [
                'order',
                'inventory',
                'promotion',
                'system',
                'payment',
                'staff',
              ].map((c) => PosDropdownItem(value: c, label: _localizedCategory(l10n, c))).toList(),
              selectedValue: category,
              onChanged: (v) => setDialogState(() => category = v ?? category),
              label: l10n.notifScheduleCategory,
              showSearch: false,
              clearable: false,
            ),
            AppSpacing.gapH12,
            PosSearchableDropdown<String>(
              items: [
                'low',
                'normal',
                'high',
                'urgent',
              ].map((p) => PosDropdownItem(value: p, label: _localizedPriority(l10n, p))).toList(),
              selectedValue: priority,
              onChanged: (v) => setDialogState(() => priority = v ?? priority),
              label: l10n.notifSchedulePriority,
              showSearch: false,
              clearable: false,
            ),
            AppSpacing.gapH12,
            PosSearchableDropdown<String>(
              items: [
                'in_app',
                'push',
                'email',
              ].map((c) => PosDropdownItem(value: c, label: _localizedChannel(l10n, c))).toList(),
              selectedValue: channel,
              onChanged: (v) => setDialogState(() => channel = v ?? channel),
              label: l10n.notifScheduleChannel,
              showSearch: false,
              clearable: false,
            ),
            AppSpacing.gapH12,
            PosSearchableDropdown<String>(
              items: ['once', 'recurring'].map((t) => PosDropdownItem(value: t, label: _localizedScheduleType(l10n, t))).toList(),
              selectedValue: scheduleType,
              onChanged: (v) => setDialogState(() => scheduleType = v ?? scheduleType),
              label: l10n.notifScheduleType,
              showSearch: false,
              clearable: false,
            ),
            AppSpacing.gapH12,
            PosCard(
              padding: AppSpacing.paddingAll16,
              onTap: () async {
                final date = await showDatePicker(
                  context: ctx,
                  initialDate: scheduledAt,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null && ctx.mounted) {
                  final time = await showTimePicker(context: ctx, initialTime: TimeOfDay.fromDateTime(scheduledAt));
                  if (time != null) {
                    setDialogState(() {
                      scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    });
                  }
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: AppSizes.iconMd),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.notifScheduleDateTime, style: AppTypography.labelMedium),
                        AppSpacing.gapH4,
                        Text(
                          '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year} ${scheduledAt.hour}:${scheduledAt.minute.toString().padLeft(2, '0')}',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_rounded, size: 16),
                ],
              ),
            ),
            AppSpacing.gapH24,
            PosButton(
              label: l10n.notifScheduleCreateBtn,
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty || messageCtrl.text.trim().isEmpty) {
                  showPosErrorSnackbar(context, l10n.notifScheduleValidation);
                  return;
                }
                ref
                    .read(schedulesProvider.notifier)
                    .create(
                      category: category,
                      title: titleCtrl.text.trim(),
                      message: messageCtrl.text.trim(),
                      channel: channel,
                      priority: priority,
                      scheduledAt: scheduledAt.toIso8601String(),
                      scheduleType: scheduleType,
                    );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(schedulesProvider);

    ref.listen<SchedulesState>(schedulesProvider, (prev, next) {
      if (prev is SchedulesLoading && next is SchedulesLoaded) {
        showPosSuccessSnackbar(context, l10n.notifScheduleCreatedSuccess);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifSchedulesTitle),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () => ref.read(schedulesProvider.notifier).load()),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showCreateDialog, child: const Icon(Icons.add_rounded)),
      body: switch (state) {
        SchedulesInitial() || SchedulesLoading() => const Center(child: PosLoading()),
        SchedulesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(schedulesProvider.notifier).load(),
        ),
        SchedulesLoaded(:final schedules) =>
          schedules.isEmpty
              ? PosEmptyState(
                  title: l10n.notifSchedulesEmpty,
                  subtitle: l10n.notifSchedulesEmptySubtitle,
                  icon: Icons.schedule_rounded,
                  actionLabel: l10n.notifScheduleCreate,
                  onAction: _showCreateDialog,
                )
              : RefreshIndicator(
                  onRefresh: () async => ref.read(schedulesProvider.notifier).load(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                    itemCount: schedules.length,
                    separatorBuilder: (_, __) => AppSpacing.gapH8,
                    itemBuilder: (context, index) => _buildScheduleCard(schedules[index], isDark),
                  ),
                ),
      },
    );
  }

  Widget _buildScheduleCard(NotificationSchedule schedule, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final isCancelled = schedule.isCancelled;
    final isSent = schedule.isSent;

    PosBadgeVariant statusVariant;
    String statusLabel;
    if (isCancelled) {
      statusVariant = PosBadgeVariant.error;
      statusLabel = l10n.notifScheduleCancelled;
    } else if (isSent) {
      statusVariant = PosBadgeVariant.success;
      statusLabel = l10n.notifScheduleSent;
    } else {
      statusVariant = PosBadgeVariant.warning;
      statusLabel = l10n.notifSchedulePending;
    }

    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(schedule.title, style: AppTypography.titleMedium)),
              PosBadge(label: statusLabel, variant: statusVariant, isSmall: true),
            ],
          ),
          AppSpacing.gapH4,
          Text(
            schedule.message,
            style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          AppSpacing.gapH8,
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.gapW4,
              Text(
                '${schedule.scheduledAt.day}/${schedule.scheduledAt.month}/${schedule.scheduledAt.year} ${schedule.scheduledAt.hour}:${schedule.scheduledAt.minute.toString().padLeft(2, '0')}',
                style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              const Spacer(),
              PosBadge(label: _localizedCategory(l10n, schedule.category), variant: PosBadgeVariant.neutral, isSmall: true),
              if (schedule.scheduleType != null) ...[
                AppSpacing.gapW4,
                PosBadge(
                  label: _localizedScheduleType(l10n, schedule.scheduleType!),
                  variant: PosBadgeVariant.info,
                  isSmall: true,
                ),
              ],
              if (schedule.priority != null && schedule.priority != 'normal') ...[
                AppSpacing.gapW4,
                PosBadge(
                  label: _localizedPriority(l10n, schedule.priority!),
                  variant: _priorityBadgeVariant(schedule.priority!),
                  isSmall: true,
                ),
              ],
            ],
          ),
          if (!isCancelled && !isSent) ...[
            AppSpacing.gapH8,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                icon: const Icon(Icons.cancel_outlined, size: 16),
                label: Text(l10n.notifScheduleCancelBtn),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () async {
                  final confirmed = await showPosConfirmDialog(
                    context,
                    title: l10n.notifScheduleCancelConfirmTitle,
                    message: l10n.notifScheduleCancelConfirmMessage,
                    confirmLabel: l10n.notifScheduleCancelBtn,
                    isDanger: true,
                  );
                  if (confirmed == true) {
                    ref.read(schedulesProvider.notifier).cancel(schedule.id);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  PosBadgeVariant _priorityBadgeVariant(String priority) {
    return switch (priority) {
      'urgent' => PosBadgeVariant.error,
      'high' => PosBadgeVariant.warning,
      'low' => PosBadgeVariant.neutral,
      _ => PosBadgeVariant.info,
    };
  }

  String _localizedCategory(AppLocalizations l10n, String cat) {
    return switch (cat) {
      'order' => l10n.notifCategoryOrder,
      'inventory' => l10n.notifCategoryInventory,
      'promotion' => l10n.notifCategoryPromotion,
      'system' => l10n.notifCategorySystem,
      'payment' => l10n.notifCategoryPayment,
      'staff' => l10n.notifCategoryStaff,
      _ => cat.isNotEmpty ? '${cat[0].toUpperCase()}${cat.substring(1)}' : cat,
    };
  }

  String _localizedPriority(AppLocalizations l10n, String priority) {
    return switch (priority) {
      'urgent' => l10n.notifPriorityUrgent,
      'high' => l10n.notifPriorityHigh,
      'low' => l10n.notifPriorityLow,
      _ => l10n.notifPriorityNormal,
    };
  }

  String _localizedChannel(AppLocalizations l10n, String channel) {
    return switch (channel) {
      'in_app' => l10n.notificationsInApp,
      'push' => l10n.notificationsPush,
      'email' => l10n.notifPrefEmail,
      _ => channel,
    };
  }

  String _localizedScheduleType(AppLocalizations l10n, String type) {
    return switch (type) {
      'once' => l10n.notifScheduleTypeOnce,
      'recurring' => l10n.notifScheduleTypeRecurring,
      _ => type,
    };
  }
}
