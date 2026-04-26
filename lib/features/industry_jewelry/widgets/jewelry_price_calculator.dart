import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Shows the jewelry price calculator as a bottom sheet / dialog.
void showJewelryPriceCalculator(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => const JewelryPriceCalculatorDialog(),
  );
}

class JewelryPriceCalculatorDialog extends ConsumerStatefulWidget {
  const JewelryPriceCalculatorDialog({super.key});

  @override
  ConsumerState<JewelryPriceCalculatorDialog> createState() =>
      _JewelryPriceCalculatorDialogState();
}

class _JewelryPriceCalculatorDialogState
    extends ConsumerState<JewelryPriceCalculatorDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final _netWeightCtrl = TextEditingController();
  final _makingChargesCtrl = TextEditingController(text: '0');

  DailyMetalRate? _selectedRate;
  String _makingChargesType = 'percentage'; // percentage | flat | per_gram

  double get _netWeight => double.tryParse(_netWeightCtrl.text) ?? 0.0;
  double get _makingChargesValue =>
      double.tryParse(_makingChargesCtrl.text) ?? 0.0;

  double get _calculatedPrice {
    if (_selectedRate == null || _netWeight <= 0) return 0.0;
    final metalValue = _netWeight * _selectedRate!.ratePerGram;
    final making = switch (_makingChargesType) {
      'flat' => _makingChargesValue,
      'per_gram' => _netWeight * _makingChargesValue,
      _ => metalValue * (_makingChargesValue / 100), // percentage
    };
    return metalValue + making;
  }

  @override
  void dispose() {
    _netWeightCtrl.dispose();
    _makingChargesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jewelryProvider);
    final rates = state is JewelryLoaded ? state.metalRates : <DailyMetalRate>[];

    return AlertDialog(
      title: Text(l10n.jewelryPriceCalculator),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rate selector
            PosSearchableDropdown<DailyMetalRate>(
              label: l10n.jewelrySelectRate,
              hint: l10n.jewelrySelectRate,
              items: rates
                  .map((r) => PosDropdownItem(
                        value: r,
                        label:
                            '${r.metalType.value} ${r.karat ?? ''} — ${r.ratePerGram.toStringAsFixed(3)} ${l10n.sarPerGram}',
                      ))
                  .toList(),
              selectedValue: _selectedRate,
              onChanged: (v) => setState(() => _selectedRate = v),
            ),
            const SizedBox(height: AppSpacing.md),

            // Net weight
            PosTextField(
              controller: _netWeightCtrl,
              label: l10n.jewelryNetWeightG,
              hint: '0.000',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),

            // Making charges type
            PosSearchableDropdown<String>(
              label: l10n.jewelryMakingChargesType,
              hint: l10n.jewelryMakingChargesType,
              items: [
                PosDropdownItem(
                    value: 'percentage', label: l10n.jewelryPercentage),
                PosDropdownItem(value: 'flat', label: l10n.jewelryFlat),
                PosDropdownItem(
                    value: 'per_gram', label: l10n.jewelryPerGram),
              ],
              selectedValue: _makingChargesType,
              onChanged: (v) =>
                  setState(() => _makingChargesType = v ?? 'percentage'),
            ),
            const SizedBox(height: AppSpacing.md),

            // Making charges value
            PosTextField(
              controller: _makingChargesCtrl,
              label: l10n.jewelryMakingChargesValue,
              hint: '0.00',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.jewelryCalculatedPrice,
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${_calculatedPrice.toStringAsFixed(3)} SAR',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
