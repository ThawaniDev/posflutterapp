import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/l10n/app_localizations.dart';

class AdminWameedAIProvidersPage extends ConsumerStatefulWidget {
  const AdminWameedAIProvidersPage({super.key});

  @override
  ConsumerState<AdminWameedAIProvidersPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIProvidersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wameedAIAdminProvidersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wameedAIAdminProvidersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminWameedAIProviders),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: switch (state) {
        WameedAIAdminListLoading() => const Center(child: PosLoading()),
        WameedAIAdminListLoaded(data: final resp) => _buildContent(resp, l10n),
        WameedAIAdminListError(message: final msg) => PosErrorState(
          title: l10n.errorLoadingData,
          message: msg,
          onRetry: () => ref.read(wameedAIAdminProvidersProvider.notifier).load(),
        ),
        _ => Center(child: Text(l10n.loading)),
      },
    );
  }

  Widget _buildContent(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final providers = (data['providers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Calculate stats across all providers
    int totalModels = 0;
    int totalEnabled = 0;
    int totalWithKeys = 0;
    int totalActive = 0;
    for (final p in providers) {
      totalModels += (p['model_count'] as num?)?.toInt() ?? 0;
      totalEnabled += (p['enabled_count'] as num?)?.toInt() ?? 0;
      totalWithKeys += (p['models_with_keys'] as num?)?.toInt() ?? 0;
      if (p['is_active'] == true) totalActive++;
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(wameedAIAdminProvidersProvider.notifier).load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── KPI Cards ──
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 2.2,
              children: [
                PosKpiCard(
                  title: l10n.adminWameedAITotalProviders,
                  value: '${providers.length}',
                  subtitle: '$totalActive ${l10n.active}',
                  icon: Icons.cloud_rounded,
                  color: AppColors.primary,
                ),
                PosKpiCard(
                  title: l10n.adminWameedAITotalModelsKpi,
                  value: '$totalModels',
                  subtitle: '$totalEnabled ${l10n.enabled}',
                  icon: Icons.psychology_rounded,
                  color: AppColors.info,
                ),
                PosKpiCard(
                  title: l10n.adminWameedAIModelsWithKeys,
                  value: '$totalWithKeys',
                  subtitle: l10n.adminWameedAIConfiguredModels,
                  icon: Icons.vpn_key_rounded,
                  color: AppColors.success,
                ),
                PosKpiCard(
                  title: l10n.adminWameedAIActiveProviders,
                  value: '$totalActive',
                  subtitle: '${l10n.of_} ${providers.length} ${l10n.providers}',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.adminWameedAIProviders, style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            // ── Provider Cards ──
            ...providers.map((p) => _providerCard(p, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _providerCard(Map<String, dynamic> provider, AppLocalizations l10n) {
    final name = (provider['provider'] ?? '').toString().toUpperCase();
    final modelCount = (provider['model_count'] as num?)?.toInt() ?? 0;
    final enabledCount = (provider['enabled_count'] as num?)?.toInt() ?? 0;
    final hasDefault = provider['has_default'] == true;
    final modelsWithKeys = (provider['models_with_keys'] as num?)?.toInt() ?? 0;
    final isActive = provider['is_active'] == true;

    IconData providerIcon;
    Color providerColor;
    switch (name) {
      case 'OPENAI':
        providerIcon = Icons.auto_awesome;
        providerColor = const Color(0xFF10A37F);
        break;
      case 'ANTHROPIC':
        providerIcon = Icons.psychology;
        providerColor = const Color(0xFFD97757);
        break;
      case 'GOOGLE':
        providerIcon = Icons.smart_toy;
        providerColor = const Color(0xFF4285F4);
        break;
      default:
        providerIcon = Icons.cloud;
        providerColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: PosCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: providerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(providerIcon, color: providerColor, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: AppSpacing.sm),
                        PosBadge(
                          label: isActive ? l10n.active : l10n.inactive,
                          color: isActive ? AppColors.success : AppColors.textMutedLight,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$modelCount ${l10n.models} • $enabledCount ${l10n.enabled} • $modelsWithKeys ${l10n.withKeys}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
              if (hasDefault)
                PosBadge(label: l10n.hasDefault, color: AppColors.info),
            ],
          ),
        ),
      ),
    );
  }
}
