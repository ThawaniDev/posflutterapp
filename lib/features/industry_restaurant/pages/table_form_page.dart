import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/restaurant_table.dart';
import '../providers/restaurant_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class TableFormPage extends ConsumerStatefulWidget {
  final RestaurantTable? table;
  const TableFormPage({super.key, this.table});

  @override
  ConsumerState<TableFormPage> createState() => _TableFormPageState();
}

class _TableFormPageState extends ConsumerState<TableFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.table != null;

  late final TextEditingController _tableNumberCtrl;
  late final TextEditingController _displayNameCtrl;
  late final TextEditingController _seatsCtrl;
  late final TextEditingController _zoneCtrl;
  late final TextEditingController _posXCtrl;
  late final TextEditingController _posYCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final t = widget.table;
    _tableNumberCtrl = TextEditingController(text: t?.tableNumber ?? '');
    _displayNameCtrl = TextEditingController(text: t?.displayName ?? '');
    _seatsCtrl = TextEditingController(text: t?.seats.toString() ?? '');
    _zoneCtrl = TextEditingController(text: t?.zone ?? '');
    _posXCtrl = TextEditingController(text: t?.positionX?.toString() ?? '');
    _posYCtrl = TextEditingController(text: t?.positionY?.toString() ?? '');
    _isActive = t?.isActive ?? true;
  }

  @override
  void dispose() {
    _tableNumberCtrl.dispose();
    _displayNameCtrl.dispose();
    _seatsCtrl.dispose();
    _zoneCtrl.dispose();
    _posXCtrl.dispose();
    _posYCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'table_number': _tableNumberCtrl.text.trim(),
      'seats': int.parse(_seatsCtrl.text.trim()),
      'is_active': _isActive,
      if (_displayNameCtrl.text.isNotEmpty) 'display_name': _displayNameCtrl.text.trim(),
      if (_zoneCtrl.text.isNotEmpty) 'zone': _zoneCtrl.text.trim(),
      if (_posXCtrl.text.isNotEmpty) 'position_x': int.parse(_posXCtrl.text.trim()),
      if (_posYCtrl.text.isNotEmpty) 'position_y': int.parse(_posYCtrl.text.trim()),
    };

    final notifier = ref.read(restaurantProvider.notifier);
    if (_isEditing) {
      await notifier.updateTable(widget.table!.id, data);
    } else {
      await notifier.createTable(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosFormPage(
      title: _isEditing ? 'Edit Table' : 'New Table',
      bottomBar: PosButton(
          label: _isEditing ? 'Update Table' : 'Create Table',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _tableNumberCtrl, label: l10n.restaurantTableNumber, hint: 'e.g. T1, A-01'),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _seatsCtrl, label: l10n.restaurantSeats, hint: '4', keyboardType: TextInputType.number),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _displayNameCtrl, label: l10n.displayNameOptional, hint: 'e.g. Window Table, Patio 1'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _zoneCtrl, label: l10n.zoneOptional, hint: 'e.g. Indoor, Outdoor, VIP'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _posXCtrl, label: l10n.positionX, hint: '0', keyboardType: TextInputType.number),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _posYCtrl, label: l10n.positionY, hint: '0', keyboardType: TextInputType.number),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosToggle(
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              label: l10n.active,
              subtitle: 'Table is available for seating',
            ),
          ],
        ),
      ),
    );
  }
}
