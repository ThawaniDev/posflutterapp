import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_markdown_text.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AIMessageBubble extends StatelessWidget {
  const AIMessageBubble({super.key, required this.message});
  final AIChatMessage message;

  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: message.content));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.wameedAICopied), duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final isMobile = context.isPhone;

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? AppSpacing.sm : AppSpacing.md),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && !isMobile) ...[
            CircleAvatar(
              radius: isMobile ? 14 : 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.auto_awesome,
                size: isMobile ? AppSizes.iconSm - 1 : AppSizes.iconSm + 2,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapW8,
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _copyToClipboard(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? AppSpacing.md : AppSpacing.base,
                  vertical: isMobile ? 10 : AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primary : theme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: isUser ? null : Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Feature badge
                    if (message.featureSlug != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.white.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderLg,
                        ),
                        child: Text(
                          _formatFeatureName(message.featureSlug!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isUser ? Colors.white70 : AppColors.primary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    // Message content. Assistant replies are rendered as
                    // Markdown so headings, lists, bold, etc. are readable.
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: isUser
                          ? SelectableText(
                              message.content,
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, height: 1.35),
                            )
                          : AIMarkdownText(message.content),
                    ),
                    // Metadata row
                    if (!isUser && (message.modelUsed != null || message.latencyMs > 0)) ...[
                      AppSpacing.gapH8,
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // if (message.modelUsed != null)
                          //   Text(
                          //     message.modelUsed!,
                          //     style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontSize: 10),
                          //   ),
                          // if (message.latencyMs > 0)
                          //   Text(
                          //     '${(message.latencyMs / 1000).toStringAsFixed(1)}s',
                          //     style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontSize: 10),
                          //   ),
                          InkWell(
                            onTap: () => _copyToClipboard(context),
                            borderRadius: AppRadius.borderMd,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.copy, size: isMobile ? 16 : 14, color: theme.hintColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isUser) AppSpacing.gapW8,
        ],
      ),
    );
  }

  String _formatFeatureName(String slug) {
    return slug
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
