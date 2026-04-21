import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_electronics/models/trade_in_record.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class TradeInFormPage extends ConsumerStatefulWidget {
  const TradeInFormPage({super.key, this.record});
  final TradeInRecord? record;

  @override
  ConsumerState<TradeInFormPage> createState() => _TradeInFormPageState();
}

class _TradeInFormPageState extends ConsumerState<TradeInFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    return PosFormPage(
      title: l10n.electronicsNewTradeIn,
      bottomBar: PosButton(
          label: l10n.electronicsRecordTradeIn,
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
              hint: l10n.electronicsDeviceHintTradeIn,
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
            PosSearchableDropdown<String>(
              hint: l10n.selectGrade,
              label: l10n.electronicsConditionGrade,
              items: ['A', 'B', 'C', 'D'].map((g) => PosDropdownItem(value: g, label: l10n.electronicsGradeLetter(g.toString()))).toList(),
              selectedValue: _conditionGradeCtrl.text.isEmpty ? null : _conditionGradeCtrl.text,
              onChanged: (v) => setState(() => _conditionGradeCtrl.text = v ?? ''),
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _assessedValueCtrl,
              label: l10n.electronicsAssessedValue,
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectStaffMember,
              label: l10n.staffMember,
              items: staffList.map((s) => PosDropdownItem(value: s.id, label: l10n.electronicsStaffFullName(s.firstName, s.lastName))).toList(),
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
