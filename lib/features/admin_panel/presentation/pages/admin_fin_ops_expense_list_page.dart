import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFinOpsExpenseListPage extends ConsumerStatefulWidget {
  const AdminFinOpsExpenseListPage({super.key});

  @override
  ConsumerState<AdminFinOpsExpenseListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsExpenseListPage> {
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(finOpsExpensesProvider.notifier).load());
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) params['category'] = _categoryFilter;
    ref.read(finOpsExpensesProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsExpensesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: DropdownButtonFormField<String>(
              value: _categoryFilter ?? '',
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: ['', 'supplies', 'food', 'transport', 'maintenance', 'utility', 'other']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.isEmpty ? 'All Categories' : s[0].toUpperCase() + s.substring(1)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => _categoryFilter = v);
                _applyFilter();
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
              FinOpsListLoaded(data: final resp) => _buildList(resp),
              FinOpsListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => const Center(child: Text('Loading expenses...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No expenses found'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final category = (item['category'] ?? '').toString();
          final amount = num.tryParse(item['amount']?.toString() ?? '') ?? 0;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.error.withValues(alpha: 0.15),
                child: const Icon(Icons.receipt_long, color: AppColors.error, size: 20),
              ),
              title: Text('ر.ع. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(category[0].toUpperCase() + category.substring(1), style: const TextStyle(fontSize: 12)),
              trailing: Text(
                item['expense_date']?.toString() ?? item['created_at']?.toString().substring(0, 10) ?? '',
                style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
              ),
            ),
          );
        },
      ),
    );
  }
}
