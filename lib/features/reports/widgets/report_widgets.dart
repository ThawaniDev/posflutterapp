import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';

// ═══════════════════════════════════════════════════════════════
// Shared Report Widgets — consistent look across all report pages
// ═══════════════════════════════════════════════════════════════

/// Format a number as currency string
String formatCurrency(num value) {
  final f = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
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
  final DateTimeRange? dateRange;
  final VoidCallback onPickDate;
  final VoidCallback onClear;
  final VoidCallback onRefresh;

  const ReportDateBar({
    super.key,
    required this.dateRange,
    required this.onPickDate,
    required this.onClear,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPickDate,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      dateRange != null
                          ? '${DateFormat('MMM d').format(dateRange!.start)} – ${DateFormat('MMM d, yyyy').format(dateRange!.end)}'
                          : 'All Time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    if (dateRange != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onClear,
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const ReportKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
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
  final String title;
  final IconData? icon;
  final Widget? trailing;

  const ReportSectionHeader({super.key, required this.title, this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            const SizedBox(width: 8),
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
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ReportDataCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: child,
    );
  }
}

// ─── Ranked List Item ───────────────────────────────────────

class ReportRankedItem extends StatelessWidget {
  final int rank;
  final String title;
  final String? subtitle;
  final String trailingValue;
  final String? trailingSubtitle;
  final Color? trailingColor;
  final List<Widget>? badges;

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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isTop3 ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  Text(
                    subtitle!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                if (badges != null && badges!.isNotEmpty) ...[const SizedBox(height: 4), Wrap(spacing: 6, children: badges!)],
              ],
            ),
          ),
          const SizedBox(width: 12),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    fontSize: 11,
                  ),
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
  final String label;
  final Color color;

  const ReportBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// ─── Comparison Row ─────────────────────────────────────────

class ReportComparisonRow extends StatelessWidget {
  final String label;
  final double todayVal;
  final double yesterdayVal;

  const ReportComparisonRow({super.key, required this.label, required this.todayVal, required this.yesterdayVal});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  'Today: ${formatCurrency(todayVal)}  •  Yesterday: ${formatCurrency(yesterdayVal)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: changeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: changeColor, size: 14),
                const SizedBox(width: 4),
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
  final double value;
  final double maxValue;
  final Color color;
  final double height;

  const ReportBar({super.key, required this.value, required this.maxValue, required this.color, this.height = 8});

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
        alignment: Alignment.centerLeft,
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
  final String label;
  final String value;
  final Color? valueColor;

  const ReportStatRow({super.key, required this.label, required this.value, this.valueColor});

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
  final String title;
  final DateTimeRange? dateRange;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onRefresh;
  final Widget body;
  final PreferredSizeWidget? bottom;

  const ReportPageScaffold({
    super.key,
    required this.title,
    required this.dateRange,
    required this.onPickDate,
    required this.onClearDate,
    required this.onRefresh,
    required this.body,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(title),
        bottom: bottom,
      ),
      body: Column(
        children: [
          ReportDateBar(dateRange: dateRange, onPickDate: onPickDate, onClear: onClearDate, onRefresh: onRefresh),
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ─── KPI Grid (responsive 2-col) ───────────────────────────

class ReportKpiGrid extends StatelessWidget {
  final List<ReportKpiCard> cards;

  const ReportKpiGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth > 600 ? 1.8 : 1.5,
          children: cards,
        );
      },
    );
  }
}
