import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:wameedpos/features/industry_florist/enums/flower_freshness_status.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class FreshnessLogCard extends StatelessWidget {

  const FreshnessLogCard({super.key, required this.log, this.onTap});
  final FlowerFreshnessLog log;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysLeft = _daysUntilExpiry;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Row(
            children: [
              _expiryIndicator(context, daysLeft),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.floristProductWithId(log.productId), style: AppTypography.titleSmall),
                    Text(l10n.floristQtyReceivedOn(log.quantity.toString(), log.receivedDate.toString()), style: AppTypography.caption),
                  ],
                ),
              ),
              if (log.status != null) _statusBadge(log.status!),
            ],
          ),
        ),
      ),
    );
  }

  int get _daysUntilExpiry {
    final expiryDate = log.receivedDate.add(Duration(days: log.expectedVaseLifeDays));
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Widget _expiryIndicator(BuildContext context, int daysLeft) {
    final l10n = AppLocalizations.of(context)!;
    final color = daysLeft <= 0
        ? AppColors.error
        : daysLeft <= 2
        ? AppColors.warning
        : AppColors.success;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderSm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${daysLeft.clamp(0, 99)}', style: AppTypography.titleMedium.copyWith(color: color)),
          Text(l10n.securityDays, style: TextStyle(fontSize: 9, color: color)),
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
