import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_pharmacy/models/prescription.dart';
import 'package:wameedpos/features/industry_pharmacy/providers/pharmacy_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PrescriptionFormPage extends ConsumerStatefulWidget {
  const PrescriptionFormPage({super.key, this.prescription});
  final Prescription? prescription;

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
    return PosFormPage(
      title: _isEditing ? l10n.pharmacyEditPrescription : l10n.pharmacyNewPrescription,
      bottomBar: PosButton(
          label: _isEditing ? l10n.pharmacyUpdatePrescription : l10n.pharmacyCreatePrescription,
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosTextField(controller: _prescriptionNumberCtrl, label: l10n.pharmacyPrescriptionNumber, hint: l10n.pharmacyPrescriptionNumberHint),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _patientNameCtrl, label: l10n.pharmacyPatientName, hint: l10n.pharmacyFullNameHint),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _patientIdCtrl, label: l10n.pharmacyPatientIdOptional, hint: l10n.pharmacyPatientIdHint),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.pharmacyDoctorInfo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: PosTextField(controller: _doctorNameCtrl, label: l10n.pharmacyDoctorName, hint: l10n.pharmacyDoctorHint),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(controller: _doctorLicenseCtrl, label: l10n.pharmacyLicenseNo, hint: l10n.pharmacyLicenseHint),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.pharmacyInsurance, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(controller: _insuranceProviderCtrl, label: l10n.pharmacyInsuranceProvider, hint: l10n.pharmacyInsuranceHint),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _insuranceClaimCtrl,
              label: l10n.pharmacyClaimAmount,
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesCtrl, label: l10n.notesOptional, hint: l10n.bakeryAdditionalNotes, maxLines: 3),
          ],
        ),
      ),
    );
  }
}
