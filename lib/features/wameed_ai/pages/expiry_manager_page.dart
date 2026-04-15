import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_urgency_card.dart';

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
        AIFeatureResultInitial() || AIFeatureResultLoading() => PosLoading(message: l10n.wameedAIAnalyzing),
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

    // Backend returns 'alerts' array from AI, or 'alerts' (empty) for no-data fallback
    final expiringProducts =
        (data['alerts'] as List?)?.cast<Map<String, dynamic>>() ??
        (data['expiring_products'] as List?)?.cast<Map<String, dynamic>>() ??
        [];
    // Backend returns 'summary_ar' as a string, not a Map
    final summaryText = data['summary_ar']?.toString() ?? data['summary']?.toString() ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary chip showing count
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _summaryCard(
                context,
                Icons.warning,
                l10n.wameedAIExpiringProducts,
                '${expiringProducts.length}',
                expiringProducts.isEmpty ? AppColors.success : AppColors.error,
              ),
            ],
          ),

          // AI summary text
          if (summaryText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: SelectableText(summaryText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
            ),
          ],

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
                final daysLeft = item['days_remaining'] ?? item['days_until_expiry'] ?? item['days_left'] ?? 0;
                final quantity = item['current_stock'] ?? item['quantity'] ?? item['stock'] ?? 0;
                final expiryDate = item['expiry_date'] ?? '';
                final batchNumber = item['batch_number'] ?? '';
                final suggestedAction = item['suggested_action'] ?? '';
                final suggestedDiscount = item['suggested_discount_pct'] ?? item['suggested_discount'];
                final daysInt = (daysLeft is num) ? daysLeft.toInt() : 0;
                final urgency = daysInt <= 3 ? 'critical' : (daysInt <= 7 ? 'high' : 'medium');

                return AIUrgencyCard(
                  title: productName.toString(),
                  subtitle: suggestedAction.toString().isNotEmpty
                      ? suggestedAction.toString()
                      : '${l10n.wameedAIExpiresOn}: $expiryDate',
                  urgency: urgency,
                  icon: Icons.timer_outlined,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _countdownChip(context, daysLeft),
                        _infoChip(context, '${l10n.wameedAIQty}: $quantity'),
                        if (batchNumber.toString().isNotEmpty) _infoChip(context, '${l10n.wameedAIBatch}: $batchNumber'),
                        if (expiryDate.toString().isNotEmpty) _infoChip(context, expiryDate.toString()),
                        if (suggestedDiscount != null)
                          _discountChip(context, l10n.wameedAIDiscountOff(suggestedDiscount.toString())),
                      ],
                    ),
                  ],
                );
              },
            ),
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
