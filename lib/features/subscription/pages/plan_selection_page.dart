import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Page that displays available subscription plans for the user to choose.
class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _isAnnual = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(plansProvider.notifier).loadPlans();
      ref.read(subscriptionProvider.notifier).loadCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(plansProvider);
    final subscriptionState = ref.watch(subscriptionProvider);

    // Listen for subscription action results
    ref.listen<SubscriptionState>(subscriptionProvider, (prev, next) {
      if (next is SubscriptionActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        context.go(Routes.subscriptionStatus);
      } else if (next is SubscriptionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.subscriptionChooseYourPlan,
      showSearch: false,
      actions: [
        PosButton(
          onPressed: () => context.go(Routes.planComparison),
          icon: Icons.compare_arrows,
          label: l10n.subscriptionCompare,
          variant: PosButtonVariant.outline,
          size: PosButtonSize.sm,
        ),
      ],
      child: _buildBody(plansState, subscriptionState),
    );
  }

  Widget _buildBody(PlansState plansState, SubscriptionState subState) {
    if (plansState is PlansLoading || subState is SubscriptionLoading) {
      return const PosLoading();
    }

    if (plansState is PlansError) {
      return PosErrorState(message: plansState.message, onRetry: () => ref.read(plansProvider.notifier).loadPlans());
    }

    if (plansState is PlansLoaded) {
      final currentPlanId = subState is SubscriptionLoaded ? subState.subscription?.subscriptionPlanId : null;
      return _buildPlansContent(plansState.plans, currentPlanId);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPlansContent(List<SubscriptionPlan> plans, String? currentPlanId) {
    return Column(
      children: [
        // ── Billing Toggle ──
        Padding(
          padding: AppSpacing.paddingAll16,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : AppColors.inputBgLight,
              borderRadius: AppRadius.borderFull,
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAnnual = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isAnnual ? AppColors.primary : Colors.transparent,
                        borderRadius: AppRadius.borderFull,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.subscriptionMonthly,
                        style: TextStyle(
                          color: !_isAnnual ? Colors.white : AppColors.mutedFor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAnnual = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isAnnual ? AppColors.primary : Colors.transparent,
                        borderRadius: AppRadius.borderFull,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.subscriptionAnnual,
                            style: TextStyle(
                              color: _isAnnual ? Colors.white : AppColors.mutedFor(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          AppSpacing.gapW4,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _isAnnual ? Colors.white.withValues(alpha: 0.2) : AppColors.success.withValues(alpha: 0.15),
                              borderRadius: AppRadius.borderFull,
                            ),
                            child: Text(
                              l10n.subscriptionSavePercent,
                              style: TextStyle(
                                fontSize: 10,
                                color: _isAnnual ? Colors.white : AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Plans List ──
        Expanded(
          child: ListView.builder(
            padding: AppSpacing.paddingH16,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isCurrent = plan.id == currentPlanId;
              return _buildPlanCard(plan, isCurrent);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, bool isCurrent) {
    final price = _isAnnual ? (plan.annualPrice ?? plan.monthlyPrice) : plan.monthlyPrice;
    final period = _isAnnual ? l10n.subPerYear : l10n.subPerMonth;
    final isHighlighted = plan.isHighlighted;
    final enabledFeatures = plan.features?.where((f) => f['is_enabled'] == true).toList() ?? [];
    final limits = plan.limits ?? [];
    final langCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isCurrent
              ? AppColors.primary
              : isHighlighted
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.borderFor(context),
          width: isCurrent || isHighlighted ? 2 : 1,
        ),
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header badges
          if (isHighlighted || isCurrent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
              ),
              child: Text(
                isCurrent ? l10n.subCurrentPlanBadge : l10n.subscriptionPopular,
                textAlign: TextAlign.center,
                style: TextStyle(color: isCurrent ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

          Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan name + description
                Text(
                  plan.localizedName(langCode),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (plan.localizedDescription(langCode) != null && plan.localizedDescription(langCode)!.isNotEmpty) ...[
                  AppSpacing.gapH4,
                  Text(
                    plan.localizedDescription(langCode)!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                AppSpacing.gapH16,

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price.toStringAsFixed(2),
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '  $period',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
                      ),
                    ),
                  ],
                ),

                // Annual savings
                if (_isAnnual && plan.annualPrice != null) ...[
                  AppSpacing.gapH4,
                  Builder(
                    builder: (context) {
                      final monthlyCost = plan.monthlyPrice * 12;
                      final savings = monthlyCost - plan.annualPrice!;
                      if (savings > 0) {
                        return Text(
                          'Save ${savings.toStringAsFixed(3)} /year',
                          style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],

                // Trial days
                if (plan.trialDays != null && plan.trialDays! > 0) ...[
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      const Icon(Icons.card_giftcard, size: 14, color: AppColors.successDark),
                      AppSpacing.gapW4,
                      Text(
                        l10n.subFreeTrialDays(plan.trialDays!),
                        style: const TextStyle(color: AppColors.successDark, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],

                // SoftPOS Free Tier
                if (plan.softposFreeEligible && plan.softposFreeThreshold != null) ...[
                  AppSpacing.gapH12,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.success.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.06)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.contactless, size: 18, color: AppColors.success),
                            AppSpacing.gapW8,
                            Expanded(
                              child: Text(
                                l10n.subSoftPosFreeAfter(plan.softposFreeThreshold!),
                                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapH4,
                        Text(
                          l10n.subSoftPosFreeExplainer(plan.softposFreeThreshold!, plan.softposFreeThresholdPeriod ?? 'monthly'),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context), fontSize: 11),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          l10n.subSoftPosOrPay(price.toStringAsFixed(2), ' $period'),
                          style: TextStyle(color: AppColors.mutedFor(context), fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],

                // Features & Limits section
                if (enabledFeatures.isNotEmpty || limits.isNotEmpty) ...[
                  AppSpacing.gapH16,
                  const PosDivider(),
                  AppSpacing.gapH12,
                ],

                // Features
                if (enabledFeatures.isNotEmpty) ...[
                  ...enabledFeatures.take(6).map((f) {
                    final name = SubscriptionPlan.featureName(f, langCode);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                          AppSpacing.gapW8,
                          Expanded(child: Text(name, style: Theme.of(context).textTheme.bodySmall)),
                        ],
                      ),
                    );
                  }),
                  if (enabledFeatures.length > 6)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '+${enabledFeatures.length - 6} more',
                        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],

                // Limits
                if (limits.isNotEmpty) ...[
                  AppSpacing.gapH8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: limits.map((l) {
                      final key = l['limit_key'] as String? ?? '';
                      final value = (l['limit_value'] as num?)?.toInt();
                      final label = _formatLimitKey(key);
                      return PosBadge(
                        label: value == null || value == -1 ? '$label: ∞' : '$label: $value',
                        variant: PosBadgeVariant.neutral,
                        isSmall: true,
                      );
                    }).toList(),
                  ),
                ],

                AppSpacing.gapH16,

                // CTA
                SizedBox(
                  width: double.infinity,
                  child: PosButton(
                    onPressed: isCurrent ? null : () => _onPlanSelected(plan),
                    label: isCurrent ? l10n.subCurrentPlanBadge : l10n.subscriptionSelectPlan,
                    variant: isCurrent ? PosButtonVariant.ghost : PosButtonVariant.primary,
                    size: PosButtonSize.lg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLimitKey(String key) {
    return switch (key) {
      'products' => l10n.subLimitProducts,
      'staff_members' => l10n.subLimitStaffMembers,
      'cashier_terminals' => l10n.subLimitCashierTerminals,
      'branches' => l10n.subLimitBranches,
      'transactions_per_month' => l10n.subLimitTransactionsPerMonth,
      'storage_mb' => l10n.subLimitStorageMb,
      'pdf_reports_per_month' => l10n.subLimitPdfReportsPerMonth,
      _ => key.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w).join(' '),
    };
  }

  void _onPlanSelected(SubscriptionPlan plan) {
    final apiService = ref.read(subscriptionApiServiceProvider);
    showPosBottomSheet(
      context,
      builder: (ctx) => _SubscriptionCheckoutSheet(
        plan: plan,
        isAnnual: _isAnnual,
        apiService: apiService,
        onConfirmed: ({required String billingCycle, required double finalPrice, String? discountCode}) {
          Navigator.pop(ctx);
          context.push(
            Routes.providerPaymentCheckout,
            extra: {
              'purpose': 'subscription',
              'purpose_label': '${plan.name} ($billingCycle)',
              'amount': finalPrice,
              'subscription_plan_id': plan.id,
              'billing_cycle': billingCycle,
              if (discountCode != null) 'discount_code': discountCode,
              'notes': 'Subscription: ${plan.name} - $billingCycle',
            },
          );
        },
      ),
    );
  }
}

// ─── Subscription Checkout Bottom Sheet ─────────────────────────────────────

typedef _ConfirmCallback = void Function({required String billingCycle, required double finalPrice, String? discountCode});

/// A rich bottom sheet for confirming a plan subscription.
/// Shows billing cycle selector, discount code field, and pricing summary.
class _SubscriptionCheckoutSheet extends StatefulWidget {
  const _SubscriptionCheckoutSheet({
    required this.plan,
    required this.isAnnual,
    required this.apiService,
    required this.onConfirmed,
  });

  final SubscriptionPlan plan;
  final bool isAnnual;
  final SubscriptionApiService apiService;
  final _ConfirmCallback onConfirmed;

  @override
  State<_SubscriptionCheckoutSheet> createState() => _SubscriptionCheckoutSheetState();
}

class _SubscriptionCheckoutSheetState extends State<_SubscriptionCheckoutSheet> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  late bool _isAnnual;
  final _discountController = TextEditingController();
  bool _validatingDiscount = false;
  String? _discountError;
  Map<String, dynamic>? _discountResult;

  @override
  void initState() {
    super.initState();
    _isAnnual = widget.isAnnual;
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  double get _basePrice => _isAnnual ? (widget.plan.annualPrice ?? widget.plan.monthlyPrice * 12) : widget.plan.monthlyPrice;

  double get _finalPrice {
    if (_discountResult != null) {
      final fp = (_discountResult!['final_price'] as num?)?.toDouble();
      if (fp != null) return fp;
    }
    return _basePrice;
  }

  double get _discountAmount {
    if (_discountResult != null) {
      return (_discountResult!['discount_amount'] as num?)?.toDouble() ?? 0.0;
    }
    return 0.0;
  }

  String get _billingCycle => _isAnnual ? 'yearly' : 'monthly';
  String get _billingCycleLabel => _isAnnual ? l10n.subBillingCycleYearly : l10n.subBillingCycleMonthly;

  Future<void> _validateDiscount() async {
    final code = _discountController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _validatingDiscount = true;
      _discountError = null;
      _discountResult = null;
    });

    try {
      final result = await widget.apiService.validateDiscount(code: code, planId: widget.plan.id, billingCycle: _billingCycle);
      setState(() {
        _discountResult = result;
        _discountError = null;
      });
    } catch (e) {
      setState(() {
        _discountError = l10n.subDiscountInvalid;
        _discountResult = null;
      });
    } finally {
      setState(() => _validatingDiscount = false);
    }
  }

  void _removeDiscount() {
    setState(() {
      _discountController.clear();
      _discountResult = null;
      _discountError = null;
    });
  }

  void _onCycleChanged(bool isAnnual) {
    setState(() {
      _isAnnual = isAnnual;
      _discountResult = null;
      _discountError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = Localizations.localeOf(context).languageCode;
    final planName = widget.plan.localizedName(langCode);
    final period = _isAnnual ? l10n.subPerYear : l10n.subPerMonth;
    final hasDiscount = _discountResult != null && _discountAmount > 0;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PosBottomSheetHeader(title: l10n.subSubscribeToPlan(planName), subtitle: l10n.subscriptionChooseYourPlan),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Billing Cycle Toggle ──
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.inputBgLight,
                    borderRadius: AppRadius.borderFull,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _buildCycleOption(l10n.subscriptionMonthly, false),
                      _buildCycleOption('${l10n.subscriptionAnnual} (${l10n.subscriptionSavePercent})', true),
                    ],
                  ),
                ),

                AppSpacing.gapH16,

                // ── Pricing Summary Card ──
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingAll16,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: AppRadius.borderLg,
                    border: Border.all(color: AppColors.borderFor(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(planName, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                                Text(
                                  _billingCycleLabel,
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (hasDiscount)
                                Text(
                                  '${_basePrice.toStringAsFixed(2)} $period',
                                  style: AppTypography.bodySmall.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.mutedFor(context),
                                  ),
                                ),
                              Text(
                                '${_finalPrice.toStringAsFixed(2)} $period',
                                style: AppTypography.titleLarge.copyWith(
                                  color: hasDiscount ? AppColors.success : AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (hasDiscount) ...[
                        AppSpacing.gapH8,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.10),
                            borderRadius: AppRadius.borderFull,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_offer, size: 14, color: AppColors.successDark),
                              AppSpacing.gapW4,
                              Text(
                                l10n.subDiscountSavings(_discountAmount.toStringAsFixed(2)),
                                style: const TextStyle(color: AppColors.successDark, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                AppSpacing.gapH16,

                // ── Discount Code Section ──
                Text(l10n.subDiscountCode, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                AppSpacing.gapH8,

                if (_discountResult != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.subDiscountApplied,
                                style: const TextStyle(color: AppColors.successDark, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                '${_discountResult!["code"]} · ${l10n.subDiscountOff(_discountResult!["value"].toString())}',
                                style: TextStyle(color: AppColors.mutedFor(context), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _removeDiscount,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text(l10n.subRemoveDiscount, style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PosTextField(
                          controller: _discountController,
                          label: l10n.subEnterDiscountCode,
                          errorText: _discountError,
                          onChanged: (_) {
                            if (_discountError != null) setState(() => _discountError = null);
                          },
                          onSubmitted: (_) => _validateDiscount(),
                        ),
                      ),
                      AppSpacing.gapW8,
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: PosButton(
                          onPressed: _validatingDiscount ? null : _validateDiscount,
                          label: _validatingDiscount ? l10n.subValidatingDiscount : l10n.subApplyDiscount,
                          size: PosButtonSize.sm,
                          variant: PosButtonVariant.outline,
                        ),
                      ),
                    ],
                  ),
                ],

                AppSpacing.gapH24,

                // ── Proceed Button ──
                PosButton(
                  label: l10n.subProceedToPayment,
                  icon: Icons.payment,
                  isFullWidth: true,
                  size: PosButtonSize.lg,
                  onPressed: () => widget.onConfirmed(
                    billingCycle: _billingCycle,
                    finalPrice: _finalPrice,
                    discountCode: _discountResult != null ? (_discountResult!['code'] as String?) : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleOption(String label, bool isAnnual) {
    final isSelected = _isAnnual == isAnnual;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onCycleChanged(isAnnual),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.borderFull,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.mutedFor(context),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
