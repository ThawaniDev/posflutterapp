import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/restaurant_providers.dart';
import '../models/restaurant_table.dart';
import '../providers/restaurant_state.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/providers/order_providers.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class OpenTabFormPage extends ConsumerStatefulWidget {
  const OpenTabFormPage({super.key});

  @override
  ConsumerState<OpenTabFormPage> createState() => _OpenTabFormPageState();
}

class _OpenTabFormPageState extends ConsumerState<OpenTabFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  String? _selectedOrderId;
  late final TextEditingController _customerNameCtrl;
  String? _selectedTableId;

  @override
  void initState() {
    super.initState();
    _customerNameCtrl = TextEditingController();
    Future.microtask(() {
      ref.read(restaurantProvider.notifier).load();
      ref.read(ordersProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'order_id': _selectedOrderId ?? '',
      'customer_name': _customerNameCtrl.text.trim(),
      if (_selectedTableId != null && _selectedTableId!.isNotEmpty) 'table_id': _selectedTableId,
    };

    await ref.read(restaurantProvider.notifier).openTab(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final restState = ref.watch(restaurantProvider);
    final tables = restState is RestaurantLoaded ? restState.tables : <RestaurantTable>[];
    final ordersState = ref.watch(ordersProvider);
    final orders = ordersState is OrdersLoaded ? ordersState.orders : <Order>[];
    return PosFormPage(
      title: l10n.openTab,
      bottomBar: PosButton(label: l10n.openTab, onPressed: _saving ? null : _handleSave, isLoading: _saving, isFullWidth: true),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _customerNameCtrl, label: l10n.deliveryCustomerName, hint: l10n.restaurantTabOwnerHint),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectOrder,
              label: l10n.wameedAIOrder,
              items: orders.map((o) => PosDropdownItem(value: o.id, label: o.orderNumber)).toList(),
              selectedValue: _selectedOrderId,
              onChanged: (v) => setState(() => _selectedOrderId = v),
              showSearch: true,
            ),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectTable,
              label: l10n.tableOptional,
              items: tables.map((t) => PosDropdownItem(value: t.id, label: t.displayName ?? 'Table ${t.tableNumber}')).toList(),
              selectedValue: _selectedTableId,
              onChanged: (v) => setState(() => _selectedTableId = v),
              showSearch: true,
            ),
          ],
        ),
      ),
    );
  }
}
