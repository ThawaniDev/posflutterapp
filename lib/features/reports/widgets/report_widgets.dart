import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_page_scaffolds.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/services/upgrade_prompt_service.dart';

// ═══════════════════════════════════════════════════════════════
// Shared Report Widgets — consistent look across all report pages
// ═══════════════════════════════════════════════════════════════

/// Format a number as currency string
String formatCurrency(num value) {
  final f = NumberFormat.currency(symbol: '\u0081', decimalDigits: 2);
  return f.format(value);
}

/// Format a number compactly (e.g. 1.2K, 3.5M)
String formatCompact(num value) {
  return NumberFormat.compact().format(value);
}

/// Format a percentage
String formatPercent(num value) {
  return '${value.toStringAsFixed(1)}%';
}

// ─── Date Range Filter Bar ──────────────────────────────────

class ReportDateBar extends StatelessWidget {
  const ReportDateBar({
    super.key,
    required this.dateRange,
    required this.onPickDate,
    required this.onClear,
    required this.onRefresh,
  });
  final DateTimeRange? dateRange;
  final VoidCallback onPickDate;
  final VoidCallback onClear;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceFor(context),
        border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPickDate,
              borderRadius: AppRadius.borderSm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                  borderRadius: AppRadius.borderSm,
                  border: Border.all(color: AppColors.borderFor(context)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                    AppSpacing.gapW8,
                    Text(
                      dateRange != null
                          ? '${DateFormat('MMM d').format(dateRange!.start)} – ${DateFormat('MMM d, yyyy').format(dateRange!.end)}'
                          : 'All Time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    if (dateRange != null) ...[
                      AppSpacing.gapW8,
                      GestureDetector(
                        onTap: onClear,
                        child: Icon(Icons.close_rounded, size: 16, color: AppColors.mutedFor(context)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          AppSpacing.gapW8,
          IconButton.filled(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              foregroundColor: AppColors.primary,
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── KPI Metric Card ────────────────────────────────────────

class ReportKpiCard extends StatelessWidget {
  const ReportKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.compact = false,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) return _buildCompact(context, isDark);
    return _buildExpanded(context, isDark);
  }

  Widget _buildCompact(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderFor(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
            child: Icon(icon, color: color, size: 16),
          ),
          AppSpacing.gapH8,
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH2,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context), fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            AppSpacing.gapH2,
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderFor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.gapH12,
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapH2,
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
          if (subtitle != null) ...[
            AppSpacing.gapH2,
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Section Header ─────────────────────────────────────────

class ReportSectionHeader extends StatelessWidget {
  const ReportSectionHeader({super.key, required this.title, this.icon, this.trailing});
  final String title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            AppSpacing.gapW8,
          ],
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

// ─── Data Table Card ────────────────────────────────────────

class ReportDataCard extends StatelessWidget {
  const ReportDataCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderFor(context)),
      ),
      child: child,
    );
  }
}

// ─── Ranked List Item ───────────────────────────────────────

class ReportRankedItem extends StatelessWidget {
  const ReportRankedItem({
    super.key,
    required this.rank,
    required this.title,
    this.subtitle,
    required this.trailingValue,
    this.trailingSubtitle,
    this.trailingColor,
    this.badges,
  });
  final int rank;
  final String title;
  final String? subtitle;
  final String trailingValue;
  final String? trailingSubtitle;
  final Color? trailingColor;
  final List<Widget>? badges;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTop3 = rank <= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isTop3
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : (isDark ? AppColors.hoverDark : AppColors.backgroundLight),
              borderRadius: AppRadius.borderMd,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isTop3 ? AppColors.primary : (AppColors.mutedFor(context)),
                ),
              ),
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
                if (badges != null && badges!.isNotEmpty) ...[AppSpacing.gapH4, Wrap(spacing: 6, children: badges!)],
              ],
            ),
          ),
          AppSpacing.gapW12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailingValue,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: trailingColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
              if (trailingSubtitle != null)
                Text(
                  trailingSubtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context), fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Small Badge/Tag ────────────────────────────────────────

class ReportBadge extends StatelessWidget {
  const ReportBadge({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// ─── Comparison Row ─────────────────────────────────────────

class ReportComparisonRow extends StatelessWidget {
  const ReportComparisonRow({super.key, required this.label, required this.todayVal, required this.yesterdayVal});
  final String label;
  final double todayVal;
  final double yesterdayVal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final diff = yesterdayVal > 0 ? ((todayVal - yesterdayVal) / yesterdayVal * 100) : 0.0;
    final isPositive = diff >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  l10n.reportTodayVsYesterday(formatCurrency(todayVal), formatCurrency(yesterdayVal)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: changeColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: changeColor, size: 14),
                AppSpacing.gapW4,
                Text(
                  '${diff.toStringAsFixed(1)}%',
                  style: TextStyle(color: changeColor, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Horizontal Bar ─────────────────────────────────────────

class ReportBar extends StatelessWidget {
  const ReportBar({super.key, required this.value, required this.maxValue, required this.color, this.height = 8});
  final double value;
  final double maxValue;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.hoverDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: pct,
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
        ),
      ),
    );
  }
}

// ─── Stat Row (label: value) ────────────────────────────────

class ReportStatRow extends StatelessWidget {
  const ReportStatRow({super.key, required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}

// ─── Report Page Scaffold ───────────────────────────────────

class ReportPageScaffold extends StatelessWidget {
  const ReportPageScaffold({
    super.key,
    required this.title,
    this.filterPanel,
    this.dateRange,
    this.onPickDate,
    this.onClearDate,
    this.onRefresh,
    required this.body,
    this.bottom,
    this.actions,
  });
  final String title;
  final Widget? filterPanel;
  final DateTimeRange? dateRange;
  final VoidCallback? onPickDate;
  final VoidCallback? onClearDate;
  final VoidCallback? onRefresh;
  final Widget body;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return PosListPage(
      title: title,
      showSearch: false,
      actions: actions,
      child: Column(
        children: [
          ?bottom,
          if (filterPanel != null)
            filterPanel!
          else if (onPickDate != null && onClearDate != null && onRefresh != null)
            ReportDateBar(dateRange: dateRange, onPickDate: onPickDate!, onClear: onClearDate!, onRefresh: onRefresh!),
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ─── KPI Grid (responsive: squares on mobile) ─────────────

class ReportKpiGrid extends StatelessWidget {
  const ReportKpiGrid({super.key, required this.cards});
  final List<ReportKpiCard> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final crossAxisCount = isMobile ? 2 : 4;
        final aspectRatio = isMobile ? 1.0 : 1.8;

        final effectiveCards = isMobile
            ? cards
                  .map(
                    (c) => ReportKpiCard(
                      key: c.key,
                      label: c.label,
                      value: c.value,
                      icon: c.icon,
                      color: c.color,
                      subtitle: c.subtitle,
                      compact: true,
                    ),
                  )
                  .toList()
            : cards;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: aspectRatio,
          children: effectiveCards,
        );
      },
    );
  }
}

// ─── Report Error Body ───────────────────────────────────────
/// Shows an upgrade prompt for subscription_required errors,
/// otherwise shows the standard PosErrorState.

class ReportErrorBody extends ConsumerWidget {
  const ReportErrorBody({
    super.key,
    required this.message,
    required this.featureKey,
    required this.featureName,
    required this.onRetry,
  });
  final String message;
  final String featureKey;
  final String featureName;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (message == 'subscription_required') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 56, color: AppColors.warning),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.reportsSubscriptionRequired,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.reportsUpgradeRequired,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PosButton(
                label: AppLocalizations.of(context)!.subscriptionUpgrade,
                onPressed: () => ref
                    .read(upgradePromptServiceProvider)
                    .showFeatureGatePrompt(context: context, featureKey: featureKey, featureName: featureName),
              ),
            ],
          ),
        ),
      );
    }
    return PosErrorState(message: message, onRetry: onRetry);
  }
}
