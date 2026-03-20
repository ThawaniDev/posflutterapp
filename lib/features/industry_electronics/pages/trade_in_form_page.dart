import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/trade_in_record.dart';
import '../providers/electronics_providers.dart';

class TradeInFormPage extends ConsumerStatefulWidget {
  final TradeInRecord? record;
  const TradeInFormPage({super.key, this.record});

  @override
  ConsumerState<TradeInFormPage> createState() => _TradeInFormPageState();
}

class _TradeInFormPageState extends ConsumerState<TradeInFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.record != null;

  late final TextEditingController _deviceDescCtrl;
  late final TextEditingController _imeiCtrl;
  late final TextEditingController _conditionGradeCtrl;
  late final TextEditingController _assessedValueCtrl;
  late final TextEditingController _staffUserIdCtrl;

  @override
  void initState() {
    super.initState();
    final r = widget.record;
    _deviceDescCtrl = TextEditingController(text: r?.deviceDescription ?? '');
    _imeiCtrl = TextEditingController(text: r?.imei ?? '');
    _conditionGradeCtrl = TextEditingController(text: r?.conditionGrade ?? '');
    _assessedValueCtrl = TextEditingController(text: r?.assessedValue.toStringAsFixed(3) ?? '');
    _staffUserIdCtrl = TextEditingController(text: r?.staffUserId ?? '');
  }

  @override
  void dispose() {
    _deviceDescCtrl.dispose();
    _imeiCtrl.dispose();
    _conditionGradeCtrl.dispose();
    _assessedValueCtrl.dispose();
    _staffUserIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'device_description': _deviceDescCtrl.text.trim(),
      'condition_grade': _conditionGradeCtrl.text.trim(),
      'assessed_value': double.parse(_assessedValueCtrl.text.trim()),
      'staff_user_id': _staffUserIdCtrl.text.trim(),
      if (_imeiCtrl.text.isNotEmpty) 'imei': _imeiCtrl.text.trim(),
    };

    final notifier = ref.read(electronicsProvider.notifier);
    await notifier.createTradeIn(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
            PosDropdown<String>(
              label: 'Condition Grade',
              hint: 'Select grade',
              value: _conditionGradeCtrl.text.isEmpty ? null : _conditionGradeCtrl.text,
              onChanged: (v) => setState(() => _conditionGradeCtrl.text = v ?? ''),
              items: ['A', 'B', 'C', 'D'].map((g) => DropdownMenuItem(value: g, child: Text('Grade $g'))).toList(),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _assessedValueCtrl,
              label: 'Assessed Value (OMR)',
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _staffUserIdCtrl, label: 'Staff User ID', hint: 'Assessing staff member'),
          ],
        ),
      ),
    );
  }
}
