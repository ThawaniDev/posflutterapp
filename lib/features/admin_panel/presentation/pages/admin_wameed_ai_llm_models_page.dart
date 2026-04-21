import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAILlmModelsPage extends ConsumerStatefulWidget {
  const AdminWameedAILlmModelsPage({super.key});

  @override
  ConsumerState<AdminWameedAILlmModelsPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAILlmModelsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wameedAIAdminLlmModelsProvider.notifier).load());
  }

  void _reload() => ref.read(wameedAIAdminLlmModelsProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wameedAIAdminLlmModelsProvider);

    ref.listen<WameedAIAdminActionState>(wameedAIAdminActionProvider, (_, next) {
      if (next is WameedAIAdminActionSuccess) {
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success)));
      } else if (next is WameedAIAdminActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    return PosListPage(
      title: l10n.adminWameedAILlmModels,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.add_rounded, onPressed: () => _showCreateDialog(l10n))],
      child: switch (state) {
        WameedAIAdminListLoading() => const Center(child: PosLoading()),
        WameedAIAdminListLoaded(data: final resp) => _buildContent(resp, l10n),
        WameedAIAdminListError(message: final msg) => PosErrorState(message: msg, onRetry: _reload),
        _ => Center(child: Text(l10n.loading)),
      },
    );
  }

  Widget _buildContent(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final models = (data['models'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // KPIs
    final int total = models.length;
    final int enabled = models.where((m) => m['is_enabled'] == true).length;
    final int withKeys = models.where((m) => m['has_custom_api_key'] == true).length;
    final int defaultCount = models.where((m) => m['is_default'] == true).length;
    double totalCost = 0;
    int totalRequests = 0;
    for (final m in models) {
      final metrics = m['metrics'] as Map<String, dynamic>? ?? {};
      totalCost += (metrics['total_cost'] as num?)?.toDouble() ?? 0;
      totalRequests += (metrics['total_requests'] as num?)?.toInt() ?? 0;
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(wameedAIAdminLlmModelsProvider.notifier).load(),
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
                  label: l10n.adminWameedAITotalModelsKpi,
                  value: '$total',
                  subtitle: '$enabled ${l10n.enabled}',
                  icon: Icons.psychology_rounded,
                  iconColor: AppColors.primary,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAIActiveModels,
                  value: '$enabled',
                  subtitle: '$withKeys ${l10n.withKeys}',
                  icon: Icons.check_circle_rounded,
                  iconColor: AppColors.success,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAITotalRequestsModel,
                  value: _fmtLargeNumber(totalRequests),
                  subtitle: '$defaultCount ${l10n.defaults}',
                  icon: Icons.api_rounded,
                  iconColor: AppColors.info,
                ),
                PosKpiCard(
                  label: l10n.adminWameedAITotalCostModel,
                  value: '\$${totalCost.toStringAsFixed(4)}',
                  subtitle: l10n.adminWameedAIAcrossAllModels,
                  icon: Icons.attach_money_rounded,
                  iconColor: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // ── Model Table ──
            PosCard(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: AppSpacing.lg,
                  columns: [
                    DataColumn(label: Text(l10n.providers)),
                    DataColumn(label: Text(l10n.model)),
                    DataColumn(label: Text(l10n.displayName)),
                    DataColumn(label: Text(l10n.status)),
                    DataColumn(label: Text(l10n.requests), numeric: true),
                    DataColumn(label: Text(l10n.cost), numeric: true),
                    DataColumn(label: Text(l10n.adminWameedAIAvgLatency), numeric: true),
                    DataColumn(label: Text(l10n.actions)),
                  ],
                  rows: models.map((m) {
                    final metrics = m['metrics'] as Map<String, dynamic>? ?? {};
                    final isEnabled = m['is_enabled'] == true;
                    final isDefault = m['is_default'] == true;
                    final id = m['id']?.toString() ?? '';

                    return DataRow(
                      cells: [
                        DataCell(Text((m['provider'] ?? '').toString().toUpperCase())),
                        DataCell(Text(m['model_id']?.toString() ?? '')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m['display_name']?.toString() ?? ''),
                              if (isDefault) ...[
                                const SizedBox(width: 4),
                                PosBadge(label: l10n.defaults, customColor: AppColors.info),
                              ],
                            ],
                          ),
                        ),
                        DataCell(
                          PosBadge(
                            label: isEnabled ? l10n.enabled : l10n.disabled,
                            customColor: isEnabled ? AppColors.success : AppColors.mutedFor(context),
                          ),
                        ),
                        DataCell(Text('${metrics['total_requests'] ?? 0}')),
                        DataCell(Text('\$${((metrics['total_cost'] as num?)?.toDouble() ?? 0).toStringAsFixed(4)}')),
                        DataCell(Text('${((metrics['avg_latency'] as num?)?.toInt() ?? 0)}ms')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isEnabled ? Icons.toggle_on : Icons.toggle_off,
                                  color: isEnabled ? AppColors.success : AppColors.mutedFor(context),
                                ),
                                onPressed: () => ref.read(wameedAIAdminActionProvider.notifier).toggleLlmModel(id),
                                tooltip: isEnabled ? l10n.disable : l10n.enable,
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, size: 18),
                                onPressed: () => _showEditDialog(m, AppLocalizations.of(context)!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                                onPressed: () =>
                                    _confirmDelete(id, m['display_name']?.toString() ?? '', AppLocalizations.of(context)!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(AppLocalizations l10n) {
    final formData = <String, dynamic>{};
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminWameedAICreateModel),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'openai', label: l10n.adminProviderOpenAI),
                    PosDropdownItem(value: 'anthropic', label: l10n.adminProviderAnthropic),
                    PosDropdownItem(value: 'google', label: l10n.adminProviderGoogle),
                  ],
                  selectedValue: null,
                  onChanged: (v) => formData['provider'] = v,
                  label: l10n.providers,
                  hint: l10n.selectProvider,
                  showSearch: false,
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(label: l10n.modelId, hint: 'gpt-4o', onChanged: (v) => formData['model_id'] = v),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(label: l10n.displayName, hint: l10n.adminHintGpt4o, onChanged: (v) => formData['display_name'] = v),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(label: l10n.description, hint: l10n.optional, onChanged: (v) => formData['description'] = v),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.apiKey,
                  hint: l10n.optional,
                  onChanged: (v) => formData['api_key'] = v,
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.inputPrice,
                  hint: '0.00',
                  onChanged: (v) => formData['input_price_per_1m'] = double.tryParse(v),
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.outputPrice,
                  hint: '0.00',
                  onChanged: (v) => formData['output_price_per_1m'] = double.tryParse(v),
                ),
              ],
            ),
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            label: l10n.create,
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(wameedAIAdminActionProvider.notifier).createLlmModel(formData);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> model, AppLocalizations l10n) {
    final id = model['id']?.toString() ?? '';
    final formData = <String, dynamic>{'display_name': model['display_name'], 'description': model['description']};
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${l10n.edit} ${model['display_name']}'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(
                  label: l10n.displayName,
                  hint: model['display_name']?.toString(),
                  onChanged: (v) => formData['display_name'] = v,
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.description,
                  hint: model['description']?.toString(),
                  onChanged: (v) => formData['description'] = v,
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.apiKey,
                  hint: l10n.leaveBlankToKeep,
                  onChanged: (v) {
                    if (v.isNotEmpty) formData['api_key'] = v;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.inputPrice,
                  hint: model['input_price_per_1m']?.toString() ?? '0.00',
                  onChanged: (v) => formData['input_price_per_1m'] = double.tryParse(v),
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  label: l10n.outputPrice,
                  hint: model['output_price_per_1m']?.toString() ?? '0.00',
                  onChanged: (v) => formData['output_price_per_1m'] = double.tryParse(v),
                ),
              ],
            ),
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            label: l10n.save,
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(wameedAIAdminActionProvider.notifier).updateLlmModel(id, formData);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id, String name, AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.confirmDelete,
      message: l10n.adminDeleteModelQuote(name),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(wameedAIAdminActionProvider.notifier).deleteLlmModel(id);
    }
  }

  String _fmtLargeNumber(dynamic v) {
    final n = (v as num?)?.toInt() ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
