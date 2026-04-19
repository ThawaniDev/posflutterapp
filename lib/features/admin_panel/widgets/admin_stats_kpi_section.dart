import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Definition of a single KPI card.
class KpiDef {
  final String label;
  final String value;
  final Color color;
  final String? subtitle;
  const KpiDef(this.label, this.value, this.color, [this.subtitle]);
}

/// Helper to create a [KpiDef].
KpiDef kpi(String label, dynamic value, Color color, [String? subtitle]) {
  final str = value is num
      ? (value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2))
      : value.toString();
  return KpiDef(label, str, color, subtitle);
}

/// Reusable KPI card section that watches an [AdminStatsState] provider
/// and renders a responsive grid of metric cards.
class AdminStatsKpiSection extends ConsumerWidget {
  final StateNotifierProvider<StateNotifier<AdminStatsState>, AdminStatsState> provider;
  final List<KpiDef> Function(Map<String, dynamic> data) cardBuilder;

  const AdminStatsKpiSection({super.key, required this.provider, required this.cardBuilder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return switch (state) {
      AdminStatsLoading() => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(child: PosLoading(size: 24)),
      ),
      AdminStatsLoaded(data: final resp) => _buildGrid(context, resp),
      AdminStatsError() || AdminStatsInitial() => const SizedBox.shrink(),
    };
  }

  Widget _buildGrid(BuildContext context, Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final defs = cardBuilder(data);
    if (defs.isEmpty) return const SizedBox.shrink();

    final cols = MediaQuery.of(context).size.width > 900 ? 4 : 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
      child: GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: AppSpacing.xs,
        mainAxisSpacing: AppSpacing.xs,
        childAspectRatio: cols == 4 ? 2.2 : 2.0,
        children: defs.map((d) => _card(d)).toList(),
      ),
    );
  }

  Widget _card(KpiDef d) {
    return PosCard(
      elevation: 1,
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(color: d.color, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    d.label,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 9),
              child: Text(
                d.value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: d.color),
              ),
            ),
            if (d.subtitle != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 9),
                child: Text(
                  d.subtitle!,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
