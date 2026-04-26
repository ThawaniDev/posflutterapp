import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_providers.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_state.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/providers/order_providers.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class KitchenTicketFormPage extends ConsumerStatefulWidget {
  const KitchenTicketFormPage({super.key});

  @override
  ConsumerState<KitchenTicketFormPage> createState() => _KitchenTicketFormPageState();
}

class _KitchenTicketFormPageState extends ConsumerState<KitchenTicketFormPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  String? _selectedOrderId;
  String? _selectedTableId;
  final _stationCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  DateTime? _fireAt;

  // Dynamic items list (name → qty)
  final List<_TicketItem> _items = [_TicketItem()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(restaurantProvider.notifier).load();
      ref.read(ordersProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _stationCtrl.dispose();
    _courseCtrl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> get _buildItemsJson {
    final list = <Map<String, dynamic>>[];
    for (final item in _items) {
      final name = item.nameCtrl.text.trim();
      final qty = int.tryParse(item.qtyCtrl.text.trim()) ?? 1;
      if (name.isNotEmpty) list.add({'name': name, 'qty': qty});
    }
    return list;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'order_id': _selectedOrderId ?? '',
      'items_json': _buildItemsJson,
      if (_selectedTableId != null && _selectedTableId!.isNotEmpty) 'table_id': _selectedTableId,
      if (_stationCtrl.text.isNotEmpty) 'station': _stationCtrl.text.trim(),
      if (_courseCtrl.text.isNotEmpty) 'course_number': int.tryParse(_courseCtrl.text.trim()),
      if (_fireAt != null) 'fire_at': _fireAt!.toIso8601String(),
    };

    await ref.read(restaurantProvider.notifier).createKitchenTicket(data);

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickFireAt() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 7)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    if (time == null || !mounted) return;
    setState(() => _fireAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    final restState = ref.watch(restaurantProvider);
    final tables = restState is RestaurantLoaded ? restState.tables : <RestaurantTable>[];
    final ordersState = ref.watch(ordersProvider);
    final orders = ordersState is OrdersLoaded ? ordersState.orders : <Order>[];

    return PosFormPage(
      title: l10n.restaurantNewKitchenTicket,
      bottomBar: PosButton(
        label: l10n.restaurantCreateTicket,
        onPressed: _saving ? null : _handleSave,
        isLoading: _saving,
        isFullWidth: true,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order
            PosSearchableDropdown<String>(
              hint: l10n.selectOrder,
              label: l10n.wameedAIOrder,
              items: orders.map((o) => PosDropdownItem(value: o.id, label: o.orderNumber)).toList(),
              selectedValue: _selectedOrderId,
              validator: (v) => (v == null || v.isEmpty) ? l10n.fieldRequired : null,
              onChanged: (v) => setState(() => _selectedOrderId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // Table (optional)
            PosSearchableDropdown<String>(
              hint: l10n.selectTable,
              label: l10n.tableOptional,
              items: tables.map((t) => PosDropdownItem(value: t.id, label: t.displayName ?? 'Table ${t.tableNumber}')).toList(),
              selectedValue: _selectedTableId,
              onChanged: (v) => setState(() => _selectedTableId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // Station (optional)
            PosTextField(controller: _stationCtrl, label: l10n.restaurantStationLabel, hint: l10n.restaurantStationHint),
            const SizedBox(height: AppSpacing.md),

            // Course number (optional)
            PosTextField(
              controller: _courseCtrl,
              label: l10n.restaurantCourseLabel,
              hint: '1',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),

            // Fire-at picker (optional)
            _FireAtPicker(
              value: _fireAt,
              label: l10n.restaurantFireAt,
              onTap: _pickFireAt,
              onClear: () => setState(() => _fireAt = null),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Items header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.restaurantTicketItems, style: Theme.of(context).textTheme.titleSmall),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l10n.add,
                  onPressed: () => setState(() => _items.add(_TicketItem())),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Items list
            ..._items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PosTextField(
                        controller: item.nameCtrl,
                        label: idx == 0 ? l10n.restaurantItemName : null,
                        hint: l10n.restaurantItemNameHint,
                        validator: (v) => (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PosTextField(
                        controller: item.qtyCtrl,
                        label: idx == 0 ? l10n.restaurantItemQty : null,
                        hint: '1',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (_items.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => setState(() {
                          item.dispose();
                          _items.removeAt(idx);
                        }),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TicketItem {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: '1');

  void dispose() {
    nameCtrl.dispose();
    qtyCtrl.dispose();
  }
}

class _FireAtPicker extends StatelessWidget {
  const _FireAtPicker({required this.value, required this.label, required this.onTap, required this.onClear});

  final DateTime? value;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: value != null
              ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: onClear)
              : const Icon(Icons.schedule),
        ),
        child: Text(
          value != null ? '${value!.toLocal()}'.substring(0, 16) : '—',
          style: value == null ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor) : null,
        ),
      ),
    );
  }
}
