import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_payment_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_refund_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_cash_session_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_expense_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_gift_card_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_accounting_config_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_thawani_settlement_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_daily_sales_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminFinOpsOverviewPage extends ConsumerStatefulWidget {
  const AdminFinOpsOverviewPage({super.key});

  @override
  ConsumerState<AdminFinOpsOverviewPage> createState() => _AdminFinOpsOverviewPageState();
}

class _AdminFinOpsOverviewPageState extends ConsumerState<AdminFinOpsOverviewPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(finOpsOverviewProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(finOpsOverviewProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsOverviewProvider);

    return PosListPage(
  title: l10n.adminFinOps,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              FinOpsOverviewLoading() => const Center(child: CircularProgressIndicator()),
              FinOpsOverviewLoaded(data: final resp) => _buildContent(resp),
              FinOpsOverviewError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
                    const SizedBox(height: AppSpacing.md),
                    PosButton(
                      onPressed: () => ref.read(finOpsOverviewProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => Center(child: Text(l10n.adminLoadingFinancial)),
            },
          ),
        ],
      ),
);
  }

  Widget _buildContent(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;

    return RefreshIndicator(
      onRefresh: () => ref.read(finOpsOverviewProvider.notifier).load(storeId: _storeId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Overview'),
            const SizedBox(height: AppSpacing.sm),
            _buildKpiGrid(data),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle('Sections'),
            const SizedBox(height: AppSpacing.sm),
            _buildNavigationGrid(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
    );
  }

  Widget _buildKpiGrid(Map<String, dynamic> data) {
    final payments = data['payments'] as Map<String, dynamic>? ?? {};
    final refunds = data['refunds'] as Map<String, dynamic>? ?? {};
    final cashSessions = data['cash_sessions'] as Map<String, dynamic>? ?? {};
    final expenses = data['expenses'] as Map<String, dynamic>? ?? {};
    final giftCards = data['gift_cards'] as Map<String, dynamic>? ?? {};
    final thawani = data['thawani_settlements'] as Map<String, dynamic>? ?? {};

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.8,
      children: [
        _kpiCard('Payments', '${payments['total'] ?? 0}', '\u0081. ${_fmt(payments['total_amount'])}', AppColors.primary),
        _kpiCard('Refunds', '${refunds['total'] ?? 0}', '${refunds['pending'] ?? 0} pending', AppColors.warning),
        _kpiCard('Cash Sessions', '${cashSessions['total'] ?? 0}', '${cashSessions['open'] ?? 0} open', AppColors.info),
        _kpiCard('Expenses', '${expenses['total'] ?? 0}', '\u0081. ${_fmt(expenses['total_amount'])}', AppColors.error),
        _kpiCard('Gift Cards', '${giftCards['total'] ?? 0}', '${giftCards['active'] ?? 0} active', AppColors.success),
        _kpiCard('Thawani Net', '${thawani['total'] ?? 0}', '\u0081. ${_fmt(thawani['total_net'])}', const Color(0xFF6366F1)),
      ],
    );
  }

  Widget _kpiCard(String label, String value, String subtitle, Color color) {
    return PosCard(
      elevation: 2,
      borderRadius: BorderRadius.circular(12,),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(dynamic value) {
    if (value == null) return '0.00';
    final num n = value is num ? value : num.tryParse(value.toString()) ?? 0;
    return n.toStringAsFixed(2);
  }

  Widget _buildNavigationGrid() {
    final items = [
      _NavItem('Payments', Icons.payment, () => _navigate(const AdminFinOpsPaymentListPage())),
      _NavItem('Refunds', Icons.replay, () => _navigate(const AdminFinOpsRefundListPage())),
      _NavItem('Cash Sessions', Icons.point_of_sale, () => _navigate(const AdminFinOpsCashSessionListPage())),
      _NavItem('Expenses', Icons.receipt_long, () => _navigate(const AdminFinOpsExpenseListPage())),
      _NavItem('Gift Cards', Icons.card_giftcard, () => _navigate(const AdminFinOpsGiftCardListPage())),
      _NavItem('Accounting', Icons.account_balance, () => _navigate(const AdminFinOpsAccountingConfigListPage())),
      _NavItem('Thawani Settlements', Icons.handshake, () => _navigate(const AdminFinOpsThawaniSettlementListPage())),
      _NavItem('Daily Sales', Icons.bar_chart, () => _navigate(const AdminFinOpsDailySalesPage())),
    ];

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.5,
      children: items.map((item) => _navCard(item)).toList(),
    );
  }

  Widget _navCard(_NavItem item) {
    return PosCard(
      elevation: 1,
      borderRadius: BorderRadius.circular(12,),
      child: InkWell(
        borderRadius: AppRadius.borderLg,
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 32, color: AppColors.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _NavItem(this.label, this.icon, this.onTap);
}
