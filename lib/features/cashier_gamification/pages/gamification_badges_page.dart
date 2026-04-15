import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/badge_card.dart';

class GamificationBadgesPage extends ConsumerStatefulWidget {
  const GamificationBadgesPage({super.key});

  @override
  ConsumerState<GamificationBadgesPage> createState() => _GamificationBadgesPageState();
}

class _GamificationBadgesPageState extends ConsumerState<GamificationBadgesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(badgesProvider.notifier).load();
      ref.read(badgeAwardsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                decoration: const InputDecoration(labelText: 'Slug'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameEnC,
                decoration: const InputDecoration(labelText: 'Name (EN)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameArC,
                decoration: const InputDecoration(labelText: 'Name (AR)'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: triggerType,
                decoration: const InputDecoration(labelText: 'Trigger Type'),
                items: const [
                  DropdownMenuItem(value: 'items_per_minute', child: Text('Items/min')),
                  DropdownMenuItem(value: 'total_transactions', child: Text('Total TXN')),
                  DropdownMenuItem(value: 'total_revenue', child: Text('Revenue')),
                  DropdownMenuItem(value: 'avg_basket_size', child: Text('Avg Basket')),
                  DropdownMenuItem(value: 'upsell_rate', child: Text('Upsell Rate')),
                  DropdownMenuItem(value: 'zero_void_rate', child: Text('Zero Void Rate')),
                  DropdownMenuItem(value: 'consistency_king', child: Text('Consistency')),
                  DropdownMenuItem(value: 'early_bird', child: Text('Early Bird')),
                ],
                onChanged: (v) => triggerType = v ?? triggerType,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: thresholdC,
                decoration: const InputDecoration(labelText: 'Threshold'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: period,
                decoration: const InputDecoration(labelText: 'Period'),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'shift', child: Text('Shift')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                ],
                onChanged: (v) => period = v ?? period,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.commonCancel)),
          FilledButton(
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
            child: Text(AppLocalizations.of(context)!.commonCreate),
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.gamificationBadges),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.gamificationBadgeDefinitions),
            Tab(text: l10n.gamificationBadgeAwards),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high_rounded),
            tooltip: l10n.gamificationSeedBadges,
            onPressed: () => ref.read(badgesProvider.notifier).seed(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () {
              ref.read(badgesProvider.notifier).load();
              ref.read(badgeAwardsProvider.notifier).load();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showCreateBadgeDialog, child: const Icon(Icons.add)),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Badge Definitions
          _buildBadgesTab(badgesState, l10n, isMobile),
          // Tab 2: Badge Awards
          _buildAwardsTab(awardsState, l10n, isMobile),
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
                padding: EdgeInsets.all(isMobile ? 12 : 16),
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
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                itemCount: awards.length,
                itemBuilder: (context, index) {
                  final award = awards[index];
                  return Card(
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
