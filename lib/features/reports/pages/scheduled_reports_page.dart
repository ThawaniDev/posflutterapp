import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ScheduledReportsPage extends ConsumerStatefulWidget {
  const ScheduledReportsPage({super.key});

  @override
  ConsumerState<ScheduledReportsPage> createState() => _ScheduledReportsPageState();
}

class _ScheduledReportsPageState extends ConsumerState<ScheduledReportsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduledReportsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduledReportsProvider);

    return PermissionGuardPage(
      permission: Permissions.reportsView,
      child: PosListPage(
        title: l10n.reportsScheduledTitle,
        showSearch: false,
        actions: [
          PosButton.icon(
            icon: Icons.add_rounded,
            onPressed: () => _showCreateSheet(context),
          ),
        ],
        child: switch (state) {
          ScheduledReportsInitial() || ScheduledReportsLoading() => PosLoadingSkeleton.list(),
          ScheduledReportsError(:final message) => PosErrorState(
            message: message,
            onRetry: () => ref.read(scheduledReportsProvider.notifier).load(),
          ),
          ScheduledReportsLoaded(:final schedules) => schedules.isEmpty
              ? PosEmptyState(title: l10n.reportsScheduledEmpty, icon: Icons.schedule)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _ScheduleCard(
                    schedule: schedules[i],
                    onDelete: () => _confirmDelete(context, schedules[i]),
                  ),
                ),
        },
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateScheduleSheet(
        onCreated: () => ref.read(scheduledReportsProvider.notifier).load(),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Map<String, dynamic> schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.reportsScheduledDelete),
        content: Text(l10n.reportsScheduledDeleteConfirm(schedule['name'] as String? ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(scheduledReportsProvider.notifier).delete(schedule['id'] as String);
    }
  }
}

// ─── Schedule Card ───────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.schedule, required this.onDelete});
  final Map<String, dynamic> schedule;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isActive = schedule['is_active'] as bool? ?? true;
    final frequency = schedule['frequency'] as String? ?? '';
    final nextRun = schedule['next_run_at'] as String?;
    final lastRun = schedule['last_run_at'] as String?;
    final reportType = (schedule['report_type'] as String? ?? '').replaceAll('_', ' ');
    final format = (schedule['format'] as String? ?? 'pdf').toUpperCase();
    final recipients = (schedule['recipients'] as List?)?.cast<String>() ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderFor(context)),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['name'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reportType.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isActive ? AppColors.success : AppColors.textMutedLight).withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderSm,
                ),
                child: Text(
                  isActive ? l10n.active : l10n.inactive,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.success : AppColors.textMutedLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _InfoChip(icon: Icons.repeat_rounded, label: _frequencyLabel(l10n, frequency)),
              _InfoChip(icon: Icons.picture_as_pdf_rounded, label: format),
              if (nextRun != null) _InfoChip(icon: Icons.schedule_rounded, label: l10n.reportsScheduledNext(nextRun.substring(0, 10))),
              if (lastRun != null) _InfoChip(icon: Icons.history_rounded, label: l10n.reportsScheduledLast(lastRun.substring(0, 10))),
            ],
          ),
          if (recipients.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              l10n.reportsScheduledRecipients,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedFor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recipients.join(', '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _frequencyLabel(AppLocalizations l10n, String frequency) {
    return switch (frequency) {
      'daily' => l10n.reportsScheduledDaily,
      'weekly' => l10n.reportsScheduledWeekly,
      'monthly' => l10n.reportsScheduledMonthly,
      _ => frequency,
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.borderFor(context).withValues(alpha: 0.5),
        borderRadius: AppRadius.borderSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.mutedFor(context)),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
        ],
      ),
    );
  }
}

// ─── Create Schedule Sheet ───────────────────────────────────

class _CreateScheduleSheet extends ConsumerStatefulWidget {
  const _CreateScheduleSheet({required this.onCreated});
  final VoidCallback onCreated;

  @override
  ConsumerState<_CreateScheduleSheet> createState() => _CreateScheduleSheetState();
}

class _CreateScheduleSheetState extends ConsumerState<_CreateScheduleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _recipientsCtrl = TextEditingController();

  String _reportType = 'sales_summary';
  String _frequency = 'daily';
  String _format = 'pdf';
  bool _isSubmitting = false;

  static const _reportTypes = [
    'sales_summary', 'product_performance', 'category_breakdown',
    'staff_performance', 'slow_movers', 'product_margin',
    'inventory_valuation', 'inventory_low_stock', 'inventory_expiry',
    'financial_pl', 'financial_expenses', 'financial_delivery_commission',
    'top_customers',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _recipientsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderFor(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.reportsScheduledCreate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                // Name
                PosTextField(
                  controller: _nameCtrl,
                  label: l10n.reportsScheduledName,
                  validator: (v) => (v?.trim().isEmpty ?? true) ? l10n.fieldRequired : null,
                ),
                const SizedBox(height: 16),

                // Report type
                Text(l10n.reportsType, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _reportType,
                  decoration: const InputDecoration(isDense: true),
                  items: _reportTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').toUpperCase()))).toList(),
                  onChanged: (v) => setState(() => _reportType = v ?? _reportType),
                ),
                const SizedBox(height: 16),

                // Frequency
                Text(
                  l10n.reportsScheduledFrequency,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _FrequencyButton(
                      label: l10n.reportsScheduledDaily,
                      value: 'daily',
                      groupValue: _frequency,
                      onChanged: (v) => setState(() => _frequency = v),
                    ),
                    const SizedBox(width: 8),
                    _FrequencyButton(
                      label: l10n.reportsScheduledWeekly,
                      value: 'weekly',
                      groupValue: _frequency,
                      onChanged: (v) => setState(() => _frequency = v),
                    ),
                    const SizedBox(width: 8),
                    _FrequencyButton(
                      label: l10n.reportsScheduledMonthly,
                      value: 'monthly',
                      groupValue: _frequency,
                      onChanged: (v) => setState(() => _frequency = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Format
                Text(
                  l10n.reportsScheduledFormat,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _FrequencyButton(
                      label: l10n.reportsExportPdf,
                      value: 'pdf',
                      groupValue: _format,
                      onChanged: (v) => setState(() => _format = v),
                    ),
                    const SizedBox(width: 8),
                    _FrequencyButton(
                      label: l10n.reportsExportCsv,
                      value: 'csv',
                      groupValue: _format,
                      onChanged: (v) => setState(() => _format = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Recipients
                PosTextField(
                  controller: _recipientsCtrl,
                  label: l10n.reportsScheduledRecipients,
                  hint: 'email1@example.com, email2@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v?.trim().isEmpty ?? true) return l10n.fieldRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: _isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : PosButton(
                          label: l10n.reportsScheduledCreate,
                          onPressed: _submit,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      final emails = _recipientsCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await ref.read(scheduledReportsProvider.notifier).create(
        reportType: _reportType,
        name: _nameCtrl.text.trim(),
        frequency: _frequency,
        recipients: emails,
        format: _format,
      );
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCreated();
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _FrequencyButton extends StatelessWidget {
  const _FrequencyButton({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: AppRadius.borderMd,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderFor(context),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}
