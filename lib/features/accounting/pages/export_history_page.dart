import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_providers.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_state.dart';

class ExportHistoryPage extends ConsumerStatefulWidget {
  const ExportHistoryPage({super.key});

  @override
  ConsumerState<ExportHistoryPage> createState() => _ExportHistoryPageState();
}

class _ExportHistoryPageState extends ConsumerState<ExportHistoryPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountingExportsProvider.notifier).loadExports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exportsState = ref.watch(accountingExportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export History'),
        actions: [IconButton(icon: const Icon(Icons.add), tooltip: 'New Export', onPressed: () => _showNewExportDialog())],
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          const Divider(height: 1),
          Expanded(child: _buildExportList(exportsState)),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    const statuses = ['pending', 'processing', 'success', 'failed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _statusFilter == null,
            onSelected: (_) {
              setState(() => _statusFilter = null);
              ref.read(accountingExportsProvider.notifier).loadExports();
            },
          ),
          const SizedBox(width: 8),
          ...statuses.map(
            (s) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(s[0].toUpperCase() + s.substring(1)),
                selected: _statusFilter == s,
                avatar: Icon(_statusIcon(s), size: 16),
                onSelected: (_) {
                  setState(() => _statusFilter = s);
                  ref.read(accountingExportsProvider.notifier).loadExports(status: s);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportList(AccountingExportsState state) {
    return switch (state) {
      AccountingExportsInitial() || AccountingExportsLoading() => const Center(child: CircularProgressIndicator()),
      AccountingExportsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text('Error: $message', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(accountingExportsProvider.notifier).loadExports(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      AccountingExportsLoaded(:final exports) =>
        exports.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_download_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text('No exports yet', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Tap + to create your first export', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(accountingExportsProvider.notifier).loadExports(status: _statusFilter),
                child: ListView.separated(
                  itemCount: exports.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _buildExportTile(exports[index]),
                ),
              ),
    };
  }

  Widget _buildExportTile(Map<String, dynamic> export) {
    final status = export['status'] as String? ?? 'pending';
    final startDate = export['start_date'] as String? ?? '';
    final endDate = export['end_date'] as String? ?? '';
    final entriesCount = export['entries_count'] as int? ?? 0;
    final createdAt = export['created_at'] as String?;
    final triggeredBy = export['triggered_by'] as String? ?? 'manual';
    final errorMessage = export['error_message'] as String?;
    final id = export['id'] as String;
    final exportTypes = export['export_types'] as List<dynamic>?;

    final Color statusColor = _statusColor(status);
    final IconData statusIcon = _statusIcon(status);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        child: Icon(statusIcon, color: statusColor, size: 20),
      ),
      title: Text('$startDate → $endDate', style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusChip(status, statusColor),
              const SizedBox(width: 8),
              Text('$entriesCount entries', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(width: 8),
              Icon(triggeredBy == 'scheduled' ? Icons.schedule : Icons.touch_app, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(triggeredBy, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          if (exportTypes != null && exportTypes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4,
                children: exportTypes
                    .take(3)
                    .map(
                      (t) => Chip(
                        label: Text((t as String).replaceAll('_', ' '), style: const TextStyle(fontSize: 10)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (createdAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_formatDate(createdAt), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
        ],
      ),
      isThreeLine: true,
      trailing: status == 'failed'
          ? IconButton(
              icon: const Icon(Icons.replay, color: Colors.orange),
              tooltip: 'Retry Export',
              onPressed: () => ref.read(accountingExportsProvider.notifier).retryExport(id),
            )
          : null,
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showNewExportDialog() {
    final startController = TextEditingController();
    final endController = TextEditingController();
    final selectedTypes = <String>{};
    const allTypes = [
      'daily_summary',
      'payment_breakdown',
      'category_breakdown',
      'expense_entries',
      'payroll_summary',
      'full_reconciliation',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Export'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(
                    labelText: 'Start Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      startController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(
                    labelText: 'End Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      endController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                const Text('Export Types (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...allTypes.map(
                  (t) => CheckboxListTile(
                    title: Text(
                      t.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' '),
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: selectedTypes.contains(t),
                    dense: true,
                    onChanged: (val) {
                      setDialogState(() {
                        if (val == true) {
                          selectedTypes.add(t);
                        } else {
                          selectedTypes.remove(t);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (startController.text.isEmpty || endController.text.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please select both dates')));
                  return;
                }
                Navigator.of(ctx).pop();
                ref
                    .read(accountingExportsProvider.notifier)
                    .triggerExport(
                      startDate: startController.text,
                      endDate: endController.text,
                      exportTypes: selectedTypes.isNotEmpty ? selectedTypes.toList() : null,
                    );
              },
              child: const Text('Export'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'pending' => Icons.hourglass_empty,
      'processing' => Icons.sync,
      'success' => Icons.check_circle,
      'failed' => Icons.error,
      _ => Icons.help_outline,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'pending' => Colors.orange,
      'processing' => Colors.blue,
      'success' => Colors.green,
      'failed' => Colors.red,
      _ => Colors.grey,
    };
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
