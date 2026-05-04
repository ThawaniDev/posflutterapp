import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Shows a split bill dialog, returning the list of per-person amounts (or null on dismiss).
Future<List<double>?> showSplitBillDialog(BuildContext context, {double? initialTotal}) {
  return showDialog<List<double>>(
    context: context,
    builder: (_) => SplitBillDialog(initialTotal: initialTotal),
  );
}

class SplitBillDialog extends StatefulWidget {
  const SplitBillDialog({super.key, this.initialTotal});

  final double? initialTotal;

  @override
  State<SplitBillDialog> createState() => _SplitBillDialogState();
}

class _SplitBillDialogState extends State<SplitBillDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  static const _modeEqual = 'equal';
  static const _modeCustom = 'custom';

  String _mode = _modeEqual;
  final _totalCtrl = TextEditingController();
  final _numPeopleCtrl = TextEditingController(text: '2');

  // Custom mode: one controller per person
  final List<TextEditingController> _customCtrls = [TextEditingController(), TextEditingController()];

  double get _total => double.tryParse(_totalCtrl.text) ?? 0.0;
  int get _numPeople => int.tryParse(_numPeopleCtrl.text) ?? 2;
  double get _perPerson => _numPeople > 0 ? _total / _numPeople : 0.0;

  double get _customSum => _customCtrls.fold(0.0, (s, c) => s + (double.tryParse(c.text) ?? 0.0));

  bool get _customValid => (_total - _customSum).abs() < 0.01 && _customSum > 0;

  @override
  void initState() {
    super.initState();
    _totalCtrl.text = widget.initialTotal != null ? widget.initialTotal!.toStringAsFixed(2) : '';
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    _numPeopleCtrl.dispose();
    for (final c in _customCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _confirm() {
    final amounts = _mode == _modeEqual
        ? List.filled(_numPeople, _perPerson)
        : _customCtrls.map((c) => double.tryParse(c.text) ?? 0.0).toList();
    Navigator.of(context).pop(amounts);
  }

  bool get _canConfirm {
    if (_total <= 0) return false;
    if (_mode == _modeEqual) return _numPeople >= 2;
    return _customValid;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(l10n.restaurantSplitBill),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total amount field
              PosTextField(
                controller: _totalCtrl,
                label: l10n.restaurantBillTotal,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),

              // Mode toggle
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: _modeEqual, label: Text(l10n.restaurantSplitEqual)),
                  ButtonSegment(value: _modeCustom, label: Text(l10n.restaurantSplitCustom)),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: AppSpacing.md),

              if (_mode == _modeEqual) ...[
                PosTextField(
                  controller: _numPeopleCtrl,
                  label: l10n.restaurantNumberOfPeople,
                  hint: '2',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                if (_total > 0 && _numPeople >= 2) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.restaurantPerPerson),
                        Text(
                          '${_perPerson.toStringAsFixed(2)} SAR',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // Custom: one row per person
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.restaurantCustomAmounts, style: Theme.of(context).textTheme.labelMedium),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: () => setState(() => _customCtrls.add(TextEditingController())),
                    ),
                  ],
                ),
                ..._customCtrls.asMap().entries.map((e) {
                  final idx = e.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: PosTextField(
                            controller: e.value,
                            label: '${l10n.restaurantPerson} ${idx + 1}',
                            hint: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_customCtrls.length > 2)
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, size: 18, color: Theme.of(context).colorScheme.error),
                            onPressed: () => setState(() {
                              e.value.dispose();
                              _customCtrls.removeAt(idx);
                            }),
                          ),
                      ],
                    ),
                  );
                }),
                if (_total > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.restaurantSumEntered, style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        '${_customSum.toStringAsFixed(2)} / ${_total.toStringAsFixed(2)} SAR',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _customValid ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        PosButton(label: l10n.restaurantConfirmSplit, onPressed: _canConfirm ? _confirm : null),
      ],
    );
  }
}
