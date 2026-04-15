import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/trade_in_record.dart';
import '../providers/electronics_providers.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class TradeInFormPage extends ConsumerStatefulWidget {
  final TradeInRecord? record;
  const TradeInFormPage({super.key, this.record});

  @override
  ConsumerState<TradeInFormPage> createState() => _TradeInFormPageState();
}

class _TradeInFormPageState extends ConsumerState<TradeInFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  late final TextEditingController _deviceDescCtrl;
  late final TextEditingController _imeiCtrl;
  late final TextEditingController _conditionGradeCtrl;
  late final TextEditingController _assessedValueCtrl;
  String? _selectedStaffUserId;

  @override
  void initState() {
    super.initState();
    final r = widget.record;
    _deviceDescCtrl = TextEditingController(text: r?.deviceDescription ?? '');
    _imeiCtrl = TextEditingController(text: r?.imei ?? '');
    _conditionGradeCtrl = TextEditingController(text: r?.conditionGrade ?? '');
    _assessedValueCtrl = TextEditingController(text: r?.assessedValue.toStringAsFixed(2) ?? '');
    _selectedStaffUserId = r?.staffUserId;
    Future.microtask(() => ref.read(staffListProvider.notifier).load());
  }

  @override
  void dispose() {
    _deviceDescCtrl.dispose();
    _imeiCtrl.dispose();
    _conditionGradeCtrl.dispose();
    _assessedValueCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'device_description': _deviceDescCtrl.text.trim(),
      'condition_grade': _conditionGradeCtrl.text.trim(),
      'assessed_value': double.parse(_assessedValueCtrl.text.trim()),
      'staff_user_id': _selectedStaffUserId ?? '',
      if (_imeiCtrl.text.isNotEmpty) 'imei': _imeiCtrl.text.trim(),
    };

    final notifier = ref.read(electronicsProvider.notifier);
    await notifier.createTradeIn(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffListProvider);
    final staffList = staffState is StaffListLoaded ? staffState.staff : <StaffUser>[];
    return Scaffold(
      appBar: AppBar(title: const Text('New Trade-In')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: 'Record Trade-In',
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
              hint: 'e.g. Samsung Galaxy S24 Ultra',
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
            PosSearchableDropdown<String>(
              label: 'Condition Grade',
              items: ['A', 'B', 'C', 'D'].map((g) => PosDropdownItem(value: g, label: 'Grade $g')).toList(),
              selectedValue: _conditionGradeCtrl.text.isEmpty ? null : _conditionGradeCtrl.text,
              onChanged: (v) => setState(() => _conditionGradeCtrl.text = v ?? ''),
              showSearch: false,
              clearable: false,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _assessedValueCtrl,
              label: 'Assessed Value (\u0081)',
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              label: 'Staff Member',
              items: staffList.map((s) => PosDropdownItem(value: s.id, label: '${s.firstName} ${s.lastName}')).toList(),
              selectedValue: _selectedStaffUserId,
              onChanged: (v) => setState(() => _selectedStaffUserId = v),
              showSearch: true,
            ),
          ],
        ),
      ),
    );
  }
}
