import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIDashboardWidget extends ConsumerStatefulWidget {
  const AIDashboardWidget({super.key});

  @override
  ConsumerState<AIDashboardWidget> createState() => _AIDashboardWidgetState();
}

class _AIDashboardWidgetState extends ConsumerState<AIDashboardWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiSuggestionsProvider.notifier).load(status: 'pending');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suggestionsState = ref.watch(aiSuggestionsProvider);

    return InkWell(
      onTap: () => context.push(Routes.wameedAI),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.primary.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.wameedAI, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text(l10n.wameedAIInsights, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
              ],
            ),
            const SizedBox(height: 14),
            switch (suggestionsState) {
              AISuggestionsLoading() => const LinearProgressIndicator(),
              AISuggestionsLoaded(:final suggestions, :final total) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _miniStat(context, Icons.lightbulb_outline, '$total', l10n.wameedAIPendingSuggestions, AppColors.warning),
                        const SizedBox(width: 16),
                        _miniStat(
                          context,
                          Icons.priority_high,
                          '${suggestions.where((s) => s.priority.value == 'high' || s.priority.value == 'critical').length}',
                          l10n.wameedAIHighPriority,
                          AppColors.error,
                        ),
                      ],
                    ),
                    if (suggestions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: suggestions.take(3).map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: s.priority.value == 'high' || s.priority.value == 'critical'
                                        ? AppColors.error
                                        : (s.priority.value == 'medium' ? AppColors.warning : AppColors.success),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    s.title ?? s.featureSlug,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              _ => Text(l10n.wameedAITapToExplore, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
            },
          ],
        ),
      ),
    );
  }

  Widget _miniStat(BuildContext context, IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: color)),
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, color: Theme.of(context).hintColor)),
            ],
          ),
        ],
      ),
    );
  }
}
