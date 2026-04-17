import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../models/prescription.dart';
import '../providers/pharmacy_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PrescriptionFormPage extends ConsumerStatefulWidget {
  final Prescription? prescription;
  const PrescriptionFormPage({super.key, this.prescription});

  @override
  ConsumerState<PrescriptionFormPage> createState() => _PrescriptionFormPageState();
}

class _PrescriptionFormPageState extends ConsumerState<PrescriptionFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.prescription != null;

  late final TextEditingController _prescriptionNumberCtrl;
  late final TextEditingController _patientNameCtrl;
  late final TextEditingController _patientIdCtrl;
  late final TextEditingController _doctorNameCtrl;
  late final TextEditingController _doctorLicenseCtrl;
  late final TextEditingController _insuranceProviderCtrl;
  late final TextEditingController _insuranceClaimCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.prescription;
    _prescriptionNumberCtrl = TextEditingController(text: p?.prescriptionNumber ?? '');
    _patientNameCtrl = TextEditingController(text: p?.patientName ?? '');
    _patientIdCtrl = TextEditingController(text: p?.patientId ?? '');
    _doctorNameCtrl = TextEditingController(text: p?.doctorName ?? '');
    _doctorLicenseCtrl = TextEditingController(text: p?.doctorLicense ?? '');
    _insuranceProviderCtrl = TextEditingController(text: p?.insuranceProvider ?? '');
    _insuranceClaimCtrl = TextEditingController(text: p?.insuranceClaimAmount?.toStringAsFixed(2) ?? '');
    _notesCtrl = TextEditingController(text: p?.notes ?? '');
  }

  @override
  void dispose() {
    _prescriptionNumberCtrl.dispose();
    _patientNameCtrl.dispose();
    _patientIdCtrl.dispose();
    _doctorNameCtrl.dispose();
    _doctorLicenseCtrl.dispose();
    _insuranceProviderCtrl.dispose();
    _insuranceClaimCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'prescription_number': _prescriptionNumberCtrl.text.trim(),
      'patient_name': _patientNameCtrl.text.trim(),
      if (_patientIdCtrl.text.isNotEmpty) 'patient_id': _patientIdCtrl.text.trim(),
      if (_doctorNameCtrl.text.isNotEmpty) 'doctor_name': _doctorNameCtrl.text.trim(),
      if (_doctorLicenseCtrl.text.isNotEmpty) 'doctor_license': _doctorLicenseCtrl.text.trim(),
      if (_insuranceProviderCtrl.text.isNotEmpty) 'insurance_provider': _insuranceProviderCtrl.text.trim(),
      if (_insuranceClaimCtrl.text.isNotEmpty) 'insurance_claim_amount': double.parse(_insuranceClaimCtrl.text.trim()),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    };

    final notifier = ref.read(pharmacyProvider.notifier);
    if (_isEditing) {
      await notifier.updatePrescription(widget.prescription!.id, data);
    } else {
      await notifier.createPrescription(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Prescription' : 'New Prescription')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Prescription' : 'Create Prescription',
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
            PosTextField(controller: _prescriptionNumberCtrl, label: 'Prescription Number', hint: 'e.g. RX-001234'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _patientNameCtrl, label: l10n.pharmacyPatientName, hint: 'Full name'),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _patientIdCtrl, label: 'Patient ID (optional)', hint: 'National ID or system ID'),
            SizedBox(height: AppSpacing.lg),
            Text('Doctor Information', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _doctorNameCtrl, label: l10n.pharmacyDoctorName, hint: 'Dr. ...'),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _doctorLicenseCtrl, label: 'License No.', hint: 'Medical license'),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Text('Insurance', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm),
            PosTextField(controller: _insuranceProviderCtrl, label: 'Insurance Provider (optional)', hint: 'e.g. DHAMAN'),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _insuranceClaimCtrl,
              label: 'Claim Amount (\u0081)',
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: l10n.notesOptional, hint: 'Additional notes...', maxLines: 3),
          ],
        ),
      ),
    );
  }
}
