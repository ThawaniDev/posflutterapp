import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/badge_card.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class GamificationBadgesPage extends ConsumerStatefulWidget {
  const GamificationBadgesPage({super.key});

  @override
  ConsumerState<GamificationBadgesPage> createState() => _GamificationBadgesPageState();
}

class _GamificationBadgesPageState extends ConsumerState<GamificationBadgesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(badgesProvider.notifier).load();
      ref.read(badgeAwardsProvider.notifier).load();
    });
  }

  void _showCreateBadgeDialog() {
    final nameEnC = TextEditingController();
    final nameArC = TextEditingController();
    final slugC = TextEditingController();
    final thresholdC = TextEditingController(text: '10');
    String triggerType = 'items_per_minute';
    String period = 'daily';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.gamificationCreateBadge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: slugC,
                decoration: InputDecoration(labelText: l10n.slug),
              ),
              AppSpacing.gapH8,
              TextField(
                controller: nameEnC,
                decoration: const InputDecoration(labelText: 'Name (EN)'),
              ),
              AppSpacing.gapH8,
              TextField(
                controller: nameArC,
                decoration: const InputDecoration(labelText: 'Name (AR)'),
              ),
              AppSpacing.gapH8,
              DropdownButtonFormField<String>(
                value: triggerType,
                decoration: const InputDecoration(labelText: 'Trigger Type'),
                items: [
                  DropdownMenuItem(value: 'items_per_minute', child: Text('Items/min')),
                  DropdownMenuItem(value: 'total_transactions', child: Text('Total TXN')),
                  DropdownMenuItem(value: 'total_revenue', child: Text(l10n.reportsRevenue)),
                  DropdownMenuItem(value: 'avg_basket_size', child: Text(l10n.txStatsAvgBasket)),
                  DropdownMenuItem(value: 'upsell_rate', child: Text('Upsell Rate')),
                  DropdownMenuItem(value: 'zero_void_rate', child: Text('Zero Void Rate')),
                  DropdownMenuItem(value: 'consistency_king', child: Text('Consistency')),
                  DropdownMenuItem(value: 'early_bird', child: Text('Early Bird')),
                ],
                onChanged: (v) => triggerType = v ?? triggerType,
              ),
              AppSpacing.gapH8,
              TextField(
                controller: thresholdC,
                decoration: const InputDecoration(labelText: 'Threshold'),
                keyboardType: TextInputType.number,
              ),
              AppSpacing.gapH8,
              DropdownButtonFormField<String>(
                value: period,
                decoration: InputDecoration(labelText: l10n.period),
                items: [
                  DropdownMenuItem(value: 'daily', child: Text(l10n.gamificationDaily)),
                  DropdownMenuItem(value: 'shift', child: Text(l10n.gamificationShift)),
                  DropdownMenuItem(value: 'weekly', child: Text(l10n.notificationsDigestWeekly)),
                  DropdownMenuItem(value: 'monthly', child: Text(l10n.subscriptionMonthly)),
                ],
                onChanged: (v) => period = v ?? period,
              ),
            ],
          ),
        ),
        actions: [
          PosButton(
            onPressed: () => Navigator.pop(ctx),
            variant: PosButtonVariant.ghost,
            label: AppLocalizations.of(context)!.commonCancel,
          ),
          PosButton(
            onPressed: () {
              ref.read(badgesProvider.notifier).create({
                'slug': slugC.text,
                'name_en': nameEnC.text,
                'name_ar': nameArC.text,
                'trigger_type': triggerType,
                'trigger_threshold': double.tryParse(thresholdC.text) ?? 10,
                'period': period,
                'icon': '🏅',
                'color': '#FD8209',
              });
              Navigator.pop(ctx);
            },
            variant: PosButtonVariant.soft,
            label: AppLocalizations.of(context)!.commonCreate,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final badgesState = ref.watch(badgesProvider);
    final awardsState = ref.watch(badgeAwardsProvider);
    final isMobile = context.isPhone;

    return PosListPage(
      title: l10n.gamificationBadges,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.auto_fix_high_rounded,
          tooltip: l10n.gamificationSeedBadges,
          onPressed: () => ref.read(badgesProvider.notifier).seed(),
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () {
            ref.read(badgesProvider.notifier).load();
            ref.read(badgeAwardsProvider.notifier).load();
          },
        ),
        PosButton(label: l10n.commonCreate, icon: Icons.add, size: PosButtonSize.sm, onPressed: _showCreateBadgeDialog),
      ],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.gamificationBadgeDefinitions),
              PosTabItem(label: l10n.gamificationBadgeAwards),
            ],
          ),
          IndexedStack(
            index: _currentTab,
            children: [_buildBadgesTab(badgesState, l10n, isMobile), _buildAwardsTab(awardsState, l10n, isMobile)],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(BadgesState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      BadgesInitial() || BadgesLoading() => const Center(child: CircularProgressIndicator()),
      BadgesError(:final message) => Center(child: Text(message)),
      BadgesLoaded(:final badges) =>
        badges.isEmpty
            ? Center(child: Text(l10n.gamificationNoBadges))
            : ListView.builder(
                padding: context.responsivePagePadding,
                itemCount: badges.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BadgeCard(
                    badge: badges[index],
                    showActions: true,
                    onDelete: () => ref.read(badgesProvider.notifier).delete(badges[index].id),
                  ),
                ),
              ),
    };
  }

  Widget _buildAwardsTab(BadgeAwardsState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      BadgeAwardsInitial() || BadgeAwardsLoading() => const Center(child: CircularProgressIndicator()),
      BadgeAwardsError(:final message) => Center(child: Text(message)),
      BadgeAwardsLoaded(:final awards) =>
        awards.isEmpty
            ? Center(child: Text(l10n.gamificationNoAwards))
            : ListView.builder(
                padding: context.responsivePagePadding,
                itemCount: awards.length,
                itemBuilder: (context, index) {
                  final award = awards[index];
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text(award.badge?.icon ?? '🏅', style: const TextStyle(fontSize: 24)),
                      title: Text(award.cashier?.name ?? 'Cashier'),
                      subtitle: Text('${award.badge?.nameEn ?? ''} • ${award.earnedDate}'),
                      trailing: Text(award.metricValue.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
    };
  }
}
