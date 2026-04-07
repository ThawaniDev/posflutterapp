import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminSupportTicketListPage extends ConsumerStatefulWidget {
  const AdminSupportTicketListPage({super.key});

  @override
  ConsumerState<AdminSupportTicketListPage> createState() => _AdminSupportTicketListPageState();
}

class _AdminSupportTicketListPageState extends ConsumerState<AdminSupportTicketListPage> {
  final _searchController = TextEditingController();
  String? _statusFilter;
  String? _priorityFilter;
  String? _categoryFilter;
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
    if (_statusFilter != null) params['status'] = _statusFilter;
    if (_priorityFilter != null) params['priority'] = _priorityFilter;
    if (_categoryFilter != null) params['category'] = _categoryFilter;
    ref.read(ticketListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _statusColor(String status) => switch (status) {
    'open' => AppColors.info,
    'in_progress' => AppColors.warning,
    'resolved' => AppColors.success,
    'closed' => AppColors.textSecondary,
    _ => AppColors.textSecondary,
  };

  Color _priorityColor(String priority) => switch (priority) {
    'low' => AppColors.textSecondary,
    'medium' => AppColors.info,
    'high' => AppColors.warning,
    'critical' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  IconData _priorityIcon(String priority) => switch (priority) {
    'critical' => Icons.error,
    'high' => Icons.arrow_upward,
    'medium' => Icons.remove,
    'low' => Icons.arrow_downward,
    _ => Icons.remove,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ticketListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Support Tickets'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // ── Filters ──
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tickets...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                ),
                const SizedBox(height: AppSpacing.sm),
                context.isPhone
                    ? Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _statusFilter,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('All')),
                              DropdownMenuItem(value: 'open', child: Text('Open')),
                              DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                              DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                              DropdownMenuItem(value: 'closed', child: Text('Closed')),
                            ],
                            onChanged: (v) {
                              setState(() => _statusFilter = v);
                              _applyFilters();
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          DropdownButtonFormField<String>(
                            value: _priorityFilter,
                            decoration: const InputDecoration(
                              labelText: 'Priority',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('All')),
                              DropdownMenuItem(value: 'low', child: Text('Low')),
                              DropdownMenuItem(value: 'medium', child: Text('Medium')),
                              DropdownMenuItem(value: 'high', child: Text('High')),
                              DropdownMenuItem(value: 'critical', child: Text('Critical')),
                            ],
                            onChanged: (v) {
                              setState(() => _priorityFilter = v);
                              _applyFilters();
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          DropdownButtonFormField<String>(
                            value: _categoryFilter,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('All')),
                              DropdownMenuItem(value: 'billing', child: Text('Billing')),
                              DropdownMenuItem(value: 'technical', child: Text('Technical')),
                              DropdownMenuItem(value: 'zatca', child: Text('ZATCA')),
                              DropdownMenuItem(value: 'feature_request', child: Text('Feature')),
                              DropdownMenuItem(value: 'general', child: Text('General')),
                            ],
                            onChanged: (v) {
                              setState(() => _categoryFilter = v);
                              _applyFilters();
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _statusFilter,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              ),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('All')),
                                DropdownMenuItem(value: 'open', child: Text('Open')),
                                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                                DropdownMenuItem(value: 'closed', child: Text('Closed')),
                              ],
                              onChanged: (v) {
                                setState(() => _statusFilter = v);
                                _applyFilters();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _priorityFilter,
                              decoration: const InputDecoration(
                                labelText: 'Priority',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              ),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('All')),
                                DropdownMenuItem(value: 'low', child: Text('Low')),
                                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                                DropdownMenuItem(value: 'high', child: Text('High')),
                                DropdownMenuItem(value: 'critical', child: Text('Critical')),
                              ],
                              onChanged: (v) {
                                setState(() => _priorityFilter = v);
                                _applyFilters();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _categoryFilter,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              ),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('All')),
                                DropdownMenuItem(value: 'billing', child: Text('Billing')),
                                DropdownMenuItem(value: 'technical', child: Text('Technical')),
                                DropdownMenuItem(value: 'zatca', child: Text('ZATCA')),
                                DropdownMenuItem(value: 'feature_request', child: Text('Feature')),
                                DropdownMenuItem(value: 'general', child: Text('General')),
                              ],
                              onChanged: (v) {
                                setState(() => _categoryFilter = v);
                                _applyFilters();
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          // ── List ──
          Expanded(
            child: switch (state) {
              TicketListLoading() => const Center(child: CircularProgressIndicator()),
              TicketListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: AppColors.error)),
              ),
              TicketListLoaded(:final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final tickets = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        final status = t['status']?.toString() ?? '';
        final priority = t['priority']?.toString() ?? '';
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(_priorityIcon(priority), color: _priorityColor(priority)),
            title: Text(t['subject']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${t['ticket_number'] ?? ''} • ${t['category'] ?? ''}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
