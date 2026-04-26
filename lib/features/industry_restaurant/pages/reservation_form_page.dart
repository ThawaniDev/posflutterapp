import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_restaurant/models/table_reservation.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_providers.dart';
import 'package:wameedpos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ReservationFormPage extends ConsumerStatefulWidget {
  const ReservationFormPage({super.key, this.reservation});
  final TableReservation? reservation;

  @override
  ConsumerState<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends ConsumerState<ReservationFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.reservation != null;

  late final TextEditingController _customerNameCtrl;
  late final TextEditingController _customerPhoneCtrl;
  late final TextEditingController _partySizeCtrl;
  late final TextEditingController _reservationTimeCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _notesCtrl;
  String? _selectedTableId;
  DateTime _reservationDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    final r = widget.reservation;
    _customerNameCtrl = TextEditingController(text: r?.customerName ?? '');
    _customerPhoneCtrl = TextEditingController(text: r?.customerPhone ?? '');
    _partySizeCtrl = TextEditingController(text: r?.partySize.toString() ?? '');
    _reservationTimeCtrl = TextEditingController(text: r?.reservationTime ?? '');
    _durationCtrl = TextEditingController(text: r?.durationMinutes?.toString() ?? '60');
    _notesCtrl = TextEditingController(text: r?.notes ?? '');
    _selectedTableId = r?.tableId;
    if (r != null) _reservationDate = r.reservationDate;
    Future.microtask(() => ref.read(restaurantProvider.notifier).load());
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _customerPhoneCtrl.dispose();
    _partySizeCtrl.dispose();
    _reservationTimeCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reservationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _reservationDate = picked);
  }

  Future<void> _pickTime() async {
    final initial = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        _reservationTimeCtrl.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'customer_name': _customerNameCtrl.text.trim(),
      'party_size': int.parse(_partySizeCtrl.text.trim()),
      'reservation_date': _reservationDate.toIso8601String().split('T').first,
      'reservation_time': _reservationTimeCtrl.text.trim(),
      if (_customerPhoneCtrl.text.isNotEmpty) 'customer_phone': _customerPhoneCtrl.text.trim(),
      if (_durationCtrl.text.isNotEmpty) 'duration_minutes': int.parse(_durationCtrl.text.trim()),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
      if (_selectedTableId != null && _selectedTableId!.isNotEmpty) 'table_id': _selectedTableId,
    };

    final notifier = ref.read(restaurantProvider.notifier);
    if (_isEditing) {
      await notifier.updateReservation(widget.reservation!.id, data);
    } else {
      await notifier.createReservation(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final restState = ref.watch(restaurantProvider);
    final tables = restState is RestaurantLoaded ? restState.tables : <RestaurantTable>[];
    return PosFormPage(
      title: _isEditing ? l10n.editReservation : l10n.restaurantNewReservation,
      bottomBar: PosButton(
          label: _isEditing ? l10n.restaurantUpdateReservation : l10n.restaurantCreateReservation,
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _customerNameCtrl, label: l10n.deliveryCustomerName, hint: l10n.pharmacyFullNameHint),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _customerPhoneCtrl,
              label: l10n.authPhoneOptional,
              hint: l10n.restaurantPhoneHint,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _partySizeCtrl, label: l10n.restaurantPartySize, hint: '2', keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(
                    text: '${_reservationDate.day}/${_reservationDate.month}/${_reservationDate.year}',
                  ),
                  label: l10n.reservationDate,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: _reservationTimeCtrl,
                  label: l10n.time,
                  hint: l10n.restaurantTimeHint,
                  suffixIcon: Icons.access_time,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _durationCtrl, label: l10n.durationMinutes, hint: '60', keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<String>(
              hint: l10n.selectTable,
              label: l10n.tableOptional,
              items: tables.map((t) => PosDropdownItem(value: t.id, label: t.displayName ?? 'Table ${t.tableNumber}')).toList(),
              selectedValue: _selectedTableId,
              onChanged: (v) => setState(() => _selectedTableId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: l10n.notesOptional, hint: l10n.restaurantSpecialRequestsHint, maxLines: 3),
          ],
        ),
      ),
    );
  }
}
