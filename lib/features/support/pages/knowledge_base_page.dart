import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/pos_empty_state.dart';
import 'package:wameedpos/core/widgets/pos_error_state.dart';
import 'package:wameedpos/core/widgets/pos_loading_skeleton.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/features/support/enums/knowledge_base_category.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';

class KnowledgeBasePage extends ConsumerStatefulWidget {
  const KnowledgeBasePage({super.key});

  @override
  ConsumerState<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends ConsumerState<KnowledgeBasePage> {
  final _searchController = TextEditingController();
  KnowledgeBaseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kbListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    ref
        .read(kbListProvider.notifier)
        .load(
          category: _selectedCategory?.value,
          search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        );
  }

  String _categoryLabel(KnowledgeBaseCategory cat, AppLocalizations l10n) {
    return switch (cat) {
      KnowledgeBaseCategory.gettingStarted => l10n.supportKbGettingStarted,
      KnowledgeBaseCategory.posUsage => l10n.supportKbPosUsage,
      KnowledgeBaseCategory.inventory => l10n.supportKbInventory,
      KnowledgeBaseCategory.delivery => l10n.supportKbDelivery,
      KnowledgeBaseCategory.billing => l10n.supportKbBilling,
      KnowledgeBaseCategory.troubleshooting => l10n.supportKbTroubleshooting,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kbListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportKnowledgeBase)),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: PosSearchField(
              controller: _searchController,
              hint: l10n.supportSearchArticles,
              onChanged: (_) => _reload(),
              onClear: () {
                _searchController.clear();
                _reload();
              },
            ),
          ),
          // Category filter pills
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                PosButton.pill(
                  label: l10n.supportAll,
                  isSelected: _selectedCategory == null,
                  onPressed: () {
                    setState(() => _selectedCategory = null);
                    _reload();
                  },
                ),
                AppSpacing.gapW8,
                ...KnowledgeBaseCategory.values.map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: PosButton.pill(
                      label: _categoryLabel(cat, l10n),
                      isSelected: _selectedCategory == cat,
                      onPressed: () {
                        setState(() => _selectedCategory = cat);
                        _reload();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH12,
          // Article list
          Expanded(
            child: switch (state) {
              KbListInitial() || KbListLoading() => PosLoadingSkeleton.list(),
              KbListError(:final message) => PosErrorState(message: message, onRetry: _reload),
              KbListLoaded(:final articles) =>
                articles.isEmpty
                    ? PosEmptyState(icon: Icons.menu_book_rounded, title: l10n.supportNoArticles)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: articles.length,
                        separatorBuilder: (_, __) => AppSpacing.gapH8,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final isAr = Localizations.localeOf(context).languageCode == 'ar';
                          final title = (isAr && article.titleAr != null && article.titleAr!.isNotEmpty)
                              ? article.titleAr!
                              : article.title;

                          return PosCard(
                            onTap: () => context.push('/support/kb/${article.slug}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: AppTypography.titleSmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    AppSpacing.gapW8,
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ],
                                ),
                                AppSpacing.gapH4,
                                Text(
                                  _categoryLabel(article.category, l10n),
                                  style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            },
          ),
        ],
      ),
    );
  }
}
