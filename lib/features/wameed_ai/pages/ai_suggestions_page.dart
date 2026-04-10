import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_mobile_data_list.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AISuggestionsPage extends ConsumerStatefulWidget {
  const AISuggestionsPage({super.key});

  @override
  ConsumerState<AISuggestionsPage> createState() => _AISuggestionsPageState();
}

class _AISuggestionsPageState extends ConsumerState<AISuggestionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiSuggestionsProvider.notifier).load());
  }

  PosBadgeVariant _priorityVariant(String priority) {
    return switch (priority) {
      'high' => PosBadgeVariant.error,
      'medium' => PosBadgeVariant.warning,
      _ => PosBadgeVariant.neutral,
    };
  }

  PosBadgeVariant _statusVariant(String status) {
    return switch (status) {
      'accepted' => PosBadgeVariant.success,
      'dismissed' => PosBadgeVariant.neutral,
      'viewed' => PosBadgeVariant.info,
      _ => PosBadgeVariant.warning,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiSuggestionsProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wameedAISuggestions),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(aiSuggestionsProvider.notifier).load())],
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.md),
        child: isMobile ? _buildMobileBody(state, l10n) : _buildDesktopBody(state, l10n),
      ),
    );
  }

  Widget _buildMobileBody(AISuggestionsState state, AppLocalizations l10n) {
    final isLoading = state is AISuggestionsLoading || state is AISuggestionsInitial;
    final error = state is AISuggestionsError ? state.message : null;
    final suggestions = state is AISuggestionsLoaded ? state.suggestions : <AISuggestion>[];

    return PosMobileDataList<AISuggestion>(
      items: suggestions,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(aiSuggestionsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.lightbulb_outline,
        title: l10n.wameedAINoSuggestions,
        subtitle: l10n.wameedAINoSuggestionsSubtitle,
      ),
      onRefresh: () async => ref.read(aiSuggestionsProvider.notifier).load(),
      cardBuilder: (context, suggestion, index) {
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        return MobileListCard(
          title: Text(
            isAr ? (suggestion.titleAr ?? suggestion.title ?? '') : (suggestion.title ?? ''),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            suggestion.featureSlug,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          badges: [
            PosBadge(label: suggestion.priority.value, variant: _priorityVariant(suggestion.priority.value)),
            PosBadge(label: suggestion.status.value, variant: _statusVariant(suggestion.status.value)),
          ],
          infoRows: [
            if (suggestion.contentJson != null)
              MobileInfoRow(
                label: l10n.wameedAISuggestionBody,
                value: suggestion.contentJson.toString(),
                icon: Icons.description_outlined,
              ),
          ],
          trailing: PopupMenuButton<String>(
            onSelected: (status) => ref.read(aiSuggestionsProvider.notifier).updateStatus(suggestion.id, status),
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'accepted', child: Text(l10n.wameedAIAccept)),
              PopupMenuItem(value: 'dismissed', child: Text(l10n.wameedAIDismiss)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopBody(AISuggestionsState state, AppLocalizations l10n) {
    final isLoading = state is AISuggestionsLoading || state is AISuggestionsInitial;
    final error = state is AISuggestionsError ? state.message : null;
    final suggestions = state is AISuggestionsLoaded ? state.suggestions : <AISuggestion>[];
    final loaded = state is AISuggestionsLoaded ? state : null;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return PosDataTable<AISuggestion>(
      columns: [
        PosTableColumn(title: l10n.wameedAIFeature),
        PosTableColumn(title: l10n.wameedAISuggestionTitle),
        PosTableColumn(title: l10n.wameedAIPriority),
        PosTableColumn(title: l10n.wameedAIStatus),
        PosTableColumn(title: l10n.wameedAIActions),
      ],
      items: suggestions,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(aiSuggestionsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.lightbulb_outline,
        title: l10n.wameedAINoSuggestions,
        subtitle: l10n.wameedAINoSuggestionsSubtitle,
      ),
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      cellBuilder: (suggestion, columnIndex, column) {
        return switch (columnIndex) {
          0 => Text(suggestion.featureSlug),
          1 => Text(isAr ? (suggestion.titleAr ?? suggestion.title ?? '') : (suggestion.title ?? '')),
          2 => PosBadge(label: suggestion.priority.value, variant: _priorityVariant(suggestion.priority.value)),
          3 => PosBadge(label: suggestion.status.value, variant: _statusVariant(suggestion.status.value)),
          4 => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                onPressed: () => ref.read(aiSuggestionsProvider.notifier).updateStatus(suggestion.id, 'accepted'),
                tooltip: l10n.wameedAIAccept,
              ),
              IconButton(
                icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.grey),
                onPressed: () => ref.read(aiSuggestionsProvider.notifier).updateStatus(suggestion.id, 'dismissed'),
                tooltip: l10n.wameedAIDismiss,
              ),
            ],
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
