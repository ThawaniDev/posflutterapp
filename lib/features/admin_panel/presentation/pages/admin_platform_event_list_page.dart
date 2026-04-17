import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AdminPlatformEventListPage extends ConsumerStatefulWidget {
  const AdminPlatformEventListPage({super.key});

  @override
  ConsumerState<AdminPlatformEventListPage> createState() => _AdminPlatformEventListPageState();
}

class _AdminPlatformEventListPageState extends ConsumerState<AdminPlatformEventListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _levelFilter;
  String? _eventTypeFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_levelFilter != null) params['level'] = _levelFilter;
    if (_eventTypeFilter != null) params['event_type'] = _eventTypeFilter;
    ref.read(platformEventListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _levelColor(String? level) => switch (level) {
    'critical' => AppColors.errorDark,
    'error' => AppColors.error,
    'warning' => AppColors.warning,
    'info' => AppColors.info,
    'debug' => AppColors.textSecondary,
    _ => AppColors.textSecondary,
  };

  IconData _levelIcon(String? level) => switch (level) {
    'critical' => Icons.dangerous,
    'error' => Icons.error_outline,
    'warning' => Icons.warning_amber,
    'info' => Icons.info_outline,
    'debug' => Icons.bug_report_outlined,
    _ => Icons.article_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(platformEventListProvider);

    return PosListPage(
  title: l10n.platformEvents,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                final searchField = TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                );
                final levelDropdown = PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'debug', label: 'Debug'),
                    PosDropdownItem(value: 'info', label: 'Info'),
                    PosDropdownItem(value: 'warning', label: 'Warning'),
                    PosDropdownItem(value: 'error', label: l10n.uiError),
                    PosDropdownItem(value: 'critical', label: l10n.supportPriorityCritical),
                  ],
                  selectedValue: _levelFilter,
                  onChanged: (v) {
                    setState(() => _levelFilter = v);
                    _applyFilters();
                  },
                  hint: 'Level',
                  showSearch: false,
                  clearable: true,
                );
                final typeDropdown = PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'deployment', label: l10n.adminDeployment),
                    PosDropdownItem(value: 'config_change', label: 'Config Change'),
                    PosDropdownItem(value: 'cron_job', label: 'Cron Job'),
                    PosDropdownItem(value: 'maintenance', label: l10n.maintenance),
                    PosDropdownItem(value: 'error', label: l10n.uiError),
                  ],
                  selectedValue: _eventTypeFilter,
                  onChanged: (v) {
                    setState(() => _eventTypeFilter = v);
                    _applyFilters();
                  },
                  hint: 'Type',
                  showSearch: false,
                  clearable: true,
                );
                return ResponsiveSearchFilterBar(
                  searchField: searchField,
                  filters: [levelDropdown, typeDropdown],
                );
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              PlatformEventListInitial() || PlatformEventListLoading() => const Center(child: CircularProgressIndicator()),
              PlatformEventListLoaded(data: final data) => _buildList(data),
              PlatformEventListError(message: final msg) => Center(
                child: Text(msg, style: const TextStyle(color: AppColors.error)),
              ),
            },
          ),
        ],
      ),
);
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data']?['data'] as List?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No platform events found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final event = items[index] as Map<String, dynamic>;
        final level = event['level']?.toString();
        return PosCard(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _levelColor(level).withValues(alpha: 0.15),
              child: Icon(_levelIcon(level), color: _levelColor(level)),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    event['message']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _levelColor(level).withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderXs,
                  ),
                  child: Text(
                    level?.toUpperCase() ?? '',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _levelColor(level)),
                  ),
                ),
              ],
            ),
            subtitle: Text('${event['event_type'] ?? ''} • ${event['source'] ?? 'system'}\n${event['created_at'] ?? ''}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
