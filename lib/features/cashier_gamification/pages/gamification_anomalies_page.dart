import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/anomaly_card.dart';

class GamificationAnomaliesPage extends ConsumerStatefulWidget {
  const GamificationAnomaliesPage({super.key});

  @override
  ConsumerState<GamificationAnomaliesPage> createState() => _GamificationAnomaliesPageState();
}

class _GamificationAnomaliesPageState extends ConsumerState<GamificationAnomaliesPage> {
  String? _severityFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(anomaliesProvider.notifier).load());
  }

  void _loadData() {
    ref.read(anomaliesProvider.notifier).load(severity: _severityFilter);
  }

  void _showReviewDialog(String anomalyId) {
    final notesC = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.gamificationReviewAnomaly),
        content: TextField(
          controller: notesC,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.gamificationReviewNotes),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.commonCancel)),
          FilledButton(
            onPressed: () {
              ref.read(anomaliesProvider.notifier).review(anomalyId, reviewNotes: notesC.text, confirmed: true);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            child: Text(AppLocalizations.of(context)!.gamificationConfirm),
          ),
          OutlinedButton(
            onPressed: () {
              ref.read(anomaliesProvider.notifier).review(anomalyId, reviewNotes: notesC.text, confirmed: false);
              Navigator.pop(ctx);
            },
            child: Text(AppLocalizations.of(context)!.gamificationDismissAnomaly),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(anomaliesProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(l10n.gamificationAnomalies),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.refresh), tooltip: l10n.commonRefresh, onPressed: _loadData)],
      ),
      body: Column(
        children: [
          // Severity filter chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.gamificationAll),
                  selected: _severityFilter == null,
                  onSelected: (_) {
                    setState(() => _severityFilter = null);
                    _loadData();
                  },
                ),
                FilterChip(
                  label: const Text('Critical'),
                  selected: _severityFilter == 'critical',
                  selectedColor: AppColors.error.withValues(alpha: 0.2),
                  onSelected: (_) {
                    setState(() => _severityFilter = 'critical');
                    _loadData();
                  },
                ),
                FilterChip(
                  label: const Text('High'),
                  selected: _severityFilter == 'high',
                  selectedColor: AppColors.rose.withValues(alpha: 0.2),
                  onSelected: (_) {
                    setState(() => _severityFilter = 'high');
                    _loadData();
                  },
                ),
                FilterChip(
                  label: const Text('Medium'),
                  selected: _severityFilter == 'medium',
                  selectedColor: AppColors.warning.withValues(alpha: 0.2),
                  onSelected: (_) {
                    setState(() => _severityFilter = 'medium');
                    _loadData();
                  },
                ),
                FilterChip(
                  label: const Text('Low'),
                  selected: _severityFilter == 'low',
                  selectedColor: AppColors.info.withValues(alpha: 0.2),
                  onSelected: (_) {
                    setState(() => _severityFilter = 'low');
                    _loadData();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildContent(state, l10n, isMobile)),
        ],
      ),
    );
  }

  Widget _buildContent(AnomaliesState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      AnomaliesInitial() || AnomaliesLoading() => const Center(child: CircularProgressIndicator()),
      AnomaliesError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadData, child: Text(l10n.commonRetry)),
          ],
        ),
      ),
      AnomaliesLoaded(:final anomalies) =>
        anomalies.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
                    const SizedBox(height: 12),
                    Text(l10n.gamificationNoAnomalies, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                itemCount: anomalies.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AnomalyCard(
                    anomaly: anomalies[index],
                    onReview: anomalies[index].isReviewed ? null : () => _showReviewDialog(anomalies[index].id),
                  ),
                ),
              ),
    };
  }
}
