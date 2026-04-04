import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/notifications/models/notification_schedule.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

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
    DateTime scheduledAt = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.notifScheduleCreate),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(labelText: l10n.notifScheduleTitle, border: const OutlineInputBorder()),
                ),
                AppSpacing.gapH8,
                TextField(
                  controller: messageCtrl,
                  decoration: InputDecoration(labelText: l10n.notifScheduleMessage, border: const OutlineInputBorder()),
                  maxLines: 3,
                ),
                AppSpacing.gapH8,
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(labelText: l10n.notifScheduleCategory, border: const OutlineInputBorder()),
                  items: [
                    'order',
                    'inventory',
                    'promotion',
                    'system',
                    'payment',
                    'staff',
                  ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setDialogState(() => category = v!),
                ),
                AppSpacing.gapH8,
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(labelText: l10n.notifSchedulePriority, border: const OutlineInputBorder()),
                  items: ['low', 'normal', 'high', 'urgent'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (v) => setDialogState(() => priority = v!),
                ),
                AppSpacing.gapH8,
                DropdownButtonFormField<String>(
                  value: channel,
                  decoration: InputDecoration(labelText: l10n.notifScheduleChannel, border: const OutlineInputBorder()),
                  items: ['in_app', 'push', 'email'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setDialogState(() => channel = v!),
                ),
                AppSpacing.gapH8,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.notifScheduleDateTime),
                  subtitle: Text(
                    '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year} ${scheduledAt.hour}:${scheduledAt.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: scheduledAt,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(context: ctx, initialTime: TimeOfDay.fromDateTime(scheduledAt));
                      if (time != null) {
                        setDialogState(() {
                          scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.notifScheduleCancel)),
            FilledButton(
              onPressed: () {
                ref
                    .read(schedulesProvider.notifier)
                    .create(
                      category: category,
                      title: titleCtrl.text,
                      message: messageCtrl.text,
                      channel: channel,
                      priority: priority,
                      scheduledAt: scheduledAt.toIso8601String(),
                    );
                Navigator.pop(ctx);
              },
              child: Text(l10n.notifScheduleCreateBtn),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(schedulesProvider);

    ref.listen<SchedulesState>(schedulesProvider, (prev, next) {
      if (prev is SchedulesLoading && next is SchedulesLoaded) {
        // Refreshed
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifSchedulesTitle),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(schedulesProvider.notifier).load())],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showCreateDialog, child: const Icon(Icons.add)),
      body: switch (state) {
        SchedulesInitial() || SchedulesLoading() => Center(child: PosLoadingSkeleton.list()),
        SchedulesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(schedulesProvider.notifier).load(),
        ),
        SchedulesLoaded(:final schedules) =>
          schedules.isEmpty
              ? PosEmptyState(title: l10n.notifSchedulesEmpty, icon: Icons.schedule)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) => _buildScheduleCard(schedules[index]),
                ),
      },
    );
  }

  Widget _buildScheduleCard(NotificationSchedule schedule) {
    final l10n = AppLocalizations.of(context)!;
    final isCancelled = schedule.isCancelled;
    final isSent = schedule.sentAt != null;

    Color statusColor;
    String statusLabel;
    if (isCancelled) {
      statusColor = AppColors.error;
      statusLabel = l10n.notifScheduleCancelled;
    } else if (isSent) {
      statusColor = AppColors.success;
      statusLabel = l10n.notifScheduleSent;
    } else {
      statusColor = AppColors.warning;
      statusLabel = l10n.notifSchedulePending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(schedule.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    statusLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH4,
            Text(schedule.message, style: TextStyle(color: AppColors.textSecondary)),
            AppSpacing.gapH8,
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                AppSpacing.gapW4,
                Text(
                  '${schedule.scheduledAt.day}/${schedule.scheduledAt.month}/${schedule.scheduledAt.year} ${schedule.scheduledAt.hour}:${schedule.scheduledAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const Spacer(),
                Chip(
                  label: Text(schedule.category, style: const TextStyle(fontSize: 10)),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                AppSpacing.gapW4,
                if (schedule.priority != null && schedule.priority != 'normal')
                  Chip(
                    label: Text(schedule.priority!, style: const TextStyle(fontSize: 10)),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: _priorityColor(schedule.priority!).withValues(alpha: 0.12),
                  ),
              ],
            ),
            if (!isCancelled && !isSent) ...[
              AppSpacing.gapH8,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: Text(l10n.notifScheduleCancelBtn),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  onPressed: () => ref.read(schedulesProvider.notifier).cancel(schedule.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
    return switch (priority) {
      'urgent' => AppColors.error,
      'high' => AppColors.warning,
      'low' => AppColors.textSecondary,
      _ => AppColors.info,
    };
  }
}
