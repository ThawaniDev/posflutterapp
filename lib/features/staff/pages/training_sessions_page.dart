import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/models/training_session.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';

class TrainingSessionsPage extends ConsumerStatefulWidget {
  const TrainingSessionsPage({super.key, required this.staffId});
  final String staffId;

  @override
  ConsumerState<TrainingSessionsPage> createState() => _TrainingSessionsPageState();
}

class _TrainingSessionsPageState extends ConsumerState<TrainingSessionsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(trainingSessionsProvider(widget.staffId));

    final activeSession = state.sessions.where((s) => s.isActive).firstOrNull;
    final totalMinutes = state.sessions.fold<int>(0, (sum, s) => sum + (s.durationMinutes ?? 0));
    final totalTransactions = state.sessions.fold<int>(0, (sum, s) => sum + (s.transactionsCount ?? 0));
    final completedSessions = state.sessions.where((s) => !s.isActive).length;
    final avgMinutes = completedSessions > 0 ? (totalMinutes / completedSessions).round() : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.staffTrainingSessions),
        actions: [
          if (activeSession == null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: PosButton(
                label: l10n.staffStartTraining,
                icon: Icons.play_arrow_rounded,
                onPressed: () => _showStartDialog(context, l10n),
                size: PosButtonSize.sm,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(trainingSessionsProvider(widget.staffId).notifier).load(),
        child: CustomScrollView(
          slivers: [
            // KPI Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PosKpiCard(
                        label: l10n.totalCount,
                        value: '${state.total}',
                        icon: Icons.fitness_center_outlined,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosKpiCard(
                        label: l10n.staffTrainingTransactionsCount,
                        value: '$totalTransactions',
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.info,
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosKpiCard(
                        label: 'Avg Duration',
                        value: l10n.staffTrainingDuration(avgMinutes),
                        icon: Icons.timer_outlined,
                        iconColor: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active session banner
            if (activeSession != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ActiveSessionBanner(
                    session: activeSession,
                    staffId: widget.staffId,
                    l10n: l10n,
                  ),
                ),
              ),

            if (state.isLoading && state.sessions.isEmpty)
              SliverToBoxAdapter(child: PosLoadingSkeleton.list()),

            if (!state.isLoading && state.sessions.isEmpty)
              SliverToBoxAdapter(
                child: PosEmptyState(
                  title: l10n.staffNoTrainingSessions,
                  icon: Icons.fitness_center_outlined,
                ),
              ),

            if (state.sessions.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: state.sessions.length,
                  separatorBuilder: (_, __) => AppSpacing.gapH12,
                  itemBuilder: (ctx, i) {
                    final session = state.sessions[i];
                    return _SessionCard(
                      session: session,
                      staffId: widget.staffId,
                      isDark: isDark,
                      l10n: l10n,
                      onEnd: session.isActive ? () => _showEndDialog(context, session, l10n) : null,
                      onDelete: () => _confirmDelete(context, session, l10n),
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(child: AppSpacing.gapH24),
          ],
        ),
      ),
    );
  }

  void _showStartDialog(BuildContext context, AppLocalizations l10n) {
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.staffStartTraining),
        content: TextFormField(
          controller: notesController,
          decoration: InputDecoration(labelText: l10n.staffTrainingNotes),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          PosButton(
            label: l10n.staffStartTraining,
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(trainingSessionsProvider(widget.staffId).notifier).start(
                notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEndDialog(BuildContext context, TrainingSession session, AppLocalizations l10n) {
    final countController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.staffEndTraining),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: countController,
                decoration: InputDecoration(labelText: l10n.staffTrainingTransactionsCount),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              AppSpacing.gapH12,
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(labelText: l10n.staffTrainingEndNotes),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          PosButton(
            label: l10n.staffEndTraining,
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);
              await ref.read(trainingSessionsProvider(widget.staffId).notifier).end(
                session.id,
                transactionsCount: countController.text.isEmpty ? null : int.parse(countController.text),
                notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, TrainingSession session, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.staffDeleteTraining),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(trainingSessionsProvider(widget.staffId).notifier).remove(session.id);
    }
  }
}

// ─── Active Session Banner ────────────────────────────────────

class _ActiveSessionBanner extends ConsumerWidget {
  const _ActiveSessionBanner({required this.session, required this.staffId, required this.l10n});
  final TrainingSession session;
  final String staffId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsed = session.startedAt != null
        ? DateTime.now().difference(DateTime.parse(session.startedAt!))
        : Duration.zero;
    final mins = elapsed.inMinutes;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success.withOpacity(0.15), AppColors.success.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_filled, color: AppColors.success, size: 24),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.staffTrainingActive, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success)),
                Text(l10n.staffTrainingDuration(mins), style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          PosButton(
            label: l10n.staffEndTraining,
            icon: Icons.stop_rounded,
            size: PosButtonSize.sm,
            color: AppColors.error,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Session Card ─────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.staffId,
    required this.isDark,
    required this.l10n,
    this.onEnd,
    required this.onDelete,
  });
  final TrainingSession session;
  final String staffId;
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback? onEnd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = session.isActive;
    final statusColor = isActive ? AppColors.success : AppColors.info;
    final statusLabel = isActive ? l10n.staffTrainingActive : l10n.staffTrainingCompleted;
    final fmt = DateFormat('dd MMM yyyy, hh:mm a');

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PosStatusBadge(label: statusLabel, color: statusColor),
              const Spacer(),
              if (onEnd != null)
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined, color: AppColors.error),
                  tooltip: l10n.staffEndTraining,
                  onPressed: onEnd,
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                tooltip: l10n.delete,
                onPressed: onDelete,
              ),
            ],
          ),
          AppSpacing.gapH8,
          Row(
            children: [
              _InfoChip(
                icon: Icons.play_arrow_rounded,
                label: session.startedAt != null ? fmt.format(DateTime.parse(session.startedAt!)) : '—',
                color: AppColors.success,
              ),
              if (session.endedAt != null) ...[
                AppSpacing.gapW12,
                _InfoChip(
                  icon: Icons.stop_rounded,
                  label: fmt.format(DateTime.parse(session.endedAt!)),
                  color: AppColors.error,
                ),
              ],
            ],
          ),
          if (session.durationMinutes != null || session.transactionsCount != null) ...[
            AppSpacing.gapH8,
            Row(
              children: [
                if (session.durationMinutes != null)
                  _InfoChip(
                    icon: Icons.timer_outlined,
                    label: l10n.staffTrainingDuration(session.durationMinutes!),
                    color: AppColors.warning,
                  ),
                if (session.transactionsCount != null) ...[
                  AppSpacing.gapW12,
                  _InfoChip(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.staffTrainingTransactions(session.transactionsCount!),
                    color: AppColors.info,
                  ),
                ],
              ],
            ),
          ],
          if (session.notes != null && session.notes!.isNotEmpty) ...[
            AppSpacing.gapH8,
            Text(session.notes!, style: TextStyle(fontSize: 13, color: AppColors.mutedFor(context))),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
      ],
    );
  }
}
