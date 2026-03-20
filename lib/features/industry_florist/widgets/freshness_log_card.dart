import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/flower_freshness_log.dart';
import '../enums/flower_freshness_status.dart';

class FreshnessLogCard extends StatelessWidget {
  final FlowerFreshnessLog log;
  final VoidCallback? onTap;

  const FreshnessLogCard({super.key, required this.log, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysLeft = _daysUntilExpiry;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Row(
            children: [
              _expiryIndicator(daysLeft),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product: ${log.productId}', style: AppTypography.titleSmall),
                    Text('Qty: ${log.quantity} · Received: ${log.receivedDate}', style: AppTypography.caption),
                  ],
                ),
              ),
              _statusBadge(log.status),
            ],
          ),
        ),
      ),
    );
  }

  int get _daysUntilExpiry {
    final received = DateTime.tryParse(log.receivedDate);
    if (received == null) return 0;
    final expiryDate = received.add(Duration(days: log.expectedVaseLifeDays));
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Widget _expiryIndicator(int daysLeft) {
    final color = daysLeft <= 0
        ? AppColors.error
        : daysLeft <= 2
            ? AppColors.warning
            : AppColors.success;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${daysLeft.clamp(0, 99)}', style: AppTypography.titleMedium.copyWith(color: color)),
          Text('days', style: TextStyle(fontSize: 9, color: color)),
        ],
      ),
    );
  }

  Widget _statusBadge(FlowerFreshnessStatus status) {
    final (label, variant) = switch (status) {
      FlowerFreshnessStatus.fresh => ('Fresh', PosStatusBadgeVariant.success),
      FlowerFreshnessStatus.markedDown => ('Marked Down', PosStatusBadgeVariant.warning),
      FlowerFreshnessStatus.disposed => ('Disposed', PosStatusBadgeVariant.error),
    };
    return PosStatusBadge(label: label, variant: variant);
  }
}
