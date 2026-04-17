import 'package:flutter/material.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminNotificationTemplateListPage extends ConsumerStatefulWidget {
  const AdminNotificationTemplateListPage({super.key});

  @override
  ConsumerState<AdminNotificationTemplateListPage> createState() => _AdminNotificationTemplateListPageState();
}

class _AdminNotificationTemplateListPageState extends ConsumerState<AdminNotificationTemplateListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _selectedChannel;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(notificationTemplateListProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(notificationTemplateListProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          channel: _selectedChannel,
          storeId: _storeId,
        );
  }

  Color _channelColor(String? channel) => switch (channel) {
    'push' => AppColors.info,
    'email' => AppColors.purple,
    'sms' => AppColors.success,
    'whatsapp' => AppColors.info,
    'in_app' => AppColors.warning,
    _ => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationTemplateListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminNotificationTemplates),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.marketplaceSearch,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: 'push', label: l10n.notificationsPush),
                      PosDropdownItem(value: 'email', label: l10n.email),
                      PosDropdownItem(value: 'sms', label: l10n.notifPrefSms),
                      PosDropdownItem(value: 'in_app', label: l10n.notificationsInApp),
                      PosDropdownItem(value: 'whatsapp', label: 'WhatsApp'),
                    ],
                    selectedValue: _selectedChannel,
                    onChanged: (v) {
                      setState(() => _selectedChannel = v);
                      _search();
                    },
                    hint: 'Channel',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              NotificationTemplateListInitial() ||
              NotificationTemplateListLoading() => const Center(child: CircularProgressIndicator()),
              NotificationTemplateListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
              ),
              NotificationTemplateListLoaded(:final templates) =>
                templates.isEmpty
                    ? Center(child: Text(l10n.marketplaceNoListings))
                    : ListView.builder(
                        itemCount: templates.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final tpl = templates[index];
                          final channel = tpl['channel'] as String?;
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _channelColor(channel).withValues(alpha: 0.2),
                                child: Text(
                                  (channel ?? '?').substring(0, 1).toUpperCase(),
                                  style: TextStyle(color: _channelColor(channel), fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(tpl['event_key'] ?? ''),
                              subtitle: Text('${channel ?? ''} • ${tpl['title'] ?? 'No title'}'),
                              trailing: Switch(value: tpl['is_active'] == true, onChanged: null),
                            ),
                          );
                        },
                      ),
            },
          ),
        ],
      ),
    );
  }
}
