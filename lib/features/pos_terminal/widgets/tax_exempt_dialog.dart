import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Tax-exemption details captured at sale time. Wired into the
/// `tax_exemption` nested object accepted by `POST /pos/transactions`.
class TaxExemptionDetails {
  const TaxExemptionDetails({
    required this.exemptionType,
    this.customerTaxId,
    this.certificateNumber,
    this.notes,
  });

  final String exemptionType;
  final String? customerTaxId;
  final String? certificateNumber;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'exemption_type': exemptionType,
        if (customerTaxId?.isNotEmpty == true) 'customer_tax_id': customerTaxId,
        if (certificateNumber?.isNotEmpty == true) 'certificate_number': certificateNumber,
        if (notes?.isNotEmpty == true) 'notes': notes,
      };
}

const _kExemptionTypes = <String, String>{
  'export': 'Export',
  'diplomatic': 'Diplomatic',
  'government': 'Government',
  'charity': 'Charity / Non-profit',
  'medical': 'Medical / Healthcare',
  'other': 'Other',
};

Future<TaxExemptionDetails?> showPosTaxExemptDialog(BuildContext context) {
  return showDialog<TaxExemptionDetails>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _TaxExemptDialog(),
  );
}

class _TaxExemptDialog extends StatefulWidget {
  const _TaxExemptDialog();

  @override
  State<_TaxExemptDialog> createState() => _TaxExemptDialogState();
}

class _TaxExemptDialogState extends State<_TaxExemptDialog> {
  String _type = _kExemptionTypes.keys.first;
  final _taxId = TextEditingController();
  final _certNo = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _taxId.dispose();
    _certNo.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(
      context,
      TaxExemptionDetails(
        exemptionType: _type,
        customerTaxId: _taxId.text.trim(),
        certificateNumber: _certNo.text.trim(),
        notes: _notes.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.posTaxExemptTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH16,
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l.posTaxExemptType),
                items: _kExemptionTypes.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              AppSpacing.gapH12,
              PosTextField(controller: _taxId, label: l.posTaxExemptCustomerTaxId),
              AppSpacing.gapH12,
              PosTextField(controller: _certNo, label: l.posTaxExemptCertificateNumber),
              AppSpacing.gapH12,
              PosTextField(controller: _notes, label: l.posTaxExemptNotes, maxLines: 3, minLines: 2),
              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: MaterialLocalizations.of(context).cancelButtonLabel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(label: l.posTaxExemptSubmit, onPressed: _submit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
