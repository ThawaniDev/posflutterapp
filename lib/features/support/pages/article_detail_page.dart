import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/support/enums/knowledge_base_category.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';

class ArticleDetailPage extends ConsumerStatefulWidget {
  const ArticleDetailPage({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends ConsumerState<ArticleDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kbArticleProvider.notifier).load(widget.slug));
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
    final state = ref.watch(kbArticleProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
  title: l10n.supportKnowledgeBase,
  showSearch: false,
    child: switch (state) {
        KbArticleInitial() || KbArticleLoading() => Center(child: PosLoadingSkeleton.list()),
        KbArticleError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(kbArticleProvider.notifier).load(widget.slug),
        ),
        KbArticleLoaded(:final article) => () {
          final isAr = Localizations.localeOf(context).languageCode == 'ar';
          final title = (isAr && article.titleAr != null && article.titleAr!.isNotEmpty) ? article.titleAr! : article.title;
          final body = (isAr && article.bodyAr != null && article.bodyAr!.isNotEmpty) ? article.bodyAr! : article.body;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: PosCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Text(
                    _categoryLabel(article.category, l10n),
                    style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.gapH8,
                  // Title
                  Text(title, style: AppTypography.titleLarge),
                  AppSpacing.gapH16,
                  // Body
                  SelectableText(
                    body,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          );
        }(),
      },
);
  }
}
