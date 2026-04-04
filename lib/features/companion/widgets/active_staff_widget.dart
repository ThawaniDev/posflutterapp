import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/companion/providers/companion_providers.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

class ActiveStaffWidget extends ConsumerStatefulWidget {
  const ActiveStaffWidget({super.key});

  @override
  ConsumerState<ActiveStaffWidget> createState() => _ActiveStaffWidgetState();
}

class _ActiveStaffWidgetState extends ConsumerState<ActiveStaffWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeStaffProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeStaffProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      ActiveStaffInitial() || ActiveStaffLoading() => const Center(child: CircularProgressIndicator()),
      ActiveStaffError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
            AppSpacing.gapH8,
            TextButton(onPressed: () => ref.read(activeStaffProvider.notifier).load(), child: Text(l10n.companionRetry)),
          ],
        ),
      ),
      ActiveStaffLoaded(:final staff, :final totalActive) =>
        staff.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline, size: 48, color: AppColors.textSecondary),
                    AppSpacing.gapH8,
                    Text(l10n.companionNoActiveStaff, style: theme.textTheme.titleMedium),
                  ],
                ),
              )
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: staff.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.people, size: 20, color: AppColors.info),
                          AppSpacing.gapW8,
                          Text('${l10n.companionActiveStaff} ($totalActive)', style: theme.textTheme.titleMedium),
                        ],
                      ),
                    );
                  }
                  final member = staff[index - 1];
                  return _StaffCard(member: member);
                },
              ),
    };
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member});

  final Map<String, dynamic> member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final role = member['role'] as String? ?? '';
    final clockedInAt = member['clocked_in_at'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            (member['name'] as String? ?? '?').substring(0, 1).toUpperCase(),
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(member['name'] as String? ?? '-', style: theme.textTheme.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (role.isNotEmpty) Text(role, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            if (clockedInAt != null)
              Text(
                '${l10n.companionClockedIn}: $clockedInAt',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
          ],
        ),
        trailing: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
