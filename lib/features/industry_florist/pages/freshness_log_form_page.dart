import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/flower_freshness_log.dart';
import '../providers/florist_providers.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';

class FreshnessLogFormPage extends ConsumerStatefulWidget {
  final FlowerFreshnessLog? log;
  const FreshnessLogFormPage({super.key, this.log});

  @override
  ConsumerState<FreshnessLogFormPage> createState() => _FreshnessLogFormPageState();
}

class _FreshnessLogFormPageState extends ConsumerState<FreshnessLogFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  String? _selectedProductId;
  late final TextEditingController _expectedVaseLifeCtrl;
  late final TextEditingController _quantityCtrl;
  DateTime _receivedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final l = widget.log;
    _selectedProductId = l?.productId;
    _expectedVaseLifeCtrl = TextEditingController(text: l?.expectedVaseLifeDays.toString() ?? '');
    _quantityCtrl = TextEditingController(text: l?.quantity.toString() ?? '');
    if (l != null) _receivedDate = l.receivedDate;
    Future.microtask(() => ref.read(productsProvider.notifier).load());
  }

  @override
  void dispose() {
    _expectedVaseLifeCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _receivedDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'product_id': _selectedProductId ?? '',
      'received_date': _receivedDate.toIso8601String().split('T').first,
      'expected_vase_life_days': int.parse(_expectedVaseLifeCtrl.text.trim()),
      'quantity': int.parse(_quantityCtrl.text.trim()),
    };

    final notifier = ref.read(floristProvider.notifier);
    await notifier.createFreshnessLog(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : <Product>[];
    return Scaffold(
      appBar: AppBar(title: const Text('New Freshness Log')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(label: 'Log Freshness', onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosSearchableDropdown<String>(
              label: 'Product',
              items: products.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
              selectedValue: _selectedProductId,
              onChanged: (v) => setState(() => _selectedProductId = v),
              showSearch: true,
            ),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: '${_receivedDate.day}/${_receivedDate.month}/${_receivedDate.year}'),
                  label: 'Received Date',
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
                    controller: _expectedVaseLifeCtrl,
                    label: 'Vase Life (days)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _quantityCtrl,
                    label: 'Quantity',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
