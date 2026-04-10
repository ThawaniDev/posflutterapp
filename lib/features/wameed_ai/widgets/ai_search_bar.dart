import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AISearchBar extends ConsumerStatefulWidget {
  const AISearchBar({super.key});

  @override
  ConsumerState<AISearchBar> createState() => _AISearchBarState();
}

class _AISearchBarState extends ConsumerState<AISearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    ref.read(aiSmartSearchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiSmartSearchProvider);
    final isLoading = state is AISmartSearchLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.wameedAISmartSearch, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: PosTextField(
                      controller: _controller,
                      hint: l10n.wameedAISmartSearchHint,
                      prefixIcon: Icons.search,
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PosButton(
                    label: l10n.wameedAISearch,
                    icon: Icons.search,
                    onPressed: isLoading ? null : _search,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (state is AISmartSearchLoaded) ...[
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(l10n.wameedAISearchResults, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => ref.read(aiSmartSearchProvider.notifier).reset(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (state.result.data != null) _buildResultData(state.result.data!),
                ],
              ),
            ),
          ),
        ],
        if (state is AISmartSearchError) ...[
          const SizedBox(height: 8),
          Text((state as AISmartSearchError).message, style: const TextStyle(color: AppColors.error)),
        ],
      ],
    );
  }

  Widget _buildResultData(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        if (entry.value is List) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key.replaceAll('_', ' '), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ...(entry.value as List).take(5).map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text('• ${item is Map ? (item['name'] ?? item.toString()) : item}', style: Theme.of(context).textTheme.bodySmall),
              )),
              const SizedBox(height: 8),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text('${entry.key.replaceAll('_', ' ')}: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              Flexible(child: Text('${entry.value}', style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
