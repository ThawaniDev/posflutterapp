import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/restaurant_providers.dart';

class OpenTabFormPage extends ConsumerStatefulWidget {
  const OpenTabFormPage({super.key});

  @override
  ConsumerState<OpenTabFormPage> createState() => _OpenTabFormPageState();
}

class _OpenTabFormPageState extends ConsumerState<OpenTabFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  late final TextEditingController _orderIdCtrl;
  late final TextEditingController _customerNameCtrl;
  late final TextEditingController _tableIdCtrl;

  @override
  void initState() {
    super.initState();
    _orderIdCtrl = TextEditingController();
    _customerNameCtrl = TextEditingController();
    _tableIdCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _orderIdCtrl.dispose();
    _customerNameCtrl.dispose();
    _tableIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'order_id': _orderIdCtrl.text.trim(),
      'customer_name': _customerNameCtrl.text.trim(),
      if (_tableIdCtrl.text.isNotEmpty) 'table_id': _tableIdCtrl.text.trim(),
    };

    await ref.read(restaurantProvider.notifier).openTab(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Tab')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(label: 'Open Tab', onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosTextField(controller: _customerNameCtrl, label: 'Customer Name', hint: 'Tab owner name'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _orderIdCtrl, label: 'Order ID', hint: 'Associated order'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _tableIdCtrl, label: 'Table (optional)', hint: 'Assign to table'),
          ],
        ),
      ),
    );
  }
}
