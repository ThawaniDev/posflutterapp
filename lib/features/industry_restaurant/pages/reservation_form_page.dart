import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/table_reservation.dart';
import '../providers/restaurant_providers.dart';

class ReservationFormPage extends ConsumerStatefulWidget {
  final TableReservation? reservation;
  const ReservationFormPage({super.key, this.reservation});

  @override
  ConsumerState<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends ConsumerState<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.reservation != null;

  late final TextEditingController _customerNameCtrl;
  late final TextEditingController _customerPhoneCtrl;
  late final TextEditingController _partySizeCtrl;
  late final TextEditingController _reservationTimeCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _tableIdCtrl;
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
    _tableIdCtrl = TextEditingController(text: r?.tableId ?? '');
    if (r != null) _reservationDate = r.reservationDate;
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _customerPhoneCtrl.dispose();
    _partySizeCtrl.dispose();
    _reservationTimeCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    _tableIdCtrl.dispose();
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
      if (_tableIdCtrl.text.isNotEmpty) 'table_id': _tableIdCtrl.text.trim(),
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
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Reservation' : 'New Reservation')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Reservation' : 'Create Reservation',
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
            PosTextField(controller: _customerNameCtrl, label: 'Customer Name', hint: 'Full name'),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _customerPhoneCtrl,
              label: 'Phone (optional)',
              hint: '+968 XXXX XXXX',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _partySizeCtrl, label: 'Party Size', hint: '2', keyboardType: TextInputType.number),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(
                    text: '${_reservationDate.day}/${_reservationDate.month}/${_reservationDate.year}',
                  ),
                  label: 'Reservation Date',
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: PosTextField(
                  controller: _reservationTimeCtrl,
                  label: 'Time',
                  hint: 'HH:MM',
                  suffixIcon: Icons.access_time,
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _durationCtrl, label: 'Duration (minutes)', hint: '60', keyboardType: TextInputType.number),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _tableIdCtrl, label: 'Table (optional)', hint: 'Assign table'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: 'Notes (optional)', hint: 'Special requests, allergies...', maxLines: 3),
          ],
        ),
      ),
    );
  }
}
