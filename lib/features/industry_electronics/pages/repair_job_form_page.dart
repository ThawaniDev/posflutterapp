import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_electronics/models/repair_job.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class RepairJobFormPage extends ConsumerStatefulWidget {
  const RepairJobFormPage({super.key, this.job});
  final RepairJob? job;

  @override
  ConsumerState<RepairJobFormPage> createState() => _RepairJobFormPageState();
}

class _RepairJobFormPageState extends ConsumerState<RepairJobFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.job != null;

  late final TextEditingController _deviceDescCtrl;
  late final TextEditingController _imeiCtrl;
  late final TextEditingController _issueDescCtrl;
  late final TextEditingController _diagnosisNotesCtrl;
  late final TextEditingController _repairNotesCtrl;
  late final TextEditingController _estimatedCostCtrl;
  late final TextEditingController _finalCostCtrl;
  String? _selectedStaffUserId;

  @override
  void initState() {
    super.initState();
    final j = widget.job;
    _deviceDescCtrl = TextEditingController(text: j?.deviceDescription ?? '');
    _imeiCtrl = TextEditingController(text: j?.imei ?? '');
    _issueDescCtrl = TextEditingController(text: j?.issueDescription ?? '');
    _diagnosisNotesCtrl = TextEditingController(text: j?.diagnosisNotes ?? '');
    _repairNotesCtrl = TextEditingController(text: j?.repairNotes ?? '');
    _estimatedCostCtrl = TextEditingController(text: j?.estimatedCost?.toStringAsFixed(2) ?? '');
    _finalCostCtrl = TextEditingController(text: j?.finalCost?.toStringAsFixed(2) ?? '');
    _selectedStaffUserId = j?.staffUserId;
    Future.microtask(() => ref.read(staffListProvider.notifier).load());
  }

  @override
  void dispose() {
    _deviceDescCtrl.dispose();
    _imeiCtrl.dispose();
    _issueDescCtrl.dispose();
    _diagnosisNotesCtrl.dispose();
    _repairNotesCtrl.dispose();
    _estimatedCostCtrl.dispose();
    _finalCostCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'device_description': _deviceDescCtrl.text.trim(),
      'issue_description': _issueDescCtrl.text.trim(),
      'staff_user_id': _selectedStaffUserId ?? '',
      if (_imeiCtrl.text.isNotEmpty) 'imei': _imeiCtrl.text.trim(),
      if (_estimatedCostCtrl.text.isNotEmpty) 'estimated_cost': double.parse(_estimatedCostCtrl.text.trim()),
      if (_finalCostCtrl.text.isNotEmpty) 'final_cost': double.parse(_finalCostCtrl.text.trim()),
      if (_diagnosisNotesCtrl.text.isNotEmpty) 'diagnosis_notes': _diagnosisNotesCtrl.text.trim(),
      if (_repairNotesCtrl.text.isNotEmpty) 'repair_notes': _repairNotesCtrl.text.trim(),
    };

    final notifier = ref.read(electronicsProvider.notifier);
    if (_isEditing) {
      await notifier.updateRepairJob(widget.job!.id, data);
    } else {
      await notifier.createRepairJob(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    return PosFormPage(
      title: _isEditing ? 'Edit Repair Job' : 'New Repair Job',
      bottomBar: PosButton(
          label: _isEditing ? 'Update Job' : 'Create Job',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(
              controller: _deviceDescCtrl,
              label: l10n.electronicsDeviceDescription,
              hint: l10n.electronicsDeviceHintRepair,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _imeiCtrl,
              label: l10n.electronicsImeiOptional,
              hint: l10n.electronicsImeiHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _issueDescCtrl, label: l10n.electronicsIssueDescription, hint: l10n.electronicsIssueHint, maxLines: 3),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectTechnician,
              label: l10n.electronicsAssignedTech,
              items: staffList.map((s) => PosDropdownItem(value: s.id, label: l10n.electronicsStaffFullName(s.firstName, s.lastName))).toList(),
              selectedValue: _selectedStaffUserId,
              onChanged: (v) => setState(() => _selectedStaffUserId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _estimatedCostCtrl,
                    label: l10n.electronicsEstCost,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _finalCostCtrl,
                    label: l10n.electronicsFinalCost,
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: _diagnosisNotesCtrl, label: l10n.electronicsDiagnosisNotes, hint: l10n.electronicsDiagnosisHint, maxLines: 3),
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: _repairNotesCtrl, label: l10n.electronicsRepairNotes, hint: l10n.electronicsRepairHint, maxLines: 3),
            ],
          ],
        ),
      ),
    );
  }
}
