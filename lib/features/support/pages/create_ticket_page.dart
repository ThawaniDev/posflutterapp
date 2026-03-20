import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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

    ref.listen<TicketActionState>(ticketActionProvider, (prev, next) {
      if (next is TicketActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(ticketActionProvider.notifier).reset();
        context.pop();
      } else if (next is TicketActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: Colors.red));
      }
    });

    final isLoading = actionState is TicketActionLoading;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.supportNewSupportTicket)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.supportCategory,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'general', child: Text(AppLocalizations.of(context)!.supportCategoryGeneral)),
                DropdownMenuItem(value: 'billing', child: Text(AppLocalizations.of(context)!.supportCategoryBilling)),
                DropdownMenuItem(value: 'technical', child: Text(AppLocalizations.of(context)!.supportCategoryTechnical)),
                DropdownMenuItem(value: 'zatca', child: Text(AppLocalizations.of(context)!.supportCategoryZatca)),
                DropdownMenuItem(
                  value: 'feature_request',
                  child: Text(AppLocalizations.of(context)!.supportCategoryFeatureRequest),
                ),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // Priority
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.supportPriority,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'low', child: Text(AppLocalizations.of(context)!.supportPriorityLow)),
                DropdownMenuItem(value: 'medium', child: Text(AppLocalizations.of(context)!.supportPriorityMedium)),
                DropdownMenuItem(value: 'high', child: Text(AppLocalizations.of(context)!.supportPriorityHigh)),
                DropdownMenuItem(value: 'critical', child: Text(AppLocalizations.of(context)!.supportPriorityCritical)),
              ],
              onChanged: (v) => setState(() => _priority = v!),
            ),
            const SizedBox(height: 16),

            // Subject
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.supportSubject,
                border: const OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? AppLocalizations.of(context)!.supportRequired : null,
              maxLength: 255,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.supportDescription,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? AppLocalizations.of(context)!.supportRequired : null,
              maxLines: 6,
              maxLength: 5000,
            ),
            const SizedBox(height: 24),

            // Submit
            FilledButton.icon(
              onPressed: isLoading ? null : _submit,
              icon: isLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: Text(
                isLoading ? AppLocalizations.of(context)!.supportSubmitting : AppLocalizations.of(context)!.supportSubmitTicket,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
