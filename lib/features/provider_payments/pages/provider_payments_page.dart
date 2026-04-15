import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/provider_payments/enums/provider_payment_status.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_providers.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_state.dart';

class ProviderPaymentsPage extends ConsumerStatefulWidget {
  const ProviderPaymentsPage({super.key});

  @override
  ConsumerState<ProviderPaymentsPage> createState() => _ProviderPaymentsPageState();
}

class _ProviderPaymentsPageState extends ConsumerState<ProviderPaymentsPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(providerPaymentsListProvider.notifier).loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentsState = ref.watch(providerPaymentsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payments'), centerTitle: true),
      body: Column(
        children: [
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', null),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed'),
                const SizedBox(width: 8),
                _buildFilterChip('Failed', 'failed'),
                const SizedBox(width: 8),
                _buildFilterChip('Refunded', 'refunded'),
              ],
            ),
          ),
          Expanded(child: _buildBody(paymentsState)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _statusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary20,
      checkmarkColor: AppColors.primary,
      onSelected: (_) {
        setState(() => _statusFilter = value);
        ref.read(providerPaymentsListProvider.notifier).loadPayments(status: value);
      },
    );
  }

  Widget _buildBody(ProviderPaymentsListState state) {
    if (state is ProviderPaymentsListLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (state is ProviderPaymentsListError) {
      return PosErrorState(
        message: state.message,
        onRetry: () => ref.read(providerPaymentsListProvider.notifier).loadPayments(status: _statusFilter),
      );
    }

    if (state is ProviderPaymentsListLoaded) {
      final payments = state.payments;

      if (payments.isEmpty) {
        return const PosEmptyState(title: 'No payments found', icon: Icons.payment_outlined);
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(providerPaymentsListProvider.notifier).loadPayments(status: _statusFilter);
        },
        child: ListView.separated(
          padding: AppSpacing.paddingAllMd,
          itemCount: payments.length,
          separatorBuilder: (_, __) => AppSpacing.verticalSm,
          itemBuilder: (context, index) {
            return _PaymentListTile(
              payment: payments[index],
              onTap: () => context.go('${Routes.providerPaymentDetail}/${payments[index].id}'),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _PaymentListTile extends StatelessWidget {
  final ProviderPayment payment;
  final VoidCallback onTap;

  const _PaymentListTile({required this.payment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = payment.createdAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(payment.createdAt!) : '-';

    return PosCard(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    payment.purposeLabel ?? payment.purpose?.label ?? 'Payment',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: payment.status),
              ],
            ),
            AppSpacing.verticalXs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  payment.formattedAmount,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                if (payment.cartId != null)
                  Text(
                    payment.cartId!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            AppSpacing.verticalXs,
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(dateStr, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const Spacer(),
                if (payment.confirmationEmailSent)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.email_outlined, size: 16, color: AppColors.success),
                  ),
                if (payment.invoiceGenerated)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.success),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProviderPaymentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      ProviderPaymentStatus.pending => (AppColors.warning, AppColors.warning.withValues(alpha: 0.12)),
      ProviderPaymentStatus.processing => (AppColors.info, AppColors.info.withValues(alpha: 0.12)),
      ProviderPaymentStatus.completed => (AppColors.success, AppColors.success.withValues(alpha: 0.12)),
      ProviderPaymentStatus.failed => (AppColors.error, AppColors.error.withValues(alpha: 0.12)),
      ProviderPaymentStatus.refunded => (Colors.grey, Colors.grey.withValues(alpha: 0.12)),
      ProviderPaymentStatus.voided => (Colors.grey, Colors.grey.withValues(alpha: 0.12)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
