import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({super.key});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'general';
  String _priority = 'medium';

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(ticketActionProvider.notifier)
        .createTicket(
          category: _category,
          subject: _subjectController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
        );
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(ticketActionProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<TicketActionState>(ticketActionProvider, (prev, next) {
      if (next is TicketActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(ticketActionProvider.notifier).reset();
        context.pop();
      } else if (next is TicketActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final isLoading = actionState is TicketActionLoading;

    return PosListPage(
  title: l10n.supportNewSupportTicket,
  showSearch: false,
    child: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Category & Priority row
            PosCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosSearchableDropdown<String>(
                    label: l10n.supportCategory,
                    items: [
                      PosDropdownItem(value: 'general', label: l10n.supportCategoryGeneral),
                      PosDropdownItem(value: 'billing', label: l10n.supportCategoryBilling),
                      PosDropdownItem(value: 'technical', label: l10n.supportCategoryTechnical),
                      PosDropdownItem(value: 'zatca', label: l10n.supportCategoryZatca),
                      PosDropdownItem(value: 'feature_request', label: l10n.supportCategoryFeatureRequest),
                      PosDropdownItem(value: 'hardware', label: l10n.supportCategoryHardware),
                    ],
                    selectedValue: _category,
                    onChanged: (v) => setState(() => _category = v!),
                    showSearch: false,
                  ),
                  AppSpacing.gapH16,
                  PosSearchableDropdown<String>(
                    label: l10n.supportPriority,
                    items: [
                      PosDropdownItem(value: 'low', label: l10n.supportPriorityLow),
                      PosDropdownItem(value: 'medium', label: l10n.supportPriorityMedium),
                      PosDropdownItem(value: 'high', label: l10n.supportPriorityHigh),
                      PosDropdownItem(value: 'critical', label: l10n.supportPriorityCritical),
                    ],
                    selectedValue: _priority,
                    onChanged: (v) => setState(() => _priority = v!),
                    showSearch: false,
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,

            // Subject & Description
            PosCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(labelText: l10n.supportSubject, hintText: l10n.supportSubjectHint),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.supportRequired : null,
                    maxLength: 255,
                    textInputAction: TextInputAction.next,
                  ),
                  AppSpacing.gapH16,
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.supportDescription,
                      hintText: l10n.supportDescriptionHint,
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.supportRequired : null,
                    maxLines: 6,
                    maxLength: 5000,
                  ),
                ],
              ),
            ),
            AppSpacing.gapH24,

            // Submit
            PosButton(
              label: isLoading ? l10n.supportSubmitting : l10n.supportSubmitTicket,
              icon: Icons.send_rounded,
              isLoading: isLoading,
              isFullWidth: true,
              size: PosButtonSize.lg,
              onPressed: isLoading ? null : _submit,
            ),
          ],
        ),
      ),
);
  }
}
