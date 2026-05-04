import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/zatca/repositories/zatca_repository.dart';

final zatcaAdminOverviewProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(zatcaRepositoryProvider);
  final result = await repo.adminOverview();
  return Map<String, dynamic>.from(result['data'] as Map);
});

class ZatcaAdminOverviewPage extends ConsumerWidget {
  const ZatcaAdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(zatcaAdminOverviewProvider);

    return PosListPage(
      title: '${l10n.zatcaTitle} • Admin',
      showSearch: false,
      child: async.when(
        loading: () => const Center(
          child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: AppSpacing.paddingAll20,
          child: Text(e.toString(), style: const TextStyle(color: AppColors.error)),
        ),
        data: (data) => _buildContent(context, l10n, data, ref),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n, Map<String, dynamic> data, WidgetRef ref) {
    final totals = Map<String, dynamic>.from(data['totals'] as Map);
    final stores = (data['stores'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(zatcaAdminOverviewProvider.future),
      child: ListView(
        padding: AppSpacing.paddingAll20,
        children: [
          PosCard(
            padding: AppSpacing.paddingAll16,
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _stat('${totals['stores'] ?? 0}', 'Stores', AppColors.info),
                _stat('${totals['connected'] ?? 0}', l10n.zatcaConnected, AppColors.success),
                _stat('${totals['healthy'] ?? 0}', l10n.zatcaHealthy, AppColors.success),
                _stat('${totals['tampered'] ?? 0}', 'Tampered', (totals['tampered'] ?? 0) > 0 ? AppColors.error : AppColors.info),
                _stat('${totals['accepted'] ?? 0}', 'Accepted', AppColors.success),
                _stat('${totals['rejected'] ?? 0}', 'Rejected', AppColors.error),
                _stat('${totals['pending'] ?? 0}', 'Pending', AppColors.warning),
              ],
            ),
          ),
          AppSpacing.gapH16,
          ...stores.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PosCard(
                padding: AppSpacing.paddingAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(s['store_name']?.toString() ?? '', style: Theme.of(context).textTheme.titleMedium)),
                        _healthDot(s['is_healthy'] == true, s['connected'] == true),
                      ],
                    ),
                    AppSpacing.gapH8,
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _chip('${s['environment']}', AppColors.info),
                        _chip('Acc ${s['accepted'] ?? 0}', AppColors.success),
                        _chip('Rej ${s['rejected'] ?? 0}', (s['rejected'] ?? 0) > 0 ? AppColors.error : AppColors.info),
                        _chip('Queue ${s['queue_depth'] ?? 0}', (s['queue_depth'] ?? 0) > 0 ? AppColors.warning : AppColors.info),
                        if (s['expiring_soon'] == true) _chip('Cert in ${s['days_until_expiry']}d', AppColors.warning),
                        if ((s['tampered_devices'] ?? 0) > 0) _chip('Tampered ${s['tampered_devices']}', AppColors.error),
                      ],
                    ),
                    if (s['last_error_message'] != null) ...[
                      AppSpacing.gapH8,
                      Text(
                        l10n.zatcaLastErrorMessage(s['last_error_message'].toString()),
                        style: const TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }

  Widget _healthDot(bool healthy, bool connected) {
    final color = healthy ? AppColors.success : (connected ? AppColors.warning : AppColors.error);
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
