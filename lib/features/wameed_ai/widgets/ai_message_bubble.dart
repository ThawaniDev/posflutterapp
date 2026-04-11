import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';

class AIMessageBubble extends StatelessWidget {
  final AIChatMessage message;

  const AIMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : theme.cardColor,
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
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.1),
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
                    ),
                  ),
                  // Metadata row
                  if (!isUser && (message.modelUsed != null || message.latencyMs > 0)) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.modelUsed != null)
                          Text(
                            message.modelUsed!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.hintColor,
                              fontSize: 10,
                            ),
                          ),
                        if (message.latencyMs > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${(message.latencyMs / 1000).toStringAsFixed(1)}s',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.hintColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: message.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
                            );
                          },
                          child: Icon(Icons.copy, size: 14, color: theme.hintColor),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatFeatureName(String slug) {
    return slug.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }
}
