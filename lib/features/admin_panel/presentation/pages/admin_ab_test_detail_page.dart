import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminABTestDetailPage extends ConsumerStatefulWidget {
  const AdminABTestDetailPage({super.key, required this.testId});
  final String testId;

  @override
  ConsumerState<AdminABTestDetailPage> createState() => _AdminABTestDetailPageState();
}

class _AdminABTestDetailPageState extends ConsumerState<AdminABTestDetailPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(abTestDetailProvider.notifier).loadTest(widget.testId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(abTestDetailProvider);

    return PosListPage(
  title: l10n.abTestDetail,
  showSearch: false,
    child: switch (state) {
        ABTestDetailInitial() || ABTestDetailLoading() => const Center(child: CircularProgressIndicator()),
        ABTestDetailLoaded(:final test, :final variants) => SingleChildScrollView(
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
                      Text(test['name'] as String? ?? '', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(test['description'] as String? ?? 'No description'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(label: Text((test['status'] as String? ?? 'draft').toUpperCase())),
                          const SizedBox(width: 8),
                          Chip(label: Text('${test['traffic_percentage'] ?? 100}% traffic')),
                        ],
                      ),
                      if (test['metric_key'] != null) ...[const SizedBox(height: 8), Text('Metric: ${test['metric_key']}')],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Variants (${variants.length})', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (variants.isEmpty)
                Text(l10n.adminNoVariantsYet)
              else
                ...variants.map(
                  (v) => PosCard(
                    child: ListTile(
                      leading: v['is_control'] == true
                          ? const Icon(Icons.science, color: AppColors.info)
                          : const Icon(Icons.science_outlined),
                      title: Text(v['variant_key'] as String? ?? ''),
                      subtitle: Text(v['variant_label'] as String? ?? ''),
                      trailing: Text('${v['weight'] ?? 50}%'),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (test['status'] == 'draft')
                    ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: Text(l10n.notificationsQuietStart)),
                  if (test['status'] == 'running')
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.stop),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    ),
                  ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.bar_chart), label: Text(l10n.adminViewResults)),
                ],
              ),
            ],
          ),
        ),
        ABTestDetailError(:final message) => Center(
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
