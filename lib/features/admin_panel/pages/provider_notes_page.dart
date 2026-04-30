import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProviderNotesPage extends ConsumerStatefulWidget {
  const ProviderNotesPage({super.key, required this.organizationId});
  final String organizationId;

  @override
  ConsumerState<ProviderNotesPage> createState() => _ProviderNotesPageState();
}

class _ProviderNotesPageState extends ConsumerState<ProviderNotesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _noteController = TextEditingController();
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(providerNotesProvider.notifier).load(widget.organizationId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(providerNotesProvider);
    final theme = Theme.of(context);
    final isLoading = state is ProviderNotesLoading;
    final hasError = state is ProviderNotesError;
    final isEmpty = state is ProviderNotesLoaded && state.notes.isEmpty;

    return PosListPage(
      title: l10n.providerNotes,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(providerNotesProvider.notifier).load(widget.organizationId),
      isEmpty: isEmpty,
      emptyTitle: 'No notes yet',
      emptySubtitle: l10n.adminAddNoteToStart,
      emptyIcon: Icons.note_outlined,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceFor(context),
              border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _noteController,
                    label: l10n.adminAddNote,
                    hint: l10n.adminTypeNoteHint,
                    maxLines: 2,
                  ),
                ),
                AppSpacing.gapW12,
                PosButton(label: l10n.add, icon: Icons.send, onPressed: _addNote, size: PosButtonSize.md),
              ],
            ),
          ),
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
    if (state is ProviderNotesLoaded) {
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
    // API now returns admin_user_name directly (loaded via relation)
    final adminName =
        note['admin_user_name'] as String? ?? (note['admin_user'] as Map<String, dynamic>?)?['name'] as String? ?? 'Admin';

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
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
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(adminName, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                if (createdAt.isNotEmpty)
                  Text(createdAt, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context), fontSize: 11)),
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
