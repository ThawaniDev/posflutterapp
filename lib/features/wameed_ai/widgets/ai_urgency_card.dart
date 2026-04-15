import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';

class AIUrgencyCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String urgency;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final List<Widget>? children;

  const AIUrgencyCard({
    super.key,
    required this.title,
    this.subtitle,
    this.urgency = 'medium',
    this.icon,
    this.onTap,
    this.trailing,
    this.children,
  });

  Color get _urgencyColor {
    return switch (urgency.toLowerCase()) {
      'critical' || 'urgent' => AppColors.error,
      'high' => const Color(0xFFDC2626),
      'medium' => AppColors.warning,
      'low' => AppColors.success,
      _ => AppColors.info,
    };
  }

  String get _urgencyLabel {
    return switch (urgency.toLowerCase()) {
      'critical' => 'CRITICAL',
      'urgent' => 'URGENT',
      'high' => 'HIGH',
      'medium' => 'MEDIUM',
      'low' => 'LOW',
      _ => urgency.toUpperCase(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: _urgencyColor, width: 4)),
          boxShadow: [BoxShadow(color: _urgencyColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[Icon(icon, size: 20, color: _urgencyColor), const SizedBox(width: 8)],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: _urgencyColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    _urgencyLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: _urgencyColor, fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (children != null && children!.isNotEmpty) ...[const SizedBox(height: 10), ...children!],
          ],
        ),
      ),
    );
  }
}
