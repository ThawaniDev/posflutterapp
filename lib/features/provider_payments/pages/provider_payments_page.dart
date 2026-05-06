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
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProviderPaymentsPage extends ConsumerStatefulWidget {
  const ProviderPaymentsPage({super.key});

  @override
  ConsumerState<ProviderPaymentsPage> createState() => _ProviderPaymentsPageState();
}

class _ProviderPaymentsPageState extends ConsumerState<ProviderPaymentsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final isLoading = paymentsState is ProviderPaymentsListLoading;
    final hasError = paymentsState is ProviderPaymentsListError;
    final isEmpty = paymentsState is ProviderPaymentsListLoaded && paymentsState.payments.isEmpty;

    return PosListPage(
      title: l10n.providerPaymentsTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? paymentsState.message : null,
      onRetry: () => ref.read(providerPaymentsListProvider.notifier).loadPayments(status: _statusFilter),
      isEmpty: isEmpty,
      emptyTitle: l10n.providerPaymentNoPayments,
      emptyIcon: Icons.payment_outlined,
      filters: [
        _buildFilterChip(l10n.providerPaymentFilterAll, null),
        _buildFilterChip(l10n.providerPaymentFilterPending, 'pending'),
        _buildFilterChip(l10n.providerPaymentFilterCompleted, 'completed'),
        _buildFilterChip(l10n.providerPaymentFilterFailed, 'failed'),
        _buildFilterChip(l10n.providerPaymentFilterRefunded, 'refunded'),
      ],
      child: paymentsState is ProviderPaymentsListLoaded ? _buildList(paymentsState.payments) : const SizedBox.shrink(),
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

  Widget _buildList(List<ProviderPayment> payments) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(providerPaymentsListProvider.notifier).loadPayments(status: _statusFilter);
      },
      child: ListView.separated(
        padding: AppSpacing.paddingAllMd,
        itemCount: payments.length,
        separatorBuilder: (_, _) => AppSpacing.verticalSm,
        itemBuilder: (context, index) {
          return _PaymentListTile(
            payment: payments[index],
            onTap: () => context.go('${Routes.providerPaymentDetail}/${payments[index].id}'),
          );
        },
      ),
    );
  }
}

class _PaymentListTile extends StatelessWidget {

  const _PaymentListTile({required this.payment, required this.onTap});
  final ProviderPayment payment;
  final VoidCallback onTap;

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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8),
                    child: Icon(Icons.email_outlined, size: 16, color: AppColors.success),
                  ),
                if (payment.invoiceGenerated)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8),
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

  const _StatusBadge({required this.status});
  final ProviderPaymentStatus status;

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
      decoration: BoxDecoration(color: bgColor, borderRadius: AppRadius.borderLg),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
