import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AdminABTestResultsPage extends ConsumerStatefulWidget {
  final String testId;
  const AdminABTestResultsPage({super.key, required this.testId});

  @override
  ConsumerState<AdminABTestResultsPage> createState() => _AdminABTestResultsPageState();
}

class _AdminABTestResultsPageState extends ConsumerState<AdminABTestResultsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(abTestResultsProvider.notifier).loadResults(widget.testId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abTestResultsProvider);

    return PosListPage(
  title: l10n.abTestResults,
  showSearch: false,
    child: switch (state) {
        ABTestResultsInitial() || ABTestResultsLoading() => const Center(child: CircularProgressIndicator()),
        ABTestResultsLoaded(:final test, :final results, :final winner, :final confidence) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((test['name'] as String?) ?? 'Test', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
                      if (winner != null) ...[
                        const SizedBox(height: 4),
                        Text('Winner: $winner', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Variant Results', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (results.isEmpty)
                const Text('No results yet')
              else
                ...results.map(
                  (r) => PosCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(r['variant_key'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (r['is_control'] == true) ...[
                                const SizedBox(width: 8),
                                const Chip(label: Text('Control', style: TextStyle(fontSize: 10))),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('${r['impressions'] ?? 0}'),
                                  const Text('Impressions', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('${r['conversions'] ?? 0}'),
                                  const Text('Conversions', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('${((r['conversion_rate'] as num?) ?? 0.0).toStringAsFixed(2)}%'),
                                  const Text('Rate', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ABTestResultsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              Text(message),
            ],
          ),
        ),
      },
);
  }
}
