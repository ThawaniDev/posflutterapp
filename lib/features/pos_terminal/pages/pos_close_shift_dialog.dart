import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:thawani_pos/features/pos_terminal/repositories/pos_terminal_repository.dart';

class PosCloseShiftDialog extends ConsumerStatefulWidget {
  const PosCloseShiftDialog({super.key, required this.session});

  final PosSession session;

  @override
  ConsumerState<PosCloseShiftDialog> createState() => _PosCloseShiftDialogState();
}

class _PosCloseShiftDialogState extends ConsumerState<PosCloseShiftDialog> {
  final _cashController = TextEditingController();
  bool _isLoading = false;
  bool _isRefreshing = true;
  String? _error;
  late PosSession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _refreshSession();
  }

  Future<void> _refreshSession() async {
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final updated = await repo.getSession(widget.session.id);
      if (mounted) {
        setState(() {
          _session = updated;
          _isRefreshing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final closingCash = double.tryParse(_cashController.text);
    if (closingCash == null || closingCash < 0) {
      setState(() => _error = 'Please enter a valid closing cash amount');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(activeSessionProvider.notifier).closeSession(closingCash: closingCash);
      if (mounted) {
        showPosSuccessSnackbar(context, 'Shift closed successfully');
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: SingleChildScrollView(
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
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.10), shape: BoxShape.circle),
                      child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 24),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Close Shift', style: AppTypography.headlineSmall),
                          Text('Review your session summary', style: AppTypography.bodySmall.copyWith(color: mutedColor)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                AppSpacing.gapH24,

                // Z-Report summary
                Container(
                  padding: AppSpacing.paddingAll16,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.inputBgLight,
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Session Summary (Z-Report)', style: AppTypography.titleSmall),
                          if (_isRefreshing)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            ),
                        ],
                      ),
                      AppSpacing.gapH12,
                      _summaryRow('Opening Cash', _session.openingCash, mutedColor),
                      _summaryRow('Cash Sales', _session.totalCashSales ?? 0, mutedColor),
                      _summaryRow('Card Sales', _session.totalCardSales ?? 0, mutedColor),
                      _summaryRow('Other Sales', _session.totalOtherSales ?? 0, mutedColor),
                      Divider(height: 16, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      _summaryRow('Refunds', -(_session.totalRefunds ?? 0), mutedColor, color: AppColors.error),
                      _summaryRow('Voids', -(_session.totalVoids ?? 0), mutedColor, color: AppColors.error),
                      Divider(height: 16, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      _summaryRow(
                        'Expected Cash',
                        _session.openingCash + (_session.totalCashSales ?? 0) - (_session.totalRefunds ?? 0),
                        mutedColor,
                        isBold: true,
                      ),
                      _summaryRow('Transactions', (_session.transactionCount ?? 0).toDouble(), mutedColor, isCount: true),
                    ],
                  ),
                ),
                AppSpacing.gapH16,

                // Closing cash input
                Text('Closing Cash Count', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                AppSpacing.gapH4,
                PosTextField(
                  controller: _cashController,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.attach_money_rounded,
                  autofocus: true,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                  textAlign: TextAlign.end,
                ),
                AppSpacing.gapH8,

                // Cash difference preview
                Builder(
                  builder: (context) {
                    final closingCash = double.tryParse(_cashController.text) ?? 0;
                    final expectedCash = _session.openingCash + (_session.totalCashSales ?? 0) - (_session.totalRefunds ?? 0);
                    final diff = closingCash - expectedCash;
                    final diffColor = diff.abs() < 0.01
                        ? AppColors.success
                        : diff < 0
                        ? AppColors.error
                        : AppColors.warning;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: diffColor.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Difference', style: AppTypography.bodySmall.copyWith(color: diffColor)),
                          Text(
                            '${diff >= 0 ? '+' : ''}SAR ${diff.toStringAsFixed(2)}',
                            style: AppTypography.labelSmall.copyWith(color: diffColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
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
                      child: PosButton(
                        label: 'Cancel',
                        variant: PosButtonVariant.outline,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosButton(
                        label: 'Close Shift',
                        icon: Icons.logout_rounded,
                        variant: PosButtonVariant.danger,
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
      ),
    );
  }

  Widget _summaryRow(String label, double value, Color mutedColor, {Color? color, bool isBold = false, bool isCount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: mutedColor)),
          Text(
            isCount ? value.toInt().toString() : 'SAR ${value.toStringAsFixed(2)}',
            style: (isBold ? AppTypography.labelMedium : AppTypography.bodySmall).copyWith(
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
