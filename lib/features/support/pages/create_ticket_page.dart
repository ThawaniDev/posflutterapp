import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/support/providers/support_providers.dart';
import 'package:thawani_pos/features/support/providers/support_state.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.success));
        ref.read(ticketActionProvider.notifier).reset();
        context.pop();
      } else if (next is TicketActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    final isLoading = actionState is TicketActionLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportNewSupportTicket)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Category & Priority row
            PosCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosDropdown<String>(
                    label: l10n.supportCategory,
                    value: _category,
                    items: [
                      DropdownMenuItem(value: 'general', child: Text(l10n.supportCategoryGeneral)),
                      DropdownMenuItem(value: 'billing', child: Text(l10n.supportCategoryBilling)),
                      DropdownMenuItem(value: 'technical', child: Text(l10n.supportCategoryTechnical)),
                      DropdownMenuItem(value: 'zatca', child: Text(l10n.supportCategoryZatca)),
                      DropdownMenuItem(value: 'feature_request', child: Text(l10n.supportCategoryFeatureRequest)),
                      DropdownMenuItem(value: 'hardware', child: Text(l10n.supportCategoryHardware)),
                    ],
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  AppSpacing.gapH16,
                  PosDropdown<String>(
                    label: l10n.supportPriority,
                    value: _priority,
                    items: [
                      DropdownMenuItem(value: 'low', child: Text(l10n.supportPriorityLow)),
                      DropdownMenuItem(value: 'medium', child: Text(l10n.supportPriorityMedium)),
                      DropdownMenuItem(value: 'high', child: Text(l10n.supportPriorityHigh)),
                      DropdownMenuItem(value: 'critical', child: Text(l10n.supportPriorityCritical)),
                    ],
                    onChanged: (v) => setState(() => _priority = v!),
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
