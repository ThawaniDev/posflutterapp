import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminPlanDetailPage extends ConsumerStatefulWidget {
  final String planId;
  const AdminPlanDetailPage({super.key, required this.planId});

  @override
  ConsumerState<AdminPlanDetailPage> createState() => _AdminPlanDetailPageState();
}

class _AdminPlanDetailPageState extends ConsumerState<AdminPlanDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(planDetailProvider.notifier).loadPlan(widget.planId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planDetailProvider);
    final isLoading = state is PlanDetailLoading;

    return PosFormPage(
      title: l10n.planDetails,
      isLoading: isLoading,
      child: switch (state) {
        PlanDetailError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              AppSpacing.gapH16,
              PosButton(
                label: l10n.retry,
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(planDetailProvider.notifier).loadPlan(widget.planId),
              ),
            ],
          ),
        ),
        PlanDetailLoaded(:final plan) => _PlanDetailBody(plan: plan),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _PlanDetailBody extends StatelessWidget {
  final Map<String, dynamic> plan;
  const _PlanDetailBody({required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = plan['features'] as List? ?? [];
    final limits = plan['limits'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        PosCard(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (plan['name_ar'] != null) ...[
                  AppSpacing.gapH4,
                  Text(plan['name_ar'], style: TextStyle(fontSize: 16, color: AppColors.mutedFor(context))),
                ],
                AppSpacing.gapH8,
                Row(
                  children: [
                    _PriceChip(label: l10n.subscriptionMonthly, price: plan['monthly_price']?.toString() ?? '0'),
                    AppSpacing.gapW8,
                    if (plan['annual_price'] != null)
                      _PriceChip(label: l10n.subscriptionAnnual, price: plan['annual_price'].toString()),
                  ],
                ),
              ],
            ),
          ),
        ),

        AppSpacing.gapH16,

        // Features
        if (features.isNotEmpty) ...[
          Text(l10n.subscriptionFeatures, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          AppSpacing.gapH8,
          ...features.map(
            (f) => ListTile(
              leading: Icon(
                f['is_enabled'] == true ? Icons.check_circle : Icons.cancel,
                color: f['is_enabled'] == true ? AppColors.success : AppColors.error,
              ),
              title: Text(f['feature_key'] ?? ''),
              dense: true,
            ),
          ),
          AppSpacing.gapH16,
        ],

        // Limits
        if (limits.isNotEmpty) ...[
          Text(l10n.settingsPosLimits, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          AppSpacing.gapH8,
          ...limits.map(
            (l) => ListTile(
              leading: const Icon(Icons.data_usage),
              title: Text(l['limit_key'] ?? ''),
              trailing: Text('${l['limit_value']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: l['price_per_extra_unit'] != null ? Text('\u0081${l['price_per_extra_unit']} per extra unit') : null,
              dense: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final String price;
  const _PriceChip({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderXxl),
      child: Text(
        '$label: \$$price',
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
