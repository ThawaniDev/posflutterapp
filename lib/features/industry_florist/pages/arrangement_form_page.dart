import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/flower_arrangement.dart';
import '../providers/florist_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ArrangementFormPage extends ConsumerStatefulWidget {
  final FlowerArrangement? arrangement;
  const ArrangementFormPage({super.key, this.arrangement});

  @override
  ConsumerState<ArrangementFormPage> createState() => _ArrangementFormPageState();
}

class _ArrangementFormPageState extends ConsumerState<ArrangementFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.arrangement != null;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _occasionCtrl;
  late final TextEditingController _totalPriceCtrl;
  bool _isTemplate = false;

  @override
  void initState() {
    super.initState();
    final a = widget.arrangement;
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _occasionCtrl = TextEditingController(text: a?.occasion ?? '');
    _totalPriceCtrl = TextEditingController(text: a?.totalPrice.toStringAsFixed(2) ?? '');
    _isTemplate = a?.isTemplate ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _occasionCtrl.dispose();
    _totalPriceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'total_price': double.parse(_totalPriceCtrl.text.trim()),
      'is_template': _isTemplate,
      'items_json': {},
      if (_occasionCtrl.text.isNotEmpty) 'occasion': _occasionCtrl.text.trim(),
    };

    final notifier = ref.read(floristProvider.notifier);
    if (_isEditing) {
      await notifier.updateArrangement(widget.arrangement!.id, data);
    } else {
      await notifier.createArrangement(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosFormPage(
      title: _isEditing ? 'Edit Arrangement' : 'New Arrangement',
      bottomBar: PosButton(
          label: _isEditing ? 'Update Arrangement' : 'Create Arrangement',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _nameCtrl, label: l10n.arrangementName, hint: 'e.g. Classic Rose Bouquet'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _occasionCtrl, label: l10n.occasionOptional, hint: 'e.g. Wedding, Birthday, Anniversary'),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _totalPriceCtrl,
              label: 'Total Price (\u0081)',
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md),
            PosToggle(
              value: _isTemplate,
              onChanged: (v) => setState(() => _isTemplate = v),
              label: 'Is Template',
              subtitle: 'Reusable arrangement template for subscriptions',
            ),
          ],
        ),
      ),
    );
  }
}
