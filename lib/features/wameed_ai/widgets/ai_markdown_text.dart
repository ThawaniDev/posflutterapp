import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

/// Renders an AI text response (chat reply, narrative, summary) as
/// formatted Markdown so headings, bold, lists, tables, code blocks, etc.
/// look readable to a normal user.
///
/// Falls back to a plain selectable text style when [data] is empty.
class AIMarkdownText extends StatelessWidget {
  const AIMarkdownText(this.data, {super.key, this.selectable = true, this.textStyle});

  final String data;
  final bool selectable;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return MarkdownBody(
      data: data,
      selectable: selectable,
      softLineBreak: true,
      styleSheet: aiMarkdownStyle(theme, textStyle: textStyle),
      onTapLink: (text, href, title) {
        if (href != null) {
          Clipboard.setData(ClipboardData(text: href));
        }
      },
    );
  }
}

/// Shared style sheet so chat bubbles and per-feature pages render the
/// same way.
MarkdownStyleSheet aiMarkdownStyle(ThemeData theme, {TextStyle? textStyle}) {
  final base = textStyle ?? theme.textTheme.bodyMedium?.copyWith(height: 1.5) ?? const TextStyle(height: 1.5);
  final mono = TextStyle(fontFamily: 'monospace', fontSize: (base.fontSize ?? 14) - 1, color: base.color);
  return MarkdownStyleSheet.fromTheme(theme).copyWith(
    p: base,
    h1: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    h2: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    h3: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    h4: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
    strong: base.copyWith(fontWeight: FontWeight.w700),
    em: base.copyWith(fontStyle: FontStyle.italic),
    listBullet: base,
    blockquote: base.copyWith(color: theme.hintColor, fontStyle: FontStyle.italic),
    blockquoteDecoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.06),
      border: Border(left: BorderSide(color: AppColors.primary.withValues(alpha: 0.4), width: 3)),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    code: mono.copyWith(backgroundColor: theme.colorScheme.surfaceContainerHighest),
    codeblockDecoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: AppRadius.borderMd),
    codeblockPadding: const EdgeInsets.all(10),
    tableBorder: TableBorder.all(color: theme.dividerColor, width: 0.5),
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: theme.dividerColor)),
    ),
    a: base.copyWith(color: AppColors.primary, decoration: TextDecoration.underline),
  );
}
