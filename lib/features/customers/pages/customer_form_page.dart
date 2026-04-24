import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage({super.key, this.customerId});
  final String? customerId;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _taxNumber = TextEditingController();
  final _notes = TextEditingController();
  String? _groupId;
  DateTime? _dob;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(customerGroupsProvider.notifier).load();
      if (widget.customerId != null) {
        await ref.read(customerDetailProvider(widget.customerId!).notifier).load();
      }
    });
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _address, _taxNumber, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = <String, dynamic>{
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
      if (_address.text.trim().isNotEmpty) 'address': _address.text.trim(),
      if (_taxNumber.text.trim().isNotEmpty) 'tax_registration_number': _taxNumber.text.trim(),
      if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
      if (_groupId != null) 'group_id': _groupId,
      if (_dob != null) 'date_of_birth': _dob!.toIso8601String().substring(0, 10),
    };
    await ref.read(customerDetailProvider(widget.customerId).notifier).save(data);
    final state = ref.read(customerDetailProvider(widget.customerId));
    if (!mounted) return;
    if (state is CustomerDetailSaved) {
      // Refresh list cache.
      ref.read(customersProvider.notifier).load();
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.customersSaved);
      context.pop();
    } else if (state is CustomerDetailError) {
      showPosErrorSnackbar(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detail = ref.watch(customerDetailProvider(widget.customerId));
    final groupsState = ref.watch(customerGroupsProvider);
    final groups = groupsState is CustomerGroupsLoaded ? groupsState.groups : const [];

    if (!_initialized && detail is CustomerDetailLoaded) {
      final c = detail.customer;
      _name.text = c.name;
      _phone.text = c.phone;
      _email.text = c.email ?? '';
      _address.text = c.address ?? '';
      _taxNumber.text = c.taxRegistrationNumber ?? '';
      _notes.text = c.notes ?? '';
      _groupId = c.groupId;
      _dob = c.dateOfBirth;
      _initialized = true;
    }

    final isSaving = detail is CustomerDetailSaving;
    final isLoading = widget.customerId != null && detail is CustomerDetailLoading && !_initialized;

    return PosFormPage(
      title: widget.customerId == null ? l10n.customersAdd : l10n.customersEdit,
      onBack: () => context.pop(),
      isLoading: isLoading,
      bottomBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton(
            label: l10n.cancel,
            variant: PosButtonVariant.ghost,
            onPressed: () => context.pop(),
          ),
          AppSpacing.gapW8,
          PosButton(
            label: l10n.commonSave,
            icon: Icons.save_outlined,
            onPressed: isSaving ? null : _save,
            isLoading: isSaving,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PosFormCard(
              title: l10n.customersBasicInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosTextField(
                    controller: _name,
                    label: l10n.customersName,
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequired : null,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _phone,
                    label: l10n.customersPhone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequired : null,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _email,
                    label: l10n.customersEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _address,
                    label: l10n.customersAddress,
                    maxLines: 2,
                  ),
                  AppSpacing.gapH12,
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dob ?? DateTime(now.year - 25),
                              firstDate: DateTime(1900),
                              lastDate: now,
                            );
                            if (picked != null) setState(() => _dob = picked);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.customersDateOfBirth,
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            ),
                            child: Text(_dob != null
                                ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
                                : '-'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,
            PosFormCard(
              title: l10n.customersGroupAndB2B,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosDropdown<String?>(
                    label: l10n.customersGroup,
                    value: _groupId,
                    onChanged: (v) => setState(() => _groupId = v),
                    items: [
                      DropdownMenuItem<String?>(value: null, child: Text(l10n.notificationsDigestNone)),
                      for (final g in groups) DropdownMenuItem<String?>(value: g.id, child: Text(g.name)),
                    ],
                  ),
                  AppSpacing.gapH12,
                  PosTextField(controller: _taxNumber, label: l10n.customersTaxNumber),
                ],
              ),
            ),
            AppSpacing.gapH16,
            PosFormCard(
              title: l10n.customersNotes,
              child: PosTextField(controller: _notes, maxLines: 4, hint: l10n.customersNotes),
            ),
          ],
        ),
      ),
    );
  }
}
