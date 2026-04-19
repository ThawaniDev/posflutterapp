import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/production_schedule.dart';
import '../providers/bakery_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProductionScheduleFormPage extends ConsumerStatefulWidget {
  final ProductionSchedule? schedule;
  const ProductionScheduleFormPage({super.key, this.schedule});

  @override
  ConsumerState<ProductionScheduleFormPage> createState() => _ProductionScheduleFormPageState();
}

class _ProductionScheduleFormPageState extends ConsumerState<ProductionScheduleFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.schedule != null;

  late final TextEditingController _recipeIdCtrl;
  late final TextEditingController _plannedBatchesCtrl;
  late final TextEditingController _plannedYieldCtrl;
  late final TextEditingController _actualBatchesCtrl;
  late final TextEditingController _actualYieldCtrl;
  late final TextEditingController _notesCtrl;
  DateTime _scheduleDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _recipeIdCtrl = TextEditingController(text: s?.recipeId ?? '');
    _plannedBatchesCtrl = TextEditingController(text: s?.plannedBatches.toString() ?? '');
    _plannedYieldCtrl = TextEditingController(text: s?.plannedYield.toString() ?? '');
    _actualBatchesCtrl = TextEditingController(text: s?.actualBatches?.toString() ?? '');
    _actualYieldCtrl = TextEditingController(text: s?.actualYield?.toString() ?? '');
    _notesCtrl = TextEditingController(text: s?.notes ?? '');
    if (s != null) _scheduleDate = s.scheduleDate;
  }

  @override
  void dispose() {
    _recipeIdCtrl.dispose();
    _plannedBatchesCtrl.dispose();
    _plannedYieldCtrl.dispose();
    _actualBatchesCtrl.dispose();
    _actualYieldCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduleDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _scheduleDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'recipe_id': _recipeIdCtrl.text.trim(),
      'schedule_date': _scheduleDate.toIso8601String().split('T').first,
      'planned_batches': int.parse(_plannedBatchesCtrl.text.trim()),
      'planned_yield': int.parse(_plannedYieldCtrl.text.trim()),
      if (_actualBatchesCtrl.text.isNotEmpty) 'actual_batches': int.parse(_actualBatchesCtrl.text.trim()),
      if (_actualYieldCtrl.text.isNotEmpty) 'actual_yield': int.parse(_actualYieldCtrl.text.trim()),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    };

    final notifier = ref.read(bakeryProvider.notifier);
    if (_isEditing) {
      await notifier.updateProductionSchedule(widget.schedule!.id, data);
    } else {
      await notifier.createProductionSchedule(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosFormPage(
      title: _isEditing ? 'Edit Schedule' : 'New Production Schedule',
      bottomBar: PosButton(
          label: _isEditing ? 'Update Schedule' : 'Create Schedule',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _recipeIdCtrl, label: l10n.bakeryRecipeId, hint: l10n.bakerySelectRecipe),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_scheduleDate.day}/${_scheduleDate.month}/${_scheduleDate.year}'),
                  label: l10n.scheduleDate,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _plannedBatchesCtrl,
                    label: l10n.plannedBatches,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _plannedYieldCtrl,
                    label: l10n.plannedYield,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: PosTextField(
                      controller: _actualBatchesCtrl,
                      label: l10n.actualBatches,
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosTextField(
                      controller: _actualYieldCtrl,
                      label: l10n.actualYield,
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: l10n.posNotes, hint: l10n.bakeryAdditionalNotes, maxLines: 3),
          ],
        ),
      ),
    );
  }
}
