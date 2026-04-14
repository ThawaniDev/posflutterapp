import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';

class AIMessageBubble extends StatelessWidget {
  final AIChatMessage message;

  const AIMessageBubble({super.key, required this.message});

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
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: isMobile ? 14 : 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.auto_awesome, size: isMobile ? 15 : 18, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _copyToClipboard(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: isMobile ? 10 : 12),
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
                          borderRadius: BorderRadius.circular(10),
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
                    // Message content
                    SelectableText(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUser ? Colors.white : theme.textTheme.bodyMedium?.color,
                        height: 1.5,
                        fontSize: isMobile ? 13.5 : null,
                      ),
                    ),
                    // Metadata row
                    if (!isUser && (message.modelUsed != null || message.latencyMs > 0)) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (message.modelUsed != null)
                            Text(
                              message.modelUsed!,
                              style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontSize: 10),
                            ),
                          if (message.latencyMs > 0)
                            Text(
                              '${(message.latencyMs / 1000).toStringAsFixed(1)}s',
                              style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontSize: 10),
                            ),
                          InkWell(
                            onTap: () => _copyToClipboard(context),
                            borderRadius: BorderRadius.circular(8),
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
          if (isUser) const SizedBox(width: 8),
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
