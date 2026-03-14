import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class ProviderNotesPage extends ConsumerStatefulWidget {
  final String organizationId;

  const ProviderNotesPage({super.key, required this.organizationId});

  @override
  ConsumerState<ProviderNotesPage> createState() => _ProviderNotesPageState();
}

class _ProviderNotesPageState extends ConsumerState<ProviderNotesPage> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(providerNotesProvider.notifier).load(widget.organizationId));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerNotesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Notes')),
      body: Column(
        children: [
          // ─── Add Note Bar ──────────────────────────────
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _noteController,
                    label: 'Add Note',
                    hint: 'Type your note here...',
                    maxLines: 2,
                  ),
                ),
                AppSpacing.gapW12,
                PosButton(label: 'Add', icon: Icons.send, onPressed: _addNote, size: PosButtonSize.md),
              ],
            ),
          ),

          // ─── Notes List ─────────────────────────────────
          Expanded(child: _buildNotesList(state, theme)),
        ],
      ),
    );
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    ref.read(providerNotesProvider.notifier).addNote(widget.organizationId, text);
    _noteController.clear();
  }

  Widget _buildNotesList(ProviderNotesState state, ThemeData theme) {
    if (state is ProviderNotesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ProviderNotesError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(state.message, style: theme.textTheme.bodyMedium),
            AppSpacing.gapH16,
            PosButton(
              label: 'Retry',
              variant: PosButtonVariant.outline,
              onPressed: () => ref.read(providerNotesProvider.notifier).load(widget.organizationId),
            ),
          ],
        ),
      );
    }
    if (state is ProviderNotesLoaded) {
      if (state.notes.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.note_outlined, size: 64, color: AppColors.textMutedLight),
              AppSpacing.gapH12,
              Text('No notes yet', style: theme.textTheme.titleMedium),
              AppSpacing.gapH4,
              Text(
                'Add a note above to get started',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        padding: AppSpacing.paddingAll16,
        itemCount: state.notes.length,
        separatorBuilder: (_, __) => AppSpacing.gapH8,
        itemBuilder: (context, index) {
          final note = state.notes[index];
          return _buildNoteCard(note, theme);
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNoteCard(Map<String, dynamic> note, ThemeData theme) {
    final noteText = note['note_text'] as String? ?? '';
    final createdAt = note['created_at'] as String? ?? '';
    final adminUser = note['admin_user'] as Map<String, dynamic>?;
    final adminName = adminUser?['name'] as String? ?? 'Admin';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary10,
                  child: Text(
                    adminName.isNotEmpty ? adminName[0].toUpperCase() : 'A',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(adminName, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                if (createdAt.isNotEmpty)
                  Text(createdAt, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight, fontSize: 11)),
              ],
            ),
            AppSpacing.gapH12,
            Text(noteText, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
