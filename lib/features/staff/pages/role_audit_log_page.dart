import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';

class RoleAuditLogPage extends ConsumerStatefulWidget {
  const RoleAuditLogPage({super.key});

  @override
  ConsumerState<RoleAuditLogPage> createState() => _RoleAuditLogPageState();
}

class _RoleAuditLogPageState extends ConsumerState<RoleAuditLogPage> {
  String? _filterAction;
  DateTimeRange? _dateRange;
  final _dateFmt = DateFormat('yyyy-MM-dd');
  final _displayFmt = DateFormat('dd MMM yyyy, hh:mm a');

  static const _actions = ['role_created', 'role_updated', 'permission_granted', 'permission_revoked'];

  Color _actionColor(String action) {
    return switch (action) {
      'role_created' => AppColors.success,
      'role_updated' => AppColors.warning,
      'permission_granted' => AppColors.info,
      'permission_revoked' => AppColors.error,
      _ => AppColors.info,
    };
  }

  String _actionLabel(String action, AppLocalizations l10n) {
    return switch (action) {
      'role_created' => l10n.staffRoleAuditActionCreated,
      'role_updated' => l10n.staffRoleAuditActionUpdated,
      'permission_granted' => l10n.staffRoleAuditActionPermissionGranted,
      'permission_revoked' => l10n.staffRoleAuditActionPermissionRevoked,
      _ => action,
    };
  }

  void _applyFilters() {
    ref
        .read(roleAuditLogProvider.notifier)
        .applyFilters(
          action: _filterAction,
          dateFrom: _dateRange != null ? _dateFmt.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFmt.format(_dateRange!.end) : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(roleAuditLogProvider);

    final hasFilters = _filterAction != null || _dateRange != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.staffRoleAuditLog),
        actions: [
          if (hasFilters)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _filterAction = null;
                  _dateRange = null;
                });
                ref.read(roleAuditLogProvider.notifier).clearFilters();
              },
              icon: const Icon(Icons.clear, size: 16),
              label: Text(l10n.clearFilters),
            ),
          PosButton.icon(
            icon: Icons.refresh,
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(roleAuditLogProvider.notifier).load(refresh: true),
            variant: PosButtonVariant.ghost,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            child: Row(
              children: [
                // Action filter
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _filterAction,
                    decoration: InputDecoration(
                      labelText: l10n.staffRoleAuditAction,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ..._actions.map(
                        (a) => DropdownMenuItem(
                          value: a,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: _actionColor(a), shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text(_actionLabel(a, l10n), style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() => _filterAction = v);
                      _applyFilters();
                    },
                  ),
                ),
                AppSpacing.gapW12,
                // Date range filter
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final range = await showPosDateRangePicker(
                        context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: _dateRange,
                      );
                      if (range != null) {
                        setState(() => _dateRange = range);
                        _applyFilters();
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.staffFilterByDate,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                      ),
                      child: Text(
                        _dateRange != null
                            ? '${_dateFmt.format(_dateRange!.start)} – ${_dateFmt.format(_dateRange!.end)}'
                            : l10n.all,
                        style: TextStyle(fontSize: 13, color: _dateRange != null ? null : AppColors.mutedFor(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results count
          if (!state.isLoading && state.entries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Text('${state.total} ${l10n.totalCount}', style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
                ],
              ),
            ),

          // Content
          Expanded(
            child: state.isLoading && state.entries.isEmpty
                ? PosLoadingSkeleton.list()
                : state.error != null && state.entries.isEmpty
                ? PosErrorState(message: state.error!, onRetry: () => ref.read(roleAuditLogProvider.notifier).load(refresh: true))
                : state.entries.isEmpty
                ? PosEmptyState(title: l10n.staffRoleAuditNoLogs, icon: Icons.history_outlined)
                : NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      if (n is ScrollEndNotification && n.metrics.extentAfter < 200 && state.hasMore && !state.isLoading) {
                        ref.read(roleAuditLogProvider.notifier).load(page: state.currentPage + 1);
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.entries.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => AppSpacing.gapH8,
                      itemBuilder: (ctx, i) {
                        if (i == state.entries.length) {
                          return const Center(
                            child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
                          );
                        }
                        final entry = state.entries[i];
                        return _AuditLogCard(
                          entry: entry,
                          actionColor: _actionColor(entry['action'] as String? ?? ''),
                          actionLabel: _actionLabel(entry['action'] as String? ?? '', l10n),
                          displayFmt: _displayFmt,
                          isDark: isDark,
                          l10n: l10n,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Audit Log Entry Card ─────────────────────────────────────

class _AuditLogCard extends StatefulWidget {
  const _AuditLogCard({
    required this.entry,
    required this.actionColor,
    required this.actionLabel,
    required this.displayFmt,
    required this.isDark,
    required this.l10n,
  });
  final Map<String, dynamic> entry;
  final Color actionColor;
  final String actionLabel;
  final DateFormat displayFmt;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  State<_AuditLogCard> createState() => _AuditLogCardState();
}

class _AuditLogCardState extends State<_AuditLogCard> {
  bool _expanded = false;
  AppLocalizations get l10n => widget.l10n;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final createdAt = entry['created_at'] as String?;
    final roleName = entry['role_name'] as String? ?? '—';
    final userName = entry['user_name'] as String? ?? '—';
    final userEmail = entry['user_email'] as String? ?? '';
    final details = entry['details'];

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Action badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.actionColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.actionColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: widget.actionColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.actionLabel,
                      style: TextStyle(fontSize: 12, color: widget.actionColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (createdAt != null)
                Text(
                  widget.displayFmt.format(DateTime.parse(createdAt).toLocal()),
                  style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
                ),
            ],
          ),
          AppSpacing.gapH8,
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 14, color: AppColors.mutedFor(context)),
              const SizedBox(width: 4),
              Text(roleName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          AppSpacing.gapH8,
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: AppColors.mutedFor(context)),
              const SizedBox(width: 4),
              Text(userName, style: const TextStyle(fontSize: 13)),
              if (userEmail.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text('($userEmail)', style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
              ],
            ],
          ),
          if (details != null) ...[
            AppSpacing.gapH8,
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.mutedFor(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _expanded ? l10n.commonRefresh : l10n.all,
                    style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context)),
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (widget.isDark ? Colors.white : Colors.black).withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  details.toString(),
                  style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context), fontFamily: 'monospace'),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
