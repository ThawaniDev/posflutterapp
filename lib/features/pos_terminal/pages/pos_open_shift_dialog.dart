import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_state.dart';

class PosOpenShiftDialog extends ConsumerStatefulWidget {
  const PosOpenShiftDialog({super.key});

  @override
  ConsumerState<PosOpenShiftDialog> createState() => _PosOpenShiftDialogState();
}

class _PosOpenShiftDialogState extends ConsumerState<PosOpenShiftDialog> {
  final _amountController = TextEditingController(text: '0.00');
  String? _selectedRegisterId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(terminalsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onQuickAmount(double amount) {
    final current = double.tryParse(_amountController.text) ?? 0;
    _amountController.text = (current + amount).toStringAsFixed(2);
  }

  Future<void> _submit() async {
    if (_selectedRegisterId == null) {
      setState(() => _error = 'Please select a register');
      return;
    }

    final openingCash = double.tryParse(_amountController.text) ?? 0;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(activeSessionProvider.notifier).openSession(openingCash: openingCash, registerId: _selectedRegisterId!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final terminalsState = ref.watch(terminalsProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.point_of_sale_rounded, color: AppColors.primary, size: 24),
                  ),
                  AppSpacing.gapW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Open Shift', style: AppTypography.headlineSmall),
                        Text(
                          'Count your opening cash to begin',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              AppSpacing.gapH24,

              // Register selection
              Text('Register', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
              AppSpacing.gapH4,
              _buildRegisterDropdown(terminalsState, isDark),
              AppSpacing.gapH16,

              // Opening cash
              Text('Opening Cash', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
              AppSpacing.gapH4,
              PosTextField(
                controller: _amountController,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money_rounded,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                textAlign: TextAlign.end,
              ),
              AppSpacing.gapH12,

              // Quick amounts
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [50, 100, 200, 500].map((amount) {
                  return OutlinedButton(
                    onPressed: () => _onQuickAmount(amount.toDouble()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text('+$amount'),
                  );
                }).toList(),
              ),
              AppSpacing.gapH8,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _amountController.text = '0.00',
                  child: Text('Reset', style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
                ),
              ),

              if (_error != null) ...[
                AppSpacing.gapH12,
                Container(
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                      AppSpacing.gapW8,
                      Expanded(
                        child: Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
              ],

              AppSpacing.gapH24,

              // Actions
              Row(
                children: [
                  Expanded(
                    child: PosButton(label: 'Cancel', variant: PosButtonVariant.outline, onPressed: () => Navigator.pop(context)),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(
                      label: 'Open Shift',
                      icon: Icons.login_rounded,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterDropdown(TerminalsState terminalsState, bool isDark) {
    final terminals = terminalsState is TerminalsLoaded ? terminalsState.terminals : [];
    final isLoading = terminalsState is TerminalsLoading;

    if (isLoading) {
      return Container(
        padding: AppSpacing.paddingAll12,
        child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    if (terminals.isEmpty) {
      return Container(
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
            AppSpacing.gapW8,
            Expanded(child: Text('No registers found. Please add one first.', style: AppTypography.bodySmall)),
          ],
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: _selectedRegisterId,
      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), isDense: true),
      hint: const Text('Select register'),
      items: terminals.map((t) {
        return DropdownMenuItem<String>(value: t.id, child: Text(t.name));
      }).toList(),
      onChanged: (val) => setState(() => _selectedRegisterId = val),
    );
  }
}
