import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/support/enums/ticket_sender_type.dart';
import 'package:wameedpos/features/support/models/support_ticket_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final SupportTicketMessage message;

  @override
  Widget build(BuildContext context) {
    final isProvider = message.senderType == TicketSenderType.provider;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleColor = isProvider
        ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primary10)
        : (isDark ? AppColors.cardDark : Theme.of(context).colorScheme.surfaceContainerHigh);

    final senderLabel = isProvider ? 'You' : 'Support';
    final senderColor = isProvider ? AppColors.primary : AppColors.info;

    final timeStr = message.sentAt != null ? DateFormat.jm().format(message.sentAt!) : '';
    final dateStr = message.sentAt != null ? DateFormat.MMMd().format(message.sentAt!) : '';

    return Align(
      alignment: isProvider ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        child: Column(
          crossAxisAlignment: isProvider ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender label
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 4, start: 4, end: 4),
              child: Text(
                senderLabel,
                style: AppTypography.micro.copyWith(color: senderColor, fontWeight: FontWeight.w600),
              ),
            ),
            // Bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(AppRadius.xl),
                  topEnd: const Radius.circular(AppRadius.xl),
                  bottomStart: Radius.circular(isProvider ? 16 : 4),
                  bottomEnd: Radius.circular(isProvider ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message.messageText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  // Attachments
                  if (message.attachments != null && message.attachments!.isNotEmpty) ...[
                    AppSpacing.gapH8,
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: message.attachments!.map((attachment) {
                        final name = attachment is Map ? (attachment['name'] ?? 'Attachment') : 'Attachment';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            borderRadius: AppRadius.borderSm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                size: 14,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                              AppSpacing.gapW4,
                              Flexible(
                                child: Text(
                                  name.toString(),
                                  style: AppTypography.micro.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            // Timestamp
            if (timeStr.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                child: Text(
                  '$dateStr, $timeStr',
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
