import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_urgency_card.dart';

class ExpiryManagerPage extends ConsumerStatefulWidget {
  const ExpiryManagerPage({super.key});

  @override
  ConsumerState<ExpiryManagerPage> createState() => _ExpiryManagerPageState();
}

class _ExpiryManagerPageState extends ConsumerState<ExpiryManagerPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('expiry_manager');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(l10n.wameedAIExpiryManager),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('expiry_manager'),
          ),
        ],
      ),
      body: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Checking expiry dates...')],
          ),
        ),
        AIFeatureResultError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              PosButton(
                label: l10n.commonRetry,
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('expiry_manager'),
              ),
            ],
          ),
        ),
        AIFeatureResultLoaded(:final result) => _buildContent(result.data, isMobile, l10n),
      },
    );
  }

  Widget _buildContent(Map<String, dynamic>? data, bool isMobile, AppLocalizations l10n) {
    if (data == null) {
      return Center(
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.check_circle),
      );
    }

    final expiringProducts = (data['expiring_products'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final summary = data['summary'] as Map<String, dynamic>? ?? {};
    final suggestions = data['action_suggestions'] as List? ?? data['suggestions'] as List? ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          if (summary.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _summaryCard(
                  context,
                  Icons.warning,
                  l10n.wameedAIExpiringToday,
                  '${summary['expiring_today'] ?? 0}',
                  AppColors.error,
                ),
                _summaryCard(
                  context,
                  Icons.schedule,
                  l10n.wameedAIExpiringThisWeek,
                  '${summary['expiring_this_week'] ?? 0}',
                  AppColors.warning,
                ),
                _summaryCard(
                  context,
                  Icons.event,
                  l10n.wameedAIExpiringThisMonth,
                  '${summary['expiring_this_month'] ?? 0}',
                  AppColors.info,
                ),
                _summaryCard(
                  context,
                  Icons.attach_money,
                  l10n.wameedAIAtRiskValue,
                  '\$${summary['at_risk_value'] ?? 'N/A'}',
                  AppColors.error,
                ),
              ],
            ),

          const SizedBox(height: 24),
          Text(
            l10n.wameedAIExpiringProducts,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          if (expiringProducts.isEmpty)
            PosEmptyState(title: l10n.wameedAINoExpiringProducts, icon: Icons.check_circle_outline)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expiringProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = expiringProducts[index];
                final productName = item['product_name'] ?? item['name'] ?? 'Unknown';
                final daysLeft = item['days_until_expiry'] ?? item['days_left'] ?? 0;
                final quantity = item['quantity'] ?? item['stock'] ?? 0;
                final expiryDate = item['expiry_date'] ?? '';
                final suggestedDiscount = item['suggested_discount'] ?? item['discount_suggestion'];
                final urgency = (daysLeft as num).toInt() <= 3
                    ? 'critical'
                    : ((daysLeft as num).toInt() <= 7 ? 'high' : 'medium');

                return AIUrgencyCard(
                  title: productName.toString(),
                  subtitle: '${l10n.wameedAIExpiresOn}: $expiryDate',
                  urgency: urgency,
                  icon: Icons.timer_outlined,
                  children: [
                    Row(
                      children: [
                        _countdownChip(context, daysLeft),
                        const SizedBox(width: 8),
                        _infoChip(context, 'Qty: $quantity'),
                        if (suggestedDiscount != null) ...[
                          const SizedBox(width: 8),
                          _discountChip(context, '$suggestedDiscount% off'),
                        ],
                      ],
                    ),
                  ],
                );
              },
            ),

          // Action suggestions
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.wameedAIActionSuggestions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...suggestions.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates, size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(child: Text('$s', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countdownChip(BuildContext context, dynamic daysLeft) {
    final days = (daysLeft is num) ? daysLeft.toInt() : 0;
    final color = days <= 3 ? AppColors.error : (days <= 7 ? AppColors.warning : AppColors.success);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(
        '$days days',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _infoChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
    );
  }

  Widget _discountChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.success),
      ),
    );
  }
}
