import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/repair_job.dart';
import '../providers/electronics_providers.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class RepairJobFormPage extends ConsumerStatefulWidget {
  final RepairJob? job;
  const RepairJobFormPage({super.key, this.job});

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
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Repair Job' : 'New Repair Job')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Job' : 'Create Job',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosTextField(
              controller: _deviceDescCtrl,
              label: 'Device Description',
              hint: 'e.g. iPhone 15 Pro Max 256GB',
              maxLines: 2,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _imeiCtrl,
              label: 'IMEI (optional)',
              hint: '15-digit IMEI number',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _issueDescCtrl, label: 'Issue Description', hint: 'Describe the issue...', maxLines: 3),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              label: 'Assigned Technician',
              items: staffList.map((s) => PosDropdownItem(value: s.id, label: '${s.firstName} ${s.lastName}')).toList(),
              selectedValue: _selectedStaffUserId,
              onChanged: (v) => setState(() => _selectedStaffUserId = v),
              showSearch: true,
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _estimatedCostCtrl,
                    label: 'Est. Cost (\u0081)',
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _finalCostCtrl,
                    label: 'Final Cost (\u0081)',
                    hint: '0.000',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              SizedBox(height: AppSpacing.md),
              PosTextField(controller: _diagnosisNotesCtrl, label: 'Diagnosis Notes', hint: 'Diagnosis findings...', maxLines: 3),
              SizedBox(height: AppSpacing.md),
              PosTextField(controller: _repairNotesCtrl, label: 'Repair Notes', hint: 'Repair details...', maxLines: 3),
            ],
          ],
        ),
      ),
    );
  }
}
