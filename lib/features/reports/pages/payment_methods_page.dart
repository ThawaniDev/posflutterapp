import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(paymentMethodsProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.end) : null,
        );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      _loadData();
    }
  }

  IconData _iconForMethod(String method) {
    return switch (method) {
      'cash' => Icons.payments,
      'card' => Icons.credit_card,
      'gift_card' => Icons.card_giftcard,
      'mobile' => Icons.phone_android,
      'bank_transfer' => Icons.account_balance,
      _ => Icons.attach_money,
    };
  }

  Color _colorForMethod(String method) {
    return switch (method) {
      'cash' => Colors.green,
      'card' => Colors.blue,
      'gift_card' => Colors.purple,
      'mobile' => Colors.orange,
      'bank_transfer' => Colors.teal,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        PaymentMethodsInitial() || PaymentMethodsLoading() => const Center(child: CircularProgressIndicator()),
        PaymentMethodsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
        PaymentMethodsLoaded(:final methods) =>
          methods.isEmpty
              ? const Center(child: Text('No payment data for selected period'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_dateRange != null)
                      Chip(
                        label: Text(
                          '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_dateRange!.end)}',
                        ),
                        onDeleted: () {
                          setState(() => _dateRange = null);
                          _loadData();
                        },
                      ),
                    const SizedBox(height: 8),

                    // Total
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Total', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 4),
                            Text(
                              '\$${methods.fold<double>(0, (sum, m) => sum + (m['total_amount'] as num).toDouble()).toStringAsFixed(2)}',
                              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Method cards
                    ...methods.map((m) {
                      final method = m['method'] as String;
                      final total = methods.fold<double>(0, (sum, item) => sum + (item['total_amount'] as num).toDouble());
                      final amount = (m['total_amount'] as num).toDouble();
                      final pct = total > 0 ? (amount / total) : 0.0;
                      final color = _colorForMethod(method);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(_iconForMethod(method), color: color),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(method.toUpperCase(), style: theme.textTheme.titleSmall)),
                                  Text(
                                    '\$${amount.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: pct.toDouble(),
                                color: color,
                                backgroundColor: color.withValues(alpha: 0.1),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${m['transaction_count']} transactions', style: theme.textTheme.bodySmall),
                                  Text('Avg: \$${(m['avg_amount'] as num).toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                                  Text(
                                    '${(pct * 100).toStringAsFixed(1)}%',
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
      },
    );
  }
}
