import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminRetryRulesPage extends ConsumerStatefulWidget {
  const AdminRetryRulesPage({super.key});

  @override
  ConsumerState<AdminRetryRulesPage> createState() => _AdminRetryRulesPageState();
}

class _AdminRetryRulesPageState extends ConsumerState<AdminRetryRulesPage> {
  final _maxRetriesCtrl = TextEditingController();
  final _intervalCtrl = TextEditingController();
  final _graceCtrl = TextEditingController();
  String? _storeId;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(retryRulesProvider.notifier).loadRules();
    });
  }

  @override
  void dispose() {
    _maxRetriesCtrl.dispose();
    _intervalCtrl.dispose();
    _graceCtrl.dispose();
    super.dispose();
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(retryRulesProvider);

    // Populate fields on first load
    if (state is RetryRulesLoaded && !_loaded) {
      _maxRetriesCtrl.text = '${state.maxRetries}';
      _intervalCtrl.text = '${state.retryIntervalHours}';
      _graceCtrl.text = '${state.gracePeriodDays}';
      _loaded = true;
    }

    return PosListPage(
      title: 'Payment Retry Rules',
      showSearch: false,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              RetryRulesLoading() => const Center(child: CircularProgressIndicator()),
              RetryRulesLoaded() => SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.settings, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Retry Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                              'Configure how failed payments should be retried automatically.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Max retries
                            TextField(
                              controller: _maxRetriesCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Maximum Retries',
                                helperText: 'Number of retry attempts (1-10)',
                                prefixIcon: Icon(Icons.replay),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Retry interval
                            TextField(
                              controller: _intervalCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Retry Interval (hours)',
                                helperText: 'Time between retry attempts (1-168 hours)',
                                prefixIcon: Icon(Icons.timer),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Grace period
                            TextField(
                              controller: _graceCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Grace Period (days)',
                                helperText: 'Days after failure before suspension (1-30)',
                                prefixIcon: Icon(Icons.hourglass_empty),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            SizedBox(
                              width: double.infinity,
                              child: PosButton(onPressed: _saveRules, label: 'Save Rules'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Info card
                    PosCard(
                      color: AppColors.info.withValues(alpha: 0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: AppColors.infoDark),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How retry rules work',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.infoDark),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'When a payment fails, the system will automatically '
                                    'retry up to the configured number of times, waiting '
                                    'the specified interval between attempts. If all retries '
                                    'fail, the subscription enters a grace period before '
                                    'being suspended.',
                                    style: TextStyle(fontSize: 13, color: AppColors.info),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RetryRulesError(message: final msg) => Center(child: Text('Error: $msg')),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }

  void _saveRules() async {
    final maxRetries = int.tryParse(_maxRetriesCtrl.text);
    final interval = int.tryParse(_intervalCtrl.text);
    final grace = int.tryParse(_graceCtrl.text);

    if (maxRetries == null || interval == null || grace == null) {
      showPosWarningSnackbar(context, AppLocalizations.of(context)!.pleaseEnterValidNumbers);
      return;
    }

    try {
      await ref.read(retryRulesProvider.notifier).updateRules(maxRetries, interval, grace);
      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.retryRulesUpdated);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.failedToSave(e.toString()));
      }
    }
  }
}
