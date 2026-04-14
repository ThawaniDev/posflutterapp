import 'package:thawani_pos/core/l10n/app_localizations.dart';

/// Localized month name using l10n keys.
String localizedMonthName(AppLocalizations l10n, int month) {
  return switch (month) {
    1 => l10n.wameedAIMonthJan,
    2 => l10n.wameedAIMonthFeb,
    3 => l10n.wameedAIMonthMar,
    4 => l10n.wameedAIMonthApr,
    5 => l10n.wameedAIMonthMay,
    6 => l10n.wameedAIMonthJun,
    7 => l10n.wameedAIMonthJul,
    8 => l10n.wameedAIMonthAug,
    9 => l10n.wameedAIMonthSep,
    10 => l10n.wameedAIMonthOct,
    11 => l10n.wameedAIMonthNov,
    12 => l10n.wameedAIMonthDec,
    _ => '',
  };
}

/// Format large token counts as 1.2K, 3.4M, etc.
String formatTokens(int tokens) {
  if (tokens >= 1000000) return '${(tokens / 1000000).toStringAsFixed(1)}M';
  if (tokens >= 1000) return '${(tokens / 1000).toStringAsFixed(1)}K';
  return '$tokens';
}
