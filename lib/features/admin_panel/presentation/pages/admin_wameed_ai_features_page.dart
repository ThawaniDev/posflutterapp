import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAIFeaturesPage extends ConsumerStatefulWidget {
  const AdminWameedAIFeaturesPage({super.key});

  @override
  ConsumerState<AdminWameedAIFeaturesPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIFeaturesPage> {
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wameedAIAdminFeaturesProvider.notifier).load());
  }

  void _reload() => ref.read(wameedAIAdminFeaturesProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wameedAIAdminFeaturesProvider);

    ref.listen<WameedAIAdminActionState>(wameedAIAdminActionProvider, (_, next) {
      if (next is WameedAIAdminActionSuccess) {
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success)));
      } else if (next is WameedAIAdminActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    return PosListPage(
  title: l10n.adminWameedAIFeatures,
  showSearch: false,
    child: switch (state) {
        WameedAIAdminListLoading() => const Center(child: PosLoading()),
        WameedAIAdminListLoaded(data: final resp) => _buildContent(resp, l10n),
        WameedAIAdminListError(message: final msg) => PosErrorState(message: msg, onRetry: _reload),
        _ => Center(child: Text(l10n.loading)),
      },
);
  }

  Widget _buildContent(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as List? ?? [];
    final features = data.cast<Map<String, dynamic>>();

    // Compute KPIs
    final int total = features.length;
    final int enabled = features.where((f) => f['is_enabled'] == true).length;
    final categories = features.map((f) => f['category']?.toString() ?? '').toSet();

    // Group by category
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final f in features) {
      final cat = f['category']?.toString() ?? 'other';
      grouped.putIfAbsent(cat, () => []).add(f);
    }

    final filteredGroups = _categoryFilter != null && _categoryFilter!.isNotEmpty
        ? {_categoryFilter!: grouped[_categoryFilter] ?? []}
        : grouped;

    return RefreshIndicator(
      onRefresh: () => ref.read(wameedAIAdminFeaturesProvider.notifier).load(),
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
                  label: l10n.adminWameedAITotalFeatures,
                  value: '$total',
                  subtitle: '${categories.length} ${l10n.categories}',
                  icon: Icons.auto_awesome_rounded,
                  iconColor: AppColors.primary,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAIEnabledFeatures,
                  value: '$enabled',
                  subtitle: '${total - enabled} ${l10n.disabled}',
                  icon: Icons.toggle_on_rounded,
                  iconColor: AppColors.success,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAICategories,
                  value: '${categories.length}',
                  subtitle: l10n.adminWameedAIFeatureCategories,
                  icon: Icons.category_rounded,
                  iconColor: AppColors.info,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAIEnableRate,
                  value: total > 0 ? '${((enabled / total) * 100).toStringAsFixed(0)}%' : '0%',
                  subtitle: '$enabled / $total',
                  icon: Icons.percent_rounded,
                  iconColor: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Category Filter ──
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l10n.all),
                  selected: _categoryFilter == null,
                  onSelected: (_) => setState(() => _categoryFilter = null),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _categoryFilter == null ? Colors.white : null),
                ),
                ...categories.map(
                  (c) => ChoiceChip(
                    label: Text(_formatCategory(c)),
                    selected: _categoryFilter == c,
                    onSelected: (_) => setState(() => _categoryFilter = _categoryFilter == c ? null : c),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: _categoryFilter == c ? Colors.white : null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Feature List by Category ──
            ...filteredGroups.entries.map(
              (entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatCategory(entry.key), style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.sm),
                  ...entry.value.map((f) => _featureCard(f, l10n)),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(Map<String, dynamic> feature, AppLocalizations l10n) {
    final name = feature['name']?.toString() ?? '';
    final slug = feature['slug']?.toString() ?? '';
    final isEnabled = feature['is_enabled'] == true;
    final id = feature['id']?.toString() ?? '';
    final description = feature['description']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: PosCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(slug, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(description, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                activeThumbColor: AppColors.success,
                onChanged: (v) {
                  ref.read(wameedAIAdminActionProvider.notifier).toggleFeature(id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCategory(String cat) {
    return cat.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w).join(' ');
  }
}
