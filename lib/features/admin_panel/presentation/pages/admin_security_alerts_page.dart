import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityAlertsPage extends ConsumerStatefulWidget {
  const AdminSecurityAlertsPage({super.key});

  @override
  ConsumerState<AdminSecurityAlertsPage> createState() => _AdminSecurityAlertsPageState();
}

class _AdminSecurityAlertsPageState extends ConsumerState<AdminSecurityAlertsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(secCenterAlertListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(secCenterAlertListProvider);

    return PosListPage(
  title: l10n.securityAlerts,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              SecCenterAlertListLoading() => const Center(child: CircularProgressIndicator()),
              SecCenterAlertListError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    PosButton(onPressed: () => _loadData(), label: l10n.retry),
                  ],
                ),
              ),
              SecCenterAlertListLoaded(data: final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
);
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return Center(child: Text(l10n.adminNoSecurityAlertsShort));
    }
    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          final severity = item['severity']?.toString() ?? '';
          return PosCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                color: severity == 'critical'
                    ? AppColors.error
                    : severity == 'high'
                    ? AppColors.warning
                    : AppColors.warning,
              ),
              title: Text(item['alert_type']?.toString() ?? 'Alert'),
              subtitle: Text('Severity: $severity\nStatus: ${item['status'] ?? 'unknown'}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
